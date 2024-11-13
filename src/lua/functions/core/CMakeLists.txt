target_sources(${PROJECT_NAME}_lib PRIVATE
    game/config_functions.cpp
    game/game_functions.cpp
    game/bank_functions.cpp
    game/global_functions.cpp
    game/lua_enums.cpp
    game/modal_window_functions.cpp
    game/zone_functions.cpp
    libs/db_functions.cpp
    libs/result_functions.cpp
    libs/logger_functions.cpp
    libs/metrics_functions.cpp
    libs/kv_functions.cpp
    network/network_message_functions.cpp
    network/webhook_functions.cpp
)
