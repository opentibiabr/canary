if(NOT BUILD_TESTING)
    return()
endif()

# --- boost::ut (handle common package/target name variants) ---
# Try the canonical package name first (as used by the project), then fall back
# to popular alt names in package managers.
set(_ut_targets)
find_package(
    Boost.UT
    CONFIG
    QUIET
)
if(Boost.UT_FOUND)
    list(
        APPEND
        _ut_targets
        Boost::ut
    )
else()
    find_package(
        boost_ut
        CONFIG
        QUIET
    ) # some distros
    if(boost_ut_FOUND)
        list(
            APPEND
            _ut_targets
            boost::ut
        )
    else()
        find_package(
            ut
            CONFIG
            QUIET
        ) # your original
        if(ut_FOUND)
            # guessing an imported target name; adjust if your toolchain differs
            list(
                APPEND
                _ut_targets
                Boost::ut
            )
        endif()
    endif()
endif()

if(NOT _ut_targets)
    message(
        FATAL_ERROR
            "Could not find boost::ut. Try installing via vcpkg (boost-ut) or add FetchContent in the root."
    )
endif()

# Utility to pick the first found target (Boost::ut OR boost::ut)
list(
    GET
    _ut_targets
    0
    UT_IMPORTED_TARGET
)

enable_testing()

# ---------------------------
# Helper: define one test exe
# ---------------------------
function(
    setup_test
    TARGET_NAME
    DIR
)
    add_executable(
        ${TARGET_NAME}
        ${CMAKE_CURRENT_LIST_DIR}/main.cpp
    )

    # Your project-specific knobs
    target_compile_definitions(
        ${TARGET_NAME}
        PUBLIC -DDEBUG_LOG -DBUILD_TESTS
    )
    target_link_libraries(
        ${TARGET_NAME}
        PRIVATE ${UT_IMPORTED_TARGET} ${PROJECT_NAME}_lib
    )
    target_include_directories(
        ${TARGET_NAME}
        PRIVATE ${CMAKE_SOURCE_DIR}/tests/fixture
                ${CMAKE_SOURCE_DIR}/tests/${DIR}
    )
    target_compile_features(
        ${TARGET_NAME}
        PRIVATE cxx_std_20
    )

    # Keep your hooks
    setup_target(${TARGET_NAME})
    configure_linking(${TARGET_NAME})

    # Turn OFF unity/IPO for tests (tests benefit from fast rebuilds &
    # debugging)
    set_target_properties(
        ${TARGET_NAME}
        PROPERTIES UNITY_BUILD OFF
                   INTERPROCEDURAL_OPTIMIZATION OFF
    )
    log_option_disabled("Build unity")

    # Register with ctest. boost::ut doesn’t use Catch2-style CLI; just run the
    # binary.
    add_test(
        NAME ${DIR}
        COMMAND ${TARGET_NAME}
    )

    # Per-test runtime context
    set_tests_properties(
        ${DIR}
        PROPERTIES WORKING_DIRECTORY
                   ${CMAKE_BINARY_DIR}/tests/${DIR}
                   TIMEOUT
                   120
    )
endfunction()

# Suites (each subdir calls setup_test(...) for its cases)
add_subdirectory(unit)
add_subdirectory(integration)
