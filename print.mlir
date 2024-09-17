//./build/bin/finch-opt print.mlir -sparsifier |  mlir-cpu-runner -e main -entry-point-result=void -shared-libs=/Users/jaeyeonwon/llvm-project/build/lib/libmlir_runner_utils.dylib,/Users/jaeyeonwon/llvm-project/build/lib/libmlir_c_runner_utils.dylib

// OR run this command, but this does not guarantee the correct compilation always.
//./build/bin/finch-opt print.mlir -convert-vector-to-scf -convert-scf-to-cf -convert-cf-to-llvm -convert-vector-to-llvm -convert-func-to-llvm -finalize-memref-to-llvm -reconcile-unrealized-casts |  mlir-cpu-runner -e main -entry-point-result=void -shared-libs=/Users/jaeyeonwon/llvm-project/build/lib/libmlir_runner_utils.dylib,/Users/jaeyeonwon/llvm-project/build/lib/libmlir_c_runner_utils.dylib

#SparseVector = #sparse_tensor.encoding<{ map = (d0) -> (d0 : compressed), posWidth=32, crdWidth=32 }>
module {
  func.func @main() {
    %f1    = arith.constant 1.0 : f32
    %f2    = arith.constant 2.0 : f32
    %f3    = arith.constant 3.0 : f32
    %f4    = arith.constant 4.0 : f32
    %c0    = arith.constant 0 : index
    %c1    = arith.constant 1 : index
    %c3    = arith.constant 3 : index
    %c8    = arith.constant 8 : index
    %c1023 = arith.constant 1023 : index

    // Build the sparse vector from straightline code.
    %0 = tensor.empty() : tensor<1024xf32, #SparseVector>
    %1 = tensor.insert %f1 into %0[%c0] : tensor<1024xf32, #SparseVector>
    %2 = tensor.insert %f2 into %1[%c1] : tensor<1024xf32, #SparseVector>
    %3 = tensor.insert %f3 into %2[%c3] : tensor<1024xf32, #SparseVector>
    %4 = tensor.insert %f4 into %3[%c1023] : tensor<1024xf32, #SparseVector>
    %5 = sparse_tensor.load %4 hasInserts : tensor<1024xf32, #SparseVector>

    //
    // CHECK:   ---- Sparse Tensor ----
    // CHECK-NEXT: nse = 4
    // CHECK-NEXT: dim = ( 1024 )
    // CHECK-NEXT: lvl = ( 1024 )
    // CHECK-NEXT: pos[0] : ( 0, 4 )
    // CHECK-NEXT: crd[0] : ( 0, 1, 3, 1023 )
    // CHECK-NEXT: values : ( 1, 2, 3, 4 )
    // CHECK-NEXT: ----
    //
    sparse_tensor.print %5 : tensor<1024xf32, #SparseVector>

    // Build another sparse vector in a loop.
    %6 = tensor.empty() : tensor<1024xf32, #SparseVector>
    %7 = scf.for %i = %c0 to %c8 step %c1 iter_args(%vin = %6) -> tensor<1024xf32, #SparseVector> {
      %ii = arith.muli %i, %c3 : index
      %vout = tensor.insert %f1 into %vin[%ii] : tensor<1024xf32, #SparseVector>
      scf.yield %vout : tensor<1024xf32, #SparseVector>
    }
    %8 = sparse_tensor.load %7 hasInserts : tensor<1024xf32, #SparseVector>

    //
    // CHECK-NEXT: ---- Sparse Tensor ----
    // CHECK-NEXT: nse = 8
    // CHECK-NEXT: dim = ( 1024 )
    // CHECK-NEXT: lvl = ( 1024 )
    // CHECK-NEXT: pos[0] : ( 0, 8 )
    // CHECK-NEXT: crd[0] : ( 0, 3, 6, 9, 12, 15, 18, 21 )
    // CHECK-NEXT: values : ( 1, 1, 1, 1, 1, 1, 1, 1 )
    // CHECK-NEXT: ----
    //
    sparse_tensor.print %8 : tensor<1024xf32, #SparseVector>


    // vector printing example
    %v = arith.constant dense<[0,1,127,128,254]> : vector<5xi32>
    vector.print %v : vector<5xi32>
    %x = arith.constant 3 : i32
    vector.print %x : i32

    %fp_0 = arith.constant 0.0 : f32
    %fp_1 = arith.constant 1.0 : f32
    %sum = memref.alloc() : memref<2xf32>                                           
    memref.store %fp_0, %sum[%c0] : memref<2xf32>                                     
    memref.store %fp_1, %sum[%c1] : memref<2xf32>                                     
    %xx = memref.load %sum[%c0] : memref<2xf32>
    %yy = memref.load %sum[%c1] : memref<2xf32>

    vector.print %xx : f32
    vector.print %yy : f32

    %VA = vector.type_cast %sum : memref<2xf32> to memref<vector<2xf32>>
    %vm = memref.load %VA[] : memref<vector<2xf32>>
    vector.print %vm : vector<2xf32>


    // sparse tensor memref printing example
    %cv = sparse_tensor.coordinates %8 { level = 0 : index } : tensor<1024xf32, #SparseVector> to memref<?xi32>
    %cp = sparse_tensor.positions %8 { level = 0 : index } : tensor<1024xf32, #SparseVector> to memref<?xi32>

    %U = memref.cast %cv :  memref<?xi32> to memref<*xi32>
    %V = memref.cast %cp :  memref<?xi32> to memref<*xi32>
    call @printMemrefI32(%U): (memref<*xi32>) -> ()
    call @printMemrefI32(%V): (memref<*xi32>) -> ()
    // Free resources.
    bufferization.dealloc_tensor %5 : tensor<1024xf32, #SparseVector>
    bufferization.dealloc_tensor %8 : tensor<1024xf32, #SparseVector>



    return
  }

  func.func private @printMemrefI32(%ptr:memref<*xi32>) attributes {llvm.emit_c_interface}


  //func.func @main() {
  //  %v = arith.constant dense<[0,1,127,128,254]> : vector<5xi32>
  //  vector.print %v : vector<5xi32>
  //  %x = arith.constant 3 : i32
  //  vector.print %x : i32

  //  %fp_0 = arith.constant 0.0 : f32
  //  %fp_1 = arith.constant 1.0 : f32
  //  %sum = memref.alloc() : memref<2xf32>                                           
  //  %0 = arith.constant 0 : index
  //  %1 = arith.constant 1 : index
  //  memref.store %fp_0, %sum[%0] : memref<2xf32>                                     
  //  memref.store %fp_1, %sum[%1] : memref<2xf32>                                     
  //  %xx = memref.load %sum[%0] : memref<2xf32>
  //  %yy = memref.load %sum[%1] : memref<2xf32>

  //  vector.print %xx : f32
  //  vector.print %yy : f32
  //  //vector.print %sum : memref<2xf32> // ERROR

  //  %VA = vector.type_cast %sum : memref<2xf32> to memref<vector<2xf32>>
  //  %vm = memref.load %VA[] : memref<vector<2xf32>>
  //  vector.print %vm : vector<2xf32>
  //  
  //  return
  //}
}
