# git_watcher.cmake
# https://raw.githubusercontent.com/andrew-hardin/cmake-git-version-tracking/master/git_watcher.cmake
#
# Released under the MIT License.
# https://raw.githubusercontent.com/andrew-hardin/cmake-git-version-tracking/master/LICENSE

# This file defines a target that monitors the state of a git repo. If the state
# changes (e.g. a commit is made), then a file gets reconfigured. Here are the
# primary variables that control script behavior:
#
# PRE_CONFIGURE_FILE (REQUIRED) -- The path to the file that'll be configured.
#
# POST_CONFIGURE_FILE (REQUIRED) -- The path to the configured
# PRE_CONFIGURE_FILE.
#
# GIT_STATE_FILE (OPTIONAL) -- The path to the file used to store the previous
# build's git state. Defaults to the current binary directory.
#
# GIT_WORKING_DIR (OPTIONAL) -- The directory from which git commands will be
# run. Defaults to the directory with the top level CMakeLists.txt.
#
# GIT_EXECUTABLE (OPTIONAL) -- The path to the git executable. It'll
# automatically be set if the user doesn't supply a path.
#
# DESIGN - This script was designed similar to a Python application with a
# main() function. I wanted to keep it compact to simplify "copy + paste" usage.
#
# * This script is invoked under two CMake contexts: 1. Configure time (when
#   build files are created). 2. Build time (called via CMake -P). The first
#   invocation is what registers the script to be executed at build time.
#
# MODIFICATIONS You may wish to track other git properties like when the last
# commit was made. There are two sections you need to modify, and they're tagged
# with a ">>>" header.

# Short hand for converting paths to absolute.
macro(path_to_absolute var_name)
    get_filename_component(
        ${var_name}
        "${${var_name}}"
        ABSOLUTE
    )
endmacro()

# Check that a required variable is set.
macro(check_required_variable var_name)
    if(NOT
       DEFINED
       ${var_name}
    )
        message(FATAL_ERROR "The \"${var_name}\" variable must be defined.")
    endif()
    path_to_absolute(${var_name})
endmacro()

# Check that an optional variable is set, or, set it to a default value.
macro(
    check_optional_variable
    var_name
    default_value
)
    if(NOT
       DEFINED
       ${var_name}
    )
        set(${var_name}
            ${default_value}
        )
    endif()
    path_to_absolute(${var_name})
endmacro()

check_required_variable(PRE_CONFIGURE_FILE)
check_required_variable(POST_CONFIGURE_FILE)
check_optional_variable(GIT_STATE_FILE "${CMAKE_BINARY_DIR}/git-state-hash")
check_optional_variable(GIT_WORKING_DIR "${CMAKE_SOURCE_DIR}")

# Check the optional git variable. If it's not set, we'll try to find it using
# the CMake packaging system.
if(NOT
   DEFINED
   GIT_EXECUTABLE
)
    find_package(Git QUIET)
    if(NOT Git_FOUND)
        return()
    endif()
endif()
check_required_variable(GIT_EXECUTABLE)

set(_state_variable_names
    GIT_RETRIEVED_STATE
    GIT_HEAD_SHA1
    GIT_IS_DIRTY
    GIT_AUTHOR_NAME
    GIT_AUTHOR_EMAIL
    GIT_COMMIT_DATE_ISO8601
    GIT_COMMIT_SUBJECT
    GIT_COMMIT_BODY
    # GIT_SHORT_SHA1 GIT_DESCRIBE >>> 1. Add the name of the additional git
    # variable you're interested in monitoring to this list.
)

# Macro: run_git_command Description: short-hand macro for calling a git
# function. Outputs are the "exit_code" and "output" variables.
macro(run_git_command)
    execute_process(
        COMMAND "${GIT_EXECUTABLE}" ${ARGV}
        WORKING_DIRECTORY "${_working_dir}"
        RESULT_VARIABLE exit_code
        OUTPUT_VARIABLE output
        ERROR_QUIET OUTPUT_STRIP_TRAILING_WHITESPACE
    )
    if(NOT
       exit_code
       EQUAL
       0
    )
        set(ENV{GIT_RETRIEVED_STATE}
            "false"
        )
    endif()
endmacro()

