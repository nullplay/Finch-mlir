module {
  func.func @foo(%a : memref<10x10xf32>, %b : memref<10xf32>, %c : memref<10xf32>) {
    func.call @foo_0(%a, %b) : (memref<10x10xf32>, memref<10xf32>) -> ()
    func.call @foo_1(%b, %c) : (memref<10xf32>, memref<10xf32>) -> ()
    return
  }
  func.func private @foo_0(%a : memref<10x10xf32>, %b : memref<10xf32>) {
    affine.for %i0 = 0 to 10 {
      affine.for %i1 = 0 to 10 {
        %v0 = affine.load %b[%i0] : memref<10xf32>
        %v1 = affine.load %a[%i0, %i1] : memref<10x10xf32>
        %v3 = arith.addf %v0, %v1 : f32
        affine.store %v3, %b[%i0] : memref<10xf32>
      }
    }
    return
  }
  func.func private @foo_1(%b : memref<10xf32>, %c : memref<10xf32>) {
    affine.for %i2 = 0 to 10 {
      %v4 = affine.load %b[%i2] : memref<10xf32>
      affine.store %v4, %c[%i2] : memref<10xf32>
    }
    return
  }
}
