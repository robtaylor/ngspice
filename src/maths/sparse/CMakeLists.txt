# src/maths/sparse/CMakeLists.txt - Sparse matrix library

set(SPARSE_SOURCES
    spalloc.c
    spbuild.c
    spconfig.h
    spdefs.h
    spextra.c
    spfactor.c
    spoutput.c
    spsmp.c
    spsolve.c
    sputils.c
)

add_library(ngspice_maths_sparse STATIC ${SPARSE_SOURCES})

target_include_directories(ngspice_maths_sparse PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_sparse PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_maths_sparse
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)