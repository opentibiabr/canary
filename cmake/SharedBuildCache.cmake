include_guard(GLOBAL)

set(CANARY_SHARED_CACHE_SCHEMA
    "v4"
)

file(
    READ
    "${CMAKE_CURRENT_LIST_FILE}"
    canary_shared_cache_implementation
)
string(
    REPLACE "\r\n"
            "\n"
            canary_shared_cache_implementation
            "${canary_shared_cache_implementation}"
)
string(
    REPLACE "\r"
            "\n"
            canary_shared_cache_implementation
            "${canary_shared_cache_implementation}"
)
string(SHA256 CANARY_SHARED_CACHE_IMPLEMENTATION_SHA256
              "${canary_shared_cache_implementation}"
)

function(
    canary_shared_cache_file_signature
    label
    path
    output
)
    cmake_parse_arguments(
        signature
        "NORMALIZE_LINE_ENDINGS"
        ""
        ""
        ${ARGN}
    )

    if(NOT CMAKE_SCRIPT_MODE_FILE)
        get_filename_component(
            candidate_directory
            "${path}"
            DIRECTORY
        )
        get_filename_component(
            candidate_name
            "${path}"
            NAME
        )
        if(IS_DIRECTORY "${candidate_directory}")
            file(
                GLOB
                watched_candidate
                CONFIGURE_DEPENDS
                LIST_DIRECTORIES false
                "${candidate_directory}/${candidate_name}"
            )
        endif()
    endif()

    if(EXISTS "${path}")
        if(signature_NORMALIZE_LINE_ENDINGS)
            # The manifest JSON grammar treats physical CRLF and LF line endings
            # identically. Hash their canonical form so Git checkout settings do
            # not split an otherwise identical dependency pool. Generic port and
            # registry trees intentionally remain byte-signatured because
            # patches and other arbitrary payloads can be line-ending-sensitive.
            file(
                READ
                "${path}"
                file_contents
            )
            string(
                REPLACE "\r\n"
                        "\n"
                        file_contents
                        "${file_contents}"
            )
            string(SHA256 file_hash "${file_contents}")
        else()
            file(
                SHA256
                "${path}"
                file_hash
            )
        endif()
        if(NOT CMAKE_SCRIPT_MODE_FILE)
            set_property(
                DIRECTORY
                APPEND
                PROPERTY CMAKE_CONFIGURE_DEPENDS "${path}"
            )
        endif()
        set(signature
            "${label}=${file_hash}\n"
        )
    else()
        set(signature
            "${label}=<missing>\n"
        )
    endif()

    set(${output}
        "${signature}"
        PARENT_SCOPE
    )
endfunction()

function(
    canary_shared_cache_tree_signature
    label
    root
    output
)
    if(NOT CMAKE_SCRIPT_MODE_FILE)
        get_filename_component(
            candidate_directory
            "${root}"
            DIRECTORY
        )
        get_filename_component(
            candidate_name
            "${root}"
            NAME
        )
        if(IS_DIRECTORY "${candidate_directory}")
            file(
                GLOB
                watched_root
                CONFIGURE_DEPENDS
                "${candidate_directory}/${candidate_name}"
            )
        endif()
    endif()

    if(NOT
       IS_DIRECTORY
       "${root}"
    )
        set(${output}
            "${label}=<missing>\n"
            PARENT_SCOPE
        )
        return()
    endif()

    file(
        GLOB_RECURSE tree_entries
        LIST_DIRECTORIES true
        "${root}/*"
    )
    foreach(
        tree_entry IN
        LISTS tree_entries
    )
        if(IS_SYMLINK "${tree_entry}")
            message(
                FATAL_ERROR
                    "Shared-cache input trees cannot contain symbolic links or reparse points: ${tree_entry}"
            )
        endif()
        if(WIN32
           AND IS_DIRECTORY "${tree_entry}"
        )
            execute_process(
                COMMAND
                    powershell -NoProfile -NonInteractive -Command
                    "& { param([string]$candidate) if ((Get-Item -LiteralPath $candidate -Force).Attributes -band [IO.FileAttributes]::ReparsePoint) { exit 42 } }"
                    "${tree_entry}"
                RESULT_VARIABLE tree_entry_reparse_result
                OUTPUT_QUIET ERROR_QUIET
            )
            if(tree_entry_reparse_result
               EQUAL
               42
            )
                message(
                    FATAL_ERROR
                        "Shared-cache input trees cannot contain symbolic links or reparse points: ${tree_entry}"
                )
            elseif(
                NOT
                tree_entry_reparse_result
                EQUAL
                0
            )
                message(
                    FATAL_ERROR
                        "Unable to verify a shared-cache input directory for reparse points: ${tree_entry}"
                )
            endif()
        endif()
    endforeach()

    file(
        REAL_PATH
        "${root}"
        resolved_tree_root
    )
    get_filename_component(
        lexical_tree_root
        "${root}"
        ABSOLUTE
    )
    file(
        TO_CMAKE_PATH
        "${resolved_tree_root}"
        resolved_tree_root
    )
    file(
        TO_CMAKE_PATH
        "${lexical_tree_root}"
        lexical_tree_root
    )
    if(WIN32)
        string(TOLOWER "${resolved_tree_root}" resolved_tree_root)
        string(TOLOWER "${lexical_tree_root}" lexical_tree_root)
    endif()
    if(NOT
       lexical_tree_root
       STREQUAL
       resolved_tree_root
    )
        message(
            FATAL_ERROR
                "Shared-cache input trees cannot be symbolic links or reparse points: ${root}"
        )
    endif()

    if(CMAKE_SCRIPT_MODE_FILE)
        file(
            GLOB_RECURSE tree_files
            LIST_DIRECTORIES false
            "${root}/*"
        )
    else()
        file(
            GLOB_RECURSE
            tree_files
            CONFIGURE_DEPENDS
            LIST_DIRECTORIES false
            "${root}/*"
        )
    endif()

    set(filtered_tree_files)
    foreach(
        tree_file IN
        LISTS tree_files
    )
        file(
            REAL_PATH
            "${tree_file}"
            resolved_tree_file
        )
        get_filename_component(
            lexical_tree_file
            "${tree_file}"
            ABSOLUTE
        )
        file(
            TO_CMAKE_PATH
            "${resolved_tree_file}"
            resolved_tree_file
        )
        file(
            TO_CMAKE_PATH
            "${lexical_tree_file}"
            lexical_tree_file
        )
        if(WIN32)
            string(TOLOWER "${resolved_tree_file}" resolved_tree_file)
            string(TOLOWER "${lexical_tree_file}" lexical_tree_file)
        endif()
        if(NOT
           lexical_tree_file
           STREQUAL
           resolved_tree_file
        )
            message(
                FATAL_ERROR
                    "Shared-cache input trees cannot contain symbolic links or reparse points: ${tree_file}"
            )
        endif()
        file(
            RELATIVE_PATH
            relative_candidate
            "${root}"
            "${tree_file}"
        )
        string(
            REPLACE "\\"
                    "/"
                    relative_candidate
                    "${relative_candidate}"
        )
        if(NOT
           relative_candidate
           MATCHES
           "(^|/)\\.git(/|$)"
        )
            list(
                APPEND
                filtered_tree_files
                "${tree_file}"
            )
        endif()
    endforeach()
    set(tree_files
        ${filtered_tree_files}
    )
    list(SORT tree_files)
    set(signature
        "${label}=<directory>\n"
    )
    foreach(
        tree_file IN
        LISTS tree_files
    )
        file(
            RELATIVE_PATH
            relative_path
            "${root}"
            "${tree_file}"
        )
        string(
            REPLACE "\\"
                    "/"
                    relative_path
                    "${relative_path}"
        )
        file(
            SHA256
            "${tree_file}"
            file_hash
        )
        string(
            APPEND
            signature
            "${label}/${relative_path}=${file_hash}\n"
        )
    endforeach()

    set(${output}
        "${signature}"
        PARENT_SCOPE
    )
endfunction()

function(
    canary_shared_cache_msvc_signature
    root
    output
    found_output
)
    if(CMAKE_SCRIPT_MODE_FILE)
        file(
            GLOB_RECURSE msvc_compilers
            LIST_DIRECTORIES false
            "${root}/VC/Tools/MSVC/*/bin/*/*/cl.exe"
        )
    else()
        file(
            GLOB_RECURSE
            msvc_compilers
            CONFIGURE_DEPENDS
            LIST_DIRECTORIES false
            "${root}/VC/Tools/MSVC/*/bin/*/*/cl.exe"
        )
    endif()

    list(SORT msvc_compilers)
    set(signature
        "vcpkg-msvc-compilers=<directory>\n"
    )
    foreach(
        msvc_compiler IN
        LISTS msvc_compilers
    )
        get_filename_component(
            msvc_bin_directory
            "${msvc_compiler}"
            DIRECTORY
        )
        foreach(
            tool_name IN
            ITEMS cl.exe
                  c1.dll
                  c1xx.dll
                  c2.dll
                  link.exe
                  lib.exe
        )
            set(msvc_tool
                "${msvc_bin_directory}/${tool_name}"
            )
            if(EXISTS "${msvc_tool}")
                file(
                    RELATIVE_PATH
                    relative_path
                    "${root}"
                    "${msvc_tool}"
                )
                string(
                    REPLACE "\\"
                            "/"
                            relative_path
                            "${relative_path}"
                )
                file(
                    SHA256
                    "${msvc_tool}"
                    tool_hash
                )
                string(
                    APPEND
                    signature
                    "vcpkg-msvc-tools/${relative_path}=${tool_hash}\n"
                )
            endif()
        endforeach()
    endforeach()

    if(msvc_compilers)
        set(found
            true
        )
    else()
        set(found
            false
        )
    endif()
    set(${output}
        "${signature}"
        PARENT_SCOPE
    )
    set(${found_output}
        "${found}"
        PARENT_SCOPE
    )
endfunction()

function(
    canary_shared_cache_resolve_program
    candidate
    output
)
    unset(resolved_program)
    unset(resolved_program CACHE)
    if(candidate)
        if(IS_ABSOLUTE "${candidate}"
           AND EXISTS "${candidate}"
        )
            file(
                REAL_PATH
                "${candidate}"
                resolved_program
            )
        else()
            find_program(
                resolved_program
                NAMES "${candidate}" NO_CACHE
            )
        endif()
    endif()

    set(${output}
        "${resolved_program}"
        PARENT_SCOPE
    )
