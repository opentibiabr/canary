-- Spell IDs are client identities shared with proficiency data.
-- Run from the repository root with: luajit tests/lua/test_starter_spell_identities.lua

local function readSpellId(filename)
	local path = "data/scripts/spells/attack/" .. filename .. ".lua"
	local file = assert(io.open(path, "r"))
	local source = file:read("*a")
	file:close()
	return assert(tonumber(source:match("spell:id%((%d+)%)")), "Missing spell ID in " .. path)
end

-- The current client uses 270/271 for these proficiency-backed starter spells.
-- Apprentice's Strike retains 169 and must not share it with Lesser Ethereal Spear.
local expected = {
	{ filename = "lesser_ethereal_spear", id = 270 },
	{ filename = "lesser_front_sweep", id = 271 },
	{ filename = "apprentice's_strike", id = 169 },
}
local seen = {}
for _, spell in ipairs(expected) do
	local id = readSpellId(spell.filename)
	assert(id == spell.id, spell.filename .. ": expected ID " .. spell.id .. ", got " .. id)
	assert(not seen[id], "Duplicate starter spell ID " .. id)
	seen[id] = true
end

print("\n3 passed, 0 failed")
