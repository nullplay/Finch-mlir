# RUN: %python %s | FileCheck %s

from mlir_finch.ir import *
from mlir_finch.dialects import builtin as builtin_d, finch as finch_d

with Context():
    finch_d.register_dialect()
    module = Module.parse(
        """
    %0 = arith.constant 2 : i32
    %1 = finch.foo %0 : i32
    """
    )
    # CHECK: %[[C:.*]] = arith.constant 2 : i32
    # CHECK: finch.foo %[[C]] : i32
    print(str(module))