endfunction()

function(
    canary_shared_cache_normalize_path
    input
    output
)
    get_filename_component(
        normalized_path
        "${input}"
        ABSOLUTE
        BASE_DIR
        "${CMAKE_BINARY_DIR}"
    )
    if(EXISTS "${normalized_path}")
        file(
            REAL_PATH
            "${normalized_path}"
            normalized_path
        )
    endif()
    file(
        TO_CMAKE_PATH
        "${normalized_path}"
        normalized_path
    )
    string(
        REGEX
        REPLACE "/+$"
                ""
                normalized_path
                "${normalized_path}"
    )
    if(WIN32)
        string(TOLOWER "${normalized_path}" normalized_path)
    endif()

    set(${output}
        "${normalized_path}"
        PARENT_SCOPE
    )
endfunction()

function(
    canary_shared_cache_path_is_within
    child
    parent
    output
)
    canary_shared_cache_normalize_path("${child}" normalized_child)
    canary_shared_cache_normalize_path("${parent}" normalized_parent)
    string(
        FIND "${normalized_child}/"
             "${normalized_parent}/"
             prefix_index
    )
    if(prefix_index
       EQUAL
       0
    )
        set(is_within
            true
        )
    else()
        set(is_within
            false
        )
    endif()

    set(${output}
        "${is_within}"
        PARENT_SCOPE
    )
endfunction()

function(canary_shared_cache_use_local_transient_roots replace_managed_roots)
    set(local_vcpkg_install_options
        ${VCPKG_INSTALL_OPTIONS}
    )
    if(replace_managed_roots)
        list(
            FILTER
            local_vcpkg_install_options
            EXCLUDE
            REGEX
            "^--x-(buildtrees|packages)-root(=|$)"
        )
    endif()

    set(has_buildtrees_root
        false
    )
    set(has_packages_root
        false
    )
    foreach(
        install_option IN
        LISTS local_vcpkg_install_options
    )
        if(install_option
           MATCHES
           "^--x-(buildtrees|packages)-root(=|$)"
        )
            if(NOT
               install_option
               MATCHES
               "^--x-(buildtrees|packages)-root=(.+)$"
            )
                message(
                    FATAL_ERROR
                        "Explicit vcpkg transient roots must use --x-<kind>-root=<path> so their isolation can be verified."
                )
            endif()
            get_filename_component(
                local_explicit_transient_root
                "${CMAKE_MATCH_2}"
                ABSOLUTE
                BASE_DIR
                "${CMAKE_BINARY_DIR}"
            )
            canary_shared_cache_path_is_within(
                "${local_explicit_transient_root}"
                "${CMAKE_BINARY_DIR}"
                local_explicit_transient_root_is_local
            )
            if(NOT local_explicit_transient_root_is_local)
                message(
                    FATAL_ERROR
                        "An explicit vcpkg transient root is outside this configure tree and could collide with another opt-out build: ${local_explicit_transient_root}"
                )
            endif()
        endif()
        if(install_option
           MATCHES
           "^--x-buildtrees-root(=|$)"
        )
            set(has_buildtrees_root
                true
            )
        elseif(
            install_option
            MATCHES
            "^--x-packages-root(=|$)"
        )
            set(has_packages_root
                true
            )
        endif()
    endforeach()

    if(NOT has_buildtrees_root)
        list(
            APPEND
            local_vcpkg_install_options
            "--x-buildtrees-root=${CMAKE_BINARY_DIR}/vcpkg-buildtrees"
        )
    endif()
    if(NOT has_packages_root)
        list(
            APPEND
            local_vcpkg_install_options
            "--x-packages-root=${CMAKE_BINARY_DIR}/vcpkg-packages"
        )
    endif()

    set(VCPKG_INSTALL_OPTIONS
        "${local_vcpkg_install_options}"
        CACHE STRING
              "Options passed to vcpkg manifest installation"
              FORCE
    )
endfunction()

function(
    canary_shared_cache_base_install_options
    output
    has_explicit_transient_roots_output
)
    set(base_install_options)
    set(has_explicit_transient_roots
        false
    )
    foreach(
        install_option IN
        LISTS VCPKG_INSTALL_OPTIONS
    )
        if(install_option
           MATCHES
           "^--x-buildtrees-root(=|$)"
        )
            set(expected_managed_option
                "--x-buildtrees-root=${CANARY_SHARED_VCPKG_BUILDTREES_ROOT}"
            )
        elseif(
            install_option
            MATCHES
            "^--x-packages-root(=|$)"
        )
            set(expected_managed_option
                "--x-packages-root=${CANARY_SHARED_VCPKG_PACKAGES_ROOT}"
            )
        else()
            list(
                APPEND
                base_install_options
                "${install_option}"
            )
            continue()
        endif()

        if(CANARY_SHARED_VCPKG_MANAGED
           AND install_option
               STREQUAL
               expected_managed_option
        )
            continue()
        endif()

        if(NOT
           install_option
           MATCHES
           "^--x-(buildtrees|packages)-root=(.+)$"
        )
            message(
                FATAL_ERROR
                    "Explicit vcpkg transient roots must use --x-<kind>-root=<path> so their isolation can be verified."
            )
        endif()
        get_filename_component(
            explicit_transient_root
            "${CMAKE_MATCH_2}"
            ABSOLUTE
            BASE_DIR
            "${CMAKE_BINARY_DIR}"
        )
        canary_shared_cache_path_is_within(
            "${explicit_transient_root}"
            "${CMAKE_BINARY_DIR}"
            explicit_transient_root_is_local
        )
        if(NOT explicit_transient_root_is_local)
            message(
                FATAL_ERROR
                    "An explicit vcpkg transient root is outside this configure tree. Shared-cache fallback cannot prove that it is isolated: ${explicit_transient_root}"
            )
        endif()
        set(has_explicit_transient_roots
            true
        )
    endforeach()

    set(${output}
        "${base_install_options}"
        PARENT_SCOPE
    )
    set(${has_explicit_transient_roots_output}
        "${has_explicit_transient_roots}"
        PARENT_SCOPE
    )
endfunction()

function(
    canary_shared_cache_append_environment_paths
    environment_name
    list_name
)
    if(NOT
       DEFINED
       ENV{${environment_name}}
       OR "$ENV{${environment_name}}"
          STREQUAL
          ""
    )
        return()
    endif()

    set(environment_append_failed
        false
    )
    if(WIN32)
        set(environment_path_separator
            ";"
        )
    else()
        set(environment_path_separator
            ":"
        )
    endif()
    string(
        REPLACE "${environment_path_separator}"
                ";"
                environment_paths
                "$ENV{${environment_name}}"
    )
    set(resolved_environment_paths)
    foreach(
        environment_path IN
        LISTS environment_paths
    )
        get_filename_component(
            resolved_environment_path
            "${environment_path}"
            ABSOLUTE
            BASE_DIR
            "${CMAKE_SOURCE_DIR}"
        )
        if(NOT
           IS_DIRECTORY
           "${resolved_environment_path}"
        )
            canary_shared_cache_reset_managed_install(
                "${environment_name} contains a missing directory"
            )
            set(CANARY_SHARED_CACHE_ENVIRONMENT_APPEND_FAILED
                true
                PARENT_SCOPE
            )
            return()
        endif()
        list(
            APPEND
            resolved_environment_paths
            "${resolved_environment_path}"
        )
    endforeach()
    set(${list_name}
        "${${list_name}};${resolved_environment_paths}"
        PARENT_SCOPE
    )
endfunction()

function(canary_shared_cache_native_triplet output)
    string(TOLOWER "${CMAKE_HOST_SYSTEM_NAME}" host_system)
    string(TOLOWER "${CMAKE_HOST_SYSTEM_PROCESSOR}" host_processor)
    if(NOT host_processor
       AND WIN32
       AND DEFINED ENV{PROCESSOR_ARCHITECTURE}
    )
        string(TOLOWER "$ENV{PROCESSOR_ARCHITECTURE}" host_processor)
    endif()
    if(NOT host_processor
       AND UNIX
    )
        execute_process(
            COMMAND uname -m
            RESULT_VARIABLE host_processor_result
            OUTPUT_VARIABLE host_processor
            ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
        )
        if(NOT
           host_processor_result
           EQUAL
           0
        )
            set(host_processor)
        endif()
        string(TOLOWER "${host_processor}" host_processor)
    endif()

    if(host_processor
       MATCHES
       "^(amd64|x86_64|x64)$"
    )
        set(triplet_architecture
            "x64"
        )
    elseif(
        host_processor
        MATCHES
        "^(arm64|aarch64)$"
    )
        set(triplet_architecture
            "arm64"
        )
    elseif(
        host_processor
        MATCHES
        "^(x86|i[3-6]86)$"
    )
        set(triplet_architecture
            "x86"
        )
    else()
        set(triplet_architecture)
    endif()

    if(host_system
       STREQUAL
       "windows"
    )
        set(triplet_platform
            "windows"
        )
    elseif(
        host_system
        STREQUAL
        "linux"
    )
        set(triplet_platform
            "linux"
        )
    elseif(
        host_system
        STREQUAL
        "darwin"
    )
        set(triplet_platform
            "osx"
        )
    else()
        set(triplet_platform)
    endif()

    if(triplet_architecture
       AND triplet_platform
    )
        set(native_triplet
            "${triplet_architecture}-${triplet_platform}"
        )
    else()
        set(native_triplet)
    endif()

    set(${output}
        "${native_triplet}"
        PARENT_SCOPE
    )
endfunction()

