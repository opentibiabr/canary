# Define and setup CanaryLib main library target
add_library(${PROJECT_NAME}_lib)
setup_target(${PROJECT_NAME}_lib)

# Add subdirectories
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

# Add more global sources - please add preferably in the sub_directory CMakeLists.
target_sources(${PROJECT_NAME}_lib PRIVATE canary_server.cpp)

# Add public pre compiler header to lib, to pass down to related targets
if (NOT SPEED_UP_BUILD_UNITY)
    target_precompile_headers(${PROJECT_NAME}_lib PUBLIC pch.hpp)
endif()

if(NOT SPEED_UP_BUILD_UNITY AND USE_PRECOMPILED_HEADERS)
    target_compile_definitions(${PROJECT_NAME}_lib PUBLIC -DUSE_PRECOMPILED_HEADERS)
endif()

# *****************************************************************************
# Build flags - need to be set before the links and sources
# *****************************************************************************
if (CMAKE_COMPILER_IS_GNUCXX)
    target_compile_options(${PROJECT_NAME}_lib PRIVATE -Wno-deprecated-declarations)
endif()

# Sets the NDEBUG macro for RelWithDebInfo and Release configurations.
# This disables assertions in these configurations, optimizing the code for performance
# and reducing debugging overhead, while keeping debug information available for diagnostics.
target_compile_definitions(${PROJECT_NAME}_lib PUBLIC
    $<$<CONFIG:RelWithDebInfo>:NDEBUG>
    $<$<CONFIG:Release>:NDEBUG>
)

# === IPO ===
if(MSVC)
    target_compile_options(${PROJECT_NAME}_lib PRIVATE "/GL")
    set_target_properties(${PROJECT_NAME}_lib PROPERTIES
            STATIC_LINKER_FLAGS "/LTCG"
            SHARED_LINKER_FLAGS "/LTCG"
            MODULE_LINKER_FLAGS "/LTCG"
            EXE_LINKER_FLAGS "/LTCG")
else()
    include(CheckIPOSupported)
    check_ipo_supported(RESULT result)
    if(result)
        set(CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS} -flto=auto")
        message(STATUS "IPO/LTO enabled with -flto=auto for non-MSVC compiler.")
        set_property(TARGET ${PROJECT_NAME}_lib PROPERTY INTERPROCEDURAL_OPTIMIZATION TRUE)
    else()
        message(WARNING "IPO/LTO is not supported: ${output}")
    endif()
endif()

# === UNITY BUILD (compile time reducer) ===
if(SPEED_UP_BUILD_UNITY)
    set_target_properties(${PROJECT_NAME}_lib PROPERTIES UNITY_BUILD ON)
    log_option_enabled("Build unity for speed up compilation")
endif()

# *****************************************************************************
# Target include directories - to allow #include
# *****************************************************************************
target_include_directories(${PROJECT_NAME}_lib
        PUBLIC
        ${BOOST_DI_INCLUDE_DIRS}
        ${CMAKE_SOURCE_DIR}/src
        ${GMP_INCLUDE_DIRS}
        ${LUAJIT_INCLUDE_DIRS}
        ${PARALLEL_HASHMAP_INCLUDE_DIRS}
        )

# *****************************************************************************
# Target links to external dependencies
# *****************************************************************************
target_link_libraries(${PROJECT_NAME}_lib
    PUBLIC
        ${GMP_LIBRARIES}
        ${LUAJIT_LIBRARIES}
        CURL::libcurl
        ZLIB::ZLIB
        absl::any absl::log absl::base absl::bits
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
        unofficial::mariadbclient
        protobuf
)

if(FEATURE_METRICS)
    add_definitions(-DFEATURE_METRICS)

    target_link_libraries(${PROJECT_NAME}_lib
            PUBLIC
            opentelemetry-cpp::common
            opentelemetry-cpp::metrics
            opentelemetry-cpp::api
            opentelemetry-cpp::ext
            opentelemetry-cpp::sdk
            opentelemetry-cpp::logs
            opentelemetry-cpp::ostream_metrics_exporter
            opentelemetry-cpp::prometheus_exporter
    )
endif()

if(CMAKE_BUILD_TYPE MATCHES Debug)
    target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${ZLIB_LIBRARY_DEBUG})
else()
    target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${ZLIB_LIBRARY_RELEASE})
endif()

if (MSVC)
    if(BUILD_STATIC_LIBRARY)
        set(VCPKG_TARGET_TRIPLET "x64-windows-static" CACHE STRING "")
    else()
        set(VCPKG_TARGET_TRIPLET "x64-windows" CACHE STRING "")
    endif()

    target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${CMAKE_THREAD_LIBS_INIT} ${MYSQL_CLIENT_LIBS})
else()
    target_link_libraries(${PROJECT_NAME}_lib PUBLIC Threads::Threads)
endif (MSVC)

# === OpenMP ===
if(OPTIONS_ENABLE_OPENMP)
    log_option_enabled("openmp")
    find_package(OpenMP)
    if(OpenMP_CXX_FOUND)
        target_link_libraries(${PROJECT_NAME}_lib PUBLIC OpenMP::OpenMP_CXX)
    endif()
else()
    log_option_disabled("openmp")
endif()
