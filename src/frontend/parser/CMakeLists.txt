# src/frontend/parser/CMakeLists.txt - Frontend parser library

set(PARSER_SOURCES
    backq.c
    complete.c
    cshpar.c
    glob.c
    input.c
    lexical.c
    numparse.c
    std.c
    unixcom.c
)

set(PARSER_HEADERS
    backq.h
    complete.h
    cshpar.h
    glob.h
    input.h
    lexical.h
    numparse.h
    unixcom.h
)

add_library(ngspice_frontend_parser STATIC 
    ${PARSER_SOURCES}
    ${PARSER_HEADERS}
)

target_include_directories(ngspice_frontend_parser PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_frontend_parser PUBLIC
    ngspice_misc
)

# Export target
install(TARGETS ngspice_frontend_parser
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# Install headers
install(FILES ${PARSER_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice/frontend/parser
    COMPONENT Development
)