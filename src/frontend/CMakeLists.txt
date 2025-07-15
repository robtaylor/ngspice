# src/frontend/CMakeLists.txt - Frontend library

# Add subdirectories first (order matters for dependencies)
add_subdirectory(numparam)
add_subdirectory(parser)
add_subdirectory(trannoise)
add_subdirectory(plotting)

# Add conditional subdirectories
if(NGSPICE_ENABLE_X11)
    add_subdirectory(help)
endif()

if(NGSPICE_ENABLE_WINGUI)
    add_subdirectory(wdisp)
endif()

# Main frontend library sources
set(FRONTEND_SOURCES
    # Core frontend files
    arg.c
    aspice.c
    breakp.c
    breakp2.c
    circuits.c
    commands.c
    control.c
    cpitf.c
    define.c
    device.c
    diff.c
    dimens.c
    display.c
    dotcards.c
    dvec.c
    error.c
    evaluate.c
    fourier.c
    ftesopt.c
    gens.c
    get_avail_mem_size.c
    get_phys_mem_size.c
    get_resident_set_size.c
    hcomp.c
    hpgl.c
    init.c
    inp.c
    inpc_probe.c
    inpcom.c
    inpcompat.c
    interp.c
    inventory.c
    linear.c
    logicexp.c
    measure.c
    misccoms.c
    miscvars.c
    mw_coms.c
    newcoms.c
    nutinp.c
    nutmegif.c
    options.c
    outitf.c
    parse.c
    points.c
    postcoms.c
    postsc.c
    quote.c
    rawfile.c
    resource.c
    runcoms.c
    runcoms2.c
    shyu.c
    signal_handler.c
    spec.c
    spiceif.c
    streams.c
    subckt.c
    svg.c
    terminal.c
    testcommands.c
    typesdef.c
    udevices.c
    variable.c
    vectors.c
    where.c
    
    # Command implementation files
    com_ahelp.c
    com_alias.c
    com_asciiplot.c
    com_cdump.c
    com_chdir.c
    com_compose.c
    com_display.c
    com_dl.c
    com_dump.c
    com_echo.c
    com_fft.c
    com_fileio.c
    com_ghelp.c
    com_gnuplot.c
    com_hardcopy.c
    com_help.c
    com_history.c
    com_let.c
    com_measure2.c
    com_option.c
    com_plot.c
    com_rehash.c
    com_set.c
    com_setscale.c
    com_shell.c
    com_shift.c
    com_state.c
    com_strcmp.c
    com_sysinfo.c
    com_unset.c
    com_wr_ic.c
    com_xgraph.c
)

# Header files
set(FRONTEND_HEADERS
    arg.h
    aspice.h
    breakp.h
    breakp2.h
    circuits.h
    commands.h
    completion.h
    control.h
    cpitf.h
    define.h
    device.h
    diff.h
    dimens.h
    display.h
    dotcards.h
    evaluate.h
    fourier.h
    ftehelp.h
    gens.h
    hcomp.h
    hpgl.h
    init.h
    inp.h
    inpcom.h
    inpcompat.h
    interp.h
    linear.h
    misccoms.h
    miscvars.h
    mw_coms.h
    newcoms.h
    nutinp.h
    nutmegif.h
    options.h
    outitf.h
    parse-bison-y.h
    parse.h
    points.h
    postcoms.h
    postsc.h
    quote.h
    rawfile.h
    resource.h
    runcoms.h
    runcoms2.h
    shyu.h
    signal_handler.h
    spec.h
    spiceif.h
    streams.h
    subckt.h
    svg.h
    terminal.h
    typesdef.h
    variable.h
    vectors.h
    where.h
    
    # Command implementation headers
    com_ahelp.h
    com_alias.h
    com_asciiplot.h
    com_cdump.h
    com_chdir.h
    com_commands.h
    com_compose.h
    com_display.h
    com_dl.h
    com_dump.h
    com_echo.h
    com_fft.h
    com_fileio.h
    com_ghelp.h
    com_gnuplot.h
    com_hardcopy.h
    com_help.h
    com_history.h
    com_let.h
    com_measure2.h
    com_option.h
    com_plot.h
    com_rehash.h
    com_set.h
    com_setscale.h
    com_shell.h
    com_shift.h
    com_state.h
    com_strcmp.h
    com_unset.h
    com_wr_ic.h
    com_xgraph.h
)

# Generate parser from bison grammar
bison_target(FrontendParser
    parse-bison.y
    ${CMAKE_CURRENT_BINARY_DIR}/parse-bison.c
    DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/parse-bison.h
    COMPILE_FLAGS "-y"
)

# Create frontend library
add_library(ngspice_frontend STATIC 
    ${FRONTEND_SOURCES}
    ${FRONTEND_HEADERS}
    ${BISON_FrontendParser_OUTPUTS}
)

target_include_directories(ngspice_frontend PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_CURRENT_BINARY_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend PUBLIC
    ngspice_misc
    ngspice_maths_sparse
    ngspice_frontend_numparam
    ngspice_frontend_parser
    ngspice_frontend_trannoise
    ngspice_frontend_plotting
)

# Optional dependencies
if(NGSPICE_ENABLE_X11)
    target_link_libraries(ngspice_frontend PUBLIC ngspice_frontend_help)
    target_link_libraries(ngspice_frontend PUBLIC ${X11_LIBRARIES})
    target_include_directories(ngspice_frontend PUBLIC ${X11_INCLUDE_DIR})
endif()

if(NGSPICE_ENABLE_WINGUI)
    target_link_libraries(ngspice_frontend PUBLIC ngspice_frontend_wdisp)
endif()

if(NGSPICE_ENABLE_READLINE)
    target_link_libraries(ngspice_frontend PUBLIC ${Readline_LIBRARY})
    target_include_directories(ngspice_frontend PUBLIC ${Readline_INCLUDE_DIR})
endif()

if(NGSPICE_ENABLE_EDITLINE)
    target_link_libraries(ngspice_frontend PUBLIC ${Editline_LIBRARY})
    target_include_directories(ngspice_frontend PUBLIC ${Editline_INCLUDE_DIR})
endif()

if(NGSPICE_ENABLE_FFTW3)
    target_link_libraries(ngspice_frontend PUBLIC ${FFTW3_LIBRARIES})
    target_include_directories(ngspice_frontend PUBLIC ${FFTW3_INCLUDE_DIRS})
endif()

# System libraries
if(HAVE_LIBM)
    target_link_libraries(ngspice_frontend PUBLIC m)
endif()

if(CMAKE_DL_LIBS)
    target_link_libraries(ngspice_frontend PUBLIC ${CMAKE_DL_LIBS})
endif()

if(Threads_FOUND)
    target_link_libraries(ngspice_frontend PUBLIC Threads::Threads)
endif()

# Export target
install(TARGETS ngspice_frontend
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# Install headers
install(FILES ${FRONTEND_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice/frontend
    COMPONENT Development
)