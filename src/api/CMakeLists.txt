target_sources(
    ${CORE_TARGET_NAME}
    PRIVATE api.cpp
            endpoints/player.cpp
            endpoints/server.cpp
            utils/broadcast_manager.cpp
            utils/chat_history.cpp
            utils/system_info.cpp
)
