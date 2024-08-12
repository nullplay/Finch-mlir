add_mlir_public_c_api_library(FinchCAPI
  Dialects.cpp
  LINK_LIBS PUBLIC
  MLIRFinch
)
