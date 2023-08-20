find_package(ut CONFIG REQUIRED)

set(CMAKE_CXX_FLAGS "-pipe -O0 -g -std=c++11 -lstdc++ -lpthread -ldl")

add_executable(canary_ut main.cpp test1.cpp test2.cpp)

target_compile_definitions(canary_ut PUBLIC -DDEBUG_LOG)
target_link_libraries(canary_ut PRIVATE Boost::ut ${PROJECT_NAME}_lib)
