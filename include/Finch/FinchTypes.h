//===- FinchTypes.h - Finch dialect types -------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#ifndef FINCH_FINCHTYPES_H
#define FINCH_FINCHTYPES_H

#include "mlir/IR/BuiltinTypes.h"

#define GET_TYPEDEF_CLASSES
#include "Finch/FinchOpsTypes.h.inc"

#endif // FINCH_FINCHTYPES_H
