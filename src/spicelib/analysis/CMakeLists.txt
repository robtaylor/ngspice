# src/spicelib/analysis/CMakeLists.txt - Analysis library

set(ANALYSIS_SOURCES
    acan.c
    acaskq.c
    acsetp.c
    analysis.c
    analysis.h
    cktacct.c
    cktacdum.c
    cktaskaq.c
    cktasknq.c
    cktbkdum.c
    cktclrbk.c
    cktdelt.c
    cktdest.c
    cktdisto.c
    cktdlti.c
    cktdltm.c
    cktdltn.c
    cktdojob.c
    cktdump.c
    cktfbran.c
    cktfnda.c
    cktfndm.c
    cktfnode.c
    cktftask.c
    cktgrnd.c
    ckti2nod.c
    cktic.c
    cktlnkeq.c
    cktload.c
    cktmapn.c
    cktmask.c
    cktmcrt.c
    cktmkcur.c
    cktmknod.c
    cktmkvol.c
    cktmpar.c
    cktnames.c
    cktncdump.c
    cktnewan.c
    cktneweq.c
    cktnewn.c
    cktnodn.c
    cktnoise.c
    cktntask.c
    cktnum2n.c
    cktop.c
    cktparam.c
    cktpmnam.c
    cktpname.c
    cktpzld.c
    cktpzset.c
    cktpzstr.c
    cktsens.c
    cktsetap.c
    cktsetbk.c
    cktsetnp.c
    cktsetup.c
    cktsgen.c
    cktsopt.c
    cktspdum.c
    cktspnoise.c
    ckttemp.c
    cktterr.c
    ckttroub.c
    ckttrunc.c
    ckttyplk.c
    daskq.c
    dcoaskq.c
    dcop.c
    dcosetp.c
    dctaskq.c
    dctran.c
    dctrcurv.c
    dctsetp.c
    distoan.c
    dkerproc.c
    dloadfns.c
    dsetparm.c
    naskq.c
    nevalsrc.c
    ninteg.c
    noisean.c
    noisesp.c
    nsetparm.c
    pzan.c
    pzaskq.c
    pzsetp.c
    sensaskq.c
    senssetp.c
    span.c
    spaskq.c
    spsetp.c
    tfanal.c
    tfaskq.c
    tfsetp.c
    tranaskq.c
    traninit.c
    transetp.c
)

# Optional sources
if(NGSPICE_ENABLE_CLUSTER)
    list(APPEND ANALYSIS_SOURCES cluster.c)
endif()

if(NGSPICE_ENABLE_PSS)
    list(APPEND ANALYSIS_SOURCES
        pssaskq.c
        pssinit.c
        psssetp.c
        dcpss.c
    )
endif()

# OPTRAN support
list(APPEND ANALYSIS_SOURCES
    optran.c
    com_optran.h
)

add_library(ngspice_spicelib_analysis STATIC ${ANALYSIS_SOURCES})

target_include_directories(ngspice_spicelib_analysis PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_spicelib_analysis PUBLIC
    ngspice_misc
    ngspice_maths_sparse
)

if(NGSPICE_ENABLE_KLU)
    target_link_libraries(ngspice_spicelib_analysis PUBLIC ngspice_maths_klu)
endif()

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_spicelib_analysis PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_spicelib_analysis
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)