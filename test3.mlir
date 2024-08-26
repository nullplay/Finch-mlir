// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
  func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index, %int_0:i32, %int_1:i32,%int_2:i32,%int_3:i32,%int_4:i32,%int_5:i32,%int_6:i32) -> (f32) {
      %sum_0 = arith.constant 0.0 : f32
      %fp_1 = arith.constant 1.1 : f32
      %fp_2 = arith.constant 2.2 : f32
    
      //%int_0 = arith.constant 0 : i32
      %c1 = arith.constant 1 : index
      //%int_2 = arith.constant 2 : i32
      //%int_3 = arith.constant 3 : i32
      //%int_4 = arith.constant 4 : i32
      //%int_5 = arith.constant 5 : i32
      //%int_6 = arith.constant 6 : i32

      %r1 = finch.run %fp_1 : (f32) -> (!finch.looplet)
      %r2 = finch.run %fp_1 : (f32) -> (!finch.looplet)
      %s1 = finch.sequence %int_3, %r1, %r2 : (i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      %r3 = finch.run %fp_1 : (f32) -> (!finch.looplet)
      %r5 = finch.run %fp_2 : (f32) -> (!finch.looplet)
      %s2 = finch.sequence %int_1, %r3, %r5 : (i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      %test = memref.alloc() : memref<f32>

      scf.for %i = %b0 to %b1 step %c1  {
        %1 = finch.access %s1, %i : f32
        %2 = finch.access %s2, %i : f32

        %sum_next1 = arith.addf %sum_0, %1 : f32
        %sum_next2 = arith.addf %sum_next1, %2 : f32
        
        memref.store %sum_next2, %test[] : memref<f32> 
      }
      
      %sum = memref.load %test[] : memref<f32>
      return %sum : f32
    }
}
