target_sources(${PROJECT_NAME}_lib PRIVATE
    network/connection/connection.cpp
    network/message/networkmessage.cpp
    network/message/outputmessage.cpp
    network/protocol/protocol.cpp
    network/protocol/protocolgame.cpp
    network/protocol/protocollogin.cpp
    network/protocol/protocolstatus.cpp
    network/webhook/webhook.cpp
    network/httpclient/httpclient.cpp
    server.cpp
    signals.cpp
)
