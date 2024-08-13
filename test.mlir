// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index, %int_1:i32) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      //%int_1 = arith.constant 1 : i32
      %idx_1 = arith.constant 1 : index
      %fp_2 = arith.constant 0.0 : f32
     

      %sum = affine.for %i = %b0 to %b1 iter_args(%sum_iter = %sum_0) -> f32 {
        %3 = finch.run %int_1, %int_1, %fp_2 : (i32, i32, f32) -> (!finch.looplet)
        %5 = finch.sequence %int_1, %int_1, %3, %3, %3 : (i32, i32, !finch.looplet, !finch.looplet, !finch.looplet) -> (!finch.looplet)
        %4 = finch.access %5, %i : f32

        //%t = affine.load %buffer[%i] : memref<4xf32>
        //%sum_next = arith.addf %sum_iter, %t : f32
        %sum_next2 = arith.addf %sum_iter, %4 : f32
        
        affine.yield %sum_next2 : f32
      }
      
      return %sum : f32
    }
}
