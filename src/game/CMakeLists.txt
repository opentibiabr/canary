target_sources(
    ${CORE_TARGET_NAME}
    PRIVATE functions/game_reload.cpp
            game.cpp
            bank/bank.cpp
            movement/position.cpp
            movement/teleport.cpp
            scheduling/events_scheduler.cpp
            scheduling/dispatcher.cpp
            scheduling/task.cpp
            scheduling/save_manager.cpp
            zones/zone.cpp
            multichannel/channel_context.cpp
            multichannel/channel_registry.cpp
            multichannel/position_resolver.cpp
            multichannel/cluster_session_manager.cpp
            multichannel/channel_switch_service.cpp
            multichannel/cluster_config_validator.cpp
            multichannel/cluster_runtime.cpp
)

if(FEATURE_MULTICHANNEL_REDIS)
    target_sources(
        ${CORE_TARGET_NAME}
        PRIVATE multichannel/hiredis_redis_client.cpp
    )
endif()