function(canary_shared_cache_reset_managed_install reason)
    if(CANARY_SHARED_VCPKG_MANAGED
       OR (CMAKE_PROJECT_NAME
           AND CANARY_USE_SHARED_VCPKG_INSTALLED)
    )
        message(
            FATAL_ERROR
                "The previously managed shared vcpkg contract is no longer usable (${reason}). Cached package paths cannot be migrated safely in place. Re-run cmake --fresh --preset <configure-preset>."
        )
    endif()

    if(CANARY_USE_SHARED_VCPKG_INSTALLED)
        set(VCPKG_INSTALLED_DIR
            "${CMAKE_BINARY_DIR}/vcpkg_installed"
            CACHE PATH
                  "vcpkg manifest installation directory"
                  FORCE
        )
        canary_shared_cache_use_local_transient_roots(false)
        set(CANARY_SHARED_VCPKG_MANAGED
            false
            CACHE INTERNAL
                  "Whether Canary owns VCPKG_INSTALLED_DIR"
                  FORCE
        )
    endif()

    unset(CANARY_VCPKG_CACHE_FINGERPRINT CACHE)
    unset(CANARY_VCPKG_DEPENDENCY_FINGERPRINT CACHE)
    unset(CANARY_VCPKG_CONSUMER_FINGERPRINT CACHE)
    unset(CANARY_SHARED_VCPKG_BUILDTREES_ROOT CACHE)
    unset(CANARY_SHARED_VCPKG_PACKAGES_ROOT CACHE)

    set(CANARY_SHARED_VCPKG_ACTIVE
        false
        CACHE INTERNAL
              "Whether the shared vcpkg installed tree is active"
              FORCE
    )
    if(reason)
        message(STATUS "Shared vcpkg installed tree disabled: ${reason}")
    endif()
endfunction()

set(shared_cache_root_default)
if(DEFINED ENV{CANARY_SHARED_CACHE_ROOT}
   AND NOT
       "$ENV{CANARY_SHARED_CACHE_ROOT}"
       STREQUAL
       ""
)
    set(shared_cache_root_default
        "$ENV{CANARY_SHARED_CACHE_ROOT}"
    )
endif()

set(CANARY_SHARED_CACHE_ROOT
    "${shared_cache_root_default}"
    CACHE PATH "Global cache root shared by compatible Canary worktrees"
)

set(shared_cache_local_filesystem_verified_default
    false
)
if(DEFINED ENV{CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED}
   AND "$ENV{CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED}"
       MATCHES
       "^(1|ON|TRUE|YES)$"
)
    set(shared_cache_local_filesystem_verified_default
        true
    )
endif()
set(CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED
    ${shared_cache_local_filesystem_verified_default}
    CACHE
        BOOL
        "Confirm that the shared pool is on a local filesystem with reliable locks"
)
set(shared_cache_verified_root_default)
if(DEFINED ENV{CANARY_SHARED_CACHE_VERIFIED_ROOT}
   AND NOT
       "$ENV{CANARY_SHARED_CACHE_VERIFIED_ROOT}"
       STREQUAL
       ""
)
    set(shared_cache_verified_root_default
        "$ENV{CANARY_SHARED_CACHE_VERIFIED_ROOT}"
    )
endif()
set(CANARY_SHARED_CACHE_VERIFIED_ROOT
    "${shared_cache_verified_root_default}"
    CACHE PATH
          "Exact shared pool root covered by the local-filesystem verification"
)

set(use_shared_install_default
    false
)
if(CANARY_SHARED_CACHE_ROOT)
    set(use_shared_install_default
        true
    )
endif()
option(
    CANARY_USE_SHARED_VCPKG_INSTALLED
    "Share compatible vcpkg manifest installations across worktrees"
    ${use_shared_install_default}
)
option(
    CANARY_SHARED_CACHE_READ_ONLY
    "Compute and report the shared-cache fingerprint without writing the pool"
    false
)
option(
    CANARY_SHARED_CACHE_PREPARE_ONLY
    "Prepare a shared-cache contract without configuring a CMake project"
    false
)

if(CANARY_SHARED_CACHE_READ_ONLY
   AND NOT CMAKE_SCRIPT_MODE_FILE
)
    message(
        FATAL_ERROR
            "CANARY_SHARED_CACHE_READ_ONLY is available only in CMake script mode; it cannot safely continue into project()"
    )
endif()
if(CANARY_SHARED_CACHE_PREPARE_ONLY
   AND NOT CMAKE_SCRIPT_MODE_FILE
)
    message(
        FATAL_ERROR
            "CANARY_SHARED_CACHE_PREPARE_ONLY is available only in CMake script mode"
    )
endif()
if(CANARY_SHARED_CACHE_READ_ONLY
   AND CANARY_SHARED_CACHE_PREPARE_ONLY
)
    message(
        FATAL_ERROR
            "CANARY_SHARED_CACHE_READ_ONLY and CANARY_SHARED_CACHE_PREPARE_ONLY are mutually exclusive"
    )
endif()

if(DEFINED VCPKG_MANIFEST_INSTALL
   AND NOT VCPKG_MANIFEST_INSTALL
)
    if(CANARY_SHARED_VCPKG_MANAGED
       OR CANARY_SHARED_VCPKG_ACTIVE
    )
        message(
            FATAL_ERROR
                "The previously managed shared vcpkg contract cannot switch to a preprovisioned installation in place. Re-run cmake --fresh --preset <configure-preset>."
        )
    endif()

    set(CANARY_SHARED_VCPKG_MANAGED
        false
        CACHE INTERNAL
              "Whether Canary owns VCPKG_INSTALLED_DIR"
              FORCE
    )
    set(CANARY_SHARED_VCPKG_ACTIVE
        false
        CACHE INTERNAL
              "Whether the shared vcpkg installed tree is active"
              FORCE
    )
    set(CANARY_SHARED_VCPKG_PREPROVISIONED
        true
        CACHE
            INTERNAL
            "Whether this configure consumes a preprovisioned vcpkg installation"
            FORCE
    )
    unset(CANARY_VCPKG_CACHE_FINGERPRINT CACHE)
    unset(CANARY_VCPKG_DEPENDENCY_FINGERPRINT CACHE)
    unset(CANARY_VCPKG_CONSUMER_FINGERPRINT CACHE)
    unset(CANARY_SHARED_VCPKG_BUILDTREES_ROOT CACHE)
    unset(CANARY_SHARED_VCPKG_PACKAGES_ROOT CACHE)
    message(
        STATUS
            "Shared vcpkg installed tree disabled: VCPKG_MANIFEST_INSTALL is disabled; preserving the preprovisioned VCPKG_INSTALLED_DIR"
    )
    return()
endif()

if(CANARY_SHARED_VCPKG_PREPROVISIONED)
    message(
        FATAL_ERROR
            "The previously preprovisioned vcpkg contract cannot enable manifest installation in place. Re-run cmake --fresh --preset <configure-preset>."
    )
endif()

if(NOT CANARY_USE_SHARED_VCPKG_INSTALLED)
    if(DEFINED VCPKG_INSTALLED_DIR
       AND NOT
           VCPKG_INSTALLED_DIR
           STREQUAL
           ""
    )
        get_filename_component(
            opt_out_installed_root
            "${VCPKG_INSTALLED_DIR}"
            ABSOLUTE
            BASE_DIR
            "${CMAKE_BINARY_DIR}"
        )
        canary_shared_cache_path_is_within(
            "${opt_out_installed_root}"
            "${CMAKE_BINARY_DIR}"
            opt_out_installed_root_is_local
        )
        if(NOT opt_out_installed_root_is_local)
            message(
                FATAL_ERROR
                    "Opt-out VCPKG_INSTALLED_DIR must remain inside this configure tree: ${opt_out_installed_root}"
            )
        endif()
    endif()
    if(NOT CANARY_SHARED_VCPKG_MANAGED)
        canary_shared_cache_use_local_transient_roots(false)
    endif()
    canary_shared_cache_reset_managed_install("explicitly disabled")
    return()
endif()

canary_shared_cache_base_install_options(canary_base_vcpkg_install_options
                                         canary_has_explicit_transient_roots
)
if(canary_has_explicit_transient_roots)
    canary_shared_cache_reset_managed_install(
        "explicit build-local vcpkg transient roots keep this configure isolated"
    )
    return()
endif()
set(VCPKG_INSTALL_OPTIONS
    "${canary_base_vcpkg_install_options}"
    CACHE STRING
          "Options passed to vcpkg manifest installation"
          FORCE
)

if(NOT CANARY_SHARED_CACHE_ROOT)
    canary_shared_cache_reset_managed_install(
        "CANARY_SHARED_CACHE_ROOT is not configured"
    )
    return()
endif()

get_filename_component(
    shared_cache_root
    "${CANARY_SHARED_CACHE_ROOT}"
    ABSOLUTE
    BASE_DIR
    "${CMAKE_BINARY_DIR}"
)
file(
    TO_CMAKE_PATH
    "${shared_cache_root}"
    shared_cache_root
)

canary_shared_cache_path_is_within(
    "${shared_cache_root}"
    "${CMAKE_SOURCE_DIR}"
    cache_inside_source
)
canary_shared_cache_path_is_within(
    "${CMAKE_SOURCE_DIR}"
    "${shared_cache_root}"
    source_inside_cache
)
canary_shared_cache_path_is_within(
    "${shared_cache_root}"
    "${CMAKE_BINARY_DIR}"
    cache_inside_binary
)
canary_shared_cache_path_is_within(
    "${CMAKE_BINARY_DIR}"
    "${shared_cache_root}"
    binary_inside_cache
)
if(cache_inside_source
   OR source_inside_cache
   OR cache_inside_binary
   OR binary_inside_cache
)
    message(
        FATAL_ERROR
            "CANARY_SHARED_CACHE_ROOT must be outside and separate from the source and binary directory hierarchies"
    )
endif()

if(NOT CANARY_SHARED_CACHE_LOCAL_FILESYSTEM_VERIFIED)
    canary_shared_cache_reset_managed_install(
        "the shared cache filesystem has not been verified as local"
    )
    return()
endif()
if(NOT CANARY_SHARED_CACHE_VERIFIED_ROOT)
    canary_shared_cache_reset_managed_install(
        "the local-filesystem verification is not bound to an exact cache root"
    )
    return()
