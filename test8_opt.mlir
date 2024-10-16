module {
  llvm.func @malloc(i64) -> !llvm.ptr
  llvm.func private @sparseValuesF32(%arg0: !llvm.ptr) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.alloca %0 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.call @_mlir_ciface_sparseValuesF32(%1, %arg0) : (!llvm.ptr, !llvm.ptr) -> ()
    %2 = llvm.load %1 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.return %2 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
  }
  llvm.func @_mlir_ciface_sparseValuesF32(!llvm.ptr, !llvm.ptr) attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func private @sparseCoordinates0(%arg0: !llvm.ptr, %arg1: i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.alloca %0 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.call @_mlir_ciface_sparseCoordinates0(%1, %arg0, %arg1) : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %2 = llvm.load %1 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.return %2 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
  }
  llvm.func @_mlir_ciface_sparseCoordinates0(!llvm.ptr, !llvm.ptr, i64) attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func private @sparsePositions0(%arg0: !llvm.ptr, %arg1: i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.constant(1 : index) : i64
    %1 = llvm.alloca %0 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.call @_mlir_ciface_sparsePositions0(%1, %arg0, %arg1) : (!llvm.ptr, !llvm.ptr, i64) -> ()
    %2 = llvm.load %1 : !llvm.ptr -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    llvm.return %2 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
  }
  llvm.func @_mlir_ciface_sparsePositions0(!llvm.ptr, !llvm.ptr, i64) attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func @endLexInsert(!llvm.ptr) attributes {sym_visibility = "private"}
  llvm.func private @lexInsertF32(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: !llvm.ptr, %arg7: !llvm.ptr, %arg8: i64) attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg1, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg2, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg3, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg4, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg5, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.alloca %6 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %5, %7 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %8 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64)>
    %9 = llvm.insertvalue %arg6, %8[0] : !llvm.struct<(ptr, ptr, i64)> 
    %10 = llvm.insertvalue %arg7, %9[1] : !llvm.struct<(ptr, ptr, i64)> 
    %11 = llvm.insertvalue %arg8, %10[2] : !llvm.struct<(ptr, ptr, i64)> 
    %12 = llvm.mlir.constant(1 : index) : i64
    %13 = llvm.alloca %12 x !llvm.struct<(ptr, ptr, i64)> : (i64) -> !llvm.ptr
    llvm.store %11, %13 : !llvm.struct<(ptr, ptr, i64)>, !llvm.ptr
    llvm.call @_mlir_ciface_lexInsertF32(%arg0, %7, %13) : (!llvm.ptr, !llvm.ptr, !llvm.ptr) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_lexInsertF32(!llvm.ptr, !llvm.ptr, !llvm.ptr) attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func private @newSparseTensor(%arg0: !llvm.ptr, %arg1: !llvm.ptr, %arg2: i64, %arg3: i64, %arg4: i64, %arg5: !llvm.ptr, %arg6: !llvm.ptr, %arg7: i64, %arg8: i64, %arg9: i64, %arg10: !llvm.ptr, %arg11: !llvm.ptr, %arg12: i64, %arg13: i64, %arg14: i64, %arg15: !llvm.ptr, %arg16: !llvm.ptr, %arg17: i64, %arg18: i64, %arg19: i64, %arg20: !llvm.ptr, %arg21: !llvm.ptr, %arg22: i64, %arg23: i64, %arg24: i64, %arg25: i32, %arg26: i32, %arg27: i32, %arg28: i32, %arg29: !llvm.ptr) -> !llvm.ptr attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg2, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg3, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg4, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.alloca %6 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %5, %7 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %8 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %9 = llvm.insertvalue %arg5, %8[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %10 = llvm.insertvalue %arg6, %9[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %11 = llvm.insertvalue %arg7, %10[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %12 = llvm.insertvalue %arg8, %11[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %13 = llvm.insertvalue %arg9, %12[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %14 = llvm.mlir.constant(1 : index) : i64
    %15 = llvm.alloca %14 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %13, %15 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %16 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %17 = llvm.insertvalue %arg10, %16[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.insertvalue %arg11, %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.insertvalue %arg12, %18[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %20 = llvm.insertvalue %arg13, %19[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %21 = llvm.insertvalue %arg14, %20[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %22 = llvm.mlir.constant(1 : index) : i64
    %23 = llvm.alloca %22 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %21, %23 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %24 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %25 = llvm.insertvalue %arg15, %24[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.insertvalue %arg16, %25[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %27 = llvm.insertvalue %arg17, %26[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %28 = llvm.insertvalue %arg18, %27[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %29 = llvm.insertvalue %arg19, %28[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.mlir.constant(1 : index) : i64
    %31 = llvm.alloca %30 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %29, %31 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %32 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %33 = llvm.insertvalue %arg20, %32[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %34 = llvm.insertvalue %arg21, %33[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %35 = llvm.insertvalue %arg22, %34[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %36 = llvm.insertvalue %arg23, %35[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %37 = llvm.insertvalue %arg24, %36[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.mlir.constant(1 : index) : i64
    %39 = llvm.alloca %38 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %37, %39 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %40 = llvm.call @_mlir_ciface_newSparseTensor(%7, %15, %23, %31, %39, %arg25, %arg26, %arg27, %arg28, %arg29) : (!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32, i32, !llvm.ptr) -> !llvm.ptr
    llvm.return %40 : !llvm.ptr
  }
  llvm.func @_mlir_ciface_newSparseTensor(!llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, !llvm.ptr, i32, i32, i32, i32, !llvm.ptr) -> !llvm.ptr attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func private @printMemrefF32(%arg0: i64, %arg1: !llvm.ptr) attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(i64, ptr)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(i64, ptr)> 
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.alloca %3 x !llvm.struct<(i64, ptr)> : (i64) -> !llvm.ptr
    llvm.store %2, %4 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.call @_mlir_ciface_printMemrefF32(%4) : (!llvm.ptr) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_printMemrefF32(!llvm.ptr) attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func private @printMemrefInd(%arg0: i64, %arg1: !llvm.ptr) attributes {llvm.emit_c_interface, sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %1 = llvm.insertvalue %arg0, %0[0] : !llvm.struct<(i64, ptr)> 
    %2 = llvm.insertvalue %arg1, %1[1] : !llvm.struct<(i64, ptr)> 
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.alloca %3 x !llvm.struct<(i64, ptr)> : (i64) -> !llvm.ptr
    llvm.store %2, %4 : !llvm.struct<(i64, ptr)>, !llvm.ptr
    llvm.call @_mlir_ciface_printMemrefInd(%4) : (!llvm.ptr) -> ()
    llvm.return
  }
  llvm.func @_mlir_ciface_printMemrefInd(!llvm.ptr) attributes {llvm.emit_c_interface, sym_visibility = "private"}
  llvm.func @buffers_from_sparsevector(%arg0: i64) -> !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64)>
    %1 = llvm.mlir.constant(0 : index) : i64
    %2 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %3 = llvm.mlir.constant(1 : index) : i64
    %4 = llvm.mlir.constant(262144 : i64) : i64
    %5 = llvm.mlir.constant(1024 : index) : i64
    %6 = llvm.mlir.constant(1.000000e+00 : f32) : f32
    %7 = llvm.mlir.constant(8 : index) : i64
    %8 = llvm.mlir.constant(1 : index) : i64
    %9 = llvm.mlir.zero : !llvm.ptr
    %10 = llvm.mlir.constant(2 : i32) : i32
    %11 = llvm.mlir.constant(0 : i32) : i32
    %12 = llvm.mlir.constant(0 : index) : i64
    %13 = llvm.alloca %3 x i64 : (i64) -> !llvm.ptr
    %14 = llvm.insertvalue %13, %2[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %15 = llvm.insertvalue %13, %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %16 = llvm.insertvalue %1, %15[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %17 = llvm.insertvalue %3, %16[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %18 = llvm.insertvalue %3, %17[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %19 = llvm.getelementptr %13[%12] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    llvm.store %4, %19 : i64, !llvm.ptr
    %20 = llvm.alloca %3 x i64 : (i64) -> !llvm.ptr
    %21 = llvm.insertvalue %20, %2[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %22 = llvm.insertvalue %20, %21[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %23 = llvm.insertvalue %1, %22[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %24 = llvm.insertvalue %3, %23[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %25 = llvm.insertvalue %3, %24[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %26 = llvm.getelementptr %20[%12] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    llvm.store %5, %26 : i64, !llvm.ptr
    %27 = llvm.alloca %3 x i64 : (i64) -> !llvm.ptr
    %28 = llvm.insertvalue %27, %2[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %29 = llvm.insertvalue %27, %28[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %30 = llvm.insertvalue %1, %29[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %31 = llvm.insertvalue %3, %30[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %32 = llvm.insertvalue %3, %31[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %33 = llvm.getelementptr %27[%12] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    llvm.store %12, %33 : i64, !llvm.ptr
    %34 = llvm.extractvalue %25[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %35 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %36 = llvm.extractvalue %25[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %37 = llvm.extractvalue %25[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %38 = llvm.extractvalue %25[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %39 = llvm.extractvalue %25[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %40 = llvm.extractvalue %25[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %41 = llvm.extractvalue %25[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %42 = llvm.extractvalue %25[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %43 = llvm.extractvalue %25[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %44 = llvm.extractvalue %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %45 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %46 = llvm.extractvalue %18[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %47 = llvm.extractvalue %18[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %48 = llvm.extractvalue %18[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %49 = llvm.extractvalue %32[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %50 = llvm.extractvalue %32[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.extractvalue %32[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %52 = llvm.extractvalue %32[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %53 = llvm.extractvalue %32[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %54 = llvm.extractvalue %32[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %55 = llvm.extractvalue %32[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %56 = llvm.extractvalue %32[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %57 = llvm.extractvalue %32[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %58 = llvm.extractvalue %32[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %59 = llvm.call @newSparseTensor(%34, %35, %36, %37, %38, %39, %40, %41, %42, %43, %44, %45, %46, %47, %48, %49, %50, %51, %52, %53, %54, %55, %56, %57, %58, %11, %11, %10, %11, %9) : (!llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, i32, i32, i32, i32, !llvm.ptr) -> !llvm.ptr
    %60 = llvm.alloca %3 x i64 : (i64) -> !llvm.ptr
    %61 = llvm.insertvalue %60, %2[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %62 = llvm.insertvalue %60, %61[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %63 = llvm.insertvalue %1, %62[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %64 = llvm.insertvalue %3, %63[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %65 = llvm.insertvalue %3, %64[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %66 = llvm.alloca %3 x f32 : (i64) -> !llvm.ptr
    %67 = llvm.insertvalue %66, %0[0] : !llvm.struct<(ptr, ptr, i64)> 
    %68 = llvm.insertvalue %66, %67[1] : !llvm.struct<(ptr, ptr, i64)> 
    %69 = llvm.insertvalue %1, %68[2] : !llvm.struct<(ptr, ptr, i64)> 
    llvm.br ^bb1(%12 : i64)
  ^bb1(%70: i64):  // 2 preds: ^bb0, ^bb2
    %71 = llvm.icmp "slt" %70, %7 : i64
    llvm.cond_br %71, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %72 = llvm.mul %70, %arg0 : i64
    %73 = llvm.getelementptr %60[%12] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    llvm.store %72, %73 : i64, !llvm.ptr
    llvm.store %6, %66 : f32, !llvm.ptr
    %74 = llvm.extractvalue %65[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %75 = llvm.extractvalue %65[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %76 = llvm.extractvalue %65[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %77 = llvm.extractvalue %65[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %78 = llvm.extractvalue %65[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %79 = llvm.extractvalue %69[0] : !llvm.struct<(ptr, ptr, i64)> 
    %80 = llvm.extractvalue %69[1] : !llvm.struct<(ptr, ptr, i64)> 
    %81 = llvm.extractvalue %69[2] : !llvm.struct<(ptr, ptr, i64)> 
    llvm.call @lexInsertF32(%59, %74, %75, %76, %77, %78, %79, %80, %81) : (!llvm.ptr, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64) -> ()
    %82 = llvm.add %70, %8 : i64
    llvm.br ^bb1(%82 : i64)
  ^bb3:  // pred: ^bb1
    llvm.call @endLexInsert(%59) : (!llvm.ptr) -> ()
    %83 = llvm.call @sparsePositions0(%59, %12) : (!llvm.ptr, i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %84 = llvm.call @sparseCoordinates0(%59, %12) : (!llvm.ptr, i64) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %85 = llvm.call @sparseValuesF32(%59) : (!llvm.ptr) -> !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %86 = llvm.mlir.undef : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)>
    %87 = llvm.insertvalue %83, %86[0] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %88 = llvm.insertvalue %84, %87[1] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %89 = llvm.insertvalue %85, %88[2] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    llvm.return %89 : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)>
  }
  llvm.func @binarysearch(%arg0: i64, %arg1: !llvm.ptr, %arg2: !llvm.ptr, %arg3: i64, %arg4: i64, %arg5: i64, %arg6: !llvm.ptr, %arg7: !llvm.ptr, %arg8: i64, %arg9: i64, %arg10: i64) -> i64 attributes {sym_visibility = "private"} {
    %0 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>
    %1 = llvm.insertvalue %arg6, %0[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %2 = llvm.insertvalue %arg7, %1[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %3 = llvm.insertvalue %arg8, %2[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %4 = llvm.insertvalue %arg9, %3[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %5 = llvm.insertvalue %arg10, %4[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %6 = llvm.mlir.constant(1 : index) : i64
    %7 = llvm.mlir.constant(0 : index) : i64
    llvm.br ^bb1(%7 : i64)
  ^bb1(%8: i64):  // 2 preds: ^bb0, ^bb2
    %9 = llvm.extractvalue %5[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %10 = llvm.getelementptr %9[%8] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %11 = llvm.load %10 : !llvm.ptr -> i64
    %12 = llvm.icmp "ult" %11, %arg0 : i64
    llvm.cond_br %12, ^bb2, ^bb3
  ^bb2:  // pred: ^bb1
    %13 = llvm.add %8, %6 : i64
    llvm.br ^bb1(%13 : i64)
  ^bb3:  // pred: ^bb1
    llvm.return %8 : i64
  }
  llvm.func @main() {
    %0 = llvm.mlir.constant(0 : index) : i64
    %1 = llvm.mlir.undef : !llvm.struct<(ptr, ptr, i64)>
    %2 = llvm.mlir.zero : !llvm.ptr
    %3 = llvm.mlir.undef : !llvm.struct<(i64, ptr)>
    %4 = llvm.mlir.constant(1 : index) : i64
    %5 = llvm.mlir.constant(3 : index) : i64
    %6 = llvm.mlir.constant(2 : index) : i64
    %7 = llvm.mlir.constant(0.000000e+00 : f32) : f32
    %8 = llvm.mlir.constant(-0.000000e+00 : f32) : f32
    %9 = llvm.mlir.constant(100 : index) : i64
    %10 = llvm.mlir.constant(0 : index) : i64
    %11 = llvm.mlir.constant(1 : index) : i64
    %12 = llvm.call @buffers_from_sparsevector(%6) : (i64) -> !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)>
    %13 = llvm.extractvalue %12[0] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %14 = llvm.extractvalue %12[1] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %15 = llvm.extractvalue %12[2] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %16 = llvm.call @buffers_from_sparsevector(%5) : (i64) -> !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)>
    %17 = llvm.extractvalue %16[0] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %18 = llvm.extractvalue %16[1] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %19 = llvm.extractvalue %16[2] : !llvm.struct<(struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>)> 
    %20 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %13, %20 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %21 = llvm.insertvalue %4, %3[0] : !llvm.struct<(i64, ptr)> 
    %22 = llvm.insertvalue %20, %21[1] : !llvm.struct<(i64, ptr)> 
    %23 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %14, %23 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %24 = llvm.insertvalue %4, %3[0] : !llvm.struct<(i64, ptr)> 
    %25 = llvm.insertvalue %23, %24[1] : !llvm.struct<(i64, ptr)> 
    %26 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %15, %26 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %27 = llvm.insertvalue %4, %3[0] : !llvm.struct<(i64, ptr)> 
    %28 = llvm.insertvalue %26, %27[1] : !llvm.struct<(i64, ptr)> 
    %29 = llvm.extractvalue %22[0] : !llvm.struct<(i64, ptr)> 
    %30 = llvm.extractvalue %22[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefInd(%29, %30) : (i64, !llvm.ptr) -> ()
    %31 = llvm.extractvalue %25[0] : !llvm.struct<(i64, ptr)> 
    %32 = llvm.extractvalue %25[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefInd(%31, %32) : (i64, !llvm.ptr) -> ()
    %33 = llvm.extractvalue %28[0] : !llvm.struct<(i64, ptr)> 
    %34 = llvm.extractvalue %28[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefF32(%33, %34) : (i64, !llvm.ptr) -> ()
    %35 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %17, %35 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %36 = llvm.insertvalue %4, %3[0] : !llvm.struct<(i64, ptr)> 
    %37 = llvm.insertvalue %35, %36[1] : !llvm.struct<(i64, ptr)> 
    %38 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %18, %38 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %39 = llvm.insertvalue %4, %3[0] : !llvm.struct<(i64, ptr)> 
    %40 = llvm.insertvalue %38, %39[1] : !llvm.struct<(i64, ptr)> 
    %41 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> : (i64) -> !llvm.ptr
    llvm.store %19, %41 : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)>, !llvm.ptr
    %42 = llvm.insertvalue %4, %3[0] : !llvm.struct<(i64, ptr)> 
    %43 = llvm.insertvalue %41, %42[1] : !llvm.struct<(i64, ptr)> 
    %44 = llvm.extractvalue %37[0] : !llvm.struct<(i64, ptr)> 
    %45 = llvm.extractvalue %37[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefInd(%44, %45) : (i64, !llvm.ptr) -> ()
    %46 = llvm.extractvalue %40[0] : !llvm.struct<(i64, ptr)> 
    %47 = llvm.extractvalue %40[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefInd(%46, %47) : (i64, !llvm.ptr) -> ()
    %48 = llvm.extractvalue %43[0] : !llvm.struct<(i64, ptr)> 
    %49 = llvm.extractvalue %43[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefF32(%48, %49) : (i64, !llvm.ptr) -> ()
    %50 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %51 = llvm.getelementptr %50[%11] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %52 = llvm.load %51 : !llvm.ptr -> i64
    %53 = llvm.sub %52, %11 : i64
    %54 = llvm.extractvalue %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %55 = llvm.getelementptr %54[%53] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %56 = llvm.load %55 : !llvm.ptr -> i64
    %57 = llvm.add %56, %11 : i64
    %58 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %59 = llvm.getelementptr %58[%11] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %60 = llvm.load %59 : !llvm.ptr -> i64
    %61 = llvm.sub %60, %11 : i64
    %62 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %63 = llvm.getelementptr %62[%61] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %64 = llvm.load %63 : !llvm.ptr -> i64
    %65 = llvm.add %64, %11 : i64
    %66 = llvm.getelementptr %2[1] : (!llvm.ptr) -> !llvm.ptr, f32
    %67 = llvm.ptrtoint %66 : !llvm.ptr to i64
    %68 = llvm.call @malloc(%67) : (i64) -> !llvm.ptr
    %69 = llvm.insertvalue %68, %1[0] : !llvm.struct<(ptr, ptr, i64)> 
    %70 = llvm.insertvalue %68, %69[1] : !llvm.struct<(ptr, ptr, i64)> 
    %71 = llvm.insertvalue %0, %70[2] : !llvm.struct<(ptr, ptr, i64)> 
    llvm.store %7, %68 : f32, !llvm.ptr
    %72 = llvm.icmp "ult" %57, %9 : i64
    %73 = llvm.select %72, %57, %9 : i1, i64
    %74 = llvm.icmp "ult" %73, %65 : i64
    %75 = llvm.select %74, %73, %65 : i1, i64
    %76 = llvm.extractvalue %13[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %77 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %78 = llvm.extractvalue %13[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %79 = llvm.extractvalue %13[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %80 = llvm.extractvalue %13[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %81 = llvm.extractvalue %14[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %82 = llvm.extractvalue %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %83 = llvm.extractvalue %14[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %84 = llvm.extractvalue %14[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %85 = llvm.extractvalue %14[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %86 = llvm.call @binarysearch(%10, %76, %77, %78, %79, %80, %81, %82, %83, %84, %85) : (i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64) -> i64
    %87 = llvm.extractvalue %17[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %88 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %89 = llvm.extractvalue %17[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %90 = llvm.extractvalue %17[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %91 = llvm.extractvalue %17[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %92 = llvm.extractvalue %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %93 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %94 = llvm.extractvalue %18[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %95 = llvm.extractvalue %18[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %96 = llvm.extractvalue %18[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %97 = llvm.call @binarysearch(%10, %87, %88, %89, %90, %91, %92, %93, %94, %95, %96) : (i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64) -> i64
    llvm.br ^bb1(%86, %97, %10 : i64, i64, i64)
  ^bb1(%98: i64, %99: i64, %100: i64):  // 2 preds: ^bb0, ^bb22
    %101 = llvm.icmp "ult" %100, %75 : i64
    llvm.cond_br %101, ^bb2, ^bb23
  ^bb2:  // pred: ^bb1
    %102 = llvm.extractvalue %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %103 = llvm.getelementptr %102[%98] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %104 = llvm.load %103 : !llvm.ptr -> i64
    %105 = llvm.add %104, %11 : i64
    %106 = llvm.icmp "ult" %75, %105 : i64
    %107 = llvm.select %106, %75, %105 : i1, i64
    %108 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %109 = llvm.getelementptr %108[%99] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %110 = llvm.load %109 : !llvm.ptr -> i64
    %111 = llvm.add %110, %11 : i64
    %112 = llvm.icmp "ult" %107, %111 : i64
    %113 = llvm.select %112, %107, %111 : i1, i64
    %114 = llvm.extractvalue %15[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %115 = llvm.getelementptr %114[%98] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %116 = llvm.load %115 : !llvm.ptr -> f32
    %117 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %118 = llvm.getelementptr %117[%99] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %119 = llvm.load %118 : !llvm.ptr -> f32
    %120 = llvm.icmp "ult" %113, %104 : i64
    %121 = llvm.select %120, %113, %104 : i1, i64
    %122 = llvm.icmp "ugt" %100, %104 : i64
    %123 = llvm.select %122, %100, %104 : i1, i64
    %124 = llvm.icmp "ult" %121, %110 : i64
    %125 = llvm.select %124, %121, %110 : i1, i64
    %126 = llvm.icmp "ugt" %100, %110 : i64
    %127 = llvm.select %126, %100, %110 : i1, i64
    llvm.br ^bb3(%100 : i64)
  ^bb3(%128: i64):  // 2 preds: ^bb2, ^bb4
    %129 = llvm.icmp "slt" %128, %125 : i64
    llvm.cond_br %129, ^bb4, ^bb5
  ^bb4:  // pred: ^bb3
    %130 = llvm.load %68 : !llvm.ptr -> f32
    %131 = llvm.fadd %130, %7  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %131, %68 : f32, !llvm.ptr
    %132 = llvm.add %128, %11 : i64
    llvm.br ^bb3(%132 : i64)
  ^bb5:  // pred: ^bb3
    %133 = llvm.fmul %119, %8  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.br ^bb6(%127 : i64)
  ^bb6(%134: i64):  // 2 preds: ^bb5, ^bb7
    %135 = llvm.icmp "slt" %134, %121 : i64
    llvm.cond_br %135, ^bb7, ^bb8
  ^bb7:  // pred: ^bb6
    %136 = llvm.load %68 : !llvm.ptr -> f32
    %137 = llvm.fadd %136, %133  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %137, %68 : f32, !llvm.ptr
    %138 = llvm.add %134, %11 : i64
    llvm.br ^bb6(%138 : i64)
  ^bb8:  // pred: ^bb6
    %139 = llvm.icmp "ult" %113, %110 : i64
    %140 = llvm.select %139, %113, %110 : i1, i64
    %141 = llvm.icmp "ugt" %123, %110 : i64
    %142 = llvm.select %141, %123, %110 : i1, i64
    %143 = llvm.fmul %116, %8  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.br ^bb9(%123 : i64)
  ^bb9(%144: i64):  // 2 preds: ^bb8, ^bb10
    %145 = llvm.icmp "slt" %144, %140 : i64
    llvm.cond_br %145, ^bb10, ^bb11
  ^bb10:  // pred: ^bb9
    %146 = llvm.load %68 : !llvm.ptr -> f32
    %147 = llvm.fadd %146, %143  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %147, %68 : f32, !llvm.ptr
    %148 = llvm.add %144, %11 : i64
    llvm.br ^bb9(%148 : i64)
  ^bb11:  // pred: ^bb9
    %149 = llvm.fmul %116, %119  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.br ^bb12(%142 : i64)
  ^bb12(%150: i64):  // 2 preds: ^bb11, ^bb13
    %151 = llvm.icmp "slt" %150, %113 : i64
    llvm.cond_br %151, ^bb13, ^bb14
  ^bb13:  // pred: ^bb12
    %152 = llvm.load %68 : !llvm.ptr -> f32
    %153 = llvm.fadd %152, %149  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %153, %68 : f32, !llvm.ptr
    %154 = llvm.add %150, %11 : i64
    llvm.br ^bb12(%154 : i64)
  ^bb14:  // pred: ^bb12
    %155 = llvm.icmp "eq" %105, %113 : i64
    llvm.cond_br %155, ^bb15, ^bb16
  ^bb15:  // pred: ^bb14
    %156 = llvm.add %98, %11 : i64
    llvm.br ^bb17(%156 : i64)
  ^bb16:  // pred: ^bb14
    llvm.br ^bb17(%98 : i64)
  ^bb17(%157: i64):  // 2 preds: ^bb15, ^bb16
    llvm.br ^bb18
  ^bb18:  // pred: ^bb17
    %158 = llvm.icmp "eq" %111, %113 : i64
    llvm.cond_br %158, ^bb19, ^bb20
  ^bb19:  // pred: ^bb18
    %159 = llvm.add %99, %11 : i64
    llvm.br ^bb21(%159 : i64)
  ^bb20:  // pred: ^bb18
    llvm.br ^bb21(%99 : i64)
  ^bb21(%160: i64):  // 2 preds: ^bb19, ^bb20
    llvm.br ^bb22
  ^bb22:  // pred: ^bb21
    llvm.br ^bb1(%157, %160, %113 : i64, i64, i64)
  ^bb23:  // pred: ^bb1
    %161 = llvm.extractvalue %13[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %162 = llvm.extractvalue %13[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %163 = llvm.extractvalue %13[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %164 = llvm.extractvalue %13[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %165 = llvm.extractvalue %13[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %166 = llvm.extractvalue %14[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %167 = llvm.extractvalue %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %168 = llvm.extractvalue %14[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %169 = llvm.extractvalue %14[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %170 = llvm.extractvalue %14[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %171 = llvm.call @binarysearch(%65, %161, %162, %163, %164, %165, %166, %167, %168, %169, %170) : (i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64) -> i64
    llvm.br ^bb24(%171, %65 : i64, i64)
  ^bb24(%172: i64, %173: i64):  // 2 preds: ^bb23, ^bb35
    %174 = llvm.icmp "ult" %173, %73 : i64
    llvm.cond_br %174, ^bb25, ^bb36
  ^bb25:  // pred: ^bb24
    %175 = llvm.extractvalue %14[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %176 = llvm.getelementptr %175[%172] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %177 = llvm.load %176 : !llvm.ptr -> i64
    %178 = llvm.add %177, %11 : i64
    %179 = llvm.icmp "ult" %73, %178 : i64
    %180 = llvm.select %179, %73, %178 : i1, i64
    %181 = llvm.extractvalue %15[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %182 = llvm.getelementptr %181[%172] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %183 = llvm.load %182 : !llvm.ptr -> f32
    %184 = llvm.icmp "ult" %180, %177 : i64
    %185 = llvm.select %184, %180, %177 : i1, i64
    %186 = llvm.icmp "ugt" %173, %177 : i64
    %187 = llvm.select %186, %173, %177 : i1, i64
    llvm.br ^bb26(%173 : i64)
  ^bb26(%188: i64):  // 2 preds: ^bb25, ^bb27
    %189 = llvm.icmp "slt" %188, %185 : i64
    llvm.cond_br %189, ^bb27, ^bb28
  ^bb27:  // pred: ^bb26
    %190 = llvm.load %68 : !llvm.ptr -> f32
    %191 = llvm.fadd %190, %7  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %191, %68 : f32, !llvm.ptr
    %192 = llvm.add %188, %11 : i64
    llvm.br ^bb26(%192 : i64)
  ^bb28:  // pred: ^bb26
    %193 = llvm.fmul %183, %8  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.br ^bb29(%187 : i64)
  ^bb29(%194: i64):  // 2 preds: ^bb28, ^bb30
    %195 = llvm.icmp "slt" %194, %180 : i64
    llvm.cond_br %195, ^bb30, ^bb31
  ^bb30:  // pred: ^bb29
    %196 = llvm.load %68 : !llvm.ptr -> f32
    %197 = llvm.fadd %196, %193  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %197, %68 : f32, !llvm.ptr
    %198 = llvm.add %194, %11 : i64
    llvm.br ^bb29(%198 : i64)
  ^bb31:  // pred: ^bb29
    %199 = llvm.icmp "eq" %178, %180 : i64
    llvm.cond_br %199, ^bb32, ^bb33
  ^bb32:  // pred: ^bb31
    %200 = llvm.add %172, %11 : i64
    llvm.br ^bb34(%200 : i64)
  ^bb33:  // pred: ^bb31
    llvm.br ^bb34(%172 : i64)
  ^bb34(%201: i64):  // 2 preds: ^bb32, ^bb33
    llvm.br ^bb35
  ^bb35:  // pred: ^bb34
    llvm.br ^bb24(%201, %180 : i64, i64)
  ^bb36:  // pred: ^bb24
    %202 = llvm.icmp "ult" %65, %9 : i64
    %203 = llvm.select %202, %65, %9 : i1, i64
    %204 = llvm.icmp "ugt" %57, %65 : i64
    %205 = llvm.select %204, %57, %65 : i1, i64
    %206 = llvm.extractvalue %17[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %207 = llvm.extractvalue %17[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %208 = llvm.extractvalue %17[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %209 = llvm.extractvalue %17[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %210 = llvm.extractvalue %17[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %211 = llvm.extractvalue %18[0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %212 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %213 = llvm.extractvalue %18[2] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %214 = llvm.extractvalue %18[3, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %215 = llvm.extractvalue %18[4, 0] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %216 = llvm.call @binarysearch(%57, %206, %207, %208, %209, %210, %211, %212, %213, %214, %215) : (i64, !llvm.ptr, !llvm.ptr, i64, i64, i64, !llvm.ptr, !llvm.ptr, i64, i64, i64) -> i64
    llvm.br ^bb37(%216, %57 : i64, i64)
  ^bb37(%217: i64, %218: i64):  // 2 preds: ^bb36, ^bb48
    %219 = llvm.icmp "ult" %218, %203 : i64
    llvm.cond_br %219, ^bb38, ^bb49
  ^bb38:  // pred: ^bb37
    %220 = llvm.extractvalue %18[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %221 = llvm.getelementptr %220[%217] : (!llvm.ptr, i64) -> !llvm.ptr, i64
    %222 = llvm.load %221 : !llvm.ptr -> i64
    %223 = llvm.add %222, %11 : i64
    %224 = llvm.icmp "ult" %203, %223 : i64
    %225 = llvm.select %224, %203, %223 : i1, i64
    %226 = llvm.extractvalue %19[1] : !llvm.struct<(ptr, ptr, i64, array<1 x i64>, array<1 x i64>)> 
    %227 = llvm.getelementptr %226[%217] : (!llvm.ptr, i64) -> !llvm.ptr, f32
    %228 = llvm.load %227 : !llvm.ptr -> f32
    %229 = llvm.icmp "ult" %225, %222 : i64
    %230 = llvm.select %229, %225, %222 : i1, i64
    %231 = llvm.icmp "ugt" %218, %222 : i64
    %232 = llvm.select %231, %218, %222 : i1, i64
    llvm.br ^bb39(%218 : i64)
  ^bb39(%233: i64):  // 2 preds: ^bb38, ^bb40
    %234 = llvm.icmp "slt" %233, %230 : i64
    llvm.cond_br %234, ^bb40, ^bb41
  ^bb40:  // pred: ^bb39
    %235 = llvm.load %68 : !llvm.ptr -> f32
    %236 = llvm.fadd %235, %7  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %236, %68 : f32, !llvm.ptr
    %237 = llvm.add %233, %11 : i64
    llvm.br ^bb39(%237 : i64)
  ^bb41:  // pred: ^bb39
    %238 = llvm.fmul %228, %8  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.br ^bb42(%232 : i64)
  ^bb42(%239: i64):  // 2 preds: ^bb41, ^bb43
    %240 = llvm.icmp "slt" %239, %225 : i64
    llvm.cond_br %240, ^bb43, ^bb44
  ^bb43:  // pred: ^bb42
    %241 = llvm.load %68 : !llvm.ptr -> f32
    %242 = llvm.fadd %241, %238  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %242, %68 : f32, !llvm.ptr
    %243 = llvm.add %239, %11 : i64
    llvm.br ^bb42(%243 : i64)
  ^bb44:  // pred: ^bb42
    %244 = llvm.icmp "eq" %223, %225 : i64
    llvm.cond_br %244, ^bb45, ^bb46
  ^bb45:  // pred: ^bb44
    %245 = llvm.add %217, %11 : i64
    llvm.br ^bb47(%245 : i64)
  ^bb46:  // pred: ^bb44
    llvm.br ^bb47(%217 : i64)
  ^bb47(%246: i64):  // 2 preds: ^bb45, ^bb46
    llvm.br ^bb48
  ^bb48:  // pred: ^bb47
    llvm.br ^bb37(%246, %225 : i64, i64)
  ^bb49:  // pred: ^bb37
    llvm.br ^bb50(%205 : i64)
  ^bb50(%247: i64):  // 2 preds: ^bb49, ^bb51
    %248 = llvm.icmp "slt" %247, %9 : i64
    llvm.cond_br %248, ^bb51, ^bb52
  ^bb51:  // pred: ^bb50
    %249 = llvm.load %68 : !llvm.ptr -> f32
    %250 = llvm.fadd %249, %7  {fastmathFlags = #llvm.fastmath<nnan, ninf>} : f32
    llvm.store %250, %68 : f32, !llvm.ptr
    %251 = llvm.add %247, %11 : i64
    llvm.br ^bb50(%251 : i64)
  ^bb52:  // pred: ^bb50
    %252 = llvm.alloca %4 x !llvm.struct<(ptr, ptr, i64)> : (i64) -> !llvm.ptr
    llvm.store %71, %252 : !llvm.struct<(ptr, ptr, i64)>, !llvm.ptr
    %253 = llvm.insertvalue %0, %3[0] : !llvm.struct<(i64, ptr)> 
    %254 = llvm.insertvalue %252, %253[1] : !llvm.struct<(i64, ptr)> 
    %255 = llvm.extractvalue %254[0] : !llvm.struct<(i64, ptr)> 
    %256 = llvm.extractvalue %254[1] : !llvm.struct<(i64, ptr)> 
    llvm.call @printMemrefF32(%255, %256) : (i64, !llvm.ptr) -> ()
    llvm.return
  }
}

