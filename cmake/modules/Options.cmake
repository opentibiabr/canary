option(TOGGLE_BIN_FOLDER "Use build/bin folder for generate compilation files" ON)
option(OPTIONS_ENABLE_OPENMP "Enable Open Multi-Processing support." ON)
option(DEBUG_LOG "Enable Debug Log" OFF)
option(ASAN_ENABLED "Build this target with AddressSanitizer" OFF)
option(BUILD_STATIC_LIBRARY "Build using static libraries" OFF)
option(SPEED_UP_BUILD_UNITY "Compile using build unity for speed up build" ON)

# *****************************************************************************
# Build flags
# *****************************************************************************
if (CMAKE_COMPILER_IS_GNUCXX)
    target_compile_options(${PROJECT_NAME}_lib PRIVATE -Wno-deprecated-declarations)
endif()

# === IPO ===
check_ipo_supported(RESULT result OUTPUT output)
if(result)
    set_property(TARGET ${PROJECT_NAME}_lib PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
else()
    message(WARNING "IPO is not supported: ${output}")
endif()

# === UNITY BUILD (compile time reducer) ===
if(SPEED_UP_BUILD_UNITY)
    set_target_properties(${PROJECT_NAME}_lib PROPERTIES UNITY_BUILD ON)
    log_option_enabled("Build unity for speed up compilation")
endif()

# === ASAN ===
if(ASAN_ENABLED)
    log_option_enabled("asan")
    if(MSVC)
        add_compile_options(/fsanitize=address)
    else()
        add_compile_options(-fsanitize=address)
        link_libraries(-fsanitize=address)
    endif()
else()
    log_option_disabled("asan")
endif()

# Build static libs
if(BUILD_STATIC_LIBRARY)
    log_option_enabled("STATIC_LIBRARY")

    if(MSVC)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".lib")
    elseif(UNIX AND NOT APPLE)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".a")
    elseif(APPLE)
        set(CMAKE_FIND_LIBRARY_SUFFIXES ".a" ".dylib")
    endif()
else()
    log_option_disabled("STATIC_LIBRARY")
endif()

# === DEBUG LOG ===
# cmake -DDEBUG_LOG=ON ..
if(DEBUG_LOG)
    add_definitions(-DDEBUG_LOG=ON)
    log_option_enabled("DEBUG LOG")
else()
    log_option_disabled("DEBUG LOG")
endif(DEBUG_LOG)

# *****************************************************************************
# Build Type
# *****************************************************************************
if (MSVC)
    if(CMAKE_BUILD_TYPE STREQUAL "Debug")
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_DEBUG "${CMAKE_CXX_FLAGS_DEBUG}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_DEBUG "${CMAKE_C_FLAGS_DEBUG}")
    elseif(CMAKE_BUILD_TYPE STREQUAL "Release")
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELEASE "${CMAKE_CXX_FLAGS_RELEASE}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_RELEASE "${CMAKE_C_FLAGS_RELEASE}")
    elseif(CMAKE_BUILD_TYPE STREQUAL "RelWithDebInfo")
        string(REPLACE "/Zi" "/Z7" CMAKE_CXX_FLAGS_RELWITHDEBINFO "${CMAKE_CXX_FLAGS_RELWITHDEBINFO}")
        string(REPLACE "/Zi" "/Z7" CMAKE_C_FLAGS_RELWITHDEBINFO "${CMAKE_C_FLAGS_RELWITHDEBINFO}")
    endif()

    add_compile_options(/MP /FS /Zf /EHsc)
endif (MSVC)

## Link compilation files to build/bin folder, else link to the main dir
function(set_output_directory target_name)
    if (TOGGLE_BIN_FOLDER)
        set_target_properties(${target_name}
                PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
                )
    else()
        set_target_properties(${target_name}
                PROPERTIES
                RUNTIME_OUTPUT_DIRECTORY "${CMAKE_SOURCE_DIR}/"
                )
    endif()
endfunction()

## Setup shared target basic configurations
function(setup_target TARGET_NAME)
    set_output_directory(${TARGET_NAME})

    if (MSVC AND BUILD_STATIC_LIBRARY)
        set_property(TARGET ${TARGET_NAME} PROPERTY MSVC_RUNTIME_LIBRARY "MultiThreaded$<$<CONFIG:Debug>:Debug>")
    endif()
endfunction()

# *****************************************************************************
# DEBUG: Print cmake variables
# *****************************************************************************
#get_cmake_property(_variableNames VARIABLES)
#list (SORT _variableNames)
#foreach (_variableName ${_variableNames})
#	message(STATUS "${_variableName}=${${_variableName}}")
#endforeach()