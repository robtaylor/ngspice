# src/frontend/wdisp/CMakeLists.txt - Windows display library

set(WDISP_SOURCES
    wincolor.c
    windisp.c
    winprint.c
)

set(WDISP_HEADERS
    ftegraf.h
    wincolor.h
    windisp.h
    winprint.h
)

add_library(ngspice_frontend_wdisp STATIC 
    ${WDISP_SOURCES}
    ${WDISP_HEADERS}
)

target_include_directories(ngspice_frontend_wdisp PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend_wdisp PUBLIC
    ngspice_misc
)

# Windows-specific libraries
if(WIN32)
    target_link_libraries(ngspice_frontend_wdisp PUBLIC gdi32 user32)
endif()

# Export target
install(TARGETS ngspice_frontend_wdisp
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# Install headers
install(FILES ${WDISP_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice/frontend/wdisp
    COMPONENT Development
)