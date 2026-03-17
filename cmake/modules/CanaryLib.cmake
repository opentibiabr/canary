# NOTE: Target creation is now handled in src/CMakeLists.txt This file applies
# configuration to targets in CANARY_CORE_TARGETS

# Add subdirectories - these use ${CORE_TARGET_NAME} to add sources
add_subdirectory(account)
add_subdirectory(config)
add_subdirectory(creatures)
add_subdirectory(database)
add_subdirectory(game)
add_subdirectory(io)
add_subdirectory(items)
add_subdirectory(lib)
add_subdirectory(kv)
add_subdirectory(lua)
add_subdirectory(map)
add_subdirectory(protobuf)
add_subdirectory(security)
add_subdirectory(server)
add_subdirectory(utils)

# Add more global sources Note: target_sources works on a specific target, we
# use the primary core name
target_sources(
    ${CORE_TARGET_NAME}
    PRIVATE canary_server.cpp
)

# === OpenMP ===
# Find it once, outside the loop
if(OPTIONS_ENABLE_OPENMP)
    find_package(OpenMP)
endif()

# Iterate over all core targets (canary_core and/or canary executable)
foreach(
    core_target IN
    LISTS CANARY_CORE_TARGETS
)

    # Conditional Precompiled Headers
    if(USE_PRECOMPILED_HEADER)
        target_precompile_headers(
            ${core_target}
            PUBLIC
            pch.hpp
        )
        target_compile_definitions(
            ${core_target}
            PUBLIC USE_PRECOMPILED_HEADERS
        )
    endif()

    # *****************************************************************************
    # Build flags
    # *****************************************************************************
    if(CMAKE_COMPILER_IS_GNUCXX)
        target_compile_options(
            ${core_target}
            PRIVATE -Wno-deprecated-declarations
        )
    endif()

    # Sets the NDEBUG macro
    target_compile_definitions(
        ${core_target}
        PUBLIC $<$<CONFIG:Release>:NDEBUG> $<$<CONFIG:RelWithDebInfo>:NDEBUG>
    )

    # Configurar IPO e Linkagem Incremental Note: configure_linking was already
    # called for executable in src/CMakeLists.txt But for a static lib
    # (canary_core) it might be redundant or harmless. configure_linking handles
    # IPO logic.
    configure_linking(${core_target})

    # === UNITY BUILD ===
    if(SPEED_UP_BUILD_UNITY)
        set_target_properties(
            ${core_target}
            PROPERTIES UNITY_BUILD ON
        )
    endif()

    # *****************************************************************************
    # Target include directories
    # *****************************************************************************
    target_include_directories(
        ${core_target}
        PUBLIC ${BOOST_DI_INCLUDE_DIRS}
               ${CMAKE_SOURCE_DIR}/src
               ${LUAJIT_INCLUDE_DIRS}
               ${PARALLEL_HASHMAP_INCLUDE_DIRS}
               ${ATOMIC_QUEUE_INCLUDE_DIRS}
    )

    # *****************************************************************************
    # Target links to external dependencies
    # *****************************************************************************
    target_link_libraries(
        ${core_target}
        PUBLIC ${LUAJIT_LIBRARIES}
               CURL::libcurl
               ZLIB::ZLIB
               absl::any
               absl::log
               absl::base
               absl::bits
               asio::asio
               eventpp::eventpp
               fmt::fmt
               magic_enum::magic_enum
               mio::mio
               protobuf::libprotobuf
               pugixml::pugixml
               spdlog::spdlog
               unofficial::argon2::libargon2
               unofficial::libmariadb
               nlohmann_json::nlohmann_json
               protobuf
               OpenSSL::SSL
    )

    if(FEATURE_METRICS)
        target_compile_definitions(
            ${core_target}
            PUBLIC FEATURE_METRICS
        )
        target_link_libraries(
            ${core_target}
            PUBLIC opentelemetry-cpp::common
                   opentelemetry-cpp::metrics
                   opentelemetry-cpp::api
                   opentelemetry-cpp::ext
                   opentelemetry-cpp::sdk
                   opentelemetry-cpp::logs
                   opentelemetry-cpp::ostream_metrics_exporter
                   opentelemetry-cpp::prometheus_exporter
        )
    endif()

    if(MSVC)
        target_link_libraries(
            ${core_target}
            PUBLIC ${CMAKE_THREAD_LIBS_INIT} ${MYSQL_CLIENT_LIBS}
        )
    else()
        target_link_libraries(
            ${core_target}
            PUBLIC Threads::Threads
        )
    endif()

    # === OpenMP ===
    if(OPTIONS_ENABLE_OPENMP)
        if(OpenMP_CXX_FOUND)
            target_link_libraries(
                ${core_target}
                PUBLIC OpenMP::OpenMP_CXX
            )
        endif()
    endif()

    # === Optimization Flags ===
    if(CMAKE_CXX_COMPILER_ID
       MATCHES
       "GNU|Clang"
    )
        target_compile_options(
            ${core_target}
            PRIVATE $<$<OR:$<CONFIG:Release>,$<CONFIG:RelWithDebInfo>>:-O3
                    -march=native>
        )
    elseif(MSVC)
        target_compile_options(
            ${core_target}
            PRIVATE $<$<OR:$<CONFIG:Release>,$<CONFIG:RelWithDebInfo>>:/O2>
        )
    endif()

endforeach()

if(SPEED_UP_BUILD_UNITY)
    log_option_enabled("Build unity for speed up compilation")
else()
    log_option_disabled("Build unity")
endif()

if(OPTIONS_ENABLE_OPENMP)
    log_option_enabled("openmp")
else()
    log_option_disabled("openmp")
endif()
