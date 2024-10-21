// RUN: finch-opt %s | finch-opt | FileCheck %s
//./bin/finch-opt ../test12.mlir --inline --finch-simplifier  --finch-instantiate --finch-looplet-pass --finch-simplifier --finch-instantiate --finch-looplet-pass --finch-simplifier --finch-instantiate --finch-looplet-pass --sparsifier |  mlir-cpu-runner -e main -entry-point-result=void -shared-libs=/Users/jaeyeonwon/llvm-project/build/lib/libmlir_runner_utils.dylib,/Users/jaeyeonwon/llvm-project/build/lib/libmlir_c_runner_utils.dylib

#CSR = #sparse_tensor.encoding<{ map = (d0, d1) -> (d0 : dense, d1 : compressed) }>
module {

    func.func private @printMemrefF32(%ptr:memref<*xf32>) attributes {llvm.emit_c_interface}
    func.func private @printMemrefInd(%ptr:memref<*xindex>) attributes {llvm.emit_c_interface}

    func.func @buffers_from_sparsematrix(%jump : index) -> (memref<?xindex>, memref<?xindex>, memref<?xindex>, memref<?xindex>, memref<?xf32>) {
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c8 = arith.constant 8 : index
      %f1 = arith.constant 1.0 : f32

      %6 = tensor.empty() : tensor<32x32xf32, #CSR>
      %7 = scf.for %i = %c0 to %c8 step %c1 iter_args(%vin = %6) -> tensor<32x32xf32, #CSR> {
        %ii = arith.muli %i, %jump : index
        %tmp = scf.for %j = %c0 to %c8 step %c1 iter_args(%vin2 = %vin) -> tensor<32x32xf32, #CSR> {
          %jj = arith.muli %j, %jump : index
          %intj = arith.index_castui %j : index to i32
          %fj = arith.uitofp %intj : i32 to f32
          //%vout = tensor.insert %f1 into %vin2[%ii, %jj] : tensor<32x32xf32, #CSR>
          %vout = tensor.insert %fj into %vin2[%ii, %jj] : tensor<32x32xf32, #CSR>
          scf.yield %vout : tensor<32x32xf32, #CSR>
        }
        scf.yield %tmp : tensor<32x32xf32, #CSR>
      }

      %8 = sparse_tensor.load %7 hasInserts : tensor<32x32xf32, #CSR>
      sparse_tensor.print %8 : tensor<32x32xf32, #CSR>
      
      %9 = sparse_tensor.positions %8 {level = 0 :index} : tensor<32x32xf32, #CSR> to memref<?xindex>
      %10 = sparse_tensor.coordinates %8 {level = 0 :index} : tensor<32x32xf32, #CSR> to memref<?xindex>

      %11 = sparse_tensor.positions %8 {level = 1 :index} : tensor<32x32xf32, #CSR> to memref<?xindex>
      %12 = sparse_tensor.coordinates %8 {level = 1 :index} : tensor<32x32xf32, #CSR> to memref<?xindex>

      %13 = sparse_tensor.values %8 : tensor<32x32xf32, #CSR> to memref<?xf32>
      return %9,%10 ,%11,%12 ,%13: memref<?xindex>, memref<?xindex>, memref<?xindex>, memref<?xindex>, memref<?xf32>
    }

    func.func private @dense_level(%pos: index, %shape: index) -> !finch.looplet {
      %l0 = finch.lookup
        body = {
          ^bb(%idx : index) :
            %0 = arith.muli %pos, %shape : index
            %1 = arith.addi %0, %idx : index
            %2 = finch.nextlevel %1 : (index) -> (!finch.looplet)
            finch.return %2 : !finch.looplet
        }
      return %l0 : !finch.looplet
    }


    func.func private @sparse_level(%pos: index, %ptr:memref<?xindex>, %crd:memref<?xindex>) -> !finch.looplet {
      %fp_0 = arith.constant -0.0 : f32
      %fp_1 = arith.constant 1.0 : f32
      %c1 = arith.constant 1 : index
     
      %l0 = finch.stepper  
          seek={
            ^bb0(%idx : index):
              %firstpos = func.call @binarysearch(%pos, %idx, %ptr, %crd) : (index, index, memref<?xindex>, memref<?xindex>) -> (index) 
              finch.return %firstpos : index
          }
          stop={
            ^bb(%pos1 : index):
              %currcrd = memref.load %crd[%pos1] : memref<?xindex>
              %stopub = arith.addi %currcrd, %c1 : index
              finch.return %stopub : index
          } 
          body={
            ^bb(%pos1 : index):
              %currcrd = memref.load %crd[%pos1] : memref<?xindex>

              %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
              %nonzero_run = finch.nextlevel %pos1 : (index) -> (!finch.looplet)
              %seq = finch.sequence %currcrd, %zero_run, %nonzero_run : (index, !finch.looplet, !finch.looplet) -> (!finch.looplet)
              finch.return %seq : !finch.looplet
          } 
          next={
            ^bb0(%pos1 : index):
              %nextpos = arith.addi %pos1, %c1 : index
              finch.return %nextpos : index 
          }

      // nextpos = pos+1
      // nextoffset = ptr[pos+1]
      // curroffset = ptr[pos]
      // empty = curroffset == nextoffset
      // if (empty) {
      //   return 0 
      // } else {
      //   lastoffset = nextoffset - 1
      //   last_nnz_crd = crd[lastoffset]
      //   last_nnz_ub = last_nnz_crd + 1
      //   return last_nnz_ub
      // }
      %nextpos = arith.addi %pos, %c1 : index
      %nextoffset = memref.load %ptr[%nextpos] : memref<?xindex>
      %curroffset = memref.load %ptr[%pos] : memref<?xindex>
      %empty = arith.cmpi eq, %curroffset, %nextoffset : index
      %zero_ub = scf.if %empty -> (index) {
        %c0 = arith.constant 0 : index
        scf.yield %c0 : index
      } else {
        %lastoffset = arith.subi %nextoffset, %c1 : index
        %last_nnz_crd = memref.load %crd[%lastoffset] : memref<?xindex>
        %last_nnz_ub = arith.addi %last_nnz_crd, %c1 : index
        scf.yield %last_nnz_ub : index
      }

      %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
      %l1 = finch.sequence %zero_ub, %l0, %zero_run : (index, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      return %l1 : !finch.looplet
    }


    func.func private @element_level(%pos: index, %val : memref<?xf32>) -> !finch.looplet {
      %currval = memref.load %val[%pos] : memref<?xf32>
      %run = finch.run %currval : (f32) -> (!finch.looplet)
      return %run : !finch.looplet
    }

    func.func private @binarysearch(%pos: index, %idx : index, %ptr : memref<?xindex>, %crd : memref<?xindex>) -> index {
      // i = ptr[pos];
      // while(i<ptr[pos+1] && crd[i] < idx) {
      //   i += 1;
      // }

      %c1 = arith.constant 1 : index
      %offset = memref.load %ptr[%pos] : memref<?xindex>

      %nextpos = arith.addi %pos, %c1 : index
      %nextoffset = memref.load %ptr[%nextpos] : memref<?xindex>
      
      %search = scf.while (%i = %offset) : (index) -> (index) {
        %cmp1 = arith.cmpi ult, %i, %nextoffset : index 
        %cmp2 = scf.if %cmp1 -> (i1) {
          %currcrd = memref.load %crd[%i] : memref<?xindex>
          %cmp = arith.cmpi ult, %currcrd, %idx : index 
          scf.yield %cmp : i1
        } else {
          %false = arith.constant 0 : i1
          scf.yield %false : i1
        }
        scf.condition(%cmp2) %i : index
      } do {
        ^bb(%i:index) :
          %next = arith.addi %i, %c1 : index
          scf.yield %next : index
      }
      return %search : index 
    }

    func.func @main()  {
      // sparse_tensor -> extract memref (pos,crd,val) from sparse_Tensor -> build looplet representation using those memrefs
      // -> perform computation with finch dialect -> lower finch loop with finch passes to llvm -> run llvm

      /////////////////////////////////
      // Defining 2D Tensor with Looplet      
      /////////////////////////////////

      %c0 = arith.constant 0 : index
      %c2 = arith.constant 2 : index
      %c3 = arith.constant 3 : index
      %buff:5 = call @buffers_from_sparsematrix(%c2) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xindex>, memref<?xindex>, memref<?xf32>)

      %bx = memref.cast %buff#0 :  memref<?xindex> to memref<*xindex>
      %by = memref.cast %buff#1 :  memref<?xindex> to memref<*xindex>
      %bz = memref.cast %buff#2 :  memref<?xindex> to memref<*xindex>
      %bw = memref.cast %buff#3 :  memref<?xindex> to memref<*xindex>
      %bv = memref.cast %buff#4 :  memref<?xf32> to memref<*xf32>

      /////////////////////////////////
      // Wrap memrefs to Looplets
      /////////////////////////////////
      %ptr1A = memref.cast %buff#0 :  memref<?xindex> to memref<?xindex>
      %crd1A = memref.cast %buff#1 :  memref<?xindex> to memref<?xindex>
      %ptr2A = memref.cast %buff#2 :  memref<?xindex> to memref<?xindex>
      %crd2A = memref.cast %buff#3 :  memref<?xindex> to memref<?xindex>
      %valA = memref.cast %buff#4 :  memref<?xf32> to memref<?xf32>

      %shape = arith.constant 32 : index
      %ALvl0 = finch.definelevel {
        ^bb0(%pos : index) :
          %l = func.call @dense_level(%pos, %shape): (index, index) -> !finch.looplet
          finch.return %l : !finch.looplet
      }

      %ALvl1 = finch.definelevel {
        ^bb0(%pos : index) :
          %l = func.call @sparse_level(%pos, %ptr2A, %crd2A): (index, memref<?xindex>, memref<?xindex>) -> !finch.looplet
          finch.return %l : !finch.looplet
      }

      %ALvl2 = finch.definelevel {
        ^bb(%pos:index):
          %l = func.call @element_level(%pos, %valA): (index, memref<?xf32>) -> !finch.looplet
          finch.return %l : !finch.looplet
      }


      %BLvl0 = finch.definelevel {
        ^bb0(%pos : index) :
          %l = func.call @dense_level(%pos, %shape): (index, index) -> !finch.looplet
          finch.return %l : !finch.looplet
      }

      %BLvl1 = finch.definelevel {
        ^bb0(%pos : index) :
          %l = func.call @sparse_level(%pos, %ptr2A, %crd2A): (index, memref<?xindex>, memref<?xindex>) -> !finch.looplet
          finch.return %l : !finch.looplet
      }

      %BLvl2 = finch.definelevel {
        ^bb(%pos:index):
          %l = func.call @element_level(%pos, %valA): (index, memref<?xf32>) -> !finch.looplet
          finch.return %l : !finch.looplet
      }



      /////////////////////////////////////
      ////// Main Code
      /////////////////////////////////////
       
      %fp_0 = arith.constant 0.0 : f32
      %sum = memref.alloc() : memref<f32>                                           
      memref.store %fp_0, %sum[] : memref<f32>                                      

      %c1 = arith.constant 1 : index
      %b0 = arith.constant 0 : index
      %bb = arith.constant 2 : index
      %b1 = arith.constant 32 : index

      scf.for %i = %b0 to %b1 step %c1 {                                           
        %l0 = finch.getlevel %ALvl0, %c0 : (!finch.looplet, index) -> (!finch.looplet)
        %p1 = finch.access %l0, %i : index                             
        
        %l0b = finch.getlevel %BLvl0, %c0 : (!finch.looplet, index) -> (!finch.looplet)
        %p1b = finch.access %l0b, %i : index                             

        scf.for %j = %b0 to %b1 step %c1 {                                           
          %l1 = finch.getlevel %ALvl1, %p1 : (!finch.looplet, index) -> (!finch.looplet)
          %p2 = finch.access %l1, %j : index                              

          %l2 = finch.getlevel %ALvl2, %p2 : (!finch.looplet, index) -> (!finch.looplet)
          %v = finch.access %l2, %j : f32                                          


          %l1b = finch.getlevel %BLvl1, %p1b : (!finch.looplet, index) -> (!finch.looplet)
          %p2b = finch.access %l1b, %j : index                              

          %l2b = finch.getlevel %BLvl2, %p2b : (!finch.looplet, index) -> (!finch.looplet)
          %vb = finch.access %l2b, %j : f32                                          

          %z3 = memref.load %sum[] : memref<f32>     
          %z4 = arith.mulf %v, %vb  : f32    
          %z5 = arith.addf %z3, %z4 : f32    
          memref.store %z5, %sum[] : memref<f32>                                    
        }
      }

   
      //// Print %sum
      %z = memref.cast %sum :  memref<f32> to memref<*xf32>
      call @printMemrefF32(%z): (memref<*xf32>) -> ()
      
      return 
    }
}
