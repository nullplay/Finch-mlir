// RUN: finch-opt %s | finch-opt | FileCheck %s

module {

    func.func @binarysearch(%idx : index, 
      %pos : memref<index>, %ptr : memref<2xi32>, %crd : memref<?xi32>) -> index {
      %0 = arith.constant 0 : index
      return %0 : index 
    }

    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index, %N:index)  {
      %fp_0 = arith.constant -0.0 : f32
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
      %crd = memref.alloc(%N) : memref<?xi32>

      %l0 = finch.stepper  
          seek {
            ^bb(%idx : index):
              %firstpos = func.call @binarysearch(%idx, %pos, %ptr, %crd) : 
                (index, memref<index>, memref<2xi32>, memref<?xi32>) -> (index) 
              finch.return %firstpos : index
          },
          stop {
            ^bb(%pos1 : index):
              %currcrd = memref.load %crd[%pos1] : memref<?xi32>
              finch.return %currcrd : i32 
          }, 
          body {
            ^bb(%pos2 : index):
              %currcrd = memref.load %crd[%pos2] : memref<?xi32>
              %zeroend = arith.subi %currcrd, %1 : i32

              %zero_run = finch.run %0 : (i32) -> (!finch.looplet)
              %nonzero_run = finch.run %1 : (i32) -> (!finch.looplet)
              %seq = finch.sequence %zeroend, %zero_run, %nonzero_run : (i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
              finch.return %seq : !finch.looplet
          }, 
          next {
            ^bb(%pos3 : index):
              %c1 = arith.constant 1 : index
              %nextpos = arith.addi %pos3, %c1 : index
              finch.return %nextpos : index 
          }

     %pos2 = memref.alloc() : memref<index>
     %ptr2 = memref.alloc() : memref<2xi32>
     %crd2 = memref.alloc(%N) : memref<?xi32>
     %l1 = finch.stepper  
          seek {
            ^bb(%idx2 : index):
              %firstpos = func.call @binarysearch(%idx2, %pos2, %ptr2, %crd2) : 
                (index, memref<index>, memref<2xi32>, memref<?xi32>) -> (index) 
              finch.return %firstpos : index
          },
          stop {
            ^bb(%pos3 : index):
              %currcrd = memref.load %crd[%pos3] : memref<?xi32>
              finch.return %currcrd : i32 
          }, 
          body {
            ^bb(%pos4 : index):
              %currcrd = memref.load %crd[%pos4] : memref<?xi32>
              %zeroend = arith.subi %currcrd, %1 : i32

              %zero_run = finch.run %0 : (i32) -> (!finch.looplet)
              %nonzero_run = finch.run %2 : (i32) -> (!finch.looplet)
              %seq = finch.sequence %zeroend, %zero_run, %nonzero_run : (i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
              finch.return %seq : !finch.looplet
          }, 
          next {
            ^bb(%pos5 : index):
              %c1 = arith.constant 1 : index
              %nextpos = arith.addi %pos5, %c1 : index
              finch.return %nextpos : index 
          }



      /////////////////////////////////
      // Main Code
      /////////////////////////////////
      
      %sum = memref.alloc() : memref<i32>
      memref.store %0, %sum[] : memref<i32> 

      %c1 = arith.constant 1 : index
      scf.for %j = %b0 to %b1 step %c1 {
        %z1 = finch.access %l0, %j : i32
        %z2 = finch.access %l1, %j : i32

        %z3 = memref.load %sum[] : memref<i32>
        %z4 = arith.addi %z1, %z2 : i32
        %z5 = arith.addi %z3, %z4 : i32
        memref.store %z5, %sum[] : memref<i32>
      }
      
      return 
    }
}
