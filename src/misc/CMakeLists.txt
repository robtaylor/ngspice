# src/misc/CMakeLists.txt - Miscellaneous utilities library

set(MISC_SOURCES
    alloc.c
    alloc.h
    dstring.c
    hash.c
    ivars.c
    ivars.h
    misc_time.c
    misc_time.h
    printnum.c
    printnum.h
    string.c
    tilde.c
    tilde.h
    util.c
    util.h
    wlist.c
)

# Platform-specific sources
if(NGSPICE_PLATFORM_WINDOWS)
    list(APPEND MISC_SOURCES
        dup2.c
        dup2.h
        getopt_long_bsd.c
        getopt_bsd.h
        mktemp.c
        mktemp.h
    )
endif()

add_library(ngspice_misc STATIC ${MISC_SOURCES})

target_include_directories(ngspice_misc PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Export target
install(TARGETS ngspice_misc
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)