endif()
get_filename_component(
    verified_shared_cache_root
    "${CANARY_SHARED_CACHE_VERIFIED_ROOT}"
    ABSOLUTE
    BASE_DIR
    "${CMAKE_BINARY_DIR}"
)
file(
    TO_CMAKE_PATH
    "${verified_shared_cache_root}"
    verified_shared_cache_root
)
set(normalized_shared_cache_root
    "${shared_cache_root}"
)
set(normalized_verified_shared_cache_root
    "${verified_shared_cache_root}"
)
string(
    REGEX
    REPLACE "/+$"
            ""
            normalized_shared_cache_root
            "${normalized_shared_cache_root}"
)
string(
    REGEX
    REPLACE "/+$"
            ""
            normalized_verified_shared_cache_root
            "${normalized_verified_shared_cache_root}"
)
if(WIN32)
    string(TOLOWER "${normalized_shared_cache_root}"
                   normalized_shared_cache_root
    )
    string(TOLOWER "${normalized_verified_shared_cache_root}"
                   normalized_verified_shared_cache_root
    )
endif()
if(NOT
   normalized_shared_cache_root
   STREQUAL
   normalized_verified_shared_cache_root
)
    canary_shared_cache_reset_managed_install(
        "the cache root differs from the path covered by local-filesystem verification"
    )
    return()
endif()
if(EXISTS "${shared_cache_root}")
    file(
        REAL_PATH
        "${shared_cache_root}"
        resolved_shared_cache_root
    )
    file(
        TO_CMAKE_PATH
        "${resolved_shared_cache_root}"
        normalized_resolved_shared_cache_root
    )
    string(
        REGEX
        REPLACE "/+$"
                ""
                normalized_resolved_shared_cache_root
                "${normalized_resolved_shared_cache_root}"
    )
    if(WIN32)
        string(TOLOWER "${normalized_resolved_shared_cache_root}"
                       normalized_resolved_shared_cache_root
        )
    endif()
    if(NOT
       normalized_shared_cache_root
       STREQUAL
       normalized_resolved_shared_cache_root
    )
        canary_shared_cache_reset_managed_install(
            "the cache root traverses a symbolic link or reparse point"
        )
        return()
    endif()
endif()

set(cxx_compiler_candidate)
if(CMAKE_CXX_COMPILER)
    set(cxx_compiler_candidate
        "${CMAKE_CXX_COMPILER}"
    )
elseif(
    DEFINED ENV{CXX}
    AND NOT
        "$ENV{CXX}"
        STREQUAL
        ""
)
    set(cxx_compiler_candidate
        "$ENV{CXX}"
    )
endif()

set(c_compiler_candidate)
if(CMAKE_C_COMPILER)
    set(c_compiler_candidate
        "${CMAKE_C_COMPILER}"
    )
elseif(
    DEFINED ENV{CC}
    AND NOT
        "$ENV{CC}"
        STREQUAL
        ""
)
    set(c_compiler_candidate
        "$ENV{CC}"
    )
endif()

canary_shared_cache_resolve_program("${cxx_compiler_candidate}"
                                    cxx_compiler_path
)
canary_shared_cache_resolve_program("${c_compiler_candidate}" c_compiler_path)

if(NOT cxx_compiler_path
   OR NOT c_compiler_path
)
    canary_shared_cache_reset_managed_install(
        "the C and C++ compilers cannot both be identified before project(); use a compiler environment or set CMAKE_C_COMPILER and CMAKE_CXX_COMPILER"
    )
    return()
endif()

file(
    REAL_PATH
    "${cxx_compiler_path}"
    cxx_compiler_path
)
file(
    SHA256
    "${cxx_compiler_path}"
    cxx_compiler_hash
)
get_filename_component(
    cxx_compiler_name
    "${cxx_compiler_path}"
    NAME
)
file(
    REAL_PATH
    "${c_compiler_path}"
    c_compiler_path
)
file(
    SHA256
    "${c_compiler_path}"
    c_compiler_hash
)
get_filename_component(
    c_compiler_name
    "${c_compiler_path}"
    NAME
)

file(
    REAL_PATH
    "${CMAKE_COMMAND}"
    cmake_executable
)
file(
    SHA256
    "${cmake_executable}"
    cmake_executable_hash
)

set(vcpkg_root_from_toolchain)
if(CMAKE_TOOLCHAIN_FILE)
    get_filename_component(
        selected_toolchain
        "${CMAKE_TOOLCHAIN_FILE}"
        ABSOLUTE
        BASE_DIR
        "${CMAKE_SOURCE_DIR}"
    )
    file(
        TO_CMAKE_PATH
        "${selected_toolchain}"
        selected_toolchain
    )
endif()
if(selected_toolchain
   MATCHES
   "/scripts/buildsystems/vcpkg\\.cmake$"
)
    get_filename_component(
        vcpkg_toolchain_directory
        "${selected_toolchain}"
        DIRECTORY
    )
    get_filename_component(
        vcpkg_root_from_toolchain
        "${vcpkg_toolchain_directory}/../.."
        ABSOLUTE
    )
elseif(selected_toolchain)
    canary_shared_cache_reset_managed_install(
        "CMAKE_TOOLCHAIN_FILE is not the direct vcpkg toolchain"
    )
    return()
endif()

set(vcpkg_root_from_environment)
if(DEFINED ENV{VCPKG_ROOT}
   AND NOT
       "$ENV{VCPKG_ROOT}"
       STREQUAL
       ""
)
    get_filename_component(
        vcpkg_root_from_environment
        "$ENV{VCPKG_ROOT}"
        ABSOLUTE
    )
endif()

if(vcpkg_root_from_toolchain
   AND vcpkg_root_from_environment
)
    file(
        REAL_PATH
        "${vcpkg_root_from_toolchain}"
        toolchain_root_real
    )
    file(
        REAL_PATH
        "${vcpkg_root_from_environment}"
        environment_root_real
    )
    file(
        TO_CMAKE_PATH
        "${toolchain_root_real}"
        toolchain_root_real
    )
    file(
        TO_CMAKE_PATH
        "${environment_root_real}"
        environment_root_real
    )
    if(WIN32)
        string(TOLOWER "${toolchain_root_real}" toolchain_root_comparable)
        string(TOLOWER "${environment_root_real}" environment_root_comparable)
    else()
        set(toolchain_root_comparable
            "${toolchain_root_real}"
        )
        set(environment_root_comparable
            "${environment_root_real}"
        )
    endif()
    if(NOT
       toolchain_root_comparable
       STREQUAL
       environment_root_comparable
    )
        canary_shared_cache_reset_managed_install(
            "CMAKE_TOOLCHAIN_FILE and VCPKG_ROOT select different vcpkg installations"
        )
        return()
    endif()
endif()

if(vcpkg_root_from_toolchain)
    set(vcpkg_root
        "${vcpkg_root_from_toolchain}"
    )
else()
    set(vcpkg_root
        "${vcpkg_root_from_environment}"
    )
endif()

if(NOT
   IS_DIRECTORY
   "${vcpkg_root}"
)
    canary_shared_cache_reset_managed_install(
        "the vcpkg installation cannot be identified"
    )
    return()
endif()

if(WIN32)
    set(vcpkg_executable
        "${vcpkg_root}/vcpkg.exe"
    )
else()
    set(vcpkg_executable
        "${vcpkg_root}/vcpkg"
    )
endif()
set(vcpkg_toolchain
    "${vcpkg_root}/scripts/buildsystems/vcpkg.cmake"
)

if(NOT
   EXISTS
   "${vcpkg_executable}"
   OR NOT
      EXISTS
      "${vcpkg_toolchain}"
)
    canary_shared_cache_reset_managed_install(
        "the vcpkg executable or toolchain is missing"
    )
    return()
endif()

file(
    SHA256
    "${vcpkg_executable}"
    vcpkg_executable_hash
)
file(
    SHA256
    "${vcpkg_toolchain}"
    vcpkg_toolchain_hash
)
if(NOT CMAKE_SCRIPT_MODE_FILE)
    set_property(
        DIRECTORY
        APPEND
        PROPERTY CMAKE_CONFIGURE_DEPENDS
                 "${CMAKE_CURRENT_LIST_FILE}"
                 "${cxx_compiler_path}"
                 "${c_compiler_path}"
                 "${cmake_executable}"
                 "${vcpkg_executable}"
                 "${vcpkg_toolchain}"
    )
endif()
execute_process(
    COMMAND git -C "${vcpkg_root}" rev-parse HEAD
    OUTPUT_VARIABLE vcpkg_revision
    RESULT_VARIABLE vcpkg_revision_result
    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
)
execute_process(
    COMMAND
        git -C "${vcpkg_root}" status --porcelain --untracked-files=all -- ports
        versions triplets scripts
    OUTPUT_VARIABLE vcpkg_dirty_state
    RESULT_VARIABLE vcpkg_dirty_result
    ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
)
if(NOT
   vcpkg_revision_result
   EQUAL
   0
   OR NOT
      vcpkg_dirty_result
      EQUAL
      0
)
    canary_shared_cache_reset_managed_install(
        "the vcpkg Git revision cannot be verified"
    )
    return()
endif()
if(vcpkg_dirty_state)
    canary_shared_cache_reset_managed_install(
        "the vcpkg ports, versions, triplets, or scripts tree has local changes"
    )
    return()
endif()

canary_shared_cache_native_triplet(native_triplet)
if(NOT VCPKG_TARGET_TRIPLET
   AND DEFINED ENV{VCPKG_DEFAULT_TRIPLET}
   AND NOT
       "$ENV{VCPKG_DEFAULT_TRIPLET}"
       STREQUAL
       ""
)
    set(VCPKG_TARGET_TRIPLET
        "$ENV{VCPKG_DEFAULT_TRIPLET}"
    )
endif()
if(NOT VCPKG_HOST_TRIPLET
   AND DEFINED ENV{VCPKG_DEFAULT_HOST_TRIPLET}
   AND NOT
       "$ENV{VCPKG_DEFAULT_HOST_TRIPLET}"
       STREQUAL
       ""
)
    set(VCPKG_HOST_TRIPLET
        "$ENV{VCPKG_DEFAULT_HOST_TRIPLET}"
    )
endif()
if(NOT VCPKG_TARGET_TRIPLET)
    set(VCPKG_TARGET_TRIPLET
        "${native_triplet}"
    )
endif()
if(NOT VCPKG_HOST_TRIPLET)
    set(VCPKG_HOST_TRIPLET
        "${native_triplet}"
    )
