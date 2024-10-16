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
  %53 = icmp ult i64 %40, 100
  %54 = select i1 %53, i64 %40, i64 100
  %55 = icmp ult i64 %54, %48
  %56 = select i1 %55, i64 %54, i64 %48
  %57 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 0
  %58 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 1
  %59 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 2
  %60 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 3, 0
  %61 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 4, 0
  %62 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 0
  %63 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %64 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 2
  %65 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 3, 0
  %66 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 4, 0
  %67 = call i64 @binarysearch(i64 0, ptr %57, ptr %58, i64 %59, i64 %60, i64 %61, ptr %62, ptr %63, i64 %64, i64 %65, i64 %66)
  %68 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  %69 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %70 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 2
  %71 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 3, 0
  %72 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 4, 0
  %73 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 0
  %74 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %75 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 2
  %76 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 3, 0
  %77 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 4, 0
  %78 = call i64 @binarysearch(i64 0, ptr %68, ptr %69, i64 %70, i64 %71, i64 %72, ptr %73, ptr %74, i64 %75, i64 %76, i64 %77)
  br label %79

79:                                               ; preds = %163, %0
  %80 = phi i64 [ %155, %163 ], [ %67, %0 ]
  %81 = phi i64 [ %162, %163 ], [ %78, %0 ]
  %82 = phi i64 [ %96, %163 ], [ 0, %0 ]
  %83 = icmp ult i64 %82, %56
  br i1 %83, label %84, label %164

84:                                               ; preds = %79
  %85 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %86 = getelementptr i64, ptr %85, i64 %80
  %87 = load i64, ptr %86, align 4
  %88 = add i64 %87, 1
  %89 = icmp ult i64 %56, %88
  %90 = select i1 %89, i64 %56, i64 %88
  %91 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %92 = getelementptr i64, ptr %91, i64 %81
  %93 = load i64, ptr %92, align 4
  %94 = add i64 %93, 1
  %95 = icmp ult i64 %90, %94
  %96 = select i1 %95, i64 %90, i64 %94
  %97 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, 1
  %98 = getelementptr float, ptr %97, i64 %80
  %99 = load float, ptr %98, align 4
  %100 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, 1
  %101 = getelementptr float, ptr %100, i64 %81
  %102 = load float, ptr %101, align 4
  %103 = icmp ult i64 %96, %87
  %104 = select i1 %103, i64 %96, i64 %87
  %105 = icmp ugt i64 %82, %87
  %106 = select i1 %105, i64 %82, i64 %87
  %107 = icmp ult i64 %104, %93
  %108 = select i1 %107, i64 %104, i64 %93
  %109 = icmp ugt i64 %82, %93
  %110 = select i1 %109, i64 %82, i64 %93
  br label %111

111:                                              ; preds = %114, %84
  %112 = phi i64 [ %117, %114 ], [ %82, %84 ]
  %113 = icmp slt i64 %112, %108
  br i1 %113, label %114, label %118

114:                                              ; preds = %111
  %115 = load float, ptr %49, align 4
  %116 = fadd nnan ninf float %115, 0.000000e+00
  store float %116, ptr %49, align 4
  %117 = add i64 %112, 1
  br label %111

118:                                              ; preds = %111
  %119 = fmul nnan ninf float %102, -0.000000e+00
  br label %120

120:                                              ; preds = %123, %118
  %121 = phi i64 [ %126, %123 ], [ %110, %118 ]
  %122 = icmp slt i64 %121, %104
  br i1 %122, label %123, label %127

123:                                              ; preds = %120
  %124 = load float, ptr %49, align 4
  %125 = fadd nnan ninf float %124, %119
  store float %125, ptr %49, align 4
  %126 = add i64 %121, 1
  br label %120

127:                                              ; preds = %120
  %128 = icmp ult i64 %96, %93
  %129 = select i1 %128, i64 %96, i64 %93
  %130 = icmp ugt i64 %106, %93
  %131 = select i1 %130, i64 %106, i64 %93
  %132 = fmul nnan ninf float %99, -0.000000e+00
  br label %133

133:                                              ; preds = %136, %127
  %134 = phi i64 [ %139, %136 ], [ %106, %127 ]
  %135 = icmp slt i64 %134, %129
  br i1 %135, label %136, label %140

