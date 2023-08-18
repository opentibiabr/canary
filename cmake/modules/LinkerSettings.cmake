include(GNUInstallDirs)

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
)

target_include_directories(${PROJECT_NAME}_lib
PUBLIC
    ${BOOST_DI_INCLUDE_DIRS}
    ${CMAKE_SOURCE_DIR}/src
    ${GMP_INCLUDE_DIRS}
    ${LUAJIT_INCLUDE_DIRS}
    ${PARALLEL_HASHMAP_INCLUDE_DIRS}
)

if(CMAKE_BUILD_TYPE MATCHES Debug)
    target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${ZLIB_LIBRARY_DEBUG})
else()
    target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${ZLIB_LIBRARY_RELEASE})
endif()

if (MSVC)
    if(BUILD_STATIC_LIBRARY)
        target_link_libraries(${PROJECT_NAME}_lib PUBLIC jsoncpp_static)
    else()
        target_link_libraries(${PROJECT_NAME}_lib PUBLIC jsoncpp_lib)
    endif()

    target_link_libraries(${PROJECT_NAME}_lib PUBLIC ${CMAKE_THREAD_LIBS_INIT} ${MYSQL_CLIENT_LIBS})

else()
    target_link_libraries(${PROJECT_NAME}_lib PUBLIC jsoncpp_static Threads::Threads)
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