endif()
if(NOT VCPKG_TARGET_TRIPLET
   OR NOT VCPKG_HOST_TRIPLET
)
    canary_shared_cache_reset_managed_install(
        "the effective target or host triplet cannot be resolved safely"
    )
    return()
endif()
set(VCPKG_TARGET_TRIPLET
    "${VCPKG_TARGET_TRIPLET}"
    CACHE STRING
          "vcpkg target triplet"
          FORCE
)
set(VCPKG_HOST_TRIPLET
    "${VCPKG_HOST_TRIPLET}"
    CACHE STRING
          "vcpkg host triplet"
          FORCE
)

set(manifest_root
    "${CMAKE_SOURCE_DIR}"
)
if(VCPKG_MANIFEST_DIR)
    get_filename_component(
        manifest_root
        "${VCPKG_MANIFEST_DIR}"
        ABSOLUTE
        BASE_DIR
        "${CMAKE_SOURCE_DIR}"
    )
endif()

if(DEFINED VCPKG_MANIFEST_MODE
   AND NOT VCPKG_MANIFEST_MODE
)
    canary_shared_cache_reset_managed_install("VCPKG_MANIFEST_MODE is disabled")
    return()
endif()
if(NOT
   EXISTS
   "${manifest_root}/vcpkg.json"
)
    canary_shared_cache_reset_managed_install(
        "no vcpkg manifest exists at the selected manifest root"
    )
    return()
endif()
if(DEFINED VCPKG_MANIFEST_INSTALL
   AND NOT VCPKG_MANIFEST_INSTALL
)
    canary_shared_cache_reset_managed_install(
        "VCPKG_MANIFEST_INSTALL is disabled"
    )
    return()
endif()
set(VCPKG_MANIFEST_MODE
    ON
    CACHE BOOL
          "Use vcpkg manifest mode"
          FORCE
)
set(VCPKG_MANIFEST_INSTALL
    ON
    CACHE BOOL
          "Install vcpkg manifest dependencies"
          FORCE
)

set(fingerprint_input
    "schema=${CANARY_SHARED_CACHE_SCHEMA}\n"
)
string(
    APPEND
    fingerprint_input
    "implementation-sha256=${CANARY_SHARED_CACHE_IMPLEMENTATION_SHA256}\n"
    "host-system=${CMAKE_HOST_SYSTEM_NAME}\n"
    "host-processor=${CMAKE_HOST_SYSTEM_PROCESSOR}\n"
    "dependency-cmake-version=${CMAKE_VERSION}\n"
    "dependency-cmake-sha256=${cmake_executable_hash}\n"
    "cxx-compiler-name=${cxx_compiler_name}\n"
    "cxx-compiler-sha256=${cxx_compiler_hash}\n"
    "c-compiler-name=${c_compiler_name}\n"
    "c-compiler-sha256=${c_compiler_hash}\n"
    "vcpkg-revision=${vcpkg_revision}\n"
    "vcpkg-executable-sha256=${vcpkg_executable_hash}\n"
    "vcpkg-toolchain-sha256=${vcpkg_toolchain_hash}\n"
)

foreach(
    setting IN
    ITEMS VCPKG_TARGET_TRIPLET
          VCPKG_HOST_TRIPLET
          VCPKG_MANIFEST_FEATURES
          VCPKG_MANIFEST_NO_DEFAULT_FEATURES
          VCPKG_MANIFEST_MODE
          VCPKG_MANIFEST_INSTALL
          VCPKG_FEATURE_FLAGS
          VCPKG_BUILD_TYPE
          VCPKG_INSTALL_OPTIONS
          VCPKG_CMAKE_SYSTEM_NAME
          VCPKG_CMAKE_SYSTEM_VERSION
          VCPKG_CRT_LINKAGE
          VCPKG_LIBRARY_LINKAGE
          VCPKG_PLATFORM_TOOLSET
          VCPKG_PLATFORM_TOOLSET_VERSION
          VCPKG_LOAD_VCVARS_ENV
)
    if(DEFINED ${setting})
        set(setting_value
            "${${setting}}"
        )
        string(
            REPLACE ";"
                    "|"
                    setting_value
                    "${setting_value}"
        )
    else()
        set(setting_value
            "<unset>"
        )
    endif()
    string(
        APPEND
        fingerprint_input
        "${setting}=${setting_value}\n"
    )
endforeach()

foreach(
    environment_setting IN
    ITEMS VisualStudioVersion
          VCToolsVersion
          WindowsSDKVersion
          WindowsSDKLibVersion
          UCRTVersion
          VSCMD_ARG_HOST_ARCH
          VSCMD_ARG_TGT_ARCH
)
    if(DEFINED ENV{${environment_setting}}
       AND NOT
           "$ENV{${environment_setting}}"
           STREQUAL
           ""
    )
        set(environment_value
            "$ENV{${environment_setting}}"
        )
        string(
            REPLACE "\\"
                    "/"
                    environment_value
                    "${environment_value}"
        )
    else()
        set(environment_value
            "<unset>"
        )
    endif()
    string(
        APPEND
        fingerprint_input
        "env/${environment_setting}=${environment_value}\n"
    )
endforeach()

canary_shared_cache_file_signature(
    "manifest/vcpkg.json"
    "${manifest_root}/vcpkg.json"
    manifest_signature
    NORMALIZE_LINE_ENDINGS
)
string(
    APPEND
    fingerprint_input
    "${manifest_signature}"
)
canary_shared_cache_file_signature(
    "manifest/vcpkg-configuration.json"
    "${manifest_root}/vcpkg-configuration.json"
    manifest_configuration_signature
    NORMALIZE_LINE_ENDINGS
)
string(
    APPEND
    fingerprint_input
    "${manifest_configuration_signature}"
)

set(install_option_overlay_ports)
set(install_option_overlay_triplets)
foreach(
    install_option IN
    LISTS canary_base_vcpkg_install_options
)
    if(install_option
       MATCHES
       "^--overlay-(ports|triplets)=(.+)$"
    )
        set(install_overlay_kind
            "${CMAKE_MATCH_1}"
        )
        get_filename_component(
            install_overlay_root
            "${CMAKE_MATCH_2}"
            ABSOLUTE
            BASE_DIR
            "${manifest_root}"
        )
        if(NOT
           IS_DIRECTORY
           "${install_overlay_root}"
        )
            canary_shared_cache_reset_managed_install(
                "VCPKG_INSTALL_OPTIONS references a missing overlay directory"
            )
            return()
        endif()
        if(install_overlay_kind
           STREQUAL
           "ports"
        )
            list(
                APPEND
                install_option_overlay_ports
                "${install_overlay_root}"
            )
        else()
            list(
                APPEND
                install_option_overlay_triplets
                "${install_overlay_root}"
            )
        endif()
    elseif(
        install_option
        MATCHES
        "^--overlay-(ports|triplets)($|[[:space:]])"
    )
        message(
            FATAL_ERROR
                "Overlay install options must use --overlay-<kind>=<path> so the tree can be fingerprinted."
        )
    endif()
endforeach()

set(configuration_overlay_ports)
set(configuration_overlay_triplets)
set(variable_overlay_ports
    ${VCPKG_OVERLAY_PORTS}
)
set(variable_overlay_triplets
    ${VCPKG_OVERLAY_TRIPLETS}
)
set(environment_overlay_ports)
set(environment_overlay_triplets)
set(CANARY_SHARED_CACHE_ENVIRONMENT_APPEND_FAILED
    false
)
canary_shared_cache_append_environment_paths(VCPKG_OVERLAY_PORTS
                                             environment_overlay_ports
)
if(CANARY_SHARED_CACHE_ENVIRONMENT_APPEND_FAILED)
    return()
endif()
canary_shared_cache_append_environment_paths(VCPKG_OVERLAY_TRIPLETS
                                             environment_overlay_triplets
)
if(CANARY_SHARED_CACHE_ENVIRONMENT_APPEND_FAILED)
    return()
endif()
set(vcpkg_configuration_path
    "${manifest_root}/vcpkg-configuration.json"
)
file(
    READ
    "${manifest_root}/vcpkg.json"
    vcpkg_manifest_json
)
set(has_embedded_vcpkg_configuration
    false
)
foreach(
    embedded_configuration_field IN
    ITEMS configuration vcpkg-configuration
)
    string(
        JSON
        embedded_configuration_type
        ERROR_VARIABLE
        embedded_configuration_error
        TYPE
        "${vcpkg_manifest_json}"
        "${embedded_configuration_field}"
    )
    if(embedded_configuration_error
       STREQUAL
       "NOTFOUND"
    )
        if(NOT
           embedded_configuration_type
           STREQUAL
           "OBJECT"
        )
            canary_shared_cache_reset_managed_install(
                "vcpkg.json contains an invalid ${embedded_configuration_field} value"
            )
            return()
        endif()
        if(has_embedded_vcpkg_configuration)
            canary_shared_cache_reset_managed_install(
                "vcpkg.json defines both embedded configuration spellings"
            )
            return()
        endif()
        string(
            JSON
            vcpkg_configuration_json
            GET
            "${vcpkg_manifest_json}"
            "${embedded_configuration_field}"
        )
        set(has_embedded_vcpkg_configuration
            true
        )
        set(vcpkg_configuration_source
            "vcpkg.json ${embedded_configuration_field}"
        )
    elseif(
        NOT
        embedded_configuration_error
        MATCHES
        "member '.*' not found"
    )
        canary_shared_cache_reset_managed_install(
            "vcpkg.json is not valid JSON"
        )
        return()
    endif()
endforeach()

if(EXISTS "${vcpkg_configuration_path}")
    if(has_embedded_vcpkg_configuration)
        canary_shared_cache_reset_managed_install(
            "vcpkg rejects a separate vcpkg-configuration.json combined with embedded configuration"
        )
        return()
    endif()
    file(
        READ
        "${vcpkg_configuration_path}"
        vcpkg_configuration_json
    )
    set(vcpkg_configuration_source
        "vcpkg-configuration.json"
    )
    set(has_vcpkg_configuration
        true
    )
elseif(has_embedded_vcpkg_configuration)
    set(has_vcpkg_configuration
        true
    )
else()
    set(has_vcpkg_configuration
        false
    )
endif()

