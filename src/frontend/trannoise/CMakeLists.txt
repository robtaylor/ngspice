# src/frontend/trannoise/CMakeLists.txt - Transient noise library

set(TRANNOISE_SOURCES
    1-f-code.c
    FastNorm3.c
    wallace.c
)

# No header files in this directory

add_library(ngspice_frontend_trannoise STATIC 
    ${TRANNOISE_SOURCES}
)

target_include_directories(ngspice_frontend_trannoise PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend_trannoise PUBLIC
    ngspice_misc
    ngspice_maths_sparse
)

# Add FFTW3 support if enabled
if(NGSPICE_ENABLE_FFTW3)
    target_link_libraries(ngspice_frontend_trannoise PUBLIC ${FFTW3_LIBRARIES})
    target_include_directories(ngspice_frontend_trannoise PUBLIC ${FFTW3_INCLUDE_DIRS})
    target_compile_definitions(ngspice_frontend_trannoise PUBLIC HAVE_FFTW3)
endif()

# Export target
install(TARGETS ngspice_frontend_trannoise
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# No headers to install