//===- StandaloneTypes.td - Standalone dialect types -------*- tablegen -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef STANDALONE_TYPES
#define STANDALONE_TYPES

include "mlir/IR/AttrTypeBase.td"
include "mlir/IR/CommonTypeConstraints.td"
include "Standalone/StandaloneDialect.td"

//===----------------------------------------------------------------------===//
// Standalone type definitions
//===----------------------------------------------------------------------===//

class Standalone_Type<string name, string typeMnemonic, list<Trait> traits = [],
                      string baseCppClass="::mlir::Type">
    : TypeDef<Standalone_Dialect, name, traits, baseCppClass> {
  let mnemonic = typeMnemonic;
}

def Standalone_CustomType : Standalone_Type<"Custom", "custom"> {
    let summary = "Standalone custom type";
    let description = "Custom type in standalone dialect";
    let parameters = (ins StringRefParameter<"the custom value">:$value);
    let assemblyFormat = "`<` $value `>`";
}



def Standalone_LoopletType : TypeDef<Standalone_Dialect, "Looplet", []> {
    let summary = "Standalone Looplets type";
    let description = "Looplets type in standalone dialect";
    let mnemonic = "looplet";
    //let parameters = (ins "int":$lb, "int":$ub);
    //let assemblyFormat = "`<` $lb `,` $ub `>`";
}

def AnyNumber : AnyTypeOf<[AnyInteger, AnyFloat]>;
def Looplet : AnyTypeOf<[Standalone_LoopletType]>;

#endif // STANDALONE_TYPES
