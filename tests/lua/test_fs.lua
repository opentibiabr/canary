-- Test suite for FS.mkdir()/FS.mkdir_p() (data/libs/functions/fs.lua).
-- Run: luajit tests/lua/test_fs.lua
--
-- The native fsCreateDirectories() binding (src/lua/functions/core/game/global_functions.cpp)
-- is stubbed below exactly as lua_register() would expose it before fs.lua loads --
-- this suite runs standalone, without linking the real C++ binary.

local passed, failed, errors = 0, 0, {}

local function test(name, fn)
	local ok, err = pcall(fn)
	if ok then
		passed = passed + 1
	else
		failed = failed + 1
		table.insert(errors, { name = name, err = err })
	end
end

local function assert_equal(actual, expected, msg)
	if actual ~= expected then
		error((msg or "values differ") .. (": expected " .. tostring(expected) .. ", got " .. tostring(actual)), 2)
	end
end

local function assert_nil(val, msg)
	if val ~= nil then
		error(msg or ("expected nil, got " .. tostring(val)), 2)
	end
end

local nativeCalls = {}
fsCreateDirectories = function(path)
	table.insert(nativeCalls, path)
	if path == "trigger-native-failure" then
		return false, "simulated filesystem error"
	end
	return true, nil
end

dofile("data/libs/functions/fs.lua")

---------------------------------------------------------------------------
-- The native binding must not survive as a bare global
---------------------------------------------------------------------------

test("fsCreateDirectories is removed from _G once fs.lua has loaded", function()
	assert_nil(fsCreateDirectories, "must not be reachable as a second, undocumented entry point")
end)

---------------------------------------------------------------------------
-- FS.mkdir()
---------------------------------------------------------------------------

test("FS.mkdir: delegates to the native binding and returns its result", function()
	nativeCalls = {}
	local ok, err = FS.mkdir("some/dir")
	assert_equal(ok, true)
	assert_nil(err)
	assert_equal(#nativeCalls, 1)
	assert_equal(nativeCalls[1], "some/dir")
end)

test("FS.mkdir: propagates a native failure instead of swallowing it", function()
	nativeCalls = {}
	local ok, err = FS.mkdir("trigger-native-failure")
	assert_equal(ok, false)
	assert_equal(err, "simulated filesystem error")
end)

test("FS.mkdir: rejects an empty path before calling the native binding", function()
	nativeCalls = {}
	local ok, err = FS.mkdir("")
	assert_equal(ok, false)
	assert_equal(err, "invalid path")
	assert_equal(#nativeCalls, 0, "must not reach the native binding for an invalid path")
end)

test("FS.mkdir: rejects a non-string path before calling the native binding", function()
	nativeCalls = {}
	local ok, err = FS.mkdir(nil)
	assert_equal(ok, false)
	assert_equal(err, "invalid path")
	assert_equal(#nativeCalls, 0)
end)

test("FS.mkdir: paths with characters a shell would have needed escaping just work", function()
	-- No shell is involved anymore, so nothing here needs denylisting --
	-- this is exactly the class of legitimate path the old shell-based
	-- implementation used to reject.
	nativeCalls = {}
	local ok = FS.mkdir("reports/50% (final) & summary.txt's_folder")
	assert_equal(ok, true)
	assert_equal(nativeCalls[1], "reports/50% (final) & summary.txt's_folder")
end)

---------------------------------------------------------------------------
-- FS.mkdir_p()
---------------------------------------------------------------------------

test("FS.mkdir_p: delegates a single call to FS.mkdir (native binding creates all parents)", function()
	nativeCalls = {}
	local ok = FS.mkdir_p("a/b/c")
	assert_equal(ok, true)
	assert_equal(#nativeCalls, 1, "must be one call, not one per path component")
	assert_equal(nativeCalls[1], "a/b/c")
end)

test("FS.mkdir_p: empty path is a no-op success", function()
	nativeCalls = {}
	local ok = FS.mkdir_p("")
	assert_equal(ok, true)
	assert_equal(#nativeCalls, 0)
end)

---------------------------------------------------------------------------
-- Results
---------------------------------------------------------------------------
print(string.format("\n%d passed, %d failed", passed, failed))
if #errors > 0 then
	print("\nFailed tests:")
	for _, e in ipairs(errors) do
		print(string.format("  FAIL: %s\n        %s", e.name, e.err))
	end
	os.exit(1)
end
