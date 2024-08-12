// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        %1 = index.castu %0 : i32 to index
        // CHECK: %{{.*}} = finch.foo %{{.*}} : i32
        %res = finch.foo %0 : i32
       
        %val = arith.constant 3.0 : f32
        // CHECK: %{{.*}} = finch.run %{{.*}} %{{.*}} %{{.*}} : i32, i32, f32 to !finch.looplet 
        %3 = finch.run %0 %0 %val : i32, i32, f32 to !finch.looplet

        // CHECK: %{{.*}} = finch.access %{{.*}} %{{.*}} : !finch.looplet, index to f32
        %2 = finch.access %3 %1 : !finch.looplet, index to f32 
 
        return
    }

    // CHECK-LABEL: func @finch_types(%arg0: !finch.custom<"10">)
    func.func @finch_types(%arg0: !finch.custom<"10">) {
        return
    }

    func.func @test(%buffer : memref<4xf32>) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      %int_1 = arith.constant 1 : i32
      %fp_2 = arith.constant 2.0 : f32
      
      %sum = affine.for %i = 0 to 4 iter_args(%sum_iter = %sum_0) -> f32 {
        %3 = finch.run %int_1 %int_1 %fp_2 : i32, i32, f32 to !finch.looplet
        %4 = finch.access %3 %i : !finch.looplet, index to f32

        //%t = affine.load %buffer[%i] : memref<4xf32>
        //%sum_next = arith.addf %sum_iter, %t : f32
        %sum_next2 = arith.addf %sum_iter, %4 : f32
        
        affine.yield %sum_next2 : f32
      }
      
      return %sum : f32
    }
}
