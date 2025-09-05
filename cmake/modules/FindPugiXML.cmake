if(APPLE)
    find_package(PkgConfig REQUIRED)
    pkg_check_modules(
        PC_PUGIXML
        QUIET
        pugixml
    )
    set(PUGIXML_DEFINITIONS
        ${PC_PUGIXML_CFLAGS_OTHER}
    )

    find_path(
        PUGIXML_INCLUDE_DIR pugixml.hpp
        HINTS ${PC_PUGIXML_INCLUDEDIR} ${PC_PUGIXML_INCLUDE_DIRS}
    )
    find_library(
        PUGIXML_LIBRARIES
        NAMES pugixml
        HINTS ${PC_PUGIXML_LIBDIR} ${PC_PUGIXML_LIBRARY_DIRS}
    )
else()
    find_path(
        PUGIXML_INCLUDE_DIR
        NAMES pugixml.hpp
    )
    if(CMAKE_BUILD_TYPE
       STREQUAL
       Debug
    )
        find_library(
            PUGIXML_LIBRARIES
            NAMES pugixml_d pugixml
        )
    else()
        find_library(
            PUGIXML_LIBRARIES
            NAMES pugixml
        )
    endif()
endif()

include(FindPackageHandleStandardArgs)
find_package_handle_standard_args(
    PugiXML
    REQUIRED_VARS PUGIXML_INCLUDE_DIR PUGIXML_LIBRARIES
)
mark_as_advanced(PUGIXML_INCLUDE_DIR PUGIXML_LIBRARIES)
