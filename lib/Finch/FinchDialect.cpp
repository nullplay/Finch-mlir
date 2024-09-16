//===- FinchDialect.cpp - Finch dialect ---------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Finch/FinchDialect.h"
#include "Finch/FinchOps.h"
#include "Finch/FinchTypes.h"
#include "mlir/Transforms/InliningUtils.h"
#include "mlir/IR/DialectImplementation.h"


using namespace mlir;
using namespace mlir::finch;

#include "Finch/FinchOpsDialect.cpp.inc"

//===----------------------------------------------------------------------===//
// Finch dialect.
//===----------------------------------------------------------------------===//

struct FinchInlinerInterface : public DialectInlinerInterface {
  using DialectInlinerInterface::DialectInlinerInterface;

  bool isLegalToInline(Operation *, Region *, bool, IRMapping &) const final {
    return true;
  }
};

void FinchDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Finch/FinchOps.cpp.inc"
      >();
  addInterfaces<FinchInlinerInterface>();
  registerTypes();
}
