// RUN: finch-opt %s | finch-opt | FileCheck %s
//./bin/finch-opt --loop-invariant-code-motion --finch-instantiate --finch-looplet-sequence --finch-looplet-run --finch-looplet-stepper --finch-looplet-sequence --finch-looplet-run --finch-instantiate --finch-looplet-run --cse --sparsifier  ../test10.mlir | mlir-cpu-runner -e main -entry-point-result=void -shared-libs=/Users/jaeyeonwon/llvm-project/build/lib/libmlir_runner_utils.dylib,/Users/jaeyeonwon/llvm-project/build/lib/libmlir_c_runner_utils.dylib
#SparseVector = #sparse_tensor.encoding<{ map = (d0) -> (d0 : compressed) }>
module {

    func.func private @printMemrefF32(%ptr:memref<*xf32>) attributes {llvm.emit_c_interface}
    func.func private @printMemrefInd(%ptr:memref<*xindex>) attributes {llvm.emit_c_interface}

    func.func @buffers_from_sparsevector(%jump : index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>) {
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      %c8 = arith.constant 8 : index
      %f1 = arith.constant 1.0 : f32

      %6 = tensor.empty() : tensor<1024xf32, #SparseVector>
      %7 = scf.for %i = %c0 to %c8 step %c1 iter_args(%vin = %6) -> tensor<1024xf32, #SparseVector> {
        %ii = arith.muli %i, %jump : index
        %vout = tensor.insert %f1 into %vin[%ii] : tensor<1024xf32, #SparseVector>
        scf.yield %vout : tensor<1024xf32, #SparseVector>
      }
      %8 = sparse_tensor.load %7 hasInserts : tensor<1024xf32, #SparseVector>
      %9 = sparse_tensor.positions %8 {level = 0 :index} : tensor<1024xf32, #SparseVector> to memref<?xindex>
      %10 = sparse_tensor.coordinates %8 {level = 0 :index} : tensor<1024xf32, #SparseVector> to memref<?xindex>
      %11 = sparse_tensor.values %8 : tensor<1024xf32, #SparseVector> to memref<?xf32>
      return %9,%10,%11: memref<?xindex>, memref<?xindex>, memref<?xf32>
    }

    func.func private @binarysearch(%pos: index, %idx : index, %ptr : memref<?xindex>, %crd : memref<?xindex>) -> index {
      %c1 = arith.constant 1 : index
      // i = ptr[pos];
      // while(crd[i] < idx) {
      //   i += 1;
      // }
      %offset = memref.load %ptr[%pos] : memref<?xindex>
      %search = scf.while (%i = %offset) : (index) -> (index) {
        %currcrd = memref.load %crd[%i] : memref<?xindex>
        %cmp = arith.cmpi ult, %currcrd, %idx : index 
        scf.condition(%cmp) %i : index
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
      %buff:3 = call @buffers_from_sparsevector(%c2) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>)
      %buff2:3 = call @buffers_from_sparsevector(%c3) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>)

      %bx = memref.cast %buff#0 :  memref<?xindex> to memref<*xindex>
      %by = memref.cast %buff#1 :  memref<?xindex> to memref<*xindex>
      %bz = memref.cast %buff#2 :  memref<?xf32> to memref<*xf32>
      call @printMemrefInd(%bx): (memref<*xindex>) -> ()
      call @printMemrefInd(%by): (memref<*xindex>) -> ()
      call @printMemrefF32(%bz): (memref<*xf32>) -> ()

      %bx2 = memref.cast %buff2#0 :  memref<?xindex> to memref<*xindex>
      %by2 = memref.cast %buff2#1 :  memref<?xindex> to memref<*xindex>
      %bz2 = memref.cast %buff2#2 :  memref<?xf32> to memref<*xf32>
      call @printMemrefInd(%bx2): (memref<*xindex>) -> ()
      call @printMemrefInd(%by2): (memref<*xindex>) -> ()
      call @printMemrefF32(%bz2): (memref<*xf32>) -> ()


      /////////////////////////////////
      // Wrap memrefs to Looplets
      /////////////////////////////////

      %ptr = memref.cast %buff#0 :  memref<?xindex> to memref<?xindex>
      %crd = memref.cast %buff#1 :  memref<?xindex> to memref<?xindex>
      %val = memref.cast %buff#2 :  memref<?xf32> to memref<?xf32>

      %ptr2 = memref.cast %buff2#0 :  memref<?xindex> to memref<?xindex>
      %crd2 = memref.cast %buff2#1 :  memref<?xindex> to memref<?xindex>
      %val2 = memref.cast %buff2#2 :  memref<?xf32> to memref<?xf32>


      %sparse_level = finch.definelevel {
        ^bb0(%pos : index) :
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

          %posplus1 = arith.addi %pos, %c1 : index
          %lastposplus1 = memref.load %ptr[%posplus1] : memref<?xindex>
          %lastpos = arith.subi %lastposplus1, %c1 : index
          %last_nnz_crd = memref.load %crd[%lastpos] : memref<?xindex>
          %last_nnz_ub = arith.addi %last_nnz_crd, %c1 : index
          %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
          %l1 = finch.sequence %last_nnz_ub, %l0, %zero_run : (index, !finch.looplet, !finch.looplet) -> (!finch.looplet)

          finch.return %l1 : !finch.looplet
      }

      %element_level = finch.definelevel {
        ^bb(%pos:index):
          %currval = memref.load %val[%pos] : memref<?xf32>
          %run = finch.run %currval : (f32) -> (!finch.looplet)
          finch.return %run : !finch.looplet
      }

      %sparse_level2 = finch.definelevel {
        ^bb0(%pos : index) :
          %fp_0 = arith.constant -0.0 : f32
          %fp_1 = arith.constant 1.0 : f32
          %c1 = arith.constant 1 : index
         
          %l0 = finch.stepper  
              seek={
                ^bb0(%idx : index):
                  %firstpos = func.call @binarysearch(%pos, %idx, %ptr2, %crd2) : (index, index, memref<?xindex>, memref<?xindex>) -> (index) 
                  finch.return %firstpos : index
              }
              stop={
                ^bb(%pos1 : index):
                  %currcrd = memref.load %crd2[%pos1] : memref<?xindex>
                  %stopub = arith.addi %currcrd, %c1 : index
                  finch.return %stopub : index
              } 
              body={
                ^bb(%pos1 : index):
                  %currcrd = memref.load %crd2[%pos1] : memref<?xindex>

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

          %posplus1 = arith.addi %pos, %c1 : index
          %lastposplus1 = memref.load %ptr2[%posplus1] : memref<?xindex>
          %lastpos = arith.subi %lastposplus1, %c1 : index
          %last_nnz_crd = memref.load %crd2[%lastpos] : memref<?xindex>
          %last_nnz_ub = arith.addi %last_nnz_crd, %c1 : index
          %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
          %l1 = finch.sequence %last_nnz_ub, %l0, %zero_run : (index, !finch.looplet, !finch.looplet) -> (!finch.looplet)

          finch.return %l1 : !finch.looplet
      }

      %element_level2 = finch.definelevel {
        ^bb(%pos:index):
          %currval = memref.load %val2[%pos] : memref<?xf32>
          %run = finch.run %currval : (f32) -> (!finch.looplet)
          finch.return %run : !finch.looplet
      }


      ///////////////////////////////////
      //// Main Code
      ///////////////////////////////////
       
      %fp_0 = arith.constant 0.0 : f32
      %sum = memref.alloc() : memref<f32>                                           
      memref.store %fp_0, %sum[] : memref<f32>                                      

      %c1 = arith.constant 1 : index
      %b0 = arith.constant 0 : index
      %b1 = arith.constant 100 : index

      scf.for %j = %b0 to %b1 step %c1 {                                           
        %l0 = finch.getlevel %sparse_level, %c0 : (!finch.looplet, index) -> (!finch.looplet)
        %p1 = finch.access %l0, %j : index                              

        %l0b = finch.getlevel %sparse_level2, %c0 : (!finch.looplet, index) -> (!finch.looplet)
        %p1b = finch.access %l0b, %j : index                              


        %l1 = finch.getlevel %element_level, %p1 : (!finch.looplet, index) -> (!finch.looplet)
        %v = finch.access %l1, %j : f32                                           

        %l1b = finch.getlevel %element_level2, %p1b : (!finch.looplet, index) -> (!finch.looplet)
        %vb = finch.access %l1b, %j : f32                                           


        %z3 = memref.load %sum[] : memref<f32>     
        %z4 = arith.mulf %v, %vb  {fastmath = #arith.fastmath<nnan, ninf>}: f32    
        %z5 = arith.addf %z3, %z4 {fastmath = #arith.fastmath<nnan, ninf>}: f32    
        memref.store %z5, %sum[] : memref<f32>                                     
      }
   
      // Print %sum
      %z = memref.cast %sum :  memref<f32> to memref<*xf32>
      call @printMemrefF32(%z): (memref<*xf32>) -> ()
      
      return 
    }
}
