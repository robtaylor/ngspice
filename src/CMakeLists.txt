# src/CMakeLists.txt - Main source directory

# Add subdirectories in dependency order
add_subdirectory(include)
add_subdirectory(misc)
add_subdirectory(maths)
add_subdirectory(frontend)
add_subdirectory(spicelib)

# Optional components
if(NGSPICE_ENABLE_XSPICE)
    add_subdirectory(xspice)
endif()

if(NGSPICE_ENABLE_CIDER)
    add_subdirectory(ciderlib)
endif()

if(NGSPICE_ENABLE_OSDI)
    add_subdirectory(osdi)
endif()

# Device libraries list
set(NGSPICE_DEVICE_LIBRARIES
    spicelib_dev_asrc
    spicelib_dev_bjt
    spicelib_dev_bsim1
    spicelib_dev_bsim2
    spicelib_dev_bsim3
    spicelib_dev_bsim3v0
    spicelib_dev_bsim3v1
    spicelib_dev_bsim3v32
    spicelib_dev_bsim4
    spicelib_dev_bsim4v5
    spicelib_dev_bsim4v6
    spicelib_dev_bsim4v7
    spicelib_dev_cap
    spicelib_dev_bsim3soi_pd
    spicelib_dev_bsim3soi_fd
    spicelib_dev_bsim3soi_dd
    spicelib_dev_bsimsoi
    spicelib_dev_cccs
    spicelib_dev_ccvs
    spicelib_dev_cpl
    spicelib_dev_csw
    spicelib_dev_dio
    spicelib_dev_ind
    spicelib_dev_isrc
    spicelib_dev_hfet1
    spicelib_dev_hfet2
    spicelib_dev_hicum2
    spicelib_dev_hisim2
    spicelib_dev_hisimhv1
    spicelib_dev_hisimhv2
    spicelib_dev_jfet
    spicelib_dev_jfet2
    spicelib_dev_ltra
    spicelib_dev_mes
    spicelib_dev_mesa
    spicelib_dev_mos1
    spicelib_dev_mos2
    spicelib_dev_mos3
    spicelib_dev_mos6
    spicelib_dev_mos9
    spicelib_dev_res
    spicelib_dev_soi3
    spicelib_dev_sw
    spicelib_dev_txl
    spicelib_dev_tra
    spicelib_dev_urc
    spicelib_dev_vbic
    spicelib_dev_vccs
    spicelib_dev_vcvs
    spicelib_dev_vdmos
    spicelib_dev_vsrc
)

# Add NDEV devices if enabled
if(NGSPICE_ENABLE_NDEV)
    list(APPEND NGSPICE_DEVICE_LIBRARIES spicelib_dev_ndev)
endif()

# Add numerical devices if CIDER is enabled
if(NGSPICE_ENABLE_CIDER)
    list(APPEND NGSPICE_DEVICE_LIBRARIES
        spicelib_dev_nbjt
        spicelib_dev_nbjt2
        spicelib_dev_numd
        spicelib_dev_numd2
        spicelib_dev_numos
    )
endif()

# Core libraries list
set(NGSPICE_CORE_LIBRARIES
    ngspice_misc
    ngspice_maths_deriv
    ngspice_maths_cmaths
    ngspice_maths_misc
    ngspice_maths_fft
    ngspice_maths_poly
    ngspice_maths_ni
    ngspice_maths_sparse
    ngspice_frontend
    ngspice_frontend_plotting
    ngspice_frontend_parser
    ngspice_frontend_numparam
    ngspice_frontend_trannoise
    ngspice_spicelib_analysis
    ngspice_spicelib_devices
    ngspice_spicelib_parser
)

# Add KLU if enabled
if(NGSPICE_ENABLE_KLU)
    list(APPEND NGSPICE_CORE_LIBRARIES ngspice_maths_klu)
endif()

# Add dense math if S-parameters enabled
if(NGSPICE_ENABLE_SP)
    list(APPEND NGSPICE_CORE_LIBRARIES ngspice_maths_dense)
endif()

# Add X11 help if enabled
if(NGSPICE_ENABLE_X11 AND NOT NGSPICE_ENABLE_WINGUI)
    list(APPEND NGSPICE_CORE_LIBRARIES ngspice_frontend_help)
