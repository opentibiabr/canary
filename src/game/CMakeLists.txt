target_sources(
    ${PROJECT_NAME}_lib
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
)
