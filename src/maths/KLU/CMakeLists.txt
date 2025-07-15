# src/maths/KLU/CMakeLists.txt - KLU sparse linear solver

set(KLU_SOURCES
    # AMD ordering
    amd_1.c
    amd_2.c
    amd_aat.c
    amd_control.c
    amd_defaults.c
    amd_dump.c
    amd_global.c
    amd_info.c
    amd_internal.h
    amd_order.c
    amd_post_tree.c
    amd_postorder.c
    amd_preprocess.c
    amd_valid.c
    
    # BTF block triangular form
    btf_internal.h
    btf_maxtrans.c
    btf_order.c
    btf_strongcomp.c
    
    # COLAMD column ordering
    colamd.c
    colamd_global.c
    
    # KLU core
    klu.c
    klu_analyze.c
    klu_analyze_given.c
    klu_defaults.c
    klu_diagnostics.c
    klu_dump.c
    klu_extract.c
    klu_factor.c
    klu_free_numeric.c
    klu_free_symbolic.c
    klu_internal.h
    klu_kernel.c
    klu_memory.c
    klu_multiply.c
    klu_refactor.c
    klu_scale.c
    klu_solve.c
    klu_sort.c
    klu_tsolve.c
    klu_utils.c
    klu_version.h
    klusmp.c
)

add_library(ngspice_maths_klu STATIC ${KLU_SOURCES})

target_include_directories(ngspice_maths_klu PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link math library
if(HAVE_LIBM)
    target_link_libraries(ngspice_maths_klu PUBLIC m)
endif()

# Export target
install(TARGETS ngspice_maths_klu
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)