if(has_vcpkg_configuration)
    string(
        JSON
        configuration_root_type
        ERROR_VARIABLE
        configuration_root_error
        TYPE
        "${vcpkg_configuration_json}"
    )
    if(NOT
       configuration_root_error
       STREQUAL
       "NOTFOUND"
       OR NOT
          configuration_root_type
          STREQUAL
          "OBJECT"
    )
        canary_shared_cache_reset_managed_install(
            "${vcpkg_configuration_source} is not a valid JSON object"
        )
        return()
    endif()

    foreach(
        configuration_overlay_kind IN
        ITEMS overlay-ports overlay-triplets
    )
        string(
            JSON
            configuration_overlay_type
            ERROR_VARIABLE
            configuration_overlay_error
            TYPE
            "${vcpkg_configuration_json}"
            "${configuration_overlay_kind}"
        )
        if(configuration_overlay_error
           STREQUAL
           "NOTFOUND"
           AND configuration_overlay_type
               STREQUAL
               "ARRAY"
        )
            string(
                JSON configuration_overlay_count
                LENGTH "${vcpkg_configuration_json}"
                       "${configuration_overlay_kind}"
            )
            if(configuration_overlay_count
               GREATER
               0
            )
                math(
                    EXPR
                    configuration_overlay_last
                    "${configuration_overlay_count} - 1"
                )
                foreach(
                    configuration_overlay_index
                    RANGE 0 ${configuration_overlay_last}
                )
                    string(
                        JSON
                        configuration_overlay_relative_path
                        ERROR_VARIABLE
                        configuration_overlay_path_error
                        GET
                        "${vcpkg_configuration_json}"
                        "${configuration_overlay_kind}"
                        ${configuration_overlay_index}
                    )
                    if(NOT
                       configuration_overlay_path_error
                       STREQUAL
                       "NOTFOUND"
                    )
                        canary_shared_cache_reset_managed_install(
                            "vcpkg-configuration.json contains an invalid ${configuration_overlay_kind} entry"
                        )
                        return()
                    endif()
                    get_filename_component(
                        configuration_overlay_root
                        "${configuration_overlay_relative_path}"
                        ABSOLUTE
                        BASE_DIR
                        "${manifest_root}"
                    )
                    if(NOT
                       IS_DIRECTORY
                       "${configuration_overlay_root}"
                    )
                        canary_shared_cache_reset_managed_install(
                            "a configured ${configuration_overlay_kind} directory is missing"
                        )
                        return()
                    endif()
                    canary_shared_cache_tree_signature(
                        "configuration-${configuration_overlay_kind}-${configuration_overlay_index}"
                        "${configuration_overlay_root}"
                        configuration_overlay_signature
                    )
                    string(
                        APPEND
                        fingerprint_input
                        "${configuration_overlay_signature}"
                    )
                    if(configuration_overlay_kind
                       STREQUAL
                       "overlay-ports"
                    )
                        list(
                            APPEND
                            configuration_overlay_ports
                            "${configuration_overlay_root}"
                        )
                    else()
                        list(
                            APPEND
                            configuration_overlay_triplets
                            "${configuration_overlay_root}"
                        )
                    endif()
                endforeach()
            endif()
        elseif(
            NOT
            configuration_overlay_error
            STREQUAL
            "member '${configuration_overlay_kind}' not found"
            AND NOT
                configuration_overlay_error
                MATCHES
                "member '.*' not found"
        )
            canary_shared_cache_reset_managed_install(
                "vcpkg-configuration.json contains an invalid ${configuration_overlay_kind} value"
            )
            return()
        endif()
    endforeach()

    set(filesystem_registry_index
        0
    )
    string(
        JSON
        default_registry_type
        ERROR_VARIABLE
        default_registry_error
        TYPE
        "${vcpkg_configuration_json}"
        "default-registry"
    )
    if(default_registry_error
       STREQUAL
       "NOTFOUND"
       AND default_registry_type
           STREQUAL
           "OBJECT"
    )
        string(
            JSON
            default_registry_kind
            ERROR_VARIABLE
            default_registry_kind_error
            GET
            "${vcpkg_configuration_json}"
            "default-registry"
            "kind"
        )
        if(default_registry_kind_error
           STREQUAL
           "NOTFOUND"
           AND default_registry_kind
               STREQUAL
               "filesystem"
        )
            string(
                JSON
                filesystem_registry_relative_path
                ERROR_VARIABLE
                filesystem_registry_path_error
                GET
                "${vcpkg_configuration_json}"
                "default-registry"
                "path"
            )
            if(NOT
               filesystem_registry_path_error
               STREQUAL
               "NOTFOUND"
            )
                canary_shared_cache_reset_managed_install(
                    "the default filesystem registry does not define a valid path"
                )
                return()
            endif()
            get_filename_component(
                filesystem_registry_root
                "${filesystem_registry_relative_path}"
                ABSOLUTE
                BASE_DIR
                "${manifest_root}"
            )
            if(NOT
               IS_DIRECTORY
               "${filesystem_registry_root}"
            )
                canary_shared_cache_reset_managed_install(
                    "the default filesystem registry directory is missing"
                )
                return()
            endif()
            canary_shared_cache_tree_signature(
                "filesystem-registry-default"
                "${filesystem_registry_root}"
                filesystem_registry_signature
            )
            string(
                APPEND
                fingerprint_input
                "${filesystem_registry_signature}"
            )
        endif()
    endif()

    string(
        JSON
        registries_type
        ERROR_VARIABLE
        registries_error
        TYPE
        "${vcpkg_configuration_json}"
        "registries"
    )
    if(registries_error
       STREQUAL
       "NOTFOUND"
       AND registries_type
           STREQUAL
           "ARRAY"
    )
        string(
            JSON registry_count
            LENGTH "${vcpkg_configuration_json}" "registries"
        )
        if(registry_count
           GREATER
           0
        )
            math(
                EXPR
                registry_last
                "${registry_count} - 1"
            )
            foreach(
                registry_index
                RANGE 0 ${registry_last}
            )
                string(
                    JSON
                    registry_kind
                    ERROR_VARIABLE
                    registry_kind_error
                    GET
                    "${vcpkg_configuration_json}"
                    "registries"
                    ${registry_index}
                    "kind"
                )
                if(registry_kind_error
                   STREQUAL
                   "NOTFOUND"
                   AND registry_kind
                       STREQUAL
                       "filesystem"
                )
                    string(
                        JSON
                        filesystem_registry_relative_path
                        ERROR_VARIABLE
                        filesystem_registry_path_error
                        GET
                        "${vcpkg_configuration_json}"
                        "registries"
                        ${registry_index}
                        "path"
                    )
                    if(NOT
                       filesystem_registry_path_error
                       STREQUAL
                       "NOTFOUND"
                    )
                        canary_shared_cache_reset_managed_install(
                            "a filesystem registry does not define a valid path"
                        )
                        return()
                    endif()
                    get_filename_component(
                        filesystem_registry_root
                        "${filesystem_registry_relative_path}"
                        ABSOLUTE
                        BASE_DIR
                        "${manifest_root}"
                    )
                    if(NOT
                       IS_DIRECTORY
                       "${filesystem_registry_root}"
                    )
                        canary_shared_cache_reset_managed_install(
                            "a filesystem registry directory is missing"
                        )
                        return()
                    endif()
                    math(
                        EXPR
                        filesystem_registry_index
                        "${filesystem_registry_index} + 1"
                    )
                    canary_shared_cache_tree_signature(
                        "filesystem-registry-${filesystem_registry_index}"
                        "${filesystem_registry_root}"
                        filesystem_registry_signature
                    )
                    string(
                        APPEND
                        fingerprint_input
                        "${filesystem_registry_signature}"
                    )
                endif()
            endforeach()
        endif()
    endif()
endif()

set(effective_overlay_ports
    ${variable_overlay_ports}
    ${install_option_overlay_ports}
    ${configuration_overlay_ports}
    ${environment_overlay_ports}
)
set(effective_overlay_triplets
    ${variable_overlay_triplets}
    ${install_option_overlay_triplets}
    ${configuration_overlay_triplets}
    ${environment_overlay_triplets}
)

set(overlay_index
    0
)
foreach(
    overlay_root IN
    LISTS effective_overlay_ports
)
    math(
        EXPR
        overlay_index
        "${overlay_index} + 1"
    )
    canary_shared_cache_tree_signature(
        "overlay-port-${overlay_index}"
        "${overlay_root}"
        overlay_signature
    )
    string(
        APPEND
        fingerprint_input
        "${overlay_signature}"
    )
endforeach()
if(overlay_index
   EQUAL
   0
)
    string(
        APPEND
        fingerprint_input
        "overlay-ports=<none>\n"
    )
endif()

set(overlay_triplet_index
    0
)
foreach(
    overlay_triplet_root IN
    LISTS effective_overlay_triplets
)
    math(
        EXPR
        overlay_triplet_index
        "${overlay_triplet_index} + 1"
    )
    canary_shared_cache_tree_signature(
        "overlay-triplet-${overlay_triplet_index}"
        "${overlay_triplet_root}"
        overlay_triplet_signature
    )
    string(
        APPEND
        fingerprint_input
        "${overlay_triplet_signature}"
    )
endforeach()
if(overlay_triplet_index
   EQUAL
   0
)
    string(
        APPEND
        fingerprint_input
        "overlay-triplets=<none>\n"
    )
endif()

