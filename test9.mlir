#sparse = #sparse_tensor.encoding<{ map = (d0) -> (d0 : compressed) }>
module {
  func.func private @printMemrefF32(memref<*xf32>) attributes {llvm.emit_c_interface}
  func.func private @printMemrefInd(memref<*xindex>) attributes {llvm.emit_c_interface}
  func.func @buffers_from_sparsevector(%arg0: index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>) {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %c8 = arith.constant 8 : index
    %cst = arith.constant 1.000000e+00 : f32
    %0 = tensor.empty() : tensor<1024xf32, #sparse>
    %1 = scf.for %arg1 = %c0 to %c8 step %c1 iter_args(%arg2 = %0) -> (tensor<1024xf32, #sparse>) {
      %6 = arith.muli %arg1, %arg0 : index
      %inserted = tensor.insert %cst into %arg2[%6] : tensor<1024xf32, #sparse>
      scf.yield %inserted : tensor<1024xf32, #sparse>
    }
    %2 = sparse_tensor.load %1 hasInserts : tensor<1024xf32, #sparse>
    %3 = sparse_tensor.positions %2 {level = 0 : index} : tensor<1024xf32, #sparse> to memref<?xindex>
    %4 = sparse_tensor.coordinates %2 {level = 0 : index} : tensor<1024xf32, #sparse> to memref<?xindex>
    %5 = sparse_tensor.values %2 : tensor<1024xf32, #sparse> to memref<?xf32>
    return %3, %4, %5 : memref<?xindex>, memref<?xindex>, memref<?xf32>
  }
  func.func private @binarysearch(%arg0: index, %arg1: memref<?xindex>, %arg2: memref<?xindex>) -> index {
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %0 = scf.while (%arg3 = %c0) : (index) -> index {
      %1 = memref.load %arg2[%arg3] : memref<?xindex>
      %2 = arith.cmpi ult, %arg0, %1 : index
      scf.condition(%2) %arg3 : index
    } do {
    ^bb0(%arg3: index):
      %1 = arith.addi %arg3, %c1 : index
      scf.yield %1 : index
    }
    return %0 : index
  }
  func.func @main() {
    %c100 = arith.constant 100 : index
    %c0 = arith.constant 0 : index
    %c1 = arith.constant 1 : index
    %cst = arith.constant 0.000000e+00 : f32
    %c2 = arith.constant 2 : index
    %c3 = arith.constant 3 : index
    %0:3 = call @buffers_from_sparsevector(%c2) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>)
    %1:3 = call @buffers_from_sparsevector(%c3) : (index) -> (memref<?xindex>, memref<?xindex>, memref<?xf32>)
    %cast = memref.cast %0#0 : memref<?xindex> to memref<*xindex>
    %cast_0 = memref.cast %0#1 : memref<?xindex> to memref<*xindex>
    %cast_1 = memref.cast %0#2 : memref<?xf32> to memref<*xf32>
    call @printMemrefInd(%cast) : (memref<*xindex>) -> ()
    call @printMemrefInd(%cast_0) : (memref<*xindex>) -> ()
    call @printMemrefF32(%cast_1) : (memref<*xf32>) -> ()
    %cast_2 = memref.cast %1#0 : memref<?xindex> to memref<*xindex>
    %cast_3 = memref.cast %1#1 : memref<?xindex> to memref<*xindex>
    %cast_4 = memref.cast %1#2 : memref<?xf32> to memref<*xf32>
    call @printMemrefInd(%cast_2) : (memref<*xindex>) -> ()
    call @printMemrefInd(%cast_3) : (memref<*xindex>) -> ()
    call @printMemrefF32(%cast_4) : (memref<*xf32>) -> ()
    %2 = memref.load %0#0[%c1] : memref<?xindex>
    %3 = arith.subi %2, %c1 : index
    %4 = memref.load %0#1[%3] : memref<?xindex>
    %5 = arith.addi %4, %c1 : index
    %6 = memref.load %1#0[%c1] : memref<?xindex>
    %7 = arith.subi %6, %c1 : index
    %8 = memref.load %1#1[%7] : memref<?xindex>
    %9 = arith.addi %8, %c1 : index
    %alloc = memref.alloc() : memref<f32>
    memref.store %cst, %alloc[] : memref<f32>
    %cast_5 = memref.cast %alloc : memref<f32> to memref<*xf32>
    call @printMemrefF32(%cast_5) : (memref<*xf32>) -> ()
    %10 = arith.minui %5, %c100 : index
    %11 = arith.minui %10, %9 : index
    %12 = call @binarysearch(%c0, %0#0, %0#1) : (index, memref<?xindex>, memref<?xindex>) -> index
    %13 = call @binarysearch(%c0, %1#0, %1#1) : (index, memref<?xindex>, memref<?xindex>) -> index
    %14:3 = scf.while (%arg0 = %12, %arg1 = %13, %arg2 = %c0) : (index, index, index) -> (index, index, index) {
      %20 = arith.cmpi ult, %arg2, %11 : index
      scf.condition(%20) %arg0, %arg1, %arg2 : index, index, index
    } do {
    ^bb0(%arg0: index, %arg1: index, %arg2: index):
      %20 = memref.load %0#1[%arg0] : memref<?xindex>
      %21 = arith.addi %20, %c1 : index
      %22 = arith.minui %11, %21 : index
      %23 = memref.load %1#1[%arg1] : memref<?xindex>
      %24 = arith.addi %23, %c1 : index
      %25 = arith.minui %22, %24 : index
      %26 = memref.load %0#1[%arg0] : memref<?xindex>
      %27 = memref.load %0#2[%arg0] : memref<?xf32>
      %28 = memref.load %1#1[%arg1] : memref<?xindex>
      %29 = memref.load %1#2[%arg1] : memref<?xf32>
      %30 = arith.minui %25, %26 : index
      %31 = arith.maxui %arg2, %26 : index
      %32 = arith.maxui %arg2, %28 : index

      vector.print str "pos0: "
      vector.print %arg0 : index 
      vector.print str "pos1: "
      vector.print %arg1 : index 
      %dd = memref.load %alloc[] : memref<f32>
      vector.print str "memrefvalue: "
      vector.print %dd : f32
      vector.print str "\n"


      scf.for %arg3 = %32 to %30 step %c1 {
        %39 = memref.load %alloc[] : memref<f32>
        %40 = arith.addf %39, %29 fastmath<nnan,ninf> : f32
        memref.store %40, %alloc[] : memref<f32>
      }
      %33 = arith.minui %25, %28 : index
      %34 = arith.maxui %31, %28 : index
      scf.for %arg3 = %31 to %33 step %c1 {
        %39 = memref.load %alloc[] : memref<f32>
        %40 = arith.addf %39, %27 fastmath<nnan,ninf> : f32
        memref.store %40, %alloc[] : memref<f32>
      }
      scf.for %arg3 = %34 to %25 step %c1 {
        %39 = memref.load %alloc[] : memref<f32>
        %40 = arith.addf %27, %29 fastmath<nnan,ninf> : f32
        %41 = arith.addf %39, %40 fastmath<nnan,ninf> : f32
        memref.store %41, %alloc[] : memref<f32>
      }
      %35 = arith.cmpi eq, %21, %25 : index
      %36 = scf.if %35 -> (index) {
        %39 = arith.addi %arg0, %c1 : index
        scf.yield %39 : index
      } else {
        scf.yield %arg0 : index
      }
      %37 = arith.cmpi eq, %24, %25 : index
      %38 = scf.if %37 -> (index) {
        %39 = arith.addi %arg1, %c1 : index
        scf.yield %39 : index
      } else {
        scf.yield %arg1 : index
      }
      scf.yield %36, %38, %25 : index, index, index
    }
    %15 = call @binarysearch(%9, %0#0, %0#1) : (index, memref<?xindex>, memref<?xindex>) -> index
    %16:2 = scf.while (%arg0 = %15, %arg1 = %9) : (index, index) -> (index, index) {
      %20 = arith.cmpi ult, %arg1, %10 : index
      scf.condition(%20) %arg0, %arg1 : index, index
    } do {
    ^bb0(%arg0: index, %arg1: index):
      vector.print str "Apos0: "
      vector.print %arg0 : index 
      vector.print str "Loop Start Index "
      vector.print %arg1 : index 
      %dd = memref.load %alloc[] : memref<f32>
      vector.print str "memrefvalue: "
      vector.print %dd : f32
      vector.print str "\n"


      %20 = memref.load %0#1[%arg0] : memref<?xindex>
      %21 = arith.addi %20, %c1 : index
      %22 = arith.minui %10, %21 : index
      %23 = memref.load %0#1[%arg0] : memref<?xindex>
      %24 = memref.load %0#2[%arg0] : memref<?xf32>
      %25 = arith.maxui %arg1, %23 : index
      scf.for %arg2 = %25 to %22 step %c1 {
        %28 = memref.load %alloc[] : memref<f32>
        %29 = arith.addf %28, %24 fastmath<nnan,ninf> : f32
        memref.store %29, %alloc[] : memref<f32>
      }
      %26 = arith.cmpi eq, %21, %22 : index
      %27 = scf.if %26 -> (index) {
        %28 = arith.addi %arg0, %c1 : index
        scf.yield %28 : index
      } else {
        scf.yield %arg0 : index
      }
      scf.yield %27, %22 : index, index
    }
    %17 = arith.minui %9, %c100 : index
    %18 = call @binarysearch(%5, %1#0, %1#1) : (index, memref<?xindex>, memref<?xindex>) -> index
    %19:2 = scf.while (%arg0 = %18, %arg1 = %5) : (index, index) -> (index, index) {
      %20 = arith.cmpi ult, %arg1, %17 : index
      scf.condition(%20) %arg0, %arg1 : index, index
    } do {
    ^bb0(%arg0: index, %arg1: index):
      vector.print str "Bpos0: "
      vector.print %arg0 : index 
      vector.print str "Loop Start Index "
      vector.print %arg1 : index 
      %dd = memref.load %alloc[] : memref<f32>
      vector.print str "memrefvalue: "
      vector.print %dd : f32
      vector.print str "\n"
      %20 = memref.load %1#1[%arg0] : memref<?xindex>
      %21 = arith.addi %20, %c1 : index
      %22 = arith.minui %17, %21 : index
      %23 = memref.load %1#1[%arg0] : memref<?xindex>
      %24 = memref.load %1#2[%arg0] : memref<?xf32>
      %25 = arith.maxui %arg1, %23 : index
      scf.for %arg2 = %25 to %22 step %c1 {
        %28 = memref.load %alloc[] : memref<f32>
        %29 = arith.addf %28, %24 fastmath<nnan,ninf> : f32
        memref.store %29, %alloc[] : memref<f32>
      }
      %26 = arith.cmpi eq, %21, %22 : index
      %27 = scf.if %26 -> (index) {
        %28 = arith.addi %arg0, %c1 : index
        scf.yield %28 : index
      } else {
        scf.yield %arg0 : index
      }
      scf.yield %27, %22 : index, index
    }
    %cast_6 = memref.cast %alloc : memref<f32> to memref<*xf32>
    call @printMemrefF32(%cast_6) : (memref<*xf32>) -> ()
    return
  }
}
