add_mlir_dialect(StandaloneOps standalone)
add_mlir_doc(StandaloneDialect StandaloneDialect Standalone/ -gen-dialect-doc)
add_mlir_doc(StandaloneOps StandaloneOps Standalone/ -gen-op-doc)

set(LLVM_TARGET_DEFINITIONS StandalonePasses.td)
mlir_tablegen(StandalonePasses.h.inc --gen-pass-decls)
#mlir_tablegen(StandaloneOpsTypes.h.inc -gen-typedef-decls -typedefs-dialect=standalone)
#mlir_tablegen(StandaloneOpsTypes.cpp.inc -gen-typedef-defs -typedefs-dialect=standalone)
add_public_tablegen_target(MLIRStandalonePassesIncGen)

set(LLVM_TARGET_DEFINITIONS StandaloneTypes.td)
mlir_tablegen(StandaloneTypes.h.inc -gen-typedef-decls -typedefs-dialect=standalone)
mlir_tablegen(StandaloneTypes.cpp.inc -gen-typedef-defs -typedefs-dialect=standalone)
add_public_tablegen_target(MLIRStandaloneTypesIncGen)
