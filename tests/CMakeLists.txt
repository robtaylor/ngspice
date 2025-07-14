# tests/CMakeLists.txt - Test configuration for ngspice

# Enable testing
enable_testing()

# Define test categories based on the original autotools structure
set(REGRESSION_TESTS regression)

set(XSPICE_TESTS)
if(NGSPICE_ENABLE_XSPICE)
    list(APPEND XSPICE_TESTS xspice)
endif()

# Short check tests (for CI)
set(SHORT_CHECK_TESTS
    bsim3
    bsim4
)

# Full test suite
set(FULL_TESTS
    bsim3
    bsim4
    bsimsoi
    hisim
    hicum2
    hisimhv1
    hisimhv2
)

# All available test directories
set(ALL_TEST_DIRS
    bsim1
    bsim2
    bsim3
    bsim3soidd
    bsim3soifd
    bsim3soipd
    bsim4
    bsimsoi
    filters
    general
    hfet
    hicum2
    hisim
    hisimhv1
    hisimhv2
    jfet
    mes
    mesa
    mos6
    polezero
    regression
    resistance
    sensitivity
    transient
    transmission
    vbic
    xspice
)

# Choose which tests to run based on configuration
if(NGSPICE_ENABLE_SHORT_CHECK)
    set(ACTIVE_TESTS ${REGRESSION_TESTS} ${XSPICE_TESTS} ${SHORT_CHECK_TESTS})
else()
    # For now, only include tests that we have implemented
    set(ACTIVE_TESTS ${REGRESSION_TESTS} ${XSPICE_TESTS} bsim3)
endif()

# Function to add a test directory
function(add_ngspice_test_dir test_dir)
    if(IS_DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/${test_dir}")
        add_subdirectory(${test_dir})
    else()
        message(STATUS "Test directory ${test_dir} not found, skipping")
    endif()
endfunction()

# Add regression tests (always included)
add_ngspice_test_dir(regression)

# Add XSPICE tests if enabled
if(NGSPICE_ENABLE_XSPICE)
    add_ngspice_test_dir(xspice)
endif()

# Add device model tests
foreach(test_dir IN LISTS ACTIVE_TESTS)
    if(NOT test_dir STREQUAL "regression" AND NOT test_dir STREQUAL "xspice")
        add_ngspice_test_dir(${test_dir})
    endif()
endforeach()

# Create a custom target to run all tests
add_custom_target(check
    COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure
    DEPENDS ngspice
    COMMENT "Running all ngspice tests"
)

# Create individual test targets
add_custom_target(check-short
    COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -L "short"
    DEPENDS ngspice
    COMMENT "Running short test suite"
)

add_custom_target(check-full
    COMMAND ${CMAKE_CTEST_COMMAND} --output-on-failure -L "full"
    DEPENDS ngspice
    COMMENT "Running full test suite"
)

# Helper function to add SPICE circuit tests
function(add_spice_test test_name circuit_file)
    if(TARGET ngspice)
        add_test(
            NAME ${test_name}
            COMMAND $<TARGET_FILE:ngspice> -b ${circuit_file}
            WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
        )
        
        # Set test properties
        set_tests_properties(${test_name} PROPERTIES
            TIMEOUT 60
            FAIL_REGULAR_EXPRESSION "Error;error;ERROR;failed;Failed;FAILED"
        )
        
        # Add labels for test categorization
        if(${test_name} MATCHES "bsim[34]")
            set_tests_properties(${test_name} PROPERTIES LABELS "short;device")
        else()
            set_tests_properties(${test_name} PROPERTIES LABELS "full;device")
        endif()
    endif()
endfunction()

# Print test configuration summary
message(STATUS "NgSpice Test Configuration:")
message(STATUS "  Short check mode: ${NGSPICE_ENABLE_SHORT_CHECK}")
message(STATUS "  XSPICE tests: ${NGSPICE_ENABLE_XSPICE}")
message(STATUS "  Active test directories: ${ACTIVE_TESTS}")

# Install test files if requested
if(NGSPICE_INSTALL_TESTS)
    install(DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}/
        DESTINATION ${CMAKE_INSTALL_DATADIR}/ngspice/tests
        COMPONENT Tests
        PATTERN "CMakeLists.txt" EXCLUDE
        PATTERN ".git*" EXCLUDE
    )
endif()