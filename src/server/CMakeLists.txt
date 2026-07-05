target_sources(
    ${CORE_TARGET_NAME}
    PRIVATE network/connection/connection.cpp
            network/message/networkmessage.cpp
            network/message/outputmessage.cpp
            network/protocol/protocol.cpp
            network/protocol/protocol_profile.cpp
            network/protocol/protocolgame.cpp
            network/protocol/protocollogin.cpp
            network/protocol/protocol_session_hint.cpp
            network/protocol/protocolstatus.cpp
            network/protocol/transport_codec.cpp
            network/webhook/webhook.cpp
            server.cpp
            signals.cpp
)
