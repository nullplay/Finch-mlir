// RUN: finch-opt %s | finch-opt | FileCheck %s

module {

    func.func @binarysearch(%idx : index, 
      %pos : memref<index>, %ptr : memref<2xi32>, %crd : memref<?xi32>) -> index {
      return %idx : index 
    }
    func.func @buffer_to_looplet(%pos : memref<index>, %ptr : memref<2xi32>, %crd : memref<?xi32>, %val : memref<?xf32>) -> !finch.looplet {
      %fp_0 = arith.constant -0.0 : f32
      %1 = arith.constant 1 : i32
      %c1 = arith.constant 1 : index
     
      %l0 = finch.stepper  
          seek={
            ^bb0(%idx : index):
              %firstpos = func.call @binarysearch(%idx, %pos, %ptr, %crd) : 
                (index, memref<index>, memref<2xi32>, memref<?xi32>) -> (index) 
              finch.return %firstpos : index
          }
          stop={
            ^bb(%pos1 : index):
              %currcrd = memref.load %crd[%pos1] : memref<?xi32>
              finch.return %currcrd : i32 
          } 
          body={
            ^bb(%pos1 : index):
              %currcrd = memref.load %crd[%pos1] : memref<?xi32>
              %currval = memref.load %val[%pos1] : memref<?xf32>
              %zeroend = arith.subi %currcrd, %1 : i32

              %zero_run = finch.run %fp_0 : (f32) -> (!finch.looplet)
              %nonzero_run = finch.run %currval : (f32) -> (!finch.looplet)
              %seq = finch.sequence %zeroend, %zero_run, %nonzero_run : (i32, !finch.looplet, !finch.looplet) -> (!finch.looplet)
              finch.return %seq : !finch.looplet
          } 
          next={
            ^bb0(%pos1 : index):
              %nextpos = arith.addi %pos1, %c1 : index
              finch.return %nextpos : index 
          }

      return %l0 : !finch.looplet
    }


    func.func @test(%buffer : memref<4xf32>, %b0:index, %b1:index, %N:index)  {

      /////////////////////////////////
      // Defining 2D Tensor with Looplet      
      /////////////////////////////////

      // 2nd Dimension
      %pos = memref.alloc() : memref<index>
      %ptr = memref.alloc() : memref<2xi32>
      %crd = memref.alloc(%N) : memref<?xi32>
      %val = memref.alloc(%N) : memref<?xf32>

      %pos2 = memref.alloc() : memref<index>
      %ptr2 = memref.alloc() : memref<2xi32>      // ptr = [0,4]
      %crd2 = memref.alloc(%N) : memref<?xi32>    // crd = [1,3,6,9]
      %val2 = memref.alloc(%N) : memref<?xf32>    // crd = [1,3,6,9]

      %l0 = call @buffer_to_looplet(%pos, %ptr, %crd, %val) : (memref<index>, memref<2xi32>, memref<?xi32>, memref<?xf32>) -> (!finch.looplet)
      %l1 = call @buffer_to_looplet(%pos2, %ptr2, %crd2, %val2) : (memref<index>, memref<2xi32>, memref<?xi32>, memref<?xf32>) -> (!finch.looplet)


      /////////////////////////////////
      // Main Code
      /////////////////////////////////
       
      %fp_0 = arith.constant -0.0 : f32
      %sum = memref.alloc() : memref<f32>                                           // float* sum = []
      memref.store %fp_0, %sum[] : memref<f32>                                      // sum[0] = 0.0
                                                                                    
      %c1 = arith.constant 1 : index
      scf.for %j = %b0 to %b1 step %c1 {                                            // for j in range(b0,b1) :
        %z1 = finch.access %l0, %j : f32                                            //   z1 = l0[j]
        %z2 = finch.access %l1, %j : f32                                            //   z2 = l1[j]

        %z3 = memref.load %sum[] : memref<f32>                                      //   z3 = sum[0]
        %z4 = arith.mulf %z1, %z2 {fastmath = #arith.fastmath<nnan, ninf>} : f32    //   z4 = z1*z2
        %z5 = arith.addf %z3, %z4 {fastmath = #arith.fastmath<nnan, ninf>} : f32    //   z5 = z3 + z4
        memref.store %z5, %sum[] : memref<f32>                                      //   sum[0] = z5
      }
      
      return 
    }
}
