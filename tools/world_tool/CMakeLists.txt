cmake_minimum_required(VERSION 3.22)
project(world_tool LANGUAGES CXX)
find_package(nlohmann_json CONFIG REQUIRED)
find_package(pugixml CONFIG REQUIRED)
if(EXISTS "${CMAKE_CURRENT_SOURCE_DIR}/../../src/world")
  set(WORLD_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/../../src")
else()
  set(WORLD_SOURCE "${CMAKE_CURRENT_SOURCE_DIR}/../../source")
endif()
add_executable(world-tool main.cpp
  "${WORLD_SOURCE}/world/world_layers.cpp"
  "${WORLD_SOURCE}/world/world_format.cpp"
  "${WORLD_SOURCE}/world/world_validation.cpp"
  "${WORLD_SOURCE}/world/world_selectors.cpp"
  "${WORLD_SOURCE}/world/world_snapshot.cpp")
target_compile_features(world-tool PRIVATE cxx_std_20)
target_include_directories(world-tool PRIVATE "${WORLD_SOURCE}")
target_link_libraries(world-tool PRIVATE nlohmann_json::nlohmann_json pugixml::pugixml)
if(MSVC)
  target_compile_options(world-tool PRIVATE /utf-8)
endif()
