# src/frontend/plotting/CMakeLists.txt - Plotting library

set(PLOTTING_SOURCES
    agraf.c
    clip.c
    gnuplot.c
    graf.c
    graphdb.c
    grid.c
    plot5.c
    plotcurv.c
    plotit.c
    plotting.c
    pvec.c
    x11.c
)

set(PLOTTING_HEADERS
    agraf.h
    clip.h
    gnuplot.h
    graf.h
    graphdb.h
    plot5.h
    plotcurv.h
    plotit.h
    plotting.h
    pvec.h
    x11.h
)

add_library(ngspice_frontend_plotting STATIC 
    ${PLOTTING_SOURCES}
    ${PLOTTING_HEADERS}
)

target_include_directories(ngspice_frontend_plotting PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend_plotting PUBLIC
    ngspice_misc
)

# X11 support
if(NGSPICE_ENABLE_X11)
    target_link_libraries(ngspice_frontend_plotting PUBLIC ${X11_LIBRARIES})
    target_include_directories(ngspice_frontend_plotting PUBLIC ${X11_INCLUDE_DIR})
    target_compile_definitions(ngspice_frontend_plotting PUBLIC HAS_X11)
endif()

# Export target
install(TARGETS ngspice_frontend_plotting
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# Install headers
install(FILES ${PLOTTING_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice/frontend/plotting
    COMPONENT Development
)