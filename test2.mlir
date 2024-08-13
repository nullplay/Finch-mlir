// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      %idx_1 = arith.constant 1 : index
      %fp_2 = arith.constant 0.0 : f32
    
      %int_1 = arith.constant 1 : i32
      %int_2 = arith.constant 1 : i32
      %int_1 = arith.constant 1 : i32
      %int_1 = arith.constant 1 : i32
      %int_1 = arith.constant 1 : i32
      %int_1 = arith.constant 1 : i32


      %sum = affine.for %i = %b0 to %b1 iter_args(%sum_iter = %sum_0) -> f32 {
        %1 = finch.run %int_1, %int_1, %fp_2 : (i32, i32, f32) -> (!finch.looplet)
        %2 = finch.sequence %int_1, %int_1, %1, %1 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)

        %3 = finch.run %int_2, %int_2, %fp_2 : (i32, i32, f32) -> (!finch.looplet)
        %4 = finch.sequence %int_2, %int_2, %3, %3 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
 
        %5 = finch.access %2, %i : f32
        %6 = finch.access %4, %i : f32

        %sum_next1 = arith.addf %sum_iter, %5 : f32
        %sum_next2 = arith.addf %sum_next1, %6 : f32
        
        affine.yield %sum_next2 : f32
      }
      
      return %sum : f32
    }
}
