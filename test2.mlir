// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
  func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      %fp_1 = arith.constant 1.1 : f32
      %fp_2 = arith.constant 2.2 : f32
    
      %int_0 = arith.constant 0 : i32
      %int_1 = arith.constant 1 : i32
      %int_2 = arith.constant 2 : i32
      %int_3 = arith.constant 3 : i32
      %int_4 = arith.constant 4 : i32
      %int_5 = arith.constant 5 : i32
      %int_6 = arith.constant 6 : i32

      %r1 = finch.run %int_0, %int_5, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
      %r2 = finch.run %int_6, %int_6, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
      %s1 = finch.sequence %int_0, %int_6, %r1, %r2 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      %r3 = finch.run %int_1, %int_1, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
      %r4 = finch.run %int_2, %int_2, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
      %r5 = finch.run %int_3, %int_4, %fp_2 : (i32, i32, f32) -> (!finch.looplet)
      %s2 = finch.sequence %int_1, %int_4, %r3, %r4, %r5 : (i32, i32, !finch.looplet, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      %sum = affine.for %i = %b0 to %b1 iter_args(%sum_iter = %sum_0) -> f32 {
        %1 = finch.access %s1, %i : f32
        %2 = finch.access %s2, %i : f32

        %sum_next1 = arith.addf %sum_iter, %1 : f32
        %sum_next2 = arith.addf %sum_next1, %2 : f32
        
        affine.yield %sum_next2 : f32
      }
      
      return %sum : f32
    }
}
