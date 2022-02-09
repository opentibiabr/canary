# Distributed under the OSI-approved BSD 3-Clause License.  See accompanying
# file Copyright.txt or https://cmake.org/licensing for details.

#[=======================================================================[.rst:
FindZLIB
--------

Find the native ZLIB includes and library.

IMPORTED Targets
^^^^^^^^^^^^^^^^

.. versionadded:: 3.1

This module defines :prop_tgt:`IMPORTED` target ``ZLIB::ZLIB``, if
ZLIB has been found.

Result Variables
^^^^^^^^^^^^^^^^

This module defines the following variables:

::

  ZLIB_INCLUDE_DIRSS   - where to find zlib.h, etc.
  ZLIB_LIBRARIES      - List of libraries when using zlib.
  ZLIB_FOUND          - True if zlib found.

::

  ZLIB_VERSION_STRING - The version of zlib found (x.y.z)
  ZLIB_VERSION_MAJOR  - The major version of zlib
  ZLIB_VERSION_MINOR  - The minor version of zlib
  ZLIB_VERSION_PATCH  - The patch version of zlib
  ZLIB_VERSION_TWEAK  - The tweak version of zlib

.. versionadded:: 3.4
  Debug and Release variants are found separately.

Backward Compatibility
^^^^^^^^^^^^^^^^^^^^^^

The following variable are provided for backward compatibility

::

  ZLIB_MAJOR_VERSION  - The major version of zlib
  ZLIB_MINOR_VERSION  - The minor version of zlib
  ZLIB_PATCH_VERSION  - The patch version of zlib

Hints
^^^^^

A user may set ``ZLIB_ROOT`` to a zlib installation root to tell this
module where to look.
#]=======================================================================]

FIND_PATH(ZLIB_INCLUDE_DIRS NAMES zlib.h)
SET(_ZLIB_STATIC_LIBS libz.a libzlib.a zlib1.a)
SET(_ZLIB_SHARED_LIBS libz.dll.a zdll zlib zlib1 z)
IF(USE_STATIC_LIBS)
    FIND_LIBRARY(ZLIB_LIBRARIES NAMES ${_ZLIB_STATIC_LIBS} ${_ZLIB_SHARED_LIBS})
ELSE()
    FIND_LIBRARY(ZLIB_LIBRARIES NAMES ${_ZLIB_SHARED_LIBS} ${_ZLIB_STATIC_LIBS})
ENDIF()

FIND_PACKAGE_HANDLE_STANDARD_ARGS(ZLIB DEFAULT_MSG ZLIB_LIBRARIES ZLIB_INCLUDE_DIRS)
MARK_AS_ADVANCED(ZLIB_LIBRARIES ZLIB_INCLUDE_DIRS)

if(ZLIB_FOUND)
    set(ZLIB_INCLUDE_DIRSS ${ZLIB_INCLUDE_DIRS})

    if(NOT ZLIB_LIBRARIES)
        set(ZLIB_LIBRARIES ${ZLIB_LIBRARIES})
    endif()

    if(NOT TARGET ZLIB::ZLIB)
        add_library(ZLIB::ZLIB UNKNOWN IMPORTED)
        set_target_properties(ZLIB::ZLIB PROPERTIES
            INTERFACE_INCLUDE_DIRECTORIES "${ZLIB_INCLUDE_DIRSS}")

        if(ZLIB_LIBRARIES_RELEASE)
            set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_CONFIGURATIONS RELEASE)
            set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION_RELEASE "${ZLIB_LIBRARIES_RELEASE}")
        endif()

        if(ZLIB_LIBRARIES_DEBUG)
            set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_CONFIGURATIONS DEBUG)
            set_target_properties(ZLIB::ZLIB PROPERTIES
            IMPORTED_LOCATION_DEBUG "${ZLIB_LIBRARIES_DEBUG}")
        endif()

        if(NOT ZLIB_LIBRARIES_RELEASE AND NOT ZLIB_LIBRARIES_DEBUG)
            set_property(TARGET ZLIB::ZLIB APPEND PROPERTY
            IMPORTED_LOCATION "${ZLIB_LIBRARIES}")
        endif()
    endif()
endif()