endif()

# Add Windows display if enabled
if(NGSPICE_ENABLE_WINGUI)
    list(APPEND NGSPICE_CORE_LIBRARIES ngspice_frontend_wdisp)
endif()

# Add XSPICE libraries if enabled
if(NGSPICE_ENABLE_XSPICE)
    list(APPEND NGSPICE_CORE_LIBRARIES
        ngspice_xspice_cm
        ngspice_xspice_mif
        ngspice_xspice_evt
        ngspice_xspice_enh
        ngspice_xspice_ipc
        ngspice_xspice_idn
    )
endif()

# Add CIDER libraries if enabled
if(NGSPICE_ENABLE_CIDER)
    list(APPEND NGSPICE_CORE_LIBRARIES
        ngspice_ciderlib_twod
        ngspice_ciderlib_oned
        ngspice_ciderlib_input
        ngspice_ciderlib_support
    )
endif()

# Add OSDI library if enabled
if(NGSPICE_ENABLE_OSDI)
    list(APPEND NGSPICE_CORE_LIBRARIES ngspice_osdi)
endif()

# Common source files
set(NGSPICE_COMMON_SOURCES
    conf.c
    conf.h
    ngspice.c
)

# Platform-specific sources
if(NGSPICE_ENABLE_WINGUI)
    list(APPEND NGSPICE_COMMON_SOURCES
        winmain.c
        winmain.h
        hist_info.c
        hist_info.h
    )
endif()

# Create spinit file
configure_file(
    ${CMAKE_CURRENT_SOURCE_DIR}/spinit.in
    ${CMAKE_CURRENT_BINARY_DIR}/spinit
    @ONLY
)

# Create tclspinit file if TCL enabled
if(NGSPICE_ENABLE_TCL)
    configure_file(
        ${CMAKE_CURRENT_SOURCE_DIR}/tclspinit.in
        ${CMAKE_CURRENT_BINARY_DIR}/tclspinit
        @ONLY
    )
endif()

# Main executable target
if(NOT NGSPICE_ENABLE_SHARED AND NOT NGSPICE_ENABLE_TCL)
    add_executable(ngspice
        main.c
        ${NGSPICE_COMMON_SOURCES}
    )
    
    target_compile_definitions(ngspice PRIVATE SIMULATOR)
    
    target_link_libraries(ngspice PRIVATE
        ${NGSPICE_CORE_LIBRARIES}
        ${NGSPICE_DEVICE_LIBRARIES}
    )
    
    # Platform-specific linking
    if(NGSPICE_ENABLE_WINGUI)
        target_link_options(ngspice PRIVATE -municode)
        target_link_libraries(ngspice PRIVATE psapi shlwapi)
    endif()
    
    if(NGSPICE_PLATFORM_WINDOWS)
        target_link_libraries(ngspice PRIVATE psapi shlwapi)
    endif()
    
    # External libraries
    if(NGSPICE_ENABLE_X11)
        target_link_libraries(ngspice PRIVATE ${X11_LIBRARIES})
    endif()
    
    if(NGSPICE_ENABLE_READLINE)
        target_link_libraries(ngspice PRIVATE Readline::Readline)
    endif()
    
    if(NGSPICE_ENABLE_EDITLINE)
        target_link_libraries(ngspice PRIVATE ${EDITLINE_LIBRARIES})
    endif()
    
    if(FFTW3_FOUND)
        target_link_libraries(ngspice PRIVATE ${FFTW3_LIBRARIES})
    endif()
    
    if(NGSPICE_ENABLE_OPENMP)
        target_link_libraries(ngspice PRIVATE OpenMP::OpenMP_C)
    endif()
    
    if(HAVE_LIBM)
        target_link_libraries(ngspice PRIVATE m)
    endif()
    
    if(HAVE_LIBPTHREAD)
        target_link_libraries(ngspice PRIVATE pthread)
    endif()
    
    if(HAVE_LIBSTDCXX)
        target_link_libraries(ngspice PRIVATE stdc++)
    endif()
    
    if(HAVE_LIBDL)
        target_link_libraries(ngspice PRIVATE dl)
    endif()
    
    # Install executable
    install(TARGETS ngspice
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Runtime
    )
    
    # Export target
    install(TARGETS ngspice
        EXPORT ngspice-targets
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Runtime
    )
