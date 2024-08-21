// RUN: finch-opt %s | finch-opt | FileCheck %s

module {

    func.func @binarysearch(%idx : index, 
      %pos : memref<index>, %ptr : memref<2xi32>, %crd : memref<10xi32>) {
      %0 = arith.constant 0 : index
      memref.store %0, %pos[] : memref<index>
      return 
    }

    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index)  {
      %fp_0 = arith.constant 0.0 : f32
      %fp_1 = arith.constant 1.1 : f32
      %fp_2 = arith.constant 2.2 : f32
    
      %0 = arith.constant 0 : i32
      %1 = arith.constant 1 : i32
      %2 = arith.constant 2 : i32
      %3 = arith.constant 3 : i32
      %4 = arith.constant 4 : i32

      /////////////////////////////////
      // Defining 2D Tensor with Looplet      
      /////////////////////////////////

      // 2nd Dimension
      %pos = memref.alloc() : memref<index>
      %ptr = memref.alloc() : memref<2xi32>
      %crd = memref.alloc() : memref<10xi32>

      %l0 = finch.lookup %0, %4, 
          seek {
            ^bb(%idx : index):
              func.call @binarysearch(%idx, %pos, %ptr, %crd) : 
                (index, memref<index>, memref<2xi32>, memref<10xi32>) -> () 
          },
          body {
              %currpos = memref.load %pos[] : memref<index>
              %index_1 = arith.constant 1 : index
              %prevpos = arith.subi %currpos, %index_1: index
              
              %prevcrd = memref.load %crd[%currpos] : memref<10xi32>
              %currcrd = memref.load %crd[%currpos] : memref<10xi32>
              %currcrd_before = arith.subi %currcrd, %1 : i32

              %zero_run = finch.run %prevcrd, %currcrd_before, %fp_0 : (i32, i32, f32) -> (!finch.looplet)
              %nonzero_run = finch.run %currcrd, %currcrd, %fp_1 : (i32, i32, f32) -> (!finch.looplet)
              %seq = finch.sequence %prevcrd, %currcrd, %zero_run, %nonzero_run : (i32, i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
              finch.return %seq : !finch.looplet
          }, 
          next {
            ^bb:
              %currpos = memref.load %pos[] : memref<index>
              %currpos_i32 = arith.index_cast %currpos : index to i32
              %nextpos_i32 = arith.addi %currpos_i32, %1 : i32
              %nextpos = arith.index_cast %nextpos_i32 : i32 to index
              memref.store %nextpos, %pos[] : memref<index>
          }: (i32, i32) -> (!finch.looplet)


      /////////////////////////////////
      // Main Code
      /////////////////////////////////
      
      %sum = memref.alloc() : memref<f32>
      memref.store %fp_0, %sum[] : memref<f32> 

       
      affine.for %j = %b0 to %b1 {
        %z1 = finch.access %l0, %j : i32
        %v1 = arith.sitofp %z1 : i32 to f32

        %z2 = affine.load %sum[] : memref<f32>
        %z3 = arith.addf %v1, %z2 : f32
        affine.store %z3, %sum[] : memref<f32>
      }
      
      return 
    }
}
