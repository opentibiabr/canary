## Testing

### Running tests

Tests can be run directly from the repository root using CMake test presets. First, configure and build tests for your platform:

```bash
# Configure and build tests
cmake --preset linux-debug && cmake --build --preset linux-debug

# Run all tests
ctest --preset linux-debug

# Run only unit tests
ctest --preset linux-debug -R unit

# Run only integration tests
ctest --preset linux-debug -R integration

# Use -VV for verbose output showing individual test cases
ctest --preset linux-debug -VV
```

Replace `linux-debug` with `macos-debug` or `windows-debug` for other platforms.

On Windows, the release test preset can also be used when validating the same build style used by the Windows release test configuration:

```powershell
cmake --preset windows-release-enabled-tests
cmake --build --preset windows-release-enabled-tests
.\build\windows-release-enabled-tests\tests\unit\canary_ut.exe
.\build\windows-release-enabled-tests\tests\integration\canary_it.exe
```

### Integration test database

Integration tests use the database configured by `tests/test.env` unless `TEST_ENV_FILE` points to another env file. The default database is `canary_test`, which is intended to be disposable.

When `TEST_DB_ALLOW_RESET=1`, the integration test executable checks schema sentinel columns before connecting. If a sentinel differs from the expected `schema.sql` shape, it drops and recreates the test database, then imports `schema.sql` using the `mysql` client. This reset is only allowed for database names that look like test databases.

Set `TEST_DB_SCHEMA` if the test executable cannot find `schema.sql` through the CMake-provided default path.

Persistent databases are updated through numbered Lua migrations under `data-otservbr-global/migrations`; the test reset path is only for disposable integration databases.

#### Direct executable access

You can also run test executables directly if needed:

```bash
./build/linux-debug/tests/unit/canary_ut
./build/linux-debug/tests/integration/canary_it
```

### Adding tests

Tests are added in the `tests` folder, in the root of the repository.
As much as possible, tests should be added in the same folder as the code they are testing:

```
- src
    - foo
        - foo.cpp
    - bar
        - bar.cpp
- tests
    - foo
        - foo_test.cpp
    - bar
        - bar_test.cpp
```

### GoogleTest

Tests are written using GoogleTest. Add new unit test files under `tests/unit` and register them in the nearest `CMakeLists.txt` with `target_sources`.

Basic test example:

```cpp
TEST(FooTest, DoesBar) {
	EXPECT_TRUE(true);
}
```