foreach(
    triplet_kind IN
    ITEMS TARGET HOST
)
    if(triplet_kind
       STREQUAL
       "TARGET"
    )
        set(triplet_name
            "${VCPKG_TARGET_TRIPLET}"
        )
    else()
        set(triplet_name
            "${VCPKG_HOST_TRIPLET}"
        )
    endif()

    if(NOT triplet_name)
        set(triplet_name
            "<auto>"
        )
    endif()
    string(
        APPEND
        fingerprint_input
        "${triplet_kind}-triplet=${triplet_name}\n"
    )

    set(triplet_file)
    if(NOT
       triplet_name
       STREQUAL
       "<auto>"
    )
        set(effective_overlay_triplet_roots
            ${effective_overlay_triplets}
        )
        list(REMOVE_DUPLICATES effective_overlay_triplet_roots)
        foreach(
            overlay_triplet_root IN
            LISTS effective_overlay_triplet_roots
        )
            if(EXISTS "${overlay_triplet_root}/${triplet_name}.cmake")
                set(triplet_file
                    "${overlay_triplet_root}/${triplet_name}.cmake"
                )
                break()
            endif()
        endforeach()
        if(NOT triplet_file
           AND EXISTS "${vcpkg_root}/triplets/${triplet_name}.cmake"
        )
            set(triplet_file
                "${vcpkg_root}/triplets/${triplet_name}.cmake"
            )
        elseif(
            NOT triplet_file
            AND EXISTS "${vcpkg_root}/triplets/community/${triplet_name}.cmake"
        )
            set(triplet_file
                "${vcpkg_root}/triplets/community/${triplet_name}.cmake"
            )
        endif()
    endif()

    canary_shared_cache_file_signature(
        "${triplet_kind}-triplet-file"
        "${triplet_file}"
        triplet_signature
    )
    if(NOT triplet_file)
        canary_shared_cache_reset_managed_install(
            "the ${triplet_kind} triplet file cannot be identified"
        )
        return()
    endif()
    set(${triplet_kind}_triplet_file_path
        "${triplet_file}"
    )
    string(
        APPEND
        fingerprint_input
        "${triplet_signature}"
    )
endforeach()

set(vcpkg_compiler_selection_signature
    "vcpkg-compiler-selection=<platform-default>\n"
)
set(vcpkg_visual_studio_root)
if(WIN32)
    foreach(
        selected_triplet_file IN
        ITEMS "${TARGET_triplet_file_path}" "${HOST_triplet_file_path}"
    )
        file(
            STRINGS
            "${selected_triplet_file}"
            triplet_contract_lines
        )
        foreach(
            triplet_contract_line IN
            LISTS triplet_contract_lines
        )
            string(STRIP "${triplet_contract_line}" triplet_contract_line)
            if(NOT
               triplet_contract_line
               MATCHES
               "^#"
               AND (triplet_contract_line
                    MATCHES
                    "VCPKG_VISUAL_STUDIO_PATH"
                    OR triplet_contract_line
                       MATCHES
                       "^include[ \\t]*\\("
                   )
            )
                canary_shared_cache_reset_managed_install(
                    "the selected Windows triplet can override Visual Studio selection indirectly"
                )
                return()
            endif()
        endforeach()
    endforeach()

    if(DEFINED ENV{VCPKG_VISUAL_STUDIO_PATH}
       AND NOT
           "$ENV{VCPKG_VISUAL_STUDIO_PATH}"
           STREQUAL
           ""
    )
        set(vcpkg_visual_studio_candidate
            "$ENV{VCPKG_VISUAL_STUDIO_PATH}"
        )
    elseif(
        DEFINED ENV{CANARY_VCPKG_VISUAL_STUDIO_PATH}
        AND NOT
            "$ENV{CANARY_VCPKG_VISUAL_STUDIO_PATH}"
            STREQUAL
            ""
    )
        set(vcpkg_visual_studio_candidate
            "$ENV{CANARY_VCPKG_VISUAL_STUDIO_PATH}"
        )
    endif()

    if(NOT vcpkg_visual_studio_candidate)
        canary_shared_cache_reset_managed_install(
            "the vcpkg Visual Studio instance is not pinned"
        )
        return()
    endif()

    get_filename_component(
        vcpkg_visual_studio_root
        "${vcpkg_visual_studio_candidate}"
        ABSOLUTE
    )
    if(NOT
       IS_DIRECTORY
       "${vcpkg_visual_studio_root}/VC/Tools/MSVC"
       OR NOT
          EXISTS
          "${vcpkg_visual_studio_root}/VC/Auxiliary/Build/vcvarsall.bat"
    )
        canary_shared_cache_reset_managed_install(
            "the pinned vcpkg Visual Studio path is not a complete C++ installation"
        )
        return()
    endif()
    file(
        REAL_PATH
        "${vcpkg_visual_studio_root}"
        vcpkg_visual_studio_root
    )
    file(
        TO_NATIVE_PATH
        "${vcpkg_visual_studio_root}"
        vcpkg_visual_studio_native
    )
    set(ENV{VCPKG_VISUAL_STUDIO_PATH}
        "${vcpkg_visual_studio_native}"
    )

    canary_shared_cache_normalize_path("${vcpkg_visual_studio_root}"
                                       normalized_vcpkg_visual_studio_root
    )
    canary_shared_cache_msvc_signature(
        "${vcpkg_visual_studio_root}"
        vcpkg_msvc_signature
        vcpkg_msvc_found
    )
    if(NOT vcpkg_msvc_found)
        canary_shared_cache_reset_managed_install(
            "no MSVC compiler exists below VCPKG_VISUAL_STUDIO_PATH"
        )
        return()
    endif()
    canary_shared_cache_file_signature(
        "vcpkg-vcvarsall"
        "${vcpkg_visual_studio_root}/VC/Auxiliary/Build/vcvarsall.bat"
        vcpkg_vcvarsall_signature
    )
    canary_shared_cache_file_signature(
        "vcpkg-msbuild"
        "${vcpkg_visual_studio_root}/MSBuild/Current/Bin/amd64/MSBuild.exe"
        vcpkg_msbuild_signature
    )
    set(vcpkg_compiler_selection_signature
        "vcpkg-visual-studio-root=${normalized_vcpkg_visual_studio_root}\n${vcpkg_msvc_signature}${vcpkg_vcvarsall_signature}${vcpkg_msbuild_signature}"
    )
endif()

string(
    APPEND
    fingerprint_input
    "${vcpkg_compiler_selection_signature}"
)

if(VCPKG_CHAINLOAD_TOOLCHAIN_FILE)
    canary_shared_cache_file_signature(
        "chainload-toolchain"
        "${VCPKG_CHAINLOAD_TOOLCHAIN_FILE}"
        chainload_signature
    )
    string(
        APPEND
        fingerprint_input
        "${chainload_signature}"
    )
else()
    string(
        APPEND
        fingerprint_input
        "chainload-toolchain=<none>\n"
    )
endif()

string(SHA256 dependency_fingerprint "${fingerprint_input}")

set(shared_cache_consumer
    "cmake"
)
if(DEFINED CANARY_SHARED_CACHE_CONSUMER
   AND NOT
       CANARY_SHARED_CACHE_CONSUMER
       STREQUAL
       ""
)
    string(TOLOWER "${CANARY_SHARED_CACHE_CONSUMER}" shared_cache_consumer)
endif()

set(consumer_fingerprint_input
    "schema=${CANARY_SHARED_CACHE_SCHEMA}\n"
    "implementation-sha256=${CANARY_SHARED_CACHE_IMPLEMENTATION_SHA256}\n"
    "dependency-fingerprint=${dependency_fingerprint}\n"
    "consumer=${shared_cache_consumer}\n"
)
if(shared_cache_consumer
   STREQUAL
   "cmake"
)
    string(
        APPEND
        consumer_fingerprint_input
        "generator=${CMAKE_GENERATOR}\n"
        "generator-platform=${CMAKE_GENERATOR_PLATFORM}\n"
        "generator-toolset=${CMAKE_GENERATOR_TOOLSET}\n"
        "cmake-version=${CMAKE_VERSION}\n"
        "cmake-sha256=${cmake_executable_hash}\n"
    )
elseif(
    shared_cache_consumer
    STREQUAL
    "msbuild"
)
    if(NOT CANARY_SHARED_CACHE_CONSUMER_TOOL)
        message(
            FATAL_ERROR
                "The MSBuild consumer contract requires CANARY_SHARED_CACHE_CONSUMER_TOOL"
        )
    endif()
    canary_shared_cache_resolve_program("${CANARY_SHARED_CACHE_CONSUMER_TOOL}"
                                        consumer_tool_path
    )
    if(NOT consumer_tool_path)
        message(
            FATAL_ERROR
                "The MSBuild consumer executable cannot be identified: ${CANARY_SHARED_CACHE_CONSUMER_TOOL}"
        )
    endif()
    file(
        SHA256
        "${consumer_tool_path}"
        consumer_tool_hash
    )
    get_filename_component(
        consumer_tool_name
        "${consumer_tool_path}"
        NAME
    )
    string(
        APPEND
        consumer_fingerprint_input
        "consumer-tool-name=${consumer_tool_name}\n"
        "consumer-tool-sha256=${consumer_tool_hash}\n"
    )
    foreach(
        consumer_setting IN
        ITEMS CANARY_SHARED_CACHE_CONSUMER_CONFIGURATION
              CANARY_SHARED_CACHE_CONSUMER_PLATFORM
              CANARY_SHARED_CACHE_CONSUMER_LINK_CONFIGURATION
              CANARY_SHARED_CACHE_CONSUMER_TOOLSET
              CANARY_SHARED_CACHE_CONSUMER_SDK
    )
        if(DEFINED ${consumer_setting})
            set(consumer_setting_value
                "${${consumer_setting}}"
            )
        else()
            set(consumer_setting_value
                "<unset>"
            )
        endif()
        string(
            APPEND
            consumer_fingerprint_input
            "${consumer_setting}=${consumer_setting_value}\n"
        )
    endforeach()
else()
    message(
        FATAL_ERROR
            "Unsupported shared-cache consumer '${shared_cache_consumer}'"
    )
endif()
string(SHA256 consumer_fingerprint "${consumer_fingerprint_input}")

if(CANARY_SHARED_CACHE_FINGERPRINT_INPUT_FILE)
    get_filename_component(
        fingerprint_input_file
        "${CANARY_SHARED_CACHE_FINGERPRINT_INPUT_FILE}"
        ABSOLUTE
        BASE_DIR
        "${CMAKE_BINARY_DIR}"
    )
    file(
        WRITE "${fingerprint_input_file}"
        "[dependency]\n${fingerprint_input}[consumer]\n${consumer_fingerprint_input}"
    )
endif()

