# src/maths/dense/CMakeLists.txt - Dense matrix library (for S-parameters)

set(DENSE_SOURCES
    dense.c
    dense.h
    denseinlines.h
)

add_library(ngspice_maths_dense STATIC ${DENSE_SOURCES})

target_include_directories(ngspice_maths_dense PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_dense PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_maths_dense
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)