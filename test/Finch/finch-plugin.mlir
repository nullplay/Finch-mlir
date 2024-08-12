// RUN: mlir-opt %s --load-dialect-plugin=%finch_libs/FinchPlugin%shlibext --pass-pipeline="builtin.module(finch-switch-bar-foo)" | FileCheck %s

module {
  // CHECK-LABEL: func @foo()
  func.func @bar() {
    return
  }

  // CHECK-LABEL: func @finch_types(%arg0: !finch.custom<"10">)
  func.func @finch_types(%arg0: !finch.custom<"10">) {
    return
  }
}
