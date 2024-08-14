//===- FinchOps.td - Finch dialect ops -----------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef FINCH_OPS
#define FINCH_OPS

include "Finch/FinchDialect.td"
include "Finch/FinchTypes.td"
include "mlir/Interfaces/InferTypeOpInterface.td"
include "mlir/Interfaces/SideEffectInterfaces.td"

def Finch_FooOp : Finch_Op<"foo", [Pure,
                                             SameOperandsAndResultType]> {
    let summary = "Illustrates how to define an operation.";
    let description = [{
        The `finch.foo` operation illustrates how to define a new
        operation in a dialect. It uses an operation trait to declare that it
        has no side effects.

        This operation takes an integer argument and returns an integer.

        Example:

        ```mlir
        %0 = arith.constant 2 : i32
        // Apply the foo operation to %0
        %1 = finch.foo %0 : i32
        ```
    }];

    let arguments = (ins I32:$input);
    let results = (outs I32:$res);

    let assemblyFormat = [{
        $input attr-dict `:` type($input)
    }];
}


def Finch_AccessOp : Finch_Op<"access", [Pure]> {
    let summary = "Finch Access op";
    let description = [{
        ```mlir
        %2 = finch.access %0 %1 : Looplet, index
        ```
    }];

    let arguments = (ins Finch_LoopletType:$input, Index:$idx); 
    let results = (outs LoopletOrNumber:$res);

    let assemblyFormat = [{
        $input `,` $idx attr-dict `:` type($res)
    }];
}

def Finch_NextLevelOp : Finch_Op<"nextlevel", [Pure]> {
    let summary = "Finch NextLevel Looplets";
    let description = [{
        ```mlir
        %3 = finch.nextlevel %val : looplet -> looplet
        ```
    }];

    let arguments = (ins Finch_LoopletType:$val); 
    let results = (outs Finch_LoopletType:$res);

    let assemblyFormat = [{
        $val attr-dict `:` `(` type($val) `)` `->` `(` type($res) `)`
    }];
}


def Finch_RunOp : Finch_Op<"run", [Pure]> {
    let summary = "Finch Run Looplets";
    let description = [{
        ```mlir
        %3 = finch.run %lb %ub %val : i32, i32, f32 -> looplet
        ```
    }];

    let arguments = (ins I32:$lb, I32:$ub, LoopletOrNumber:$val); 
    let results = (outs Finch_LoopletType:$res);

    let assemblyFormat = [{
        $lb `,` $ub `,` $val attr-dict `:` `(` type($lb) `,` type($ub) `,` type($val) `)` `->` `(` type($res) `)`
    }];
}


def Finch_SequenceOp : Finch_Op<"sequence", [Pure]> {
    let summary = "Finch Sequence Looplets";
    let description = [{
        ```mlir
        %3 = finch.sequence %lb %ub %looplet1 %looplet2 : (i32, i32, !finch.looplet, !finch.looplet) -> !finch.looplet
        ```
    }];

    let arguments = (ins I32:$lb, 
                         I32:$ub, 
                         Variadic<Finch_LoopletType>:$val); 
    let results = (outs Finch_LoopletType:$res);

    let assemblyFormat = [{
        $lb `,` $ub `,` $val attr-dict `:` `(` type($lb) `,` type($ub) `,` type($val) `)` `->` `(` type($res) `)`
    }];
}

#endif // FINCH_OPS
