target_sources(
    canary_ut
    PRIVATE network/message/networkmessage_test.cpp
            network/protocol/multiprotocol_test.cpp
            websocket_utils_test.cpp
)