# Function: get_git_state Description: gets the current state of the git repo.
# Args: _working_dir (in)  string; the directory from which git commands will be
# executed.
function(get_git_state _working_dir)

    # This is an error code that'll be set to FALSE if the run_git_command ever
    # returns a non-zero exit code.
    set(ENV{GIT_RETRIEVED_STATE}
        "true"
    )

    # Get whether or not the working tree is dirty.
    run_git_command(status --porcelain)
    if(NOT
       exit_code
       EQUAL
       0
    )
        set(ENV{GIT_IS_DIRTY}
            "false"
        )
    else()
        if(NOT
           "${output}"
           STREQUAL
           ""
        )
            set(ENV{GIT_IS_DIRTY}
                "true"
            )
        else()
            set(ENV{GIT_IS_DIRTY}
                "false"
            )
        endif()
    endif()

    # There's a long list of attributes grabbed from git show.
    set(object
        HEAD
    )
    run_git_command(
        show
        -s
        "--format=%H"
        ${object}
    )
    if(exit_code
       EQUAL
       0
    )
        set(ENV{GIT_HEAD_SHA1}
            ${output}
        )
    endif()

    run_git_command(
        show
        -s
        "--format=%an"
        ${object}
    )
    if(exit_code
       EQUAL
       0
    )
        set(ENV{GIT_AUTHOR_NAME}
            "${output}"
        )
    endif()

    run_git_command(
        show
        -s
        "--format=%ae"
        ${object}
    )
    if(exit_code
       EQUAL
       0
    )
        set(ENV{GIT_AUTHOR_EMAIL}
            "${output}"
        )
    endif()

    run_git_command(
        show
        -s
        "--format=%cI"
        ${object}
    )
    if(exit_code
       EQUAL
       0
    )
        set(ENV{GIT_COMMIT_DATE_ISO8601}
            "${output}"
        )
    endif()

    run_git_command(
        show
        -s
        "--format=%s"
        ${object}
    )
    if(exit_code
       EQUAL
       0
    )
        set(ENV{GIT_COMMIT_SUBJECT}
            "${output}"
        )
    endif()

    run_git_command(
        show
        -s
        "--format=%b"
        ${object}
    )
    if(exit_code
       EQUAL
       0
    )
        set(ENV{GIT_COMMIT_BODY}
            "${output}"
        )
    endif()

    # run_git_command(rev-parse --short ${object}) if(exit_code EQUAL 0)
    # set(ENV{GIT_SHORT_SHA1} ${output}) endif()

    # run_git_command(describe --tags "--match=v*" ${object}) if(exit_code EQUAL
    # 0) set(ENV{GIT_DESCRIBE} "${output}") endif()

    # >>> 2. Additional git properties can be added here via the
    # "execute_process()" command. Be sure to set them in the environment using
    # the same variable name you added to the "_state_variable_names" list.

endfunction()

# Function: git_state_changed_action Description: this function is executed when
# the state of the git repository changes (e.g. a commit is made).
function(git_state_changed_action)
    foreach(
        var_name
        ${_state_variable_names}
    )
        set(${var_name}
            $ENV{${var_name}}
        )
    endforeach()
    configure_file(
        "${PRE_CONFIGURE_FILE}"
        "${POST_CONFIGURE_FILE}"
        @ONLY
    )
endfunction()

# Function: hash_git_state Description: loop through the git state variables and
# compute a unique hash. Args: _state (out)  string; a hash computed from the
# current git state.
function(hash_git_state _state)
    set(ans
        ""
    )
    foreach(
        var_name
        ${_state_variable_names}
    )
        string(SHA256 ans "${ans}$ENV{${var_name}}")
    endforeach()
    set(${_state}
        ${ans}
        PARENT_SCOPE
    )
endfunction()

# Function: check_git Description: check if the git repo has changed. If so,
# update the state file. Args: _working_dir    (in)  string; the directory from
# which git commands will be ran. _state_changed (out)    bool; whether or no
# the state of the repo has changed.
function(
    check_git
    _working_dir
    _state_changed
)

    # Get the current state of the repo.
    get_git_state("${_working_dir}")

    # Convert that state into a hash that we can compare against the hash stored
    # on-disk.
    hash_git_state(state)

    # Check if the state has changed compared to the backup on disk.
    if(EXISTS "${GIT_STATE_FILE}")
        file(
            READ
            "${GIT_STATE_FILE}"
            OLD_HEAD_CONTENTS
        )
        if(OLD_HEAD_CONTENTS
           STREQUAL
           "${state}"
        )
            # State didn't change.
            set(${_state_changed}
                "false"
                PARENT_SCOPE
            )
            return()
        endif()
    endif()

    # The state has changed. We need to update the state file on disk. Future
    # builds will compare their state to this file.
    file(
        WRITE "${GIT_STATE_FILE}"
        "${state}"
    )
    set(${_state_changed}
        "true"
        PARENT_SCOPE
    )
endfunction()

# Function: setup_git_monitoring Description: this function sets up custom
# commands that make the build system check the state of git before every build.
# If the state has changed, then a file is configured.
function(setup_git_monitoring)
    add_custom_target(
        check_git ALL
        DEPENDS ${PRE_CONFIGURE_FILE}
        BYPRODUCTS ${POST_CONFIGURE_FILE} ${GIT_STATE_FILE}
        COMMENT "Checking the git repository for changes..."
        COMMAND
            ${CMAKE_COMMAND} -D_BUILD_TIME_CHECK_GIT=TRUE
            -DGIT_WORKING_DIR=${GIT_WORKING_DIR}
            -DGIT_EXECUTABLE=${GIT_EXECUTABLE}
            -DGIT_STATE_FILE=${GIT_STATE_FILE}
            -DPRE_CONFIGURE_FILE=${PRE_CONFIGURE_FILE}
            -DPOST_CONFIGURE_FILE=${POST_CONFIGURE_FILE} -P
            "${CMAKE_CURRENT_LIST_FILE}"
    )
endfunction()

# Function: main Description: primary entry-point to the script. Functions are
# selected based on whether it's configure or build time.
function(main)
    if(_BUILD_TIME_CHECK_GIT)
        # Check if the repo has changed. If so, run the change action.
        check_git("${GIT_WORKING_DIR}" changed)
        if(changed
           OR NOT
              EXISTS
              "${POST_CONFIGURE_FILE}"
        )
            git_state_changed_action()
        endif()
    else()
        # >> Executes at configure time.
        setup_git_monitoring()
    endif()
endfunction()

# And off we go...
main()
