; ModuleID = 'LLVMDialectModule'
source_filename = "LLVMDialectModule"

declare ptr @malloc(i64)

define private { ptr, ptr, i64, [1 x i64], [1 x i64] } @sparseValuesF32(ptr %0) {
  %2 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  call void @_mlir_ciface_sparseValuesF32(ptr %2, ptr %0)
  %3 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %2, align 8
  ret { ptr, ptr, i64, [1 x i64], [1 x i64] } %3
}

declare void @_mlir_ciface_sparseValuesF32(ptr, ptr)

define private { ptr, ptr, i64, [1 x i64], [1 x i64] } @sparseCoordinates0(ptr %0, i64 %1) {
  %3 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  call void @_mlir_ciface_sparseCoordinates0(ptr %3, ptr %0, i64 %1)
  %4 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %3, align 8
  ret { ptr, ptr, i64, [1 x i64], [1 x i64] } %4
}

declare void @_mlir_ciface_sparseCoordinates0(ptr, ptr, i64)

define private { ptr, ptr, i64, [1 x i64], [1 x i64] } @sparsePositions0(ptr %0, i64 %1) {
  %3 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  call void @_mlir_ciface_sparsePositions0(ptr %3, ptr %0, i64 %1)
  %4 = load { ptr, ptr, i64, [1 x i64], [1 x i64] }, ptr %3, align 8
  ret { ptr, ptr, i64, [1 x i64], [1 x i64] } %4
}

declare void @_mlir_ciface_sparsePositions0(ptr, ptr, i64)

declare void @endLexInsert(ptr)

define private void @lexInsertF32(ptr %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, ptr %6, ptr %7, i64 %8) {
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %1, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, ptr %2, 1
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, i64 %3, 2
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, i64 %4, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %5, 4, 0
  %15 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, ptr %15, align 8
  %16 = insertvalue { ptr, ptr, i64 } undef, ptr %6, 0
  %17 = insertvalue { ptr, ptr, i64 } %16, ptr %7, 1
  %18 = insertvalue { ptr, ptr, i64 } %17, i64 %8, 2
  %19 = alloca { ptr, ptr, i64 }, i64 1, align 8
  store { ptr, ptr, i64 } %18, ptr %19, align 8
  call void @_mlir_ciface_lexInsertF32(ptr %0, ptr %15, ptr %19)
  ret void
}

declare void @_mlir_ciface_lexInsertF32(ptr, ptr, ptr)

define private ptr @newSparseTensor(ptr %0, ptr %1, i64 %2, i64 %3, i64 %4, ptr %5, ptr %6, i64 %7, i64 %8, i64 %9, ptr %10, ptr %11, i64 %12, i64 %13, i64 %14, ptr %15, ptr %16, i64 %17, i64 %18, i64 %19, ptr %20, ptr %21, i64 %22, i64 %23, i64 %24, i32 %25, i32 %26, i32 %27, i32 %28, ptr %29) {
  %31 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %0, 0
  %32 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %31, ptr %1, 1
  %33 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %32, i64 %2, 2
  %34 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %33, i64 %3, 3, 0
  %35 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %34, i64 %4, 4, 0
  %36 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %35, ptr %36, align 8
  %37 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %5, 0
  %38 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %37, ptr %6, 1
  %39 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %38, i64 %7, 2
  %40 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %39, i64 %8, 3, 0
  %41 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %40, i64 %9, 4, 0
  %42 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %41, ptr %42, align 8
  %43 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %10, 0
  %44 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %43, ptr %11, 1
  %45 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %44, i64 %12, 2
  %46 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %45, i64 %13, 3, 0
  %47 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %46, i64 %14, 4, 0
  %48 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %47, ptr %48, align 8
  %49 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %15, 0
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %49, ptr %16, 1
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, i64 %17, 2
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, i64 %18, 3, 0
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, i64 %19, 4, 0
  %54 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, ptr %54, align 8
  %55 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %20, 0
  %56 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %55, ptr %21, 1
  %57 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %56, i64 %22, 2
  %58 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %57, i64 %23, 3, 0
  %59 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %58, i64 %24, 4, 0
  %60 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %59, ptr %60, align 8
  %61 = call ptr @_mlir_ciface_newSparseTensor(ptr %36, ptr %42, ptr %48, ptr %54, ptr %60, i32 %25, i32 %26, i32 %27, i32 %28, ptr %29)
  ret ptr %61
}

