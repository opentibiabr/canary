# *****************************************************************************
# Project protobuf
# *****************************************************************************
project(protobuf)

find_package(Protobuf REQUIRED)

include_directories(${PROTOBUF_INCLUDE_DIRS})

file(GLOB ProtoFiles
	"${CMAKE_CURRENT_SOURCE_DIR}/appearances.proto"
)
PROTOBUF_GENERATE_CPP(ProtoSources ProtoHeaders ${ProtoFiles})
add_library(${PROJECT_NAME} ${ProtoSources} ${ProtoHeaders})
target_link_libraries(${PROJECT_NAME} ${PROTOBUF_LIBRARY})

add_custom_command(
        TARGET ${PROJECT_NAME} POST_BUILD
        # Copy files "appearances.pb.cc" to the "src/protobuf" folder
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_BINARY_DIR}/appearances.pb.cc
                ${CMAKE_CURRENT_SOURCE_DIR}/appearances.pb.cc

        # Copy files "appearances.pb.h" to the "src/protobuf" folder
        COMMAND ${CMAKE_COMMAND} -E copy
                ${CMAKE_CURRENT_BINARY_DIR}/appearances.pb.h
                ${CMAKE_CURRENT_SOURCE_DIR}/appearances.pb.h
 )
