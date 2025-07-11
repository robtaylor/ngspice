# src/maths/misc/CMakeLists.txt - Miscellaneous math utilities

set(MATHMISC_SOURCES
    accuracy.c
    accuracy.h
    bernoull.c
    bernoull.h
    equality.c
    norm.c
    norm.h
    randnumb.c
)

# Platform-specific sources
if(NOT HAVE_ISINF)
    list(APPEND MATHMISC_SOURCES isinf.c)
endif()

if(NOT HAVE_ISNAN)
    list(APPEND MATHMISC_SOURCES isnan.c)
endif()

if(NOT HAVE_LOGB)
    list(APPEND MATHMISC_SOURCES logb.c)
endif()

if(NOT HAVE_SCALB)
    list(APPEND MATHMISC_SOURCES scalb.c)
endif()

add_library(ngspice_maths_misc STATIC ${MATHMISC_SOURCES})

target_include_directories(ngspice_maths_misc PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_misc PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_maths_misc
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)