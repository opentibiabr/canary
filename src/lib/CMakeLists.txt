target_sources(
    ${CORE_TARGET_NAME}
    PRIVATE di/soft_singleton.cpp
            logging/logger.cpp
            logging/log_with_spd_log.cpp
            thread/thread_pool.cpp
)

if(FEATURE_METRICS)
    target_sources(
        ${CORE_TARGET_NAME}
        PRIVATE metrics/metrics.cpp
    )
endif()
