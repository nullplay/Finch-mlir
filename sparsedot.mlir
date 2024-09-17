#SparseVector = #sparse_tensor.encoding<{ map = (d0) -> (d0 : compressed) }>

module {

  //
  // Sparse kernel.
  //
  func.func @sparse_dot(%a: tensor<1024xf32, #SparseVector>,
                        %b: tensor<1024xf32, #SparseVector>,
                        %x: tensor<f32>) -> tensor<f32> {
    %dot = linalg.dot ins(%a, %b: tensor<1024xf32, #SparseVector>,
                                  tensor<1024xf32, #SparseVector>)
         outs(%x: tensor<f32>) -> tensor<f32>
    return %dot : tensor<f32>
  }

  //
  // Main driver.
  //
  func.func @main() {
    // Setup two sparse vectors.
    %d1 = arith.constant sparse<
        [ [0], [1], [22], [23], [1022] ], [1.0, 2.0, 3.0, 4.0, 5.0]
    > : tensor<1024xf32>
    %d2 = arith.constant sparse<
      [ [22], [1022], [1023] ], [6.0, 7.0, 8.0]
    > : tensor<1024xf32>
    %s1 = sparse_tensor.convert %d1 : tensor<1024xf32> to tensor<1024xf32, #SparseVector>
    %s2 = sparse_tensor.convert %d2 : tensor<1024xf32> to tensor<1024xf32, #SparseVector>

    //
    // Verify the inputs.
    //
    // CHECK:      ---- Sparse Tensor ----
    // CHECK-NEXT: nse = 5
    // CHECK-NEXT: dim = ( 1024 )
    // CHECK-NEXT: lvl = ( 1024 )
    // CHECK-NEXT: pos[0] : ( 0, 5 )
    // CHECK-NEXT: crd[0] : ( 0, 1, 22, 23, 1022 )
    // CHECK-NEXT: values : ( 1, 2, 3, 4, 5 )
    // CHECK-NEXT: ----
    //
    // CHECK:      ---- Sparse Tensor ----
    // CHECK-NEXT: nse = 3
    // CHECK-NEXT: dim = ( 1024 )
    // CHECK-NEXT: lvl = ( 1024 )
    // CHECK-NEXT: pos[0] : ( 0, 3 )
    // CHECK-NEXT: crd[0] : ( 22, 1022, 1023 )
    // CHECK-NEXT: values : ( 6, 7, 8 )
    // CHECK-NEXT: ----
    //
    sparse_tensor.print %s1 : tensor<1024xf32, #SparseVector>
    sparse_tensor.print %s2 : tensor<1024xf32, #SparseVector>

    // Call the kernel and verify the output.
    //
    // CHECK: 53
    //
    %t = tensor.empty() : tensor<f32>
    %z = arith.constant 0.0 : f32
    %x = tensor.insert %z into %t[] : tensor<f32>
    %0 = call @sparse_dot(%s1, %s2, %x) : (tensor<1024xf32, #SparseVector>,
                                           tensor<1024xf32, #SparseVector>,
                                           tensor<f32>) -> tensor<f32>
    %1 = tensor.extract %0[] : tensor<f32>
    vector.print %1 : f32

    // Release the resources.
    bufferization.dealloc_tensor %0 : tensor<f32>
    bufferization.dealloc_tensor %s1 : tensor<1024xf32, #SparseVector>
    bufferization.dealloc_tensor %s2 : tensor<1024xf32, #SparseVector>

    return
  }
}
