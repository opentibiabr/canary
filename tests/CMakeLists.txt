find_package(Catch2 REQUIRED)
# include_directories(BEFORE ${PROJECT_SOURCE_DIR})
include_directories(SYSTEM ${MYSQL_INCLUDE_DIR} ${LUA_INCLUDE_DIR}
                    ${Boost_INCLUDE_DIRS} ${PUGIXML_INCLUDE_DIR}
                    ${CRYPTOPP_INCLUDE_DIR})

project(canary_unittest)

set(CMAKE_CXX_FLAGS     "-pipe -O0 -g -Wno-everything -std=c++11 -lstdc++ -lpthread -ldl")

add_executable(canary_unittest
							main.cpp
							account_test.cpp)

target_compile_definitions(canary_unittest PUBLIC -DUNIT_TESTING -DDEBUG_LOG)

target_link_libraries(canary_unittest Catch2::Catch2 canary_lib ${MYSQL_CLIENT_LIBS} ${LUA_LIBRARIES}
						${Boost_LIBRARIES} ${Boost_FILESYSTEM_LIBRARY}
						${PUGIXML_LIBRARIES} ${CRYPTOPP_LIBRARIES}
						${CMAKE_THREAD_LIBS_INIT})

include(CTest)
include(Catch)
catch_discover_tests(canary_unittest)