endif()

# Shared library target
if(NGSPICE_ENABLE_SHARED)
    add_library(ngspice_shared SHARED
        ${NGSPICE_COMMON_SOURCES}
        sharedspice.c
    )
    
    set_target_properties(ngspice_shared PROPERTIES
        OUTPUT_NAME ngspice
        VERSION ${LIBNGSPICE_SO_VERSION}
        SOVERSION ${LT_NGSPICE_CURRENT}
    )
    
    target_compile_definitions(ngspice_shared PRIVATE
        SIMULATOR
        SHAREDSPICE_version="${PROJECT_VERSION}"
    )
    
    target_link_libraries(ngspice_shared PRIVATE
        ${NGSPICE_CORE_LIBRARIES}
        ${NGSPICE_DEVICE_LIBRARIES}
    )
    
    # Platform-specific linking for shared library
    if(NGSPICE_PLATFORM_WINDOWS)
        target_link_libraries(ngspice_shared PRIVATE psapi shlwapi)
        if(MINGW)
            target_link_options(ngspice_shared PRIVATE
                -Wl,--output-def=ngspice.def
                -Wl,--out-implib=ngspice.dll.a
                -Wl,--no-undefined
            )
        endif()
    endif()
    
    # External libraries
    if(NGSPICE_ENABLE_X11)
        target_link_libraries(ngspice_shared PRIVATE ${X11_LIBRARIES})
    endif()
    
    if(FFTW3_FOUND)
        target_link_libraries(ngspice_shared PRIVATE ${FFTW3_LIBRARIES})
    endif()
    
    if(NGSPICE_ENABLE_OPENMP)
        target_link_libraries(ngspice_shared PRIVATE OpenMP::OpenMP_C)
    endif()
    
    if(HAVE_LIBM)
        target_link_libraries(ngspice_shared PRIVATE m)
    endif()
    
    if(HAVE_LIBPTHREAD)
        target_link_libraries(ngspice_shared PRIVATE pthread)
    endif()
    
    if(HAVE_LIBSTDCXX)
        target_link_libraries(ngspice_shared PRIVATE stdc++)
    endif()
    
    if(HAVE_LIBDL)
        target_link_libraries(ngspice_shared PRIVATE dl)
    endif()
    
    # Install shared library
    install(TARGETS ngspice_shared
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Runtime
    )
    
    # Export target
    install(TARGETS ngspice_shared
        EXPORT ngspice-targets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Runtime
    )
endif()

# TCL module target
if(NGSPICE_ENABLE_TCL)
    add_library(ngspice_tcl SHARED
        main.c
        ${NGSPICE_COMMON_SOURCES}
        tclspice.c
    )
    
    set_target_properties(ngspice_tcl PROPERTIES
        OUTPUT_NAME spice
        PREFIX lib
    )
    
    target_compile_definitions(ngspice_tcl PRIVATE
        SIMULATOR
        TCLSPICE_version="${PROJECT_VERSION}"
    )
    
    target_link_libraries(ngspice_tcl PRIVATE
        ${NGSPICE_CORE_LIBRARIES}
        ${NGSPICE_DEVICE_LIBRARIES}
        ${TCL_LIBRARY}
    )
    
    # Platform-specific linking for TCL
    if(NGSPICE_PLATFORM_WINDOWS)
        target_link_libraries(ngspice_tcl PRIVATE psapi shlwapi)
        target_link_options(ngspice_tcl PRIVATE -Wl,--no-undefined)
    endif()
    
    # External libraries
    if(NGSPICE_ENABLE_X11)
        target_link_libraries(ngspice_tcl PRIVATE ${X11_LIBRARIES})
    endif()
    
    if(FFTW3_FOUND)
        target_link_libraries(ngspice_tcl PRIVATE ${FFTW3_LIBRARIES})
    endif()
    
    if(NGSPICE_ENABLE_OPENMP)
        target_link_libraries(ngspice_tcl PRIVATE OpenMP::OpenMP_C)
    endif()
    
    if(HAVE_LIBM)
        target_link_libraries(ngspice_tcl PRIVATE m)
    endif()
    
    if(HAVE_LIBPTHREAD)
        target_link_libraries(ngspice_tcl PRIVATE pthread)
    endif()
    
    if(HAVE_LIBSTDCXX)
        target_link_libraries(ngspice_tcl PRIVATE stdc++)
    endif()
    
    if(HAVE_LIBDL)
        target_link_libraries(ngspice_tcl PRIVATE dl)
    endif()
    
    # Install TCL module
    install(TARGETS ngspice_tcl
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT Runtime
    )
