get_property(dialect_libs GLOBAL PROPERTY MLIR_DIALECT_LIBS)
get_property(conversion_libs GLOBAL PROPERTY MLIR_CONVERSION_LIBS)
get_property(extension_libs GLOBAL PROPERTY MLIR_EXTENSION_LIBS)

set(test_libs
  MLIRTestDialect
  MLIRTestPDLL
  MLIRTestPass
  MLIRLLVMTestPasses
  MLIRTestRewrite
  )

set(LIBS
        ${dialect_libs}
        ${conversion_libs}
        ${extension_libs}
        MLIRArithDialect
        MLIRFuncDialect
        MLIRIndexDialect
        MLIROptLib
        MLIRPass
        MLIRFinch
        )
add_llvm_executable(finch-opt finch-opt.cpp)

llvm_update_compile_flags(finch-opt)
target_link_libraries(finch-opt PRIVATE ${LIBS})

mlir_check_all_link_libraries(finch-opt)
