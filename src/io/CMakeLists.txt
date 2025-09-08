target_sources(
    ${PROJECT_NAME}_lib
    PRIVATE fileloader.cpp
            filestream.cpp
            io_wheel.cpp
            iobestiary.cpp
            io_bosstiary.cpp
            ioguild.cpp
            iologindata.cpp
            functions/iologindata_load_player.cpp
            functions/iologindata_save_player.cpp
            iomap.cpp
            iomapserialize.cpp
            iomarket.cpp
            ioprey.cpp
            player_storage_repository_db.cpp
)
