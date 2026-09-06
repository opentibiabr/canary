-- Standalone source contract for the current-client store summary packet.
-- Run from the repository root with: lua tests/lua/test_taskboard_store_summary_wire.lua

local protocolFile = assert(io.open("src/server/network/protocol/protocolgame.cpp", "r"))
local protocol = protocolFile:read("*a")
protocolFile:close()

local summary = assert(protocol:match("void ProtocolGame::sendCyclopediaCharacterStoreSummary%(%)%s*{(.-)std::vector<uint16_t> m_hSkills"))
local preySlots = assert(summary:find("msg.addByte(preySlotsUnlocked);", 1, true))
local preyWildcards = assert(summary:find("msg.addByte(cyclopediaSummary.m_preyWildcards);", 1, true))
local weeklyExpansion = assert(summary:find('get("weekly-expansion-unlocked")', 1, true))
local collectionTokens = assert(summary:find("msg.addByte(cyclopediaSummary.m_instantRewards);", 1, true))
local charmExpansion = assert(summary:find("msg.addByte(player->hasCharmExpansion() ? 0x01 : 0x00);", 1, true))
local hirelings = assert(summary:find("msg.addByte(cyclopediaSummary.m_hirelings);", 1, true))

assert(preySlots < preyWildcards)
assert(preyWildcards < weeklyExpansion)
assert(weeklyExpansion < collectionTokens)
assert(collectionTokens < charmExpansion)
assert(charmExpansion < hirelings)
assert(summary:find("getTaskHuntingSlotById", 1, true) == nil)

print("\n1 passed, 0 failed")
