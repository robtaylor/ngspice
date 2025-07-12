# src/frontend/numparam/CMakeLists.txt - Numerical parameter library

set(NUMPARAM_SOURCES
    mystring.c
    spicenum.c
    xpressn.c
)

set(NUMPARAM_HEADERS
    general.h
    numpaif.h
    numparam.h
)

add_library(ngspice_frontend_numparam STATIC 
    ${NUMPARAM_SOURCES}
    ${NUMPARAM_HEADERS}
)

target_include_directories(ngspice_frontend_numparam PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend_numparam PUBLIC
    ngspice_misc
)

# Export target
install(TARGETS ngspice_frontend_numparam
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# Install headers
install(FILES ${NUMPARAM_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice/frontend/numparam
    COMPONENT Development
)