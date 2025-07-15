# src/maths/poly/CMakeLists.txt - Polynomial library

set(POLY_SOURCES
    interpolate.c
    interpolate.h
    poly.h
    polyderiv.c
    polyderiv.h
    polyeval.c
    polyeval.h
    polyfit.c
    polyfit.h
)

add_library(ngspice_maths_poly STATIC ${POLY_SOURCES})

target_include_directories(ngspice_maths_poly PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_poly PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_maths_poly
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)