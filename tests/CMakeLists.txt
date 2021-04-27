find_package(Catch2 REQUIRED)
# include_directories(BEFORE ${PROJECT_SOURCE_DIR})
include_directories(SYSTEM ${MYSQL_INCLUDE_DIR} ${LUA_INCLUDE_DIR}
                    ${Boost_INCLUDE_DIRS} ${PUGIXML_INCLUDE_DIR}
                    ${CRYPTOPP_INCLUDE_DIR})

project(otbr_unittest)

set(CMAKE_CXX_FLAGS     "-pipe -O0 -g -Wno-everything -std=c++11 -lstdc++ -lpthread -ldl")

add_executable(otbr_unittest
							main.cpp
							account_test.cpp)

target_compile_definitions(otbr_unittest PUBLIC -DUNIT_TESTING -DDEBUG_LOG)

target_link_libraries(otbr_unittest Catch2::Catch2 otbr_lib ${MYSQL_CLIENT_LIBS} ${LUA_LIBRARIES}
						${Boost_LIBRARIES} ${Boost_FILESYSTEM_LIBRARY}
						${PUGIXML_LIBRARIES} ${CRYPTOPP_LIBRARIES}
						${CMAKE_THREAD_LIBS_INIT})

include(CTest)
include(Catch)
catch_discover_tests(otbr_unittest)
