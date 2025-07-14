# src/spicelib/parser/CMakeLists.txt - SPICE parser library

set(PARSER_SOURCES
    ifeval.c
    ifnewuid.c
    inp2b.c
    inp2c.c
    inp2d.c
    inp2dot.c
    inp2e.c
    inp2f.c
    inp2g.c
    inp2h.c
    inp2i.c
    inp2j.c
    inp2k.c
    inp2l.c
    inp2m.c
    inp2n.c
    inp2o.c
    inp2p.c
    inp2q.c
    inp2r.c
    inp2s.c
    inp2t.c
    inp2u.c
    inp2v.c
    inp2w.c
    inp2y.c
    inp2z.c
    inpaname.c
    inpapnam.c
    inpcfix.c
    inpdomod.c
    inpdoopt.c
    inpdpar.c
    inperrc.c
    inperror.c
    inpeval.c
    inpfindl.c
    inpfindv.c
    inpgmod.c
    inpgstr.c
    inpgtitl.c
    inpgtok.c
    inpgval.c
    inpkmods.c
    inplist.c
    inplkmod.c
    inpmkmod.c
    inpmktmp.c
    inppas1.c
    inppas1.h
    inppas2.c
    inppas2.h
    inppas3.c
    inppas3.h
    inppas4.c
    inppas4.h
    inppname.c
    inpptree.c
    inpptree-parser-y.h
    inpsymt.c
    inptyplk.c
    inpxx.h
    ptfuncs.c
    sperror.c
)

add_library(ngspice_spicelib_parser STATIC ${PARSER_SOURCES})

target_include_directories(ngspice_spicelib_parser PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/frontend>
    $<BUILD_INTERFACE:${CMAKE_SOURCE_DIR}/src/include>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Generate parser from bison grammar
bison_target(InpPtreeParser
    inpptree-parser.y
    ${CMAKE_CURRENT_BINARY_DIR}/inpptree-parser.c
    DEFINES_FILE ${CMAKE_CURRENT_BINARY_DIR}/inpptree-parser.h
)

# Add generated parser to sources
target_sources(ngspice_spicelib_parser PRIVATE
    ${BISON_InpPtreeParser_OUTPUTS}
)

# Include generated headers
target_include_directories(ngspice_spicelib_parser PRIVATE
    ${CMAKE_CURRENT_BINARY_DIR}
)

# Link dependencies
target_link_libraries(ngspice_spicelib_parser PUBLIC
    ngspice_misc
)

# Export target
install(TARGETS ngspice_spicelib_parser
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)