# src/include/cppduals/duals/CMakeLists.txt - C++ dual numbers library

# Install header files
install(FILES dual dual_eigen
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/cppduals/duals
    COMPONENT Development
)