declare ptr @_mlir_ciface_newSparseTensor(ptr, ptr, ptr, ptr, ptr, i32, i32, i32, i32, ptr)

define private void @printMemrefF32(i64 %0, ptr %1) {
  %3 = insertvalue { i64, ptr } undef, i64 %0, 0
  %4 = insertvalue { i64, ptr } %3, ptr %1, 1
  %5 = alloca { i64, ptr }, i64 1, align 8
  store { i64, ptr } %4, ptr %5, align 8
  call void @_mlir_ciface_printMemrefF32(ptr %5)
  ret void
}

declare void @_mlir_ciface_printMemrefF32(ptr)

define private void @printMemrefInd(i64 %0, ptr %1) {
  %3 = insertvalue { i64, ptr } undef, i64 %0, 0
  %4 = insertvalue { i64, ptr } %3, ptr %1, 1
  %5 = alloca { i64, ptr }, i64 1, align 8
  store { i64, ptr } %4, ptr %5, align 8
  call void @_mlir_ciface_printMemrefInd(ptr %5)
  ret void
}

declare void @_mlir_ciface_printMemrefInd(ptr)

define { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } @buffers_from_sparsevector(i64 %0) {
  %2 = alloca i64, i64 1, align 8
  %3 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %2, 0
  %4 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, ptr %2, 1
  %5 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, i64 0, 2
  %6 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %5, i64 1, 3, 0
  %7 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, i64 1, 4, 0
  %8 = getelementptr i64, ptr %2, i64 0
  store i64 262144, ptr %8, align 4
  %9 = alloca i64, i64 1, align 8
  %10 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %9, 0
  %11 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %10, ptr %9, 1
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %11, i64 0, 2
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, i64 1, 3, 0
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 1, 4, 0
  %15 = getelementptr i64, ptr %9, i64 0
  store i64 1024, ptr %15, align 4
  %16 = alloca i64, i64 1, align 8
  %17 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %16, 0
  %18 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %17, ptr %16, 1
  %19 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %18, i64 0, 2
  %20 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %19, i64 1, 3, 0
  %21 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %20, i64 1, 4, 0
  %22 = getelementptr i64, ptr %16, i64 0
  store i64 0, ptr %22, align 4
  %23 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 0
  %24 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 1
  %25 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 2
  %26 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 3, 0
  %27 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 4, 0
  %28 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 0
  %29 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 1
  %30 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 2
  %31 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 3, 0
  %32 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, 4, 0
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 0
  %34 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %35 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 2
  %36 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 3, 0
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 4, 0
  %38 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 0
  %39 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %40 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %41 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 3, 0
  %42 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 4, 0
  %43 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 0
  %44 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 1
  %45 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 2
  %46 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 3, 0
  %47 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %21, 4, 0
  %48 = call ptr @newSparseTensor(ptr %23, ptr %24, i64 %25, i64 %26, i64 %27, ptr %28, ptr %29, i64 %30, i64 %31, i64 %32, ptr %33, ptr %34, i64 %35, i64 %36, i64 %37, ptr %38, ptr %39, i64 %40, i64 %41, i64 %42, ptr %43, ptr %44, i64 %45, i64 %46, i64 %47, i32 0, i32 0, i32 2, i32 0, ptr null)
  %49 = alloca i64, i64 1, align 8
  %50 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %49, 0
  %51 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %50, ptr %49, 1
  %52 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %51, i64 0, 2
  %53 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %52, i64 1, 3, 0
  %54 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %53, i64 1, 4, 0
  %55 = alloca float, i64 1, align 4
  %56 = insertvalue { ptr, ptr, i64 } undef, ptr %55, 0
  %57 = insertvalue { ptr, ptr, i64 } %56, ptr %55, 1
  %58 = insertvalue { ptr, ptr, i64 } %57, i64 0, 2
  br label %59

59:                                               ; preds = %62, %1
  %60 = phi i64 [ %73, %62 ], [ 0, %1 ]
  %61 = icmp slt i64 %60, 8
  br i1 %61, label %62, label %74

62:                                               ; preds = %59
  %63 = mul i64 %60, %0
  %64 = getelementptr i64, ptr %49, i64 0
  store i64 %63, ptr %64, align 4
  store float 1.000000e+00, ptr %55, align 4
  %65 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 0
  %66 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 1
  %67 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 2
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 3, 0
  %69 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %54, 4, 0
  %70 = extractvalue { ptr, ptr, i64 } %58, 0
  %71 = extractvalue { ptr, ptr, i64 } %58, 1
  %72 = extractvalue { ptr, ptr, i64 } %58, 2
  call void @lexInsertF32(ptr %48, ptr %65, ptr %66, i64 %67, i64 %68, i64 %69, ptr %70, ptr %71, i64 %72)
  %73 = add i64 %60, 1
  br label %59

74:                                               ; preds = %59
  call void @endLexInsert(ptr %48)
  %75 = call { ptr, ptr, i64, [1 x i64], [1 x i64] } @sparsePositions0(ptr %48, i64 0)
  %76 = call { ptr, ptr, i64, [1 x i64], [1 x i64] } @sparseCoordinates0(ptr %48, i64 0)
  %77 = call { ptr, ptr, i64, [1 x i64], [1 x i64] } @sparseValuesF32(ptr %48)
  %78 = insertvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } undef, { ptr, ptr, i64, [1 x i64], [1 x i64] } %75, 0
  %79 = insertvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %78, { ptr, ptr, i64, [1 x i64], [1 x i64] } %76, 1
  %80 = insertvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %79, { ptr, ptr, i64, [1 x i64], [1 x i64] } %77, 2
  ret { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %80
}

