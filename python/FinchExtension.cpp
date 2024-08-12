//===- FinchExtension.cpp - Extension module -------------------------===//
//
// Part of the LLVM Project, under the Apache License v2.0 with LLVM Exceptions.
// See https://llvm.org/LICENSE.txt for license information.
// SPDX-License-Identifier: Apache-2.0 WITH LLVM-exception
//
//===----------------------------------------------------------------------===//

#include "Finch-c/Dialects.h"
#include "mlir/Bindings/Python/PybindAdaptors.h"

using namespace mlir::python::adaptors;

PYBIND11_MODULE(_finchDialects, m) {
  //===--------------------------------------------------------------------===//
  // finch dialect
  //===--------------------------------------------------------------------===//
  auto finchM = m.def_submodule("finch");

  finchM.def(
      "register_dialect",
      [](MlirContext context, bool load) {
        MlirDialectHandle handle = mlirGetDialectHandle__finch__();
        mlirDialectHandleRegisterDialect(handle, context);
        if (load) {
          mlirDialectHandleLoadDialect(handle, context);
        }
      },
      py::arg("context") = py::none(), py::arg("load") = true);
}
