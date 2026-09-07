-- Benchmark: table.unserialize() (data/libs/functions/tables.lua) vs the
-- pre-fix loadstring("return "..s) baseline, for representative sizes/shapes.
-- Not part of the tests/lua/test_*.lua auto-discovered suite (a timing
-- benchmark has no pass/fail, and CI shouldn't flake on machine variance) --
-- run it explicitly: luajit tests/lua/bench_table_serialization.lua
--
-- loadstring() is only used here, in isolation, as the historical timing
-- baseline being compared against -- never reintroduced as a runtime
-- fallback in tables.lua itself, since it's exactly the code-execution
-- surface this fix removes.

dofile("data/libs/functions/tables.lua")

local function loadstringUnserialize(s)
	local f = loadstring("return " .. s)
	if not f then
		return nil
	end
	local ok, result = pcall(f)
	if not ok then
		return nil
	end
	return result
end

local function timeIt(fn, iterations)
	local start = os.clock()
	for _ = 1, iterations do
		fn()
	end
	return os.clock() - start
end

local function bench(name, serialized, iterations)
	-- Warm up both paths so the JIT has traced hot loops before timing.
	for _ = 1, 20 do
		table.unserialize(serialized)
		loadstringUnserialize(serialized)
	end

	local parserTime = timeIt(function()
		table.unserialize(serialized)
	end, iterations)
	local loadstringTime = timeIt(function()
		loadstringUnserialize(serialized)
	end, iterations)

	local ratio = parserTime / loadstringTime
	print(
		string.format(
			"%-42s %8d bytes  parser=%7.4fs  loadstring=%7.4fs  ratio=%.2fx",
			name,
			#serialized,
			parserTime,
			loadstringTime,
			ratio
		)
	)
end

local function buildNumericTable(n)
	local parts = { "{" }
	for i = 1, n do
		parts[#parts + 1] = "[" .. i .. "]=" .. i .. ","
	end
	parts[#parts + 1] = "}"
	return table.concat(parts)
end

local function buildStringTable(n)
	local parts = { "{" }
	for i = 1, n do
		parts[#parts + 1] = '[' .. i .. ']="item_' .. i .. '",'
	end
	parts[#parts + 1] = "}"
	return table.concat(parts)
end

local function buildNestedTable(depth)
	return string.rep("{[1]=", depth) .. "1" .. string.rep("}", depth)
end

print("table.unserialize() vs loadstring() -- LuaJIT " .. (jit and jit.version or "n/a"))
print(string.rep("-", 100))

bench("scalar: short quoted string", table.serialize("hello world"), 50000)
bench("table: 5000 numeric entries", buildNumericTable(5000), 100)
bench("table: 5000 short string entries", buildStringTable(5000), 100)
bench("table: 500 numeric entries", buildNumericTable(500), 1000)
bench("table: 500 short string entries", buildStringTable(500), 1000)
bench("table: nested depth 20", buildNestedTable(20), 5000)

print(string.rep("-", 100))
print("Reminder: loadstring() is the insecure baseline being measured against, not a viable fallback.")
