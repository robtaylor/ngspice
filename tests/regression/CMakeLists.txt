# tests/regression/CMakeLists.txt - Regression tests

# Basic regression test to verify ngspice can run
add_test(
    NAME basic_startup
    COMMAND $<TARGET_FILE:ngspice> --version
)

set_tests_properties(basic_startup PROPERTIES
    LABELS "regression;basic"
    TIMEOUT 10
)

# Test that ngspice can parse basic circuit
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/basic_circuit.cir")
    add_test(
        NAME basic_circuit
        COMMAND $<TARGET_FILE:ngspice> -b ${CMAKE_CURRENT_SOURCE_DIR}/basic_circuit.cir
        WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
    )
    
    set_tests_properties(basic_circuit PROPERTIES
        LABELS "regression;circuit"
        TIMEOUT 60
        FAIL_REGULAR_EXPRESSION "Error;error;ERROR;failed;Failed;FAILED"
    )
endif()

# Test help system
add_test(
    NAME help_system
    COMMAND $<TARGET_FILE:ngspice> -c "help" -c "quit"
)

set_tests_properties(help_system PROPERTIES
    LABELS "regression;basic"
    TIMEOUT 10
)