# src/spicelib/CMakeLists.txt - SPICE library

# Include device library helper functions
include(NgspiceDeviceLibrary)

# Add subdirectories
add_subdirectory(analysis)
add_subdirectory(parser)
add_subdirectory(devices)

# Create a convenience library that includes all spicelib components
add_library(ngspice_spicelib INTERFACE)

target_link_libraries(ngspice_spicelib INTERFACE
    ngspice_spicelib_analysis
    ngspice_spicelib_parser
    ngspice_spicelib_devices
)

# Export target
install(TARGETS ngspice_spicelib
    EXPORT ngspice-targets
    COMPONENT Development
)