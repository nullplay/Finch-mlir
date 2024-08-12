// RUN: standalone-opt %s | standalone-opt | FileCheck %s

#map = affine_map<()[s0, s1] -> (s0, s1)>
module {
    func.func @test(%buffer : memref<4xf32>, %b0:index) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      %int_1 = arith.constant 1 : i32
      %idx_1 = arith.constant 1 : index
      %fp_2 = arith.constant 0.0 : f32
     
      %b4 = arith.constant 4 : index
      
      %0 = affine.max #map()[%b0,%b0]

      %sum = affine.for %i = %0 to %b4 iter_args(%sum_iter = %sum_0) -> f32 {
        %3 = standalone.run %int_1 %int_1 %fp_2 : i32, i32, f32 to !standalone.looplet
        %4 = standalone.access %3 %i : !standalone.looplet, index to f32

        //%t = affine.load %buffer[%i] : memref<4xf32>
        //%sum_next = arith.addf %sum_iter, %t : f32
        %sum_next2 = arith.addf %sum_iter, %4 : f32
        
        affine.yield %sum_next2 : f32
      }
      
      return %sum : f32
    }
}
