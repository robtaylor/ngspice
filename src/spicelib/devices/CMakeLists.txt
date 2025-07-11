# src/spicelib/devices/CMakeLists.txt - Device models library

# Create device support library
set(DEVICE_SOURCES
    dev.c
    dev.h
    devsup.c
    cktaccept.c
    cktaccept.h
    cktask.c
    cktbindnode.c
    cktcrte.c
    cktfinddev.c
    cktinit.c
    cktsoachk.c
    limit.c
)

add_library(ngspice_spicelib_devices STATIC ${DEVICE_SOURCES})

target_include_directories(ngspice_spicelib_devices PUBLIC
    $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
    $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
)

# Link dependencies
target_link_libraries(ngspice_spicelib_devices PUBLIC
    ngspice_misc
)

# Export target
install(TARGETS ngspice_spicelib_devices
    EXPORT ngspice-targets
    ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
    COMPONENT Development
)

# Create all device libraries using helper function
ngspice_add_device_library(asrc)
ngspice_add_device_library(bjt)
ngspice_add_device_library(bsim1)
ngspice_add_device_library(bsim2)
ngspice_add_device_library(bsim3)
ngspice_add_device_library(bsim3v0)
ngspice_add_device_library(bsim3v1)
ngspice_add_device_library(bsim3v32)
ngspice_add_device_library(bsim4)
ngspice_add_device_library(bsim4v5)
ngspice_add_device_library(bsim4v6)
ngspice_add_device_library(bsim4v7)
ngspice_add_device_library(bsim3soi_pd)
ngspice_add_device_library(bsim3soi_fd)
ngspice_add_device_library(bsim3soi_dd)
ngspice_add_device_library(bsimsoi)
ngspice_add_device_library(cap)
ngspice_add_device_library(cccs)
ngspice_add_device_library(ccvs)
ngspice_add_device_library(cpl)
ngspice_add_device_library(csw)
ngspice_add_device_library(dio)
ngspice_add_device_library(ind)
ngspice_add_device_library(isrc)
ngspice_add_device_library(hfet1)
ngspice_add_device_library(hfet2)
ngspice_add_device_library(hicum2)
ngspice_add_device_library(hisim2)
ngspice_add_device_library(hisimhv1)
ngspice_add_device_library(hisimhv2)
ngspice_add_device_library(jfet)
ngspice_add_device_library(jfet2)
ngspice_add_device_library(ltra)
ngspice_add_device_library(mes)
ngspice_add_device_library(mesa)
ngspice_add_device_library(mos1)
ngspice_add_device_library(mos2)
ngspice_add_device_library(mos3)
ngspice_add_device_library(mos6)
ngspice_add_device_library(mos9)
ngspice_add_device_library(res)
ngspice_add_device_library(soi3)
ngspice_add_device_library(sw)
ngspice_add_device_library(tra)
ngspice_add_device_library(txl)
ngspice_add_device_library(urc)
ngspice_add_device_library(vbic)
ngspice_add_device_library(vccs)
ngspice_add_device_library(vcvs)
ngspice_add_device_library(vdmos)
ngspice_add_device_library(vsrc)

# Optional device libraries
ngspice_add_device_library(ndev CONDITION NGSPICE_ENABLE_NDEV)

# Numerical devices (require CIDER)
ngspice_add_device_library(nbjt CONDITION NGSPICE_ENABLE_CIDER)
ngspice_add_device_library(nbjt2 CONDITION NGSPICE_ENABLE_CIDER)
ngspice_add_device_library(numd CONDITION NGSPICE_ENABLE_CIDER)
ngspice_add_device_library(numd2 CONDITION NGSPICE_ENABLE_CIDER)
ngspice_add_device_library(numos CONDITION NGSPICE_ENABLE_CIDER)

# Create a convenience library that includes all device libraries
add_library(ngspice_all_devices INTERFACE)

# Get all device libraries
get_property(ALL_DEVICE_LIBRARIES GLOBAL PROPERTY NGSPICE_DEVICE_LIBRARIES)

# Link all device libraries
target_link_libraries(ngspice_all_devices INTERFACE
    ngspice_spicelib_devices
    ${ALL_DEVICE_LIBRARIES}
)

# Export target
install(TARGETS ngspice_all_devices
    EXPORT ngspice-targets
    COMPONENT Development
)