//===- FinchPasses.h - Finch passes  ------------------*- C++ -*-===//
//
// This file is licensed under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//
#ifndef FINCH_FINCHPASSES_H
#define FINCH_FINCHPASSES_H

#include "Finch/FinchDialect.h"
#include "Finch/FinchOps.h"
#include "mlir/Pass/Pass.h"
#include <memory>

namespace mlir {
namespace finch {
#define GEN_PASS_DECL
#include "Finch/FinchPasses.h.inc"

#define GEN_PASS_REGISTRATION
#include "Finch/FinchPasses.h.inc"
} // namespace finch
} // namespace mlir

#endif
