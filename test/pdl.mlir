module @patterns {
  pdl.pattern : benefit(100) {
    %type = pdl.type : i32
    %a = pdl.operand : %type
    %zattr = pdl.attribute = 0 : i32
    %cop = pdl.operation "arith.constant" {"value"=%zattr} -> (%type : !pdl.type) 
    %0 = pdl.result 0 of %cop
    %addop = pdl.operation "arith.addi"(%a, %0 : !pdl.value, !pdl.value) -> (%type: !pdl.type)
    %sum = pdl.result 0 of %addop
    pdl.rewrite %addop {
      pdl.replace %addop with (%a:!pdl.value)
    }
  }
}

module @ir {
  func.func @test(%a : i32) -> i32 {
    %0 = arith.constant 0 : i32
    %b = arith.addi %a, %0 : i32
    return %b : i32
  }
}

// Available Dialects: acc, affine, arm_neon, arm_sve, async, avx512, gpu, linalg, llvm, llvm_arm_neon, llvm_arm_sve, llvm_avx512, nvvm, omp, pdl, pdl_interp, quant, rocdl, scf, sdbm, shape, spv, std, tensor, test, tosa, vector
// --convert-pdl-to-pdl-interp - Convert PDL ops to PDL interpreter ops
// --test-pdl-bytecode-pass    - Test PDL ByteCode functionality
