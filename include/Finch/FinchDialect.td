#ifndef FINCH_DIALECT
#define FINCH_DIALECT

include "mlir/IR/OpBase.td"

//===----------------------------------------------------------------------===//
// Finch dialect definition.
//===----------------------------------------------------------------------===//

def Finch_Dialect : Dialect {
    let name = "finch";
    let summary = "A finch out-of-tree MLIR dialect.";
    let description = [{
        This dialect is an example of an out-of-tree MLIR dialect designed to
        illustrate the basic setup required to develop MLIR-based tools without
        working inside of the LLVM source tree.
    }];
    let cppNamespace = "::mlir::finch";
    
    let useDefaultTypePrinterParser = 1;
    let extraClassDeclaration = [{
        void registerTypes();
    }];
}

//===----------------------------------------------------------------------===//
// Base finch operation definition.
//===----------------------------------------------------------------------===//

class Finch_Op<string mnemonic, list<Trait> traits = []> :
        Op<Finch_Dialect, mnemonic, traits>;

#endif // FINCH_DIALECT