set(cache_fingerprint
    "${dependency_fingerprint}"
)
string(
    SUBSTRING "${dependency_fingerprint}"
              0
              24
              short_fingerprint
)
set(shared_installed_root
    "${shared_cache_root}/vcpkg-installed/${CANARY_SHARED_CACHE_SCHEMA}/${short_fingerprint}"
)
set(shared_metadata_root
    "${shared_cache_root}/metadata/${CANARY_SHARED_CACHE_SCHEMA}"
)
set(shared_buildtrees_root
    "${shared_cache_root}/vcpkg-buildtrees/${CANARY_SHARED_CACHE_SCHEMA}/${short_fingerprint}"
)
set(shared_packages_root
    "${shared_cache_root}/vcpkg-packages/${CANARY_SHARED_CACHE_SCHEMA}/${short_fingerprint}"
)

if(CMAKE_PROJECT_NAME
   AND NOT CANARY_SHARED_VCPKG_MANAGED
   AND VCPKG_INSTALLED_DIR
)
    canary_shared_cache_normalize_path("${VCPKG_INSTALLED_DIR}"
                                       previous_unmanaged_installed_root
    )
    canary_shared_cache_normalize_path("${shared_installed_root}"
                                       expected_unmanaged_installed_root
    )
    if(NOT
       previous_unmanaged_installed_root
       STREQUAL
       expected_unmanaged_installed_root
    )
        message(
            FATAL_ERROR
                "This configured build tree uses a different vcpkg installation contract. Re-run cmake --fresh --preset <configure-preset> before enabling the shared pool."
        )
    endif()
endif()

if(CANARY_SHARED_VCPKG_MANAGED)
    if(NOT
       DEFINED
       CANARY_VCPKG_CACHE_FINGERPRINT
       OR NOT
          CANARY_VCPKG_CACHE_FINGERPRINT
          STREQUAL
          cache_fingerprint
    )
        message(
            FATAL_ERROR
                "The shared vcpkg fingerprint changed. Cached package paths cannot be migrated safely in place. Re-run cmake --fresh --preset <configure-preset>."
        )
    endif()

    if(NOT
       DEFINED
       CANARY_VCPKG_CONSUMER_FINGERPRINT
       OR NOT
          CANARY_VCPKG_CONSUMER_FINGERPRINT
          STREQUAL
          consumer_fingerprint
    )
        message(
            FATAL_ERROR
                "The shared vcpkg consumer fingerprint changed. Cached build-system paths cannot be migrated safely in place. Re-run cmake --fresh --preset <configure-preset>."
        )
    endif()

    canary_shared_cache_normalize_path("${VCPKG_INSTALLED_DIR}"
                                       previous_installed_root
    )
    canary_shared_cache_normalize_path("${shared_installed_root}"
                                       expected_installed_root
    )
    if(NOT
       previous_installed_root
       STREQUAL
       expected_installed_root
    )
        message(
            FATAL_ERROR
                "The managed VCPKG_INSTALLED_DIR does not match its fingerprint. Re-run cmake --fresh --preset <configure-preset>."
        )
    endif()
endif()

if(CANARY_SHARED_CACHE_READ_ONLY)
    if(CANARY_SHARED_CACHE_RESULT_FILE)
        get_filename_component(
            shared_cache_result_file
            "${CANARY_SHARED_CACHE_RESULT_FILE}"
            ABSOLUTE
            BASE_DIR
            "${CMAKE_BINARY_DIR}"
        )
        file(
            WRITE "${shared_cache_result_file}"
            "active=true\n"
            "schema=${CANARY_SHARED_CACHE_SCHEMA}\n"
            "implementation-sha256=${CANARY_SHARED_CACHE_IMPLEMENTATION_SHA256}\n"
            "dependency-fingerprint=${dependency_fingerprint}\n"
            "consumer-fingerprint=${consumer_fingerprint}\n"
            "installed-root=${shared_installed_root}\n"
            "buildtrees-root=${shared_buildtrees_root}\n"
            "packages-root=${shared_packages_root}\n"
            "target-triplet=${VCPKG_TARGET_TRIPLET}\n"
            "host-triplet=${VCPKG_HOST_TRIPLET}\n"
        )
    endif()
    message(
        STATUS
            "Shared vcpkg dependency fingerprint: ${shared_installed_root} (${dependency_fingerprint}); consumer ${consumer_fingerprint}"
    )
    return()
endif()

file(MAKE_DIRECTORY "${shared_installed_root}")
file(MAKE_DIRECTORY "${shared_metadata_root}")
file(MAKE_DIRECTORY "${shared_buildtrees_root}")
file(MAKE_DIRECTORY "${shared_packages_root}")

set(fingerprint_identity_path
    "${shared_metadata_root}/${short_fingerprint}.txt"
)
set(fingerprint_identity_lock_path
    "${shared_metadata_root}/${short_fingerprint}.lock"
)
file(
    LOCK "${fingerprint_identity_lock_path}"
    GUARD FILE
    TIMEOUT 30
    RESULT_VARIABLE fingerprint_identity_lock_result
)
if(NOT
   fingerprint_identity_lock_result
   EQUAL
   0
)
    message(
        FATAL_ERROR
            "Unable to acquire the shared-cache fingerprint identity lock: ${fingerprint_identity_lock_result}"
    )
endif()
if(EXISTS "${fingerprint_identity_path}")
    file(
        STRINGS
        "${fingerprint_identity_path}"
        existing_fingerprint_lines
        REGEX "^fingerprint="
        LIMIT_COUNT 1
    )
    if(NOT
       existing_fingerprint_lines
       STREQUAL
       "fingerprint=${cache_fingerprint}"
    )
        message(
            FATAL_ERROR
                "A shared-cache directory prefix collision or corrupt identity was detected for ${short_fingerprint}. Refusing to reuse the mutable pool."
        )
    endif()
endif()

set(VCPKG_INSTALL_OPTIONS
    ${canary_base_vcpkg_install_options}
    "--x-buildtrees-root=${shared_buildtrees_root}"
    "--x-packages-root=${shared_packages_root}"
    CACHE STRING
          "Options passed to vcpkg manifest installation"
          FORCE
)

set(metadata
    "schema=${CANARY_SHARED_CACHE_SCHEMA}\n"
)
string(
    APPEND
    metadata
    "implementation-sha256=${CANARY_SHARED_CACHE_IMPLEMENTATION_SHA256}\n"
    "fingerprint=${dependency_fingerprint}\n"
    "dependency-fingerprint=${dependency_fingerprint}\n"
    "cxx-compiler=${cxx_compiler_name}\n"
    "cxx-compiler-sha256=${cxx_compiler_hash}\n"
    "c-compiler=${c_compiler_name}\n"
    "c-compiler-sha256=${c_compiler_hash}\n"
    "target-triplet=${VCPKG_TARGET_TRIPLET}\n"
    "host-triplet=${VCPKG_HOST_TRIPLET}\n"
    "vcpkg-revision=${vcpkg_revision}\n"
    "vcpkg-visual-studio=${vcpkg_visual_studio_root}\n"
    "buildtrees-root=${shared_buildtrees_root}\n"
    "packages-root=${shared_packages_root}\n"
)
file(
    WRITE "${fingerprint_identity_path}"
    "${metadata}"
)
file(
    LOCK
    "${fingerprint_identity_lock_path}"
    RELEASE
)

set(VCPKG_INSTALLED_DIR
    "${shared_installed_root}"
    CACHE PATH
          "Content-addressed vcpkg installation shared by compatible worktrees"
          FORCE
)
set(CANARY_VCPKG_CACHE_FINGERPRINT
    "${dependency_fingerprint}"
    CACHE INTERNAL
          "Fingerprint of the shared vcpkg installation contract"
          FORCE
)
set(CANARY_VCPKG_DEPENDENCY_FINGERPRINT
    "${dependency_fingerprint}"
    CACHE INTERNAL
          "Build-system-neutral vcpkg dependency fingerprint"
          FORCE
)
set(CANARY_VCPKG_CONSUMER_FINGERPRINT
    "${consumer_fingerprint}"
    CACHE INTERNAL
          "Build-system-specific consumer fingerprint"
          FORCE
)
set(CANARY_SHARED_VCPKG_MANAGED
    true
    CACHE INTERNAL
          "Whether Canary owns VCPKG_INSTALLED_DIR"
          FORCE
)
set(CANARY_SHARED_VCPKG_BUILDTREES_ROOT
    "${shared_buildtrees_root}"
    CACHE INTERNAL
          "Managed vcpkg buildtrees root"
          FORCE
)
set(CANARY_SHARED_VCPKG_PACKAGES_ROOT
    "${shared_packages_root}"
    CACHE INTERNAL
          "Managed vcpkg packages root"
          FORCE
)
set(CANARY_SHARED_VCPKG_ACTIVE
    true
    CACHE INTERNAL
          "Whether the shared vcpkg installed tree is active"
          FORCE
)

if(NOT CMAKE_SCRIPT_MODE_FILE)
    file(
        WRITE "${CMAKE_BINARY_DIR}/canary-shared-cache.txt"
        "dependency-fingerprint=${dependency_fingerprint}\nconsumer-fingerprint=${consumer_fingerprint}\ninstalled=${shared_installed_root}\n"
    )
endif()

if(CANARY_SHARED_CACHE_RESULT_FILE)
    get_filename_component(
        shared_cache_result_file
        "${CANARY_SHARED_CACHE_RESULT_FILE}"
        ABSOLUTE
        BASE_DIR
        "${CMAKE_BINARY_DIR}"
    )
    file(
        WRITE "${shared_cache_result_file}"
        "active=true\n"
        "schema=${CANARY_SHARED_CACHE_SCHEMA}\n"
        "implementation-sha256=${CANARY_SHARED_CACHE_IMPLEMENTATION_SHA256}\n"
        "dependency-fingerprint=${dependency_fingerprint}\n"
        "consumer-fingerprint=${consumer_fingerprint}\n"
        "installed-root=${shared_installed_root}\n"
        "buildtrees-root=${shared_buildtrees_root}\n"
        "packages-root=${shared_packages_root}\n"
        "target-triplet=${VCPKG_TARGET_TRIPLET}\n"
        "host-triplet=${VCPKG_HOST_TRIPLET}\n"
    )
endif()

if(CANARY_SHARED_CACHE_PREPARE_ONLY)
    message(
        STATUS
            "Prepared shared vcpkg dependency contract: ${shared_installed_root} (${short_fingerprint})"
    )
    return()
endif()

message(
    STATUS
        "Shared vcpkg installed tree: ${shared_installed_root} (${short_fingerprint})"
)
