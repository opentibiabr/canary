-- Test suite for table.serialize()/table.unserialize() (data/libs/functions/tables.lua)
-- and unserializeTable() (data/libs/functions/functions.lua).
-- Run: luajit tests/lua/test_table_serialization.lua

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

local function assert_true(val, msg)
	if not val then
		error(msg or "expected true, got " .. tostring(val), 2)
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

-- Stubs required by functions.lua's top-level code (unrelated to what this
-- suite exercises, but functions.lua runs its whole file body on dofile()).
logger = { warn = function() end }
configManager = {
	getBoolean = function()
		return false
	end,
	getNumber = function()
		return 0
	end,
}
configKeys = { LUA_SCRIPT_DEBUG_HOOK = 1, LUA_SCRIPT_DEBUG_HOOK_INTERVAL = 2 }
Player = {}

dofile("data/libs/functions/tables.lua")
dofile("data/libs/functions/functions.lua")

---------------------------------------------------------------------------
-- Basic round-trips through table.serialize() -> table.unserialize()
---------------------------------------------------------------------------

test("round-trip: primitives", function()
	assert_equal(table.unserialize(table.serialize(42)), 42)
	assert_equal(table.unserialize(table.serialize(-3.5)), -3.5)
	assert_equal(table.unserialize(table.serialize(true)), true)
	-- Not table.serialize(false)/table.serialize(nil): table.serialize() has
	-- two pre-existing bugs unrelated to the parser -- its boolean branch
	-- (`t and "true" or "false"` uses the type-name string `t`, always
	-- truthy, instead of the value `x`, so it always emits "true") and its
	-- nil branch (`t == nil` compares the type-name STRING "nil" to the
	-- value nil, which is never equal, so it falls through to `error()`
	-- instead of returning "nil"). Both are out of scope here, so this
	-- exercises table.unserialize() directly against the literals instead.
	assert_equal(table.unserialize("false"), false)
	assert_nil(table.unserialize("nil"))
end)

test("round-trip: plain string (fast path, no escapes)", function()
	assert_equal(table.unserialize(table.serialize("hello world")), "hello world")
end)

test("round-trip: string containing whitespace is preserved", function()
	assert_equal(table.unserialize(table.serialize("a b  c\td")), "a b  c\td")
end)

test("round-trip: string containing quotes and backslash", function()
	local s = [[He said "hi" and used a \ backslash and a 'quote']]
	assert_equal(table.unserialize(table.serialize(s)), s)
end)

test("round-trip: string containing an embedded newline", function()
	local s = "line one\nline two\r\nline three"
	assert_equal(table.unserialize(table.serialize(s)), s)
end)

test("round-trip: string containing binary/high bytes (decimal escapes)", function()
	local s = string.char(0, 1, 5, 255) .. "mid" .. string.char(200)
	assert_equal(table.unserialize(table.serialize(s)), s)
end)

test("round-trip: nested table with mixed key types", function()
	local t = { 1, 2, "three", key = "value", [10] = "ten", nested = { a = 1, b = { 2, 3 } } }
	local out = table.unserialize(table.serialize(t))
	assert_equal(out[1], 1)
	assert_equal(out[2], 2)
	assert_equal(out[3], "three")
	assert_equal(out.key, "value")
	assert_equal(out[10], "ten")
	assert_equal(out.nested.a, 1)
	assert_equal(out.nested.b[1], 2)
	assert_equal(out.nested.b[2], 3)
end)

test("round-trip: negative, float and boolean bracket keys", function()
	local out = table.unserialize('{[-1]="neg",[1.5]="float",[true]="t",[false]="f"}')
	assert_equal(out[-1], "neg")
	assert_equal(out[1.5], "float")
	assert_equal(out[true], "t")
	assert_equal(out[false], "f")
end)

test("round-trip: empty table", function()
	local out = table.unserialize(table.serialize({}))
	assert_true(type(out) == "table")
	assert_nil(next(out))
end)

