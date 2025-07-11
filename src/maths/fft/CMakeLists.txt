# src/maths/fft/CMakeLists.txt - FFT library

set(FFT_SOURCES
    fftext.c
    fftlib.c
    fftlib.h
    matlib.c
    matlib.h
)

add_library(ngspice_maths_fft STATIC ${FFT_SOURCES})

target_include_directories(ngspice_maths_fft PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_fft PUBLIC m)
endif()

# Use FFTW3 if available
if(FFTW3_FOUND)
    target_link_libraries(ngspice_maths_fft PUBLIC ${FFTW3_LIBRARIES})
    target_include_directories(ngspice_maths_fft PUBLIC ${FFTW3_INCLUDE_DIRS})
endif()

# Export target
install(TARGETS ngspice_maths_fft
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)