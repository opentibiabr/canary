target_sources(
    canary_ut
    PRIVATE network/message/networkmessage_test.cpp
            network/protocol/market_payload_test.cpp
            network/protocol/multiprotocol_test.cpp
)
