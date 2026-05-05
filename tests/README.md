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
