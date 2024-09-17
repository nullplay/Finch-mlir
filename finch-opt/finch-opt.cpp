//===- finch-opt.cpp ---------------------------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#include "mlir/Dialect/Func/Extensions/AllExtensions.h"
#include "mlir/IR/MLIRContext.h"
#include "mlir/InitAllDialects.h"
#include "mlir/InitAllPasses.h"
#include "mlir/Support/FileUtilities.h"
#include "mlir/Tools/mlir-opt/MlirOptMain.h"

#include "Finch/FinchDialect.h"
#include "Finch/FinchPasses.h"

namespace mlir {
namespace test {
void registerTestLinalgDecomposeOps();
void registerTestLinalgDropUnitDims();
void registerTestLinalgElementwiseFusion();
void registerTestLinalgGreedyFusion();
void registerTestLinalgRankReduceContractionOps();
void registerTestLinalgTransforms();
}
}

void registerTestPasses() {
  mlir::test::registerTestLinalgDecomposeOps();
  mlir::test::registerTestLinalgDropUnitDims();
  mlir::test::registerTestLinalgElementwiseFusion();
  mlir::test::registerTestLinalgGreedyFusion();
  mlir::test::registerTestLinalgRankReduceContractionOps();
  mlir::test::registerTestLinalgTransforms();
}

int main(int argc, char **argv) {
  mlir::registerAllPasses();
  mlir::finch::registerPasses();
  registerTestPasses();
  // TODO: Register finch passes here.


  mlir::DialectRegistry registry;
  //registry.insert<mlir::finch::FinchDialect,
  //                mlir::index::IndexDialect, mlir::affine::AffineDialect,
  //                mlir::arith::ArithDialect, mlir::func::FuncDialect,
  //                mlir::memref::MemRefDialect, mlir::scf::SCFDialect, 
  //                mlir::sparse_tensor::SparseTensorDialect, mlir::linalg::LinalgDialect,
  //                mlir::vector::VectorDialect, mlir::bufferization::BufferizationDialect>();
  // Add the following to include *all* MLIR Core dialects, or selectively
  // include what you need like above. You only need to register dialects that
  // will be *parsed* by the tool, not the one generated
  
  registerAllDialects(registry);

  //mlir::registerAllPasses();
  mlir::func::registerAllExtensions(registry); 
  return mlir::asMainReturnCode(
      mlir::MlirOptMain(argc, argv, "Finch optimizer driver\n", registry));
}
