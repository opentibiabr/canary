target_sources(
    ${PROJECT_NAME}_lib
    PRIVATE di/soft_singleton.cpp
            logging/logger.cpp
            logging/log_with_spd_log.cpp
            thread/thread_pool.cpp
)

if(FEATURE_METRICS)
    target_sources(
        ${PROJECT_NAME}_lib
        PRIVATE metrics/metrics.cpp
    )
endif()
