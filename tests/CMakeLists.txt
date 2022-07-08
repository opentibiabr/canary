project(canary_unittest)

find_package(spdlog CONFIG REQUIRED)
find_package(Catch2 CONFIG REQUIRED)
find_package(Boost REQUIRED COMPONENTS system filesystem iostreams date_time)

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
    INTERFACE_INCLUDE_DIRECTORIES>)

target_link_libraries(${PROJECT_NAME}
  PRIVATE
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
