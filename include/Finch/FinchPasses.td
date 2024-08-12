//===- FinchPsss.td - Finch dialect passes -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef FINCH_PASS
#define FINCH_PASS

include "mlir/Pass/PassBase.td"

def FinchSwitchBarFoo: Pass<"finch-switch-bar-foo"> {
  let summary = "Switches the name of a FuncOp named `bar` to `foo` and folds.";
  let description = [{
    Switches the name of a FuncOp named `bar` to `foo` and folds.
    ```
    func.func @bar() {
      return
    }
    // Gets transformed to:
    func.func @foo() {
      return
    }
    ```
  }];
}

def FinchLoopletRun: Pass<"finch-looplet-run"> {
  let summary = "Compiler Pass for Run Looplets";
  let description = [{
    Switches the name of a FuncOp named `bar` to `foo` and folds.
    ```
    affine.for %i = %lb to %ub ... {
       %0 = finch.run %lb2 %ub2 %val
       %1 = finch.access %0 %i
       ... 
    }

    to

    %lb_1 = arith.min %lb %lb2
   
    %newlb = arith.max %lb %lb2
    %newub = arith.min %ub %ub2
    
    %ub_2 = arith.max %ub %ub2

    affine.for %i = %lb_1 to %newlb ... {
      replace %1 to %undefined
    }

    affine.for %i = %newlb to %newub ... {
      replace %1 to %val
    }

    affine.for %i = %newlb to %newub ... {
      replace %1 to %val
    }

    ```
  }];
}

#endif // FINCH_PASS
