# src/maths/ni/CMakeLists.txt - Numerical integration library

set(NI_SOURCES
    niaciter.c
    nicomcof.c
    niconv.c
    nidest.c
    niditer.c
    niinit.c
    niinteg.c
    niiter.c
    niniter.c
    nipred.c
    nipzmeth.c
    nireinit.c
    nisenre.c
)

add_library(ngspice_maths_ni STATIC ${NI_SOURCES})

target_include_directories(ngspice_maths_ni PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_ni PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_maths_ni
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)