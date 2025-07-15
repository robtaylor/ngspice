# src/frontend/help/CMakeLists.txt - Help system library (X11 dependent)

set(HELP_SOURCES
    help.c
    provide.c
    readhelp.c
    textdisp.c
    x11disp.c
    xdisplay.c
)

# No header files in this directory

add_library(ngspice_frontend_help STATIC 
    ${HELP_SOURCES}
)

target_include_directories(ngspice_frontend_help PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend_help PUBLIC
    ngspice_misc
)

# X11 support (required for this library)
if(NGSPICE_ENABLE_X11)
    target_link_libraries(ngspice_frontend_help PUBLIC ${X11_LIBRARIES})
    target_include_directories(ngspice_frontend_help PUBLIC ${X11_INCLUDE_DIR})
    target_compile_definitions(ngspice_frontend_help PUBLIC HAS_X11)
endif()

# Export target
install(TARGETS ngspice_frontend_help
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# No headers to install