136:                                              ; preds = %133
  %137 = load float, ptr %49, align 4
  %138 = fadd nnan ninf float %137, %132
  store float %138, ptr %49, align 4
  %139 = add i64 %134, 1
  br label %133

140:                                              ; preds = %133
  %141 = fmul nnan ninf float %99, %102
  br label %142

142:                                              ; preds = %145, %140
  %143 = phi i64 [ %148, %145 ], [ %131, %140 ]
  %144 = icmp slt i64 %143, %96
  br i1 %144, label %145, label %149

145:                                              ; preds = %142
  %146 = load float, ptr %49, align 4
  %147 = fadd nnan ninf float %146, %141
  store float %147, ptr %49, align 4
  %148 = add i64 %143, 1
  br label %142

149:                                              ; preds = %142
  %150 = icmp eq i64 %88, %96
  br i1 %150, label %151, label %153

151:                                              ; preds = %149
  %152 = add i64 %80, 1
  br label %154

153:                                              ; preds = %149
  br label %154

154:                                              ; preds = %151, %153
  %155 = phi i64 [ %80, %153 ], [ %152, %151 ]
  br label %156

156:                                              ; preds = %154
  %157 = icmp eq i64 %94, %96
  br i1 %157, label %158, label %160

158:                                              ; preds = %156
  %159 = add i64 %81, 1
  br label %161

160:                                              ; preds = %156
  br label %161

161:                                              ; preds = %158, %160
  %162 = phi i64 [ %81, %160 ], [ %159, %158 ]
  br label %163

163:                                              ; preds = %161
  br label %79

164:                                              ; preds = %79
  %165 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 0
  %166 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 1
  %167 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 2
  %168 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 3, 0
  %169 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %2, 4, 0
  %170 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 0
  %171 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %172 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 2
  %173 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 3, 0
  %174 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 4, 0
  %175 = call i64 @binarysearch(i64 %48, ptr %165, ptr %166, i64 %167, i64 %168, i64 %169, ptr %170, ptr %171, i64 %172, i64 %173, i64 %174)
  br label %176

176:                                              ; preds = %217, %164
  %177 = phi i64 [ %216, %217 ], [ %175, %164 ]
  %178 = phi i64 [ %186, %217 ], [ %48, %164 ]
  %179 = icmp ult i64 %178, %54
  br i1 %179, label %180, label %218

180:                                              ; preds = %176
  %181 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %3, 1
  %182 = getelementptr i64, ptr %181, i64 %177
  %183 = load i64, ptr %182, align 4
  %184 = add i64 %183, 1
  %185 = icmp ult i64 %54, %184
  %186 = select i1 %185, i64 %54, i64 %184
  %187 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %4, 1
  %188 = getelementptr float, ptr %187, i64 %177
  %189 = load float, ptr %188, align 4
  %190 = icmp ult i64 %186, %183
  %191 = select i1 %190, i64 %186, i64 %183
  %192 = icmp ugt i64 %178, %183
  %193 = select i1 %192, i64 %178, i64 %183
  br label %194

194:                                              ; preds = %197, %180
  %195 = phi i64 [ %200, %197 ], [ %178, %180 ]
  %196 = icmp slt i64 %195, %191
  br i1 %196, label %197, label %201

197:                                              ; preds = %194
  %198 = load float, ptr %49, align 4
  %199 = fadd nnan ninf float %198, 0.000000e+00
  store float %199, ptr %49, align 4
  %200 = add i64 %195, 1
  br label %194

201:                                              ; preds = %194
  %202 = fmul nnan ninf float %189, -0.000000e+00
  br label %203

203:                                              ; preds = %206, %201
  %204 = phi i64 [ %209, %206 ], [ %193, %201 ]
  %205 = icmp slt i64 %204, %186
  br i1 %205, label %206, label %210

206:                                              ; preds = %203
  %207 = load float, ptr %49, align 4
  %208 = fadd nnan ninf float %207, %202
  store float %208, ptr %49, align 4
  %209 = add i64 %204, 1
  br label %203

210:                                              ; preds = %203
  %211 = icmp eq i64 %184, %186
  br i1 %211, label %212, label %214

212:                                              ; preds = %210
  %213 = add i64 %177, 1
  br label %215

214:                                              ; preds = %210
  br label %215

215:                                              ; preds = %212, %214
  %216 = phi i64 [ %177, %214 ], [ %213, %212 ]
  br label %217

