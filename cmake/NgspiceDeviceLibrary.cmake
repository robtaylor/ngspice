# NgspiceDeviceLibrary.cmake - Helper function to create device libraries

# Function to create a device library
function(ngspice_add_device_library device_name)
    # Parse additional arguments
    set(options OPTIONAL)
    set(oneValueArgs CONDITION)
    set(multiValueArgs SOURCES DEPENDS)
    cmake_parse_arguments(DEVICE "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Check condition if provided
    if(DEVICE_CONDITION AND NOT ${DEVICE_CONDITION})
        return()
    endif()
    
    # Find all C source files in the device directory
    file(GLOB DEVICE_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/${device_name}/*.c")
    file(GLOB DEVICE_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/${device_name}/*.h")
    
    # Add any additional sources
    if(DEVICE_SOURCES)
        list(APPEND DEVICE_SOURCES ${DEVICE_SOURCES})
    endif()
    
    # Create the library
    add_library(spicelib_dev_${device_name} STATIC ${DEVICE_SOURCES} ${DEVICE_HEADERS})
    
    # Set include directories
    target_include_directories(spicelib_dev_${device_name} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${device_name}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    
    # Add dependencies
    if(DEVICE_DEPENDS)
        target_link_libraries(spicelib_dev_${device_name} PUBLIC ${DEVICE_DEPENDS})
    endif()
    
    # Link math library
    if(HAVE_LIBM)
        target_link_libraries(spicelib_dev_${device_name} PUBLIC m)
    endif()
    
    # Export target
    install(TARGETS spicelib_dev_${device_name}
        EXPORT ngspice-targets
        ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
        COMPONENT Development
    )
    
    # Add to global list
    set_property(GLOBAL APPEND PROPERTY NGSPICE_DEVICE_LIBRARIES spicelib_dev_${device_name})
endfunction()

# Function to create XSPICE code model library
function(ngspice_add_xspice_model model_name)
    # Parse additional arguments
    set(options OPTIONAL)
    set(oneValueArgs CONDITION)
    set(multiValueArgs SOURCES DEPENDS)
    cmake_parse_arguments(MODEL "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    # Check condition if provided
    if(MODEL_CONDITION AND NOT ${MODEL_CONDITION})
        return()
    endif()
    
    # Find all C source files in the model directory
    file(GLOB MODEL_SOURCES "${CMAKE_CURRENT_SOURCE_DIR}/${model_name}/*.c")
    file(GLOB MODEL_HEADERS "${CMAKE_CURRENT_SOURCE_DIR}/${model_name}/*.h")
    
    # Add any additional sources
    if(MODEL_SOURCES)
        list(APPEND MODEL_SOURCES ${MODEL_SOURCES})
    endif()
    
    # Create the shared library for dynamic loading
    add_library(${model_name} SHARED ${MODEL_SOURCES} ${MODEL_HEADERS})
    
    # Set properties for code model
    set_target_properties(${model_name} PROPERTIES
        PREFIX ""
        SUFFIX ".cm"
        LIBRARY_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/ngspice"
    )
    
    # Set include directories
    target_include_directories(${model_name} PUBLIC
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}/${model_name}>
        $<BUILD_INTERFACE:${CMAKE_CURRENT_SOURCE_DIR}>
        $<INSTALL_INTERFACE:${CMAKE_INSTALL_INCLUDEDIR}>
    )
    
    # Add dependencies
    if(MODEL_DEPENDS)
        target_link_libraries(${model_name} PUBLIC ${MODEL_DEPENDS})
    endif()
    
    # Link math library
    if(HAVE_LIBM)
        target_link_libraries(${model_name} PUBLIC m)
    endif()
    
    # Export target
    install(TARGETS ${model_name}
        EXPORT ngspice-targets
        LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}/ngspice
        COMPONENT Runtime
    )
    
    # Add to global list
    set_property(GLOBAL APPEND PROPERTY NGSPICE_XSPICE_MODELS ${model_name})
endfunction()

# Function to process .ifs files with cmpp
function(ngspice_process_ifs_files)
    # Parse additional arguments
    set(options)
    set(oneValueArgs TARGET)
    set(multiValueArgs FILES)
    cmake_parse_arguments(IFS "${options}" "${oneValueArgs}" "${multiValueArgs}" ${ARGN})
    
    if(NOT IFS_TARGET)
        message(FATAL_ERROR "TARGET is required for ngspice_process_ifs_files")
    endif()
    
    if(NOT IFS_FILES)
        message(FATAL_ERROR "FILES is required for ngspice_process_ifs_files")
    endif()
    
    # Find cmpp executable
    find_program(CMPP_EXECUTABLE
        NAMES cmpp
        PATHS ${CMAKE_BINARY_DIR}/src/xspice/cmpp
        NO_DEFAULT_PATH
    )
    
    if(NOT CMPP_EXECUTABLE)
        message(FATAL_ERROR "cmpp executable not found")
    endif()
    
    # Process each .ifs file
    foreach(ifs_file ${IFS_FILES})
        get_filename_component(ifs_name ${ifs_file} NAME_WE)
        set(output_file "${CMAKE_CURRENT_BINARY_DIR}/${ifs_name}.c")
        
        add_custom_command(
            OUTPUT ${output_file}
            COMMAND ${CMPP_EXECUTABLE} -ifs ${ifs_file} -o ${output_file}
            DEPENDS ${ifs_file} ${CMPP_EXECUTABLE}
            WORKING_DIRECTORY ${CMAKE_CURRENT_SOURCE_DIR}
            COMMENT "Processing ${ifs_file} with cmpp"
        )
        
        # Add to target sources
        target_sources(${IFS_TARGET} PRIVATE ${output_file})
    endforeach()
endfunction()