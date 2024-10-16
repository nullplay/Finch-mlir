// RUN: finch-opt %s | finch-opt | FileCheck %s

// ./build/bin/finch-opt --inline --finch-looplet-pass --finch-switch-bar-foo --sparsifier test8.mlir | mlir-translate --mlir-to-llvmir -o "dotproduct.ll"

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

    func.func private @binarysearch(%idx : index, %ptr : memref<?xindex>, %crd : memref<?xindex>) -> index {
      %c0 = arith.constant 0 : index
      %c1 = arith.constant 1 : index
      // i = 0;
      // while(crd[i] < idx) {
      //   i += 1;
      // }
      %search = scf.while (%i = %c0) : (index) -> (index) {
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
    func.func private @buffer_to_looplet(%ptr : memref<?xindex>, %crd : memref<?xindex>, %val : memref<?xf32>) -> !finch.looplet {
      %fp_0 = arith.constant -0.0 : f32
      %fp_1 = arith.constant 1.0 : f32
      %1 = arith.constant 1 : index
      %c1 = arith.constant 1 : index
     
      %l0 = finch.stepper  
          seek={
            ^bb0(%idx : index):
              %firstpos = func.call @binarysearch(%idx, %ptr, %crd) : (index, memref<?xindex>, memref<?xindex>) -> (index) 
              //%firstpos = arith.constant 0 : index
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
              %currval = memref.load %val[%pos1] : memref<?xf32>

              %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
              %nonzero_run = finch.run %currval : (f32) -> (!finch.looplet)
              %seq = finch.sequence %currcrd, %zero_run, %nonzero_run : (index, !finch.looplet, !finch.looplet) -> (!finch.looplet)
              finch.return %seq : !finch.looplet
          } 
          next={
            ^bb0(%pos1 : index):
              %nextpos = arith.addi %pos1, %c1 : index
              finch.return %nextpos : index 
          }

      %nnz = memref.load %ptr[%1] : memref<?xindex>
      %nnz_1 = arith.subi %nnz, %1 : index
      %last_nnz_crd = memref.load %crd[%nnz_1] : memref<?xindex>
      %last_nnz_ub = arith.addi %last_nnz_crd, %c1 : index
      %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
      %l1 = finch.sequence %last_nnz_ub, %l0, %zero_run : (index, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      return %l1 : !finch.looplet
    }


    func.func @main()  {
      
      // sparse_tensor -> extract memref (pos,crd,val) from sparse_Tensor -> build looplet representation using those memrefs
      // -> perform computation with finch dialect -> lower finch loop with finch passes to llvm -> run llvm

      /////////////////////////////////
      // Defining 2D Tensor with Looplet      
      /////////////////////////////////

      %c2 = arith.constant 2 : index
      %c3 = arith.constant 3 : index
      %buff1:3 = call @buffers_from_sparsevector(%c2) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>)
      %buff2:3 = call @buffers_from_sparsevector(%c3) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>)

      %bx = memref.cast %buff1#0 :  memref<?xindex> to memref<*xindex>
      %by = memref.cast %buff1#1 :  memref<?xindex> to memref<*xindex>
      %bz = memref.cast %buff1#2 :  memref<?xf32> to memref<*xf32>
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

      %l0 = call @buffer_to_looplet(%buff1#0, %buff1#1, %buff1#2) : (memref<?xindex>, memref<?xindex>, memref<?xf32>) -> (!finch.looplet)
      %l1 = call @buffer_to_looplet(%buff2#0, %buff2#1, %buff2#2) : (memref<?xindex>, memref<?xindex>, memref<?xf32>) -> (!finch.looplet)


      /////////////////////////////////
      // Main Code
      /////////////////////////////////
       
      %fp_0 = arith.constant 0.0 : f32
      %sum = memref.alloc() : memref<f32>                                           // float* sum = []
      memref.store %fp_0, %sum[] : memref<f32>                                      // sum[0] = 0.0

      %c1 = arith.constant 1 : index
      %b0 = arith.constant 0 : index
      %b1 = arith.constant 100 : index

      scf.for %j = %b0 to %b1 step %c1 {                                            // for j in range(b0,b1) :
        %z1 = finch.access %l0, %j : f32                                            //   z1 = l0[j]
        %z2 = finch.access %l1, %j : f32                                            //   z2 = l1[j]

        %z3 = memref.load %sum[] : memref<f32>                                      //   z3 = sum[0]
        %z4 = arith.mulf %z1, %z2 {fastmath = #arith.fastmath<nnan, ninf>} : f32    //   z4 = z1*z2
        %z5 = arith.addf %z3, %z4 {fastmath = #arith.fastmath<nnan, ninf>} : f32    //   z5 = z3 + z4
        memref.store %z5, %sum[] : memref<f32>                                      //   sum[0] = z5
      }
   
      // Print %sum
      %z = memref.cast %sum :  memref<f32> to memref<*xf32>
      call @printMemrefF32(%z): (memref<*xf32>) -> ()
      
      return 
    }
}