217:                                              ; preds = %215
  br label %176

218:                                              ; preds = %176
  %219 = icmp ult i64 %48, 100
  %220 = select i1 %219, i64 %48, i64 100
  %221 = icmp ugt i64 %40, %48
  %222 = select i1 %221, i64 %40, i64 %48
  %223 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 0
  %224 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 1
  %225 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 2
  %226 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 3, 0
  %227 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %6, 4, 0
  %228 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 0
  %229 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %230 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 2
  %231 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 3, 0
  %232 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 4, 0
  %233 = call i64 @binarysearch(i64 %40, ptr %223, ptr %224, i64 %225, i64 %226, i64 %227, ptr %228, ptr %229, i64 %230, i64 %231, i64 %232)
  br label %234

234:                                              ; preds = %275, %218
  %235 = phi i64 [ %274, %275 ], [ %233, %218 ]
  %236 = phi i64 [ %244, %275 ], [ %40, %218 ]
  %237 = icmp ult i64 %236, %220
  br i1 %237, label %238, label %276

238:                                              ; preds = %234
  %239 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %7, 1
  %240 = getelementptr i64, ptr %239, i64 %235
  %241 = load i64, ptr %240, align 4
  %242 = add i64 %241, 1
  %243 = icmp ult i64 %220, %242
  %244 = select i1 %243, i64 %220, i64 %242
  %245 = extractvalue { ptr, ptr, i64, [1 x i64], [1 x i64] } %8, 1
  %246 = getelementptr float, ptr %245, i64 %235
  %247 = load float, ptr %246, align 4
  %248 = icmp ult i64 %244, %241
  %249 = select i1 %248, i64 %244, i64 %241
  %250 = icmp ugt i64 %236, %241
  %251 = select i1 %250, i64 %236, i64 %241
  br label %252

252:                                              ; preds = %255, %238
  %253 = phi i64 [ %258, %255 ], [ %236, %238 ]
  %254 = icmp slt i64 %253, %249
  br i1 %254, label %255, label %259

255:                                              ; preds = %252
  %256 = load float, ptr %49, align 4
  %257 = fadd nnan ninf float %256, 0.000000e+00
  store float %257, ptr %49, align 4
  %258 = add i64 %253, 1
  br label %252

259:                                              ; preds = %252
  %260 = fmul nnan ninf float %247, -0.000000e+00
  br label %261

261:                                              ; preds = %264, %259
  %262 = phi i64 [ %267, %264 ], [ %251, %259 ]
  %263 = icmp slt i64 %262, %244
  br i1 %263, label %264, label %268

264:                                              ; preds = %261
  %265 = load float, ptr %49, align 4
  %266 = fadd nnan ninf float %265, %260
  store float %266, ptr %49, align 4
  %267 = add i64 %262, 1
  br label %261

268:                                              ; preds = %261
  %269 = icmp eq i64 %242, %244
  br i1 %269, label %270, label %272

270:                                              ; preds = %268
  %271 = add i64 %235, 1
  br label %273

272:                                              ; preds = %268
  br label %273

273:                                              ; preds = %270, %272
  %274 = phi i64 [ %235, %272 ], [ %271, %270 ]
  br label %275

275:                                              ; preds = %273
  br label %234

276:                                              ; preds = %234
  br label %277

277:                                              ; preds = %280, %276
  %278 = phi i64 [ %283, %280 ], [ %222, %276 ]
  %279 = icmp slt i64 %278, 100
  br i1 %279, label %280, label %284

280:                                              ; preds = %277
  %281 = load float, ptr %49, align 4
  %282 = fadd nnan ninf float %281, 0.000000e+00
  store float %282, ptr %49, align 4
  %283 = add i64 %278, 1
  br label %277

284:                                              ; preds = %277
  %285 = alloca { ptr, ptr, i64 }, i64 1, align 8
  store { ptr, ptr, i64 } %52, ptr %285, align 8
  %286 = insertvalue { i64, ptr } { i64 0, ptr undef }, ptr %285, 1
  %287 = extractvalue { i64, ptr } %286, 0
  %288 = extractvalue { i64, ptr } %286, 1
  call void @printMemrefF32(i64 %287, ptr %288)
  ret void
}

!llvm.module.flags = !{!0}

!0 = !{i32 2, !"Debug Info Version", i32 3}
