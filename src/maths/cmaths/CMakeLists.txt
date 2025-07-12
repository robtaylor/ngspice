# src/maths/cmaths/CMakeLists.txt - Complex mathematics library

set(CMATHS_SOURCES
    cmath1.c
    cmath1.h
    cmath2.c
    cmath2.h
    cmath3.c
    cmath3.h
    cmath4.c
    cmath4.h
    cmath.h
)

add_library(ngspice_maths_cmaths STATIC ${CMATHS_SOURCES})

target_include_directories(ngspice_maths_cmaths PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/../poly>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_cmaths PUBLIC m)
endif()

# Use FFTW3 if available
if(FFTW3_FOUND)
    target_link_libraries(ngspice_maths_cmaths PUBLIC ${FFTW3_LIBRARIES})
    target_include_directories(ngspice_maths_cmaths PUBLIC ${FFTW3_INCLUDE_DIRS})
endif()

# Export target
install(TARGETS ngspice_maths_cmaths
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)