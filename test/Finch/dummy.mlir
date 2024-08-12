// RUN: finch-opt %s | finch-opt | FileCheck %s

module {
    // CHECK-LABEL: func @bar()
    func.func @bar() {
        %0 = arith.constant 1 : i32
        // CHECK: %{{.*}} = finch.foo %{{.*}} : i32
        %res = finch.foo %0 : i32
        return
    }

    // CHECK-LABEL: func @finch_types(%arg0: !finch.custom<"10">)
    func.func @finch_types(%arg0: !finch.custom<"10">) {
        return
    }
}