define i64 @binarysearch(i64 %0, ptr %1, ptr %2, i64 %3, i64 %4, i64 %5, ptr %6, ptr %7, i64 %8, i64 %9, i64 %10) {
  %12 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } undef, ptr %6, 0
  %13 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %12, ptr %7, 1
  %14 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %13, i64 %8, 2
  %15 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %14, i64 %9, 3, 0
  %16 = insertvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %15, i64 %10, 4, 0
  br label %17

17:                                               ; preds = %23, %11
  %18 = phi i64 [ %24, %23 ], [ 0, %11 ]
  %19 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %16, 1
  %20 = getelementptr i64, ptr %19, i64 %18
  %21 = load i64, ptr %20, align 4
  %22 = icmp ult i64 %21, %0
  br i1 %22, label %23, label %25

23:                                               ; preds = %17
  %24 = add i64 %18, 1
  br label %17

25:                                               ; preds = %17
  ret i64 %18
}

define void @main() {
  %1 = call { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } @buffers_from_sparsevector(i64 2)
  %2 = extractvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %1, 0
  %3 = extractvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %1, 1
  %4 = extractvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %1, 2
  %5 = call { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } @buffers_from_sparsevector(i64 3)
  %6 = extractvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %5, 0
  %7 = extractvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %5, 1
  %8 = extractvalue { { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] }, { ptr, ptr, i64, [1 x i64], [1 x i64] } } %5, 2
  %9 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, ptr %9, align 8
  %10 = insertvalue { i64, ptr } { i64 1, ptr undef }, ptr %9, 1
  %11 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, ptr %11, align 8
  %12 = insertvalue { i64, ptr } { i64 1, ptr undef }, ptr %11, 1
  %13 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, ptr %13, align 8
  %14 = insertvalue { i64, ptr } { i64 1, ptr undef }, ptr %13, 1
  %15 = extractvalue { i64, ptr } %10, 0
  %16 = extractvalue { i64, ptr } %10, 1
  call void @printMemrefInd(i64 %15, ptr %16)
  %17 = extractvalue { i64, ptr } %12, 0
  %18 = extractvalue { i64, ptr } %12, 1
  call void @printMemrefInd(i64 %17, ptr %18)
  %19 = extractvalue { i64, ptr } %14, 0
  %20 = extractvalue { i64, ptr } %14, 1
  call void @printMemrefF32(i64 %19, ptr %20)
  %21 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, ptr %21, align 8
  %22 = insertvalue { i64, ptr } { i64 1, ptr undef }, ptr %21, 1
  %23 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, ptr %23, align 8
  %24 = insertvalue { i64, ptr } { i64 1, ptr undef }, ptr %23, 1
  %25 = alloca { ptr, ptr, i64, [1 x i64], [1 x i64] }, i64 1, align 8
  store { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, ptr %25, align 8
  %26 = insertvalue { i64, ptr } { i64 1, ptr undef }, ptr %25, 1
  %27 = extractvalue { i64, ptr } %22, 0
  %28 = extractvalue { i64, ptr } %22, 1
  call void @printMemrefInd(i64 %27, ptr %28)
  %29 = extractvalue { i64, ptr } %24, 0
  %30 = extractvalue { i64, ptr } %24, 1
  call void @printMemrefInd(i64 %29, ptr %30)
  %31 = extractvalue { i64, ptr } %26, 0
  %32 = extractvalue { i64, ptr } %26, 1
  call void @printMemrefF32(i64 %31, ptr %32)
  %33 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 1
  %34 = getelementptr i64, ptr %33, i64 1
  %35 = load i64, ptr %34, align 4
  %36 = sub i64 %35, 1
  %37 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %38 = getelementptr i64, ptr %37, i64 %36
  %39 = load i64, ptr %38, align 4
  %40 = add i64 %39, 1
  %41 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %42 = getelementptr i64, ptr %41, i64 1
  %43 = load i64, ptr %42, align 4
  %44 = sub i64 %43, 1
  %45 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %46 = getelementptr i64, ptr %45, i64 %44
  %47 = load i64, ptr %46, align 4
  %48 = add i64 %47, 1
  %49 = call ptr @malloc(i64 ptrtoint (ptr getelementptr (float, ptr null, i32 1) to i64))
  %50 = insertvalue { ptr, ptr, i64 } undef, ptr %49, 0
  %51 = insertvalue { ptr, ptr, i64 } %50, ptr %49, 1
  %52 = insertvalue { ptr, ptr, i64 } %51, i64 0, 2
  store float 0.000000e+00, ptr %49, align 4
  %53 = alloca { ptr, ptr, i64 }, i64 1, align 8
  store { ptr, ptr, i64 } %52, ptr %53, align 8
  %54 = insertvalue { i64, ptr } { i64 0, ptr undef }, ptr %53, 1
  %55 = extractvalue { i64, ptr } %54, 0
  %56 = extractvalue { i64, ptr } %54, 1
  call void @printMemrefF32(i64 %55, ptr %56)
  %57 = icmp ult i64 %40, 100
  %58 = select i1 %57, i64 %40, i64 100
  %59 = icmp ult i64 %58, %48
  %60 = select i1 %59, i64 %58, i64 %48
  %61 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 0
  %62 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 1
  %63 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 2
  %64 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 3, 0
  %65 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 4, 0
  %66 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 0
  %67 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 2
  %69 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 3, 0
  %70 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 4, 0
  %71 = call i64 @binarysearch(i64 0, ptr %61, ptr %62, i64 %63, i64 %64, i64 %65, ptr %66, ptr %67, i64 %68, i64 %69, i64 %70)
  %72 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  %73 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %74 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 2
  %75 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 3, 0
  %76 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 4, 0
  %77 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 0
  %78 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %79 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 2
  %80 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 3, 0
  %81 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 4, 0
  %82 = call i64 @binarysearch(i64 0, ptr %72, ptr %73, i64 %74, i64 %75, i64 %76, ptr %77, ptr %78, i64 %79, i64 %80, i64 %81)
  br label %83

83:                                               ; preds = %173, %0
  %84 = phi i64 [ %165, %173 ], [ %71, %0 ]
  %85 = phi i64 [ %172, %173 ], [ %82, %0 ]
  %86 = phi i64 [ %100, %173 ], [ 0, %0 ]
  %87 = icmp ult i64 %86, %60
  br i1 %87, label %88, label %174

88:                                               ; preds = %83
  %89 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %90 = getelementptr i64, ptr %89, i64 %84
  %91 = load i64, ptr %90, align 4
  %92 = add i64 %91, 1
  %93 = icmp ult i64 %60, %92
  %94 = select i1 %93, i64 %60, i64 %92
  %95 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %96 = getelementptr i64, ptr %95, i64 %85
  %97 = load i64, ptr %96, align 4
  %98 = add i64 %97, 1
  %99 = icmp ult i64 %94, %98
  %100 = select i1 %99, i64 %94, i64 %98
  %101 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %102 = getelementptr i64, ptr %101, i64 %84
  %103 = load i64, ptr %102, align 4
  %104 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, 1
  %105 = getelementptr float, ptr %104, i64 %84
  %106 = load float, ptr %105, align 4
  %107 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %108 = getelementptr i64, ptr %107, i64 %85
  %109 = load i64, ptr %108, align 4
  %110 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, 1
  %111 = getelementptr float, ptr %110, i64 %85
  %112 = load float, ptr %111, align 4
  %113 = icmp ult i64 %100, %103
  %114 = select i1 %113, i64 %100, i64 %103
  %115 = icmp ugt i64 %86, %103
  %116 = select i1 %115, i64 %86, i64 %103
  %117 = icmp ult i64 %114, %109
  %118 = select i1 %117, i64 %114, i64 %109
  %119 = icmp ugt i64 %86, %109
  %120 = select i1 %119, i64 %86, i64 %109
  br label %121

121:                                              ; preds = %124, %88
  %122 = phi i64 [ %127, %124 ], [ %86, %88 ]
  %123 = icmp slt i64 %122, %118
  br i1 %123, label %124, label %128

124:                                              ; preds = %121
  %125 = load float, ptr %49, align 4
  %126 = fadd nnan ninf float %125, 0.000000e+00
  store float %126, ptr %49, align 4
  %127 = add i64 %122, 1
  br label %121

128:                                              ; preds = %121
  %129 = fmul nnan ninf float %112, -0.000000e+00
  br label %130

130:                                              ; preds = %133, %128
  %131 = phi i64 [ %136, %133 ], [ %120, %128 ]
  %132 = icmp slt i64 %131, %114
  br i1 %132, label %133, label %137

133:                                              ; preds = %130
  %134 = load float, ptr %49, align 4
  %135 = fadd nnan ninf float %134, %129
  store float %135, ptr %49, align 4
  %136 = add i64 %131, 1
  br label %130

137:                                              ; preds = %130
  %138 = icmp ult i64 %100, %109
  %139 = select i1 %138, i64 %100, i64 %109
  %140 = icmp ugt i64 %116, %109
  %141 = select i1 %140, i64 %116, i64 %109
  %142 = fmul nnan ninf float %106, -0.000000e+00
  br label %143

143:                                              ; preds = %146, %137
  %144 = phi i64 [ %149, %146 ], [ %116, %137 ]
  %145 = icmp slt i64 %144, %139
  br i1 %145, label %146, label %150

146:                                              ; preds = %143
  %147 = load float, ptr %49, align 4
  %148 = fadd nnan ninf float %147, %142
  store float %148, ptr %49, align 4
  %149 = add i64 %144, 1
  br label %143

150:                                              ; preds = %143
  %151 = fmul nnan ninf float %106, %112
  br label %152

152:                                              ; preds = %155, %150
  %153 = phi i64 [ %158, %155 ], [ %141, %150 ]
  %154 = icmp slt i64 %153, %100
  br i1 %154, label %155, label %159

155:                                              ; preds = %152
  %156 = load float, ptr %49, align 4
  %157 = fadd nnan ninf float %156, %151
  store float %157, ptr %49, align 4
  %158 = add i64 %153, 1
  br label %152

159:                                              ; preds = %152
  %160 = icmp eq i64 %92, %100
  br i1 %160, label %161, label %163

161:                                              ; preds = %159
  %162 = add i64 %84, 1
  br label %164

163:                                              ; preds = %159
  br label %164

164:                                              ; preds = %161, %163
  %165 = phi i64 [ %84, %163 ], [ %162, %161 ]
  br label %166

166:                                              ; preds = %164
  %167 = icmp eq i64 %98, %100
  br i1 %167, label %168, label %170

168:                                              ; preds = %166
  %169 = add i64 %85, 1
  br label %171

170:                                              ; preds = %166
  br label %171

171:                                              ; preds = %168, %170
  %172 = phi i64 [ %85, %170 ], [ %169, %168 ]
  br label %173

173:                                              ; preds = %171
  br label %83

174:                                              ; preds = %83
  %175 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 0
  %176 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 1
  %177 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 2
  %178 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 3, 0
  %179 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 4, 0
  %180 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 0
  %181 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %182 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 2
  %183 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 3, 0
  %184 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 4, 0
  %185 = call i64 @binarysearch(i64 %48, ptr %175, ptr %176, i64 %177, i64 %178, i64 %179, ptr %180, ptr %181, i64 %182, i64 %183, i64 %184)
  br label %186

186:                                              ; preds = %230, %174
  %187 = phi i64 [ %229, %230 ], [ %185, %174 ]
  %188 = phi i64 [ %196, %230 ], [ %48, %174 ]
  %189 = icmp ult i64 %188, %58
  br i1 %189, label %190, label %231

190:                                              ; preds = %186
  %191 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %192 = getelementptr i64, ptr %191, i64 %187
  %193 = load i64, ptr %192, align 4
  %194 = add i64 %193, 1
  %195 = icmp ult i64 %58, %194
  %196 = select i1 %195, i64 %58, i64 %194
  %197 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %198 = getelementptr i64, ptr %197, i64 %187
  %199 = load i64, ptr %198, align 4
  %200 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, 1
  %201 = getelementptr float, ptr %200, i64 %187
  %202 = load float, ptr %201, align 4
  %203 = icmp ult i64 %196, %199
  %204 = select i1 %203, i64 %196, i64 %199
  %205 = icmp ugt i64 %188, %199
  %206 = select i1 %205, i64 %188, i64 %199
  br label %207

207:                                              ; preds = %210, %190
  %208 = phi i64 [ %213, %210 ], [ %188, %190 ]
  %209 = icmp slt i64 %208, %204
  br i1 %209, label %210, label %214

210:                                              ; preds = %207
  %211 = load float, ptr %49, align 4
  %212 = fadd nnan ninf float %211, 0.000000e+00
  store float %212, ptr %49, align 4
  %213 = add i64 %208, 1
  br label %207

214:                                              ; preds = %207
  %215 = fmul nnan ninf float %202, -0.000000e+00
  br label %216

216:                                              ; preds = %219, %214
  %217 = phi i64 [ %222, %219 ], [ %206, %214 ]
  %218 = icmp slt i64 %217, %196
  br i1 %218, label %219, label %223

219:                                              ; preds = %216
  %220 = load float, ptr %49, align 4
  %221 = fadd nnan ninf float %220, %215
  store float %221, ptr %49, align 4
  %222 = add i64 %217, 1
  br label %216

223:                                              ; preds = %216
  %224 = icmp eq i64 %194, %196
  br i1 %224, label %225, label %227

225:                                              ; preds = %223
  %226 = add i64 %187, 1
  br label %228

227:                                              ; preds = %223
  br label %228

228:                                              ; preds = %225, %227
  %229 = phi i64 [ %187, %227 ], [ %226, %225 ]
  br label %230

230:                                              ; preds = %228
  br label %186

231:                                              ; preds = %186
  %232 = icmp ult i64 %48, 100
  %233 = select i1 %232, i64 %48, i64 100
  %234 = icmp ugt i64 %40, %48
  %235 = select i1 %234, i64 %40, i64 %48
  %236 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  %237 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %238 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 2
  %239 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 3, 0
  %240 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 4, 0
  %241 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 0
  %242 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %243 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 2
  %244 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 3, 0
  %245 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 4, 0
  %246 = call i64 @binarysearch(i64 %40, ptr %236, ptr %237, i64 %238, i64 %239, i64 %240, ptr %241, ptr %242, i64 %243, i64 %244, i64 %245)
  br label %247

247:                                              ; preds = %291, %231
  %248 = phi i64 [ %290, %291 ], [ %246, %231 ]
  %249 = phi i64 [ %257, %291 ], [ %40, %231 ]
  %250 = icmp ult i64 %249, %233
  br i1 %250, label %251, label %292

251:                                              ; preds = %247
  %252 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %253 = getelementptr i64, ptr %252, i64 %248
  %254 = load i64, ptr %253, align 4
  %255 = add i64 %254, 1
  %256 = icmp ult i64 %233, %255
  %257 = select i1 %256, i64 %233, i64 %255
  %258 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %259 = getelementptr i64, ptr %258, i64 %248
  %260 = load i64, ptr %259, align 4
  %261 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, 1
  %262 = getelementptr float, ptr %261, i64 %248
  %263 = load float, ptr %262, align 4
  %264 = icmp ult i64 %257, %260
  %265 = select i1 %264, i64 %257, i64 %260
  %266 = icmp ugt i64 %249, %260
  %267 = select i1 %266, i64 %249, i64 %260
  br label %268

268:                                              ; preds = %271, %251
  %269 = phi i64 [ %274, %271 ], [ %249, %251 ]
  %270 = icmp slt i64 %269, %265
  br i1 %270, label %271, label %275

271:                                              ; preds = %268
  %272 = load float, ptr %49, align 4
  %273 = fadd nnan ninf float %272, 0.000000e+00
  store float %273, ptr %49, align 4
  %274 = add i64 %269, 1
  br label %268

275:                                              ; preds = %268
  %276 = fmul nnan ninf float %263, -0.000000e+00
  br label %277

277:                                              ; preds = %280, %275
  %278 = phi i64 [ %283, %280 ], [ %267, %275 ]
  %279 = icmp slt i64 %278, %257
  br i1 %279, label %280, label %284

280:                                              ; preds = %277
  %281 = load float, ptr %49, align 4
  %282 = fadd nnan ninf float %281, %276
  store float %282, ptr %49, align 4
  %283 = add i64 %278, 1
  br label %277

284:                                              ; preds = %277
  %285 = icmp eq i64 %255, %257
  br i1 %285, label %286, label %288

286:                                              ; preds = %284
  %287 = add i64 %248, 1
  br label %289

288:                                              ; preds = %284
  br label %289

289:                                              ; preds = %286, %288
  %290 = phi i64 [ %248, %288 ], [ %287, %286 ]
  br label %291

291:                                              ; preds = %289
  br label %247

292:                                              ; preds = %247
  br label %293

293:                                              ; preds = %296, %292
  %294 = phi i64 [ %299, %296 ], [ %235, %292 ]
  %295 = icmp slt i64 %294, 100
  br i1 %295, label %296, label %300

296:                                              ; preds = %293
  %297 = load float, ptr %49, align 4
  %298 = fadd nnan ninf float %297, 0.000000e+00
  store float %298, ptr %49, align 4
  %299 = add i64 %294, 1
  br label %293

300:                                              ; preds = %293
  %301 = alloca { ptr, ptr, i64 }, i64 1, align 8
  store { ptr, ptr, i64 } %52, ptr %301, align 8
  %302 = insertvalue { i64, ptr } { i64 0, ptr undef }, ptr %301, 1
  %303 = extractvalue { i64, ptr } %302, 0
  %304 = extractvalue { i64, ptr } %302, 1
  call void @printMemrefF32(i64 %303, ptr %304)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
