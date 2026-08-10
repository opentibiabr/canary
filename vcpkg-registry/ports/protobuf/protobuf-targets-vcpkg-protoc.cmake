# Create imported target protobuf::protoc
add_executable(protobuf::protoc IMPORTED)

set_target_properties(
    protobuf::protoc
    PROPERTIES IMPORTED_LOCATION "${Protobuf_PROTOC_EXECUTABLE}"
               IMPORTED_LOCATION_RELEASE "${Protobuf_PROTOC_EXECUTABLE}"
               MAP_IMPORTED_CONFIG_DEBUG RELEASE
               MAP_IMPORTED_CONFIG_RELWITHDEBINFO RELEASE
               MAP_IMPORTED_CONFIG_MINSIZEREL RELEASE
)
