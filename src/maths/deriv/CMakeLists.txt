# src/maths/deriv/CMakeLists.txt - Derivative calculation library

set(DERIV_SOURCES
    atander.c
    cosderiv.c
    cubeder.c
    divderiv.c
    equalder.c
    expderiv.c
    invderiv.c
    multder.c
    plusder.c
    powderiv.c
    sqrtder.c
    tanderiv.c
    timesder.c
)

add_library(ngspice_maths_deriv STATIC ${DERIV_SOURCES})

target_include_directories(ngspice_maths_deriv PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Export target
install(TARGETS ngspice_maths_deriv
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)