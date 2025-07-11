# src/include/ngspice/CMakeLists.txt - NgSpice header files

# Install all header files
file(GLOB NGSPICE_HEADERS "*.h")

install(FILES ${NGSPICE_HEADERS}
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice
    COMPONENT Development
)

# Install the generated config.h
install(FILES ${CMAKE_CURRENT_BINARY_DIR}/config.h
    DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ngspice
    COMPONENT Development
)