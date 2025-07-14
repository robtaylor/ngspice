# tests/bsim3/CMakeLists.txt - BSIM3 device model tests

# Test BSIM3 NMOS basic functionality
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/bsim3_nmos_test.cir")
    add_test(
        NAME bsim3_nmos
        COMMAND $<TARGET_FILE:ngspice> -b ${CMAKE_CURRENT_SOURCE_DIR}/bsim3_nmos_test.cir
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    set_tests_properties(bsim3_nmos PROPERTIES 
        LABELS "short;device;bsim3"
        TIMEOUT 30
        FAIL_REGULAR_EXPRESSION "Error;error;ERROR;failed;Failed;FAILED"
    )
endif()

# Test BSIM3 PMOS basic functionality  
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/bsim3_pmos_test.cir")
    add_test(
        NAME bsim3_pmos
        COMMAND $<TARGET_FILE:ngspice> -b ${CMAKE_CURRENT_SOURCE_DIR}/bsim3_pmos_test.cir
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    set_tests_properties(bsim3_pmos PROPERTIES 
        LABELS "short;device;bsim3"
        TIMEOUT 30
        FAIL_REGULAR_EXPRESSION "Error;error;ERROR;failed;Failed;FAILED"
    )
endif()

# Test BSIM3 DC sweep
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/bsim3_dc_sweep.cir")
    add_test(
        NAME bsim3_dc_sweep
        COMMAND $<TARGET_FILE:ngspice> -b ${CMAKE_CURRENT_SOURCE_DIR}/bsim3_dc_sweep.cir
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    set_tests_properties(bsim3_dc_sweep PROPERTIES 
        LABELS "device;bsim3;sweep"
        TIMEOUT 60
        FAIL_REGULAR_EXPRESSION "Error;error;ERROR;failed;Failed;FAILED"
    )
endif()