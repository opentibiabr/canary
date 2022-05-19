project(canary_unittest)

find_package(Catch2 CONFIG REQUIRED)
find_package(Boost REQUIRED COMPONENTS system filesystem iostreams date_time)
find_package(cryptopp CONFIG REQUIRED)
find_package(CURL CONFIG REQUIRED)
find_package(jsoncpp CONFIG REQUIRED)
find_package(LuaJIT REQUIRED)
find_package(pugixml CONFIG REQUIRED)
find_package(spdlog CONFIG REQUIRED)
find_package(Threads REQUIRED)
find_package(unofficial-libmariadb CONFIG REQUIRED)

include_directories(SYSTEM ${MYSQL_INCLUDE_DIR} ${LUA_INCLUDE_DIR}
                    ${Boost_INCLUDE_DIRS} ${PUGIXML_INCLUDE_DIR}
                    ${CRYPTOPP_INCLUDE_DIR})

add_executable(canary_unittest)

target_sources(${PROJECT_NAME}
  PRIVATE
  # Server files
  # Test Files

  # Account
    ../src/creatures/players/account/account.cpp
    src/creatures/players/account/account_test.cpp
    src/creatures/players/account/account_storage_stub.cpp
)

target_compile_definitions(canary_unittest PUBLIC -DUNIT_TESTING -DDEBUG_LOG)

target_include_directories(${PROJECT_NAME}
  PRIVATE
    ${CMAKE_SOURCE_DIR}/src
    ${MYSQL_INCLUDE_DIR}
    ${LUA_INCLUDE_DIR}
    ${Boost_INCLUDE_DIRS}
    ${PUGIXML_INCLUDE_DIR}
    ${CRYPTOPP_INCLUDE_DIR}
    ${CURL_INCLUDE_DIRS}
    INTERFACE_INCLUDE_DIRECTORIES>)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
    ${MYSQL_CLIENT_LIBS}
    ${LUA_LIBRARIES}
    ${Boost_LIBRARY_DIRS}
    ${Boost_LIBRARIES}
    ${PUGIXML_LIBRARIES}
    ${CRYPTOPP_LIBRARIES}
    ${CMAKE_THREAD_LIBS_INIT}
    ${CURL_LIBRARIES}
    spdlog::spdlog
    Catch2::Catch2
    Catch2::Catch2WithMain
)

# target_compile_definitions(${PROJECT_NAME} PUBLIC "-g -O0 --coverage")
target_compile_options(${PROJECT_NAME} PUBLIC -g -O0 --coverage)
target_link_options(${PROJECT_NAME} PUBLIC --coverage)

set_target_properties(${PROJECT_NAME}
    PROPERTIES
      RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
)
