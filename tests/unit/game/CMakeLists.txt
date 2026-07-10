target_sources(
    canary_ut
    PRIVATE dispatcher_policy_test.cpp
            events_scheduler_test.cpp
            highscores_test.cpp
            monster_compute_service_test.cpp
            monster_pathfinding_test.cpp
            monster_targeting_test.cpp
            navigation_snapshot_test.cpp
            npc_shop_range_test.cpp
            random_mount_test.cpp
            player_stats_test.cpp
            spawn_monster_test.cpp
)
