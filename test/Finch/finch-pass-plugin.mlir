// RUN: mlir-opt %s --load-pass-plugin=%finch_libs/FinchPlugin%shlibext --pass-pipeline="builtin.module(finch-switch-bar-foo)" | FileCheck %s

module {
  // CHECK-LABEL: func @foo()
  func.func @bar() {
    return
  }

  // CHECK-LABEL: func @abar()
  func.func @abar() {
    return
  }
}
