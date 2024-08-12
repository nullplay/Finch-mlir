//===- FinchTypes.cpp - Finch dialect types -----------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Finch/FinchTypes.h"

#include "Finch/FinchDialect.h"
#include "mlir/IR/Builders.h"
#include "mlir/IR/DialectImplementation.h"
#include "llvm/ADT/TypeSwitch.h"

using namespace mlir::finch;

#define GET_TYPEDEF_CLASSES
#include "Finch/FinchOpsTypes.cpp.inc"

void FinchDialect::registerTypes() {
  addTypes<
#define GET_TYPEDEF_LIST
#include "Finch/FinchOpsTypes.cpp.inc"
      >();
}
