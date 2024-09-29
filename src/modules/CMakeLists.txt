cmake_minimum_required(VERSION 3.29)

project(ModuleLib LANGUAGES CXX)

set(MODULE_SOURCES
    position.cppm
)

add_library(${PROJECT_NAME} STATIC)

target_sources(${PROJECT_NAME}
    PUBLIC
        FILE_SET cxx_modules TYPE CXX_MODULES FILES ${MODULE_SOURCES}
)

set_source_files_properties(
    ${MODULE_SOURCES}
    PROPERTIES
    SKIP_PRECOMPILE_HEADERS ON
    SKIP_UNITY_BUILD_INCLUSION ON
    SKIP_PRECOMPILE_HEADERS ON
)

target_include_directories(${PROJECT_NAME} PUBLIC ${CMAKE_CURRENT_SOURCE_DIR}/include)


if(MSVC)
    set(CMAKE_EXPERIMENTAL_CXX_MODULE_CMAKE_API "TRUE")
    string(REGEX REPLACE "/showIncludes" "" CMAKE_CXX_FLAGS "${CMAKE_CXX_FLAGS}")
    string(REGEX REPLACE "/showIncludes" "" CMAKE_C_FLAGS "${CMAKE_C_FLAGS}")
    target_compile_options(${PROJECT_NAME} PRIVATE /experimental:module)
    target_compile_options(${PROJECT_NAME} PRIVATE $<$<CONFIG:Debug>:/MTd> $<$<NOT:$<CONFIG:Debug>>:/MT>)
    target_compile_options(${PROJECT_NAME} PRIVATE /diagnostics:caret)
elseif(CMAKE_CXX_COMPILER_ID MATCHES "GNU")
    target_compile_options(${PROJECT_NAME} PRIVATE -std=c++23 -fmodules-ts)
endif()

install(TARGETS ${PROJECT_NAME} DESTINATION ${CMAKE_INSTALL_LIBDIR})
install(FILES ${MODULE_SOURCES} DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}/ModuleLib)