---------------------------------------------------------------------------
-- Explicit escape allow-list (must accept %q's own escapes, reject others)
---------------------------------------------------------------------------

test("escapes: \\n \\t \\r \\\\ \\\" \\' decode correctly", function()
	assert_equal(table.unserialize([["a\nb"]]), "a\nb")
	assert_equal(table.unserialize([["a\tb"]]), "a\tb")
	assert_equal(table.unserialize([["a\rb"]]), "a\rb")
	assert_equal(table.unserialize([["a\\b"]]), "a\\b")
	assert_equal(table.unserialize([["a\"b"]]), 'a"b')
	assert_equal(table.unserialize([['a\'b']]), "a'b")
end)

test("escapes: decimal escape decodes to the byte value", function()
	assert_equal(table.unserialize([["\65\66\67"]]), "ABC")
end)

test("escapes: %q-style backslash + physical newline decodes to \\n", function()
	assert_equal(table.unserialize('"a\\\nb"'), "a\nb")
end)

test("escapes: unsupported escape sequences are rejected, not silently kept", function()
	assert_nil(table.unserialize([["\x41"]]), "\\x41 (hex escape) must be rejected")
	assert_nil(table.unserialize([["\a"]]), "\\a (bell) must be rejected")
	assert_nil(table.unserialize([["\q"]]), "\\q (not a real escape) must be rejected")
end)

test("escapes: raw unescaped newline inside a quoted string is rejected", function()
	assert_nil(table.unserialize('"a\nb"'))
	assert_nil(table.unserialize('"a\rb"'))
end)

test("escapes: raw newline after an earlier escape in the same string is still rejected", function()
	-- Exercises the slow per-char loop's own CR/LF guard (not just the fast-path pre-scan).
	assert_nil(table.unserialize('"a\\tb\nc"'))
end)

---------------------------------------------------------------------------
-- Malformed input rejection
---------------------------------------------------------------------------

test("malformed: unterminated string is rejected", function()
	assert_nil(table.unserialize('"unterminated'))
end)

test("malformed: unterminated table is rejected", function()
	assert_nil(table.unserialize("{1,2"))
end)

test("malformed: trailing garbage after a complete value is rejected", function()
	assert_nil(table.unserialize("1x"))
	assert_nil(table.unserialize("{[1]=1}junk"))
end)

test("malformed: leading comma is rejected", function()
	assert_nil(table.unserialize("{,1}"))
end)

test("malformed: repeated comma is rejected", function()
	assert_nil(table.unserialize("{1,,2}"))
end)

test("valid: single trailing comma is still accepted (table.serialize emits it)", function()
	local out = table.unserialize("{1,2,3,}")
	assert_equal(out[1], 1)
	assert_equal(out[2], 2)
	assert_equal(out[3], 3)
end)

test("malformed: nil as a bracket key is rejected instead of crashing on t[nil]", function()
	assert_nil(table.unserialize("{[nil]=1}"))
end)

test("malformed: empty/whitespace-only input returns nil", function()
	assert_nil(table.unserialize(""))
	assert_nil(table.unserialize("   "))
	assert_nil(table.unserialize(nil))
end)

---------------------------------------------------------------------------
-- Resource limits (depth / node count) reject adversarial input
---------------------------------------------------------------------------

test("limits: extremely deep nesting is rejected, not a stack overflow", function()
	local deep = string.rep("{[1]=", 5000) .. "1" .. string.rep("}", 5000)
	local ok, result = pcall(table.unserialize, deep)
	assert_true(ok, "must not raise a Lua error (e.g. stack overflow)")
	assert_nil(result, "must reject rather than accept unbounded nesting")
end)

test("limits: nesting within the configured budget still round-trips", function()
	local n = 20
	local nested = string.rep("{[1]=", n) .. "1" .. string.rep("}", n)
	local out = table.unserialize(nested)
	assert_true(type(out) == "table")
	local cursor = out
	for _ = 1, n - 1 do
		cursor = cursor[1]
	end
	assert_equal(cursor[1], 1)
end)

---------------------------------------------------------------------------
-- Resource limits (source length) reject oversized single-token payloads
---------------------------------------------------------------------------

test("limits: a huge single string literal is rejected by length, not just node count", function()
	-- remainingValues only ever charges once for a whole quoted string, no matter
	-- how long -- this exercises the separate source-byte cap that exists
	-- precisely because a single oversized string would otherwise sail through
	-- that budget untouched.
	local oversized = '"' .. string.rep("a", 4 * 1024 * 1024) .. '"' -- 2 bytes over the 4 MiB cap
	local ok, result = pcall(table.unserialize, oversized)
	assert_true(ok, "must not raise a Lua error")
	assert_nil(result, "must reject input over the source-length cap")
end)

test("limits: a large string literal right at the length cap still round-trips", function()
	local payload = string.rep("a", 4 * 1024 * 1024 - 2) -- quotes bring the total to exactly 4 MiB
	local out = table.unserialize('"' .. payload .. '"')
	assert_equal(out, payload)
end)

---------------------------------------------------------------------------
-- No code execution: loadstring-era attack strings must NOT run
---------------------------------------------------------------------------

test("security: an embedded expression is data, not executed", function()
	-- Previously "return {}, os.execute('true')" style payloads would run as
	-- Lua code through load()/loadstring(). Now it's parsed as a malformed
	-- table literal and rejected -- never invoking the expression.
	local ranSideEffect = false
	sideEffect = function()
		ranSideEffect = true
		return 1
	end
	local payload = "{[1]=sideEffect()}"
	local out = table.unserialize(payload)
	assert_nil(out, "a call expression is not valid data syntax and must be rejected")
	assert_true(not ranSideEffect, "the embedded call must never actually execute")
end)

---------------------------------------------------------------------------
-- unserializeTable() (functions.lua) -- delegates to table.unserialize()
---------------------------------------------------------------------------

test("unserializeTable: copies a valid table into `out` and returns it", function()
	local out = {}
	local ret = unserializeTable(table.serialize({ a = 1, b = { 2, 3 } }), out)
	assert_true(ret == out)
	assert_equal(out.a, 1)
	assert_equal(out.b[1], 2)
	assert_equal(out.b[2], 3)
end)

test("unserializeTable: returns false (not a table/nil) on malformed input", function()
	assert_equal(unserializeTable("not valid", {}), false)
end)

test("unserializeTable: returns false when the parsed value isn't a table", function()
	-- A bare non-table value parses successfully via table.unserialize() but
	-- unserializeTable()'s contract is specifically "give me a table".
	assert_equal(unserializeTable("42", {}), false)
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
