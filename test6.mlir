// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    func.func @test(%buffer : memref<4xf32>, %lb:index, %ub:index,%int_0:i32, %int_1:i32,%int_2:i32,%int_3:i32,%int_4:i32 )  {
      %fp_0 = arith.constant -0.0 : f32
      %fp_1 = arith.constant 1.1 : f32
      %fp_2 = arith.constant 2.2 : f32
    
      //%int_0 = arith.constant 0 : i32
      //%int_1 = arith.constant 1 : i32
      //%int_2 = arith.constant 2 : i32
      //%int_3 = arith.constant 3 : i32
      //%int_4 = arith.constant 4 : i32

      /////////////////////////////////
      // Defining 2D Tensor with Looplet      
      /////////////////////////////////

      // Tensor A
      // ([0,2], [0,4]) -> 0.0
      // ([3,4], [0,4]) -> 2.0

      // 2nd Dimension
      %a0 = finch.run %int_0, %int_4, %fp_0 : (i32, i32, f32) -> (!finch.looplet)
      %a1 = finch.run %int_0, %int_4, %fp_0 : (i32, i32, f32) -> (!finch.looplet)

      // barrier between dimensions
      //%l2 = finch.nextlevel %l0 : (!finch.looplet) -> (!finch.looplet)  
      //%l3 = finch.nextlevel %l1 : (!finch.looplet) -> (!finch.looplet) 

      // 1st Dimension
      %a4 = finch.run %int_0, %int_2, %a0 : (i32, i32, !finch.looplet) -> (!finch.looplet)
      %a5 = finch.run %int_3, %int_4, %a1 : (i32, i32, !finch.looplet) -> (!finch.looplet)
      %a7 = finch.sequence %int_0, %int_4, %a4, %a5 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
      

      // Tensor B
      // ([0,1], [0,2]) -> 0.0
      // ([0,1], [3,4]) -> 1.0
      // ([2,4], [0,4]) -> 1.0
      
      // 2nd Dimension
      %b0 = finch.run %int_0, %int_2, %fp_0 : (i32, i32, f32) -> (!finch.looplet)
      %b1 = finch.run %int_3, %int_4, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
      %b2 = finch.sequence %int_0, %int_4, %b0, %b1 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)

      %b3 = finch.run %int_0, %int_4, %fp_1 : (i32, i32, f32) -> (!finch.looplet)

      // barrier between dimensions
      //%l2 = finch.nextlevel %l0 : (!finch.looplet) -> (!finch.looplet)  
      //%l3 = finch.nextlevel %l1 : (!finch.looplet) -> (!finch.looplet) 

      // 1st Dimension
      %b4 = finch.run %int_0, %int_1, %b2 : (i32, i32, !finch.looplet) -> (!finch.looplet)
      %b5 = finch.run %int_2, %int_4, %b3 : (i32, i32, !finch.looplet) -> (!finch.looplet)
      %b7 = finch.sequence %int_0, %int_4, %b4, %b5 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
 


      /////////////////////////////////
      // Main Code
      /////////////////////////////////
      
      %sum = memref.alloc() : memref<f32>
      memref.store %fp_0, %sum[] : memref<f32> 

      affine.for %i = %lb to %ub {
        %0 = finch.access %a7, %i : !finch.looplet 
        %1 = finch.access %b7, %i : !finch.looplet 
        
        affine.for %j = %lb to %ub {
          %2 = finch.access %0, %j : f32
          %3 = finch.access %1, %j : f32

          %4 = affine.load %sum[] : memref<f32>
          %5 = arith.addf %2, %4 : f32
          %6 = arith.addf %3, %5 : f32
          affine.store %6, %sum[] : memref<f32>
        }
      }
      
      return 
    }
}
