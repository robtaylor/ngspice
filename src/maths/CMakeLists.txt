# src/maths/CMakeLists.txt - Mathematical libraries

add_subdirectory(deriv)
add_subdirectory(cmaths)
add_subdirectory(misc)
add_subdirectory(fft)
add_subdirectory(poly)
add_subdirectory(ni)
add_subdirectory(sparse)

# Optional KLU library
if(NGSPICE_ENABLE_KLU)
    add_subdirectory(KLU)
endif()

# Optional dense library for S-parameters
if(NGSPICE_ENABLE_SP)
    add_subdirectory(dense)
endif()