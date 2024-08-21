// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index, %int_1:i32) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      //%int_1 = arith.constant 1 : i32
      %idx_1 = arith.constant 1 : index
      %fp_2 = arith.constant 2.0 : f32
    
      // [1,1] -> 2.0
      // finch.run lb ub value
      %3 = finch.run %int_1, %int_!, %fp_2 : (i32, i32, f32) -> (!finch.looplet)

      %sum = affine.for %i = %b0 to %b1 iter_args(%sum_iter = %sum_0) -> f32 {
        %4 = finch.access %3, %i : f32

        %sum_next2 = arith.addf %sum_iter, %4 : f32
        
        affine.yield %sum_next2 : f32
      }
      
      return %sum : f32
    }
}
