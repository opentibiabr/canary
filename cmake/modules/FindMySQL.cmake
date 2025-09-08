# --------------------------------------------------------
# Copyright (C) 1995-2007 MySQL AB
#
# This program is free software; you can redistribute it and/or modify it under
# the terms of version 2 of the GNU General Public License as published by the
# Free Software Foundation.
#
# There are special exceptions to the terms and conditions of the GPL as it is
# applied to this software. View the full text of the exception in file
# LICENSE.exceptions in the top-level directory of this software distribution.
#
# This program is distributed in the hope that it will be useful, but WITHOUT
# ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS
# FOR A PARTICULAR PURPOSE.  See the GNU General Public License for more
# details.
#
# You should have received a copy of the GNU General Public License along with
# this program; if not, write to the Free Software Foundation, Inc., 59 Temple
# Place, Suite 330, Boston, MA  02111-1307  USA
#
# The MySQL Connector/ODBC is licensed under the terms of the GPL, like most
# MySQL Connectors. There are special exceptions to the terms and conditions of
# the GPL as it is applied to this software, see the FLOSS License Exception
# available on mysql.com.

# ##############################################################################

# -------------- FIND MYSQL_INCLUDE_DIR ------------------
find_path(
    MYSQL_INCLUDE_DIR
    mysql.h
    $ENV{MYSQL_INCLUDE_DIR}
    $ENV{MYSQL_DIR}/include
    /usr/include/mysql
    /usr/local/include/mysql
    /opt/mysql/mysql/include
    /opt/mysql/mysql/include/mysql
    /opt/mysql/include
    /opt/local/include/mysql5
    /usr/local/mysql/include
    /usr/local/mysql/include/mysql
    $ENV{ProgramFiles}/MySQL/*/include
    $ENV{SystemDrive}/MySQL/*/include
    PATH_SUFFIXES mysql
)

# ----------------- FIND MYSQL_LIB_DIR -------------------
if(WIN32)
    # Set lib path suffixes dist = for mysql binary distributions build = for
    # custom built tree
    if(CMAKE_BUILD_TYPE
       STREQUAL
       Debug
    )
        set(libsuffixDist
            debug
        )
        set(libsuffixBuild
            Debug
        )
    else(
        CMAKE_BUILD_TYPE
        STREQUAL
        Debug
    )
        set(libsuffixDist
            opt
        )
        set(libsuffixBuild
            Release
        )
        add_definitions(-DDBUG_OFF)
    endif(
        CMAKE_BUILD_TYPE
        STREQUAL
        Debug
    )

    find_library(
        MYSQL_LIB
        NAMES mariadbclient libmariadb
        PATHS $ENV{MYSQL_DIR}/lib/${libsuffixDist}
              $ENV{MYSQL_DIR}/libmysql
              $ENV{MYSQL_DIR}/libmysql/${libsuffixBuild}
              $ENV{MYSQL_DIR}/client/${libsuffixBuild}
              $ENV{MYSQL_DIR}/libmysql/${libsuffixBuild}
              $ENV{ProgramFiles}/MySQL/*/lib/${libsuffixDist}
              $ENV{SystemDrive}/MySQL/*/lib/${libsuffixDist}
    )
else(WIN32)
    find_library(
        MYSQL_LIB
        NAMES mysqlclient
              mariadbclient
              libmariadb
              libmariadbclient
        PATHS $ENV{MYSQL_DIR}/libmysql/.libs
              $ENV{MYSQL_DIR}/lib
              $ENV{MYSQL_DIR}/lib/mysql
              /usr/lib/mysql
              /usr/local/lib/mysql
              /usr/local/mysql/lib
              /usr/local/mysql/lib/mysql
              /opt/local/mysql5/lib
              /opt/local/lib/mysql5/mysql
              /opt/mysql/mysql/lib/mysql
              /opt/mysql/lib/mysql
    )
endif(WIN32)

if(MYSQL_LIB)
    get_filename_component(
        MYSQL_LIB_DIR
        ${MYSQL_LIB}
        PATH
    )
endif(MYSQL_LIB)

if(MYSQL_INCLUDE_DIR
   AND MYSQL_LIB_DIR
)
    set(MYSQL_FOUND
        TRUE
    )

    include_directories(${MYSQL_INCLUDE_DIR})
    link_directories(${MYSQL_LIB_DIR})

    find_library(
        MYSQL_ZLIB zlib
        PATHS ${MYSQL_LIB_DIR}
    )
    find_library(
        MYSQL_YASSL yassl
        PATHS ${MYSQL_LIB_DIR}
    )
    find_library(
        MYSQL_TAOCRYPT taocrypt
        PATHS ${MYSQL_LIB_DIR}
    )
    set(MYSQL_CLIENT_LIBS
        ${MYSQL_LIB}
    )
    if(MYSQL_ZLIB)
        set(MYSQL_CLIENT_LIBS
            ${MYSQL_CLIENT_LIBS} ${MYSQL_ZLIB}
        )
    endif(MYSQL_ZLIB)
    if(MYSQL_YASSL)
        set(MYSQL_CLIENT_LIBS
            ${MYSQL_CLIENT_LIBS} ${MYSQL_YASSL}
        )
    endif(MYSQL_YASSL)
    if(MYSQL_TAOCRYPT)
        set(MYSQL_CLIENT_LIBS
            ${MYSQL_CLIENT_LIBS} ${MYSQL_TAOCRYPT}
        )
    endif(MYSQL_TAOCRYPT)
    # Add needed mysqlclient dependencies on Windows
    if(WIN32)
        set(MYSQL_CLIENT_LIBS
            ${MYSQL_CLIENT_LIBS} ws2_32
        )
    endif(WIN32)
    if(APPLE)
        set(MYSQL_CLIENT_LIBS
            ${MYSQL_CLIENT_LIBS} iconv
        )
    endif(APPLE)
    if(UNIX)
        set(MYSQL_CLIENT_LIBS
            ${MYSQL_CLIENT_LIBS} "-ldl"
        )
    endif(UNIX)

    message(
        STATUS
            "MySQL Include dir: ${MYSQL_INCLUDE_DIR}  library dir: ${MYSQL_LIB_DIR}"
    )
    message(STATUS "MySQL client libraries: ${MYSQL_CLIENT_LIBS}")
else(
    MYSQL_INCLUDE_DIR
    AND MYSQL_LIB_DIR
)
    message(
        FATAL_ERROR
            "Cannot find MySQL. Include dir: ${MYSQL_INCLUDE_DIR}  library dir: ${MYSQL_LIB_DIR}"
    )
endif(
    MYSQL_INCLUDE_DIR
    AND MYSQL_LIB_DIR
)
