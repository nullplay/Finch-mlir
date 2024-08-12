llvm_canonicalize_cmake_booleans(
        MLIR_ENABLE_BINDINGS_PYTHON
)

configure_lit_site_cfg(
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.site.cfg.py.in
        ${CMAKE_CURRENT_BINARY_DIR}/lit.site.cfg.py
        MAIN_CONFIG
        ${CMAKE_CURRENT_SOURCE_DIR}/lit.cfg.py
)

set(FINCH_TEST_DEPENDS
        FileCheck count not
        finch-capi-test
        finch-opt
        finch-translate
        FinchPlugin
        )
if(MLIR_ENABLE_BINDINGS_PYTHON)
  list(APPEND FINCH_TEST_DEPENDS FinchPythonModules)
endif()

add_lit_testsuite(check-finch "Running the finch regression tests"
        ${CMAKE_CURRENT_BINARY_DIR}
        DEPENDS ${FINCH_TEST_DEPENDS}
        )
set_target_properties(check-finch PROPERTIES FOLDER "Tests")

add_lit_testsuites(FINCH ${CMAKE_CURRENT_SOURCE_DIR} DEPENDS ${FINCH_TEST_DEPENDS})

add_subdirectory(CAPI)
