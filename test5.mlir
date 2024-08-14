// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index)  {
      %fp_0 = arith.constant 0.0 : f32
      %fp_1 = arith.constant 1.1 : f32
      %fp_2 = arith.constant 2.2 : f32
    
      %int_0 = arith.constant 0 : i32
      %int_1 = arith.constant 1 : i32
      %int_2 = arith.constant 2 : i32
      %int_3 = arith.constant 3 : i32
      %int_4 = arith.constant 4 : i32

      /////////////////////////////////
      // Defining 2D Tensor with Looplet      
      /////////////////////////////////

      // 2nd Dimension
      %l0 = finch.run %int_0, %int_4, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
      %l1 = finch.run %int_0, %int_4, %fp_2 : (i32, i32, f32) -> (!finch.looplet)

      // barrier between dimensions
      //%l2 = finch.nextlevel %l0 : (!finch.looplet) -> (!finch.looplet)  
      //%l3 = finch.nextlevel %l1 : (!finch.looplet) -> (!finch.looplet) 

      // 1st Dimension
      %l4 = finch.run %int_0, %int_2, %l0 : (i32, i32, !finch.looplet) -> (!finch.looplet)
      %l5 = finch.run %int_3, %int_4, %l1 : (i32, i32, !finch.looplet) -> (!finch.looplet)
      %l7 = finch.sequence %int_0, %int_4, %l4, %l5 : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
     

      /////////////////////////////////
      // Main Code
      /////////////////////////////////
      
      %sum = memref.alloc() : memref<f32>
      memref.store %fp_0, %sum[] : memref<f32> 

      affine.for %i = %b0 to %b1 {
        %0 = finch.access %l7, %i : !finch.looplet 
        
        affine.for %j = %b0 to %b1 {
          %1 = finch.access %0, %j : f32

          %2 = affine.load %sum[] : memref<f32>
          %3 = arith.addf %1, %2 : f32
          affine.store %3, %sum[] : memref<f32>
        }
      }
      
      return 
    }
}
