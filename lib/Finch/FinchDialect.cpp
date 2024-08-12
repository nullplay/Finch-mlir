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

using namespace mlir;
using namespace mlir::finch;

#include "Finch/FinchOpsDialect.cpp.inc"

//===----------------------------------------------------------------------===//
// Finch dialect.
//===----------------------------------------------------------------------===//

void FinchDialect::initialize() {
  addOperations<
#define GET_OP_LIST
#include "Finch/FinchOps.cpp.inc"
      >();
  registerTypes();
}