endif()

# Old applications
if(NGSPICE_ENABLE_OLDAPPS AND NOT NGSPICE_ENABLE_WINGUI)
    # ngnutmeg
    add_executable(ngnutmeg
        main.c
        conf.c
        conf.h
        ngnutmeg.c
    )
    
    target_link_libraries(ngnutmeg PRIVATE
        ngspice_frontend
        ngspice_frontend_plotting
        ngspice_frontend_parser
        ngspice_frontend_numparam
        ngspice_frontend_trannoise
        ngspice_maths_cmaths
        ngspice_maths_misc
        ngspice_maths_fft
        ngspice_maths_poly
        ngspice_misc
        ngspice_spicelib_parser
    )
    
    if(NGSPICE_ENABLE_X11)
        target_link_libraries(ngnutmeg PRIVATE
            ngspice_frontend_help
            ${X11_LIBRARIES}
        )
    endif()
    
    # ngsconvert
    add_executable(ngsconvert ngsconvert.c)
    target_link_libraries(ngsconvert PRIVATE
        ngspice_frontend
        ngspice_frontend_parser
        ngspice_misc
    )
    
    # ngproc2mod
    add_executable(ngproc2mod ngproc2mod.c)
    target_link_libraries(ngproc2mod PRIVATE
        ngspice_frontend
        ngspice_frontend_parser
        ngspice_spicelib_parser
        ngspice_misc
    )
    
    # ngmultidec
    add_executable(ngmultidec ngmultidec.c)
    target_link_libraries(ngmultidec PRIVATE
        ngspice_frontend
        ngspice_frontend_parser
        ngspice_maths_sparse
        ngspice_misc
    )
    
    if(NGSPICE_ENABLE_KLU)
        target_link_libraries(ngmultidec PRIVATE ngspice_maths_klu)
    endif()
    
    # ngmakeidx
    add_executable(ngmakeidx makeidx.c)
    target_link_libraries(ngmakeidx PRIVATE
        ngspice_frontend
        ngspice_frontend_parser
        ngspice_misc
    )
    
    # nghelp
    if(NGSPICE_ENABLE_X11)
        add_executable(nghelp conf.c nghelp.c)
        target_link_libraries(nghelp PRIVATE
            ngspice_frontend_help
            ngspice_misc
        )
    endif()
    
    # Install old applications
    install(TARGETS ngnutmeg ngsconvert ngproc2mod ngmultidec ngmakeidx
        RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
        COMPONENT Runtime
    )
    
    if(NGSPICE_ENABLE_X11)
        install(TARGETS nghelp
            RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
            COMPONENT Runtime
        )
    endif()
endif()

# Install data files
install(FILES
    ${CMAKE_CURRENT_BINARY_DIR}/spinit
    setplot
    spectrum
    DESTINATION ${CMAKE_INSTALL_DATADIR}/ngspice/scripts
    COMPONENT Runtime
)

if(NGSPICE_ENABLE_CIDER)
    install(FILES
        devload
        devaxis
        ciderinit
        DESTINATION ${CMAKE_INSTALL_DATADIR}/ngspice/scripts
        COMPONENT Runtime
    )
endif()

if(NGSPICE_ENABLE_TCL)
    install(FILES
        ${CMAKE_CURRENT_BINARY_DIR}/tclspinit
        DESTINATION ${CMAKE_INSTALL_DATADIR}/ngspice/scripts
        COMPONENT Runtime
    )
endif()

if(NGSPICE_ENABLE_OLDAPPS)
    install(FILES
        ngspice.txt
        DESTINATION ${CMAKE_INSTALL_DATADIR}/ngspice/helpdir
        COMPONENT Runtime
    )
endif()