local internalNpcName = "Eliza"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}
npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2
npcConfig.outfit = {
	lookType = 58,
}
npcConfig.flags = {
	floorchange = false,
}
local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end
npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end
npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end
npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end
npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local node1 = keywordHandler:addKeyword({ "enchant party" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {enchant party} magic spell for 4000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "enchant party", vocation = { 1, 5 }, price = 4000, level = 32 })

local node2 = keywordHandler:addKeyword({ "heal party" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {heal party} magic spell for 4000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "heal party", vocation = { 2, 6 }, price = 4000, level = 32 })

local node3 = keywordHandler:addKeyword({ "protect party" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {protect party} magic spell for 4000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "protect party", vocation = { 3, 7 }, price = 4000, level = 32 })

local node4 = keywordHandler:addKeyword({ "train party" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {train party} magic spell for 4000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "train party", vocation = { 4, 8 }, price = 4000, level = 32 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I can teach you {support} spells. I can also tell you which spells are available at your {level}." })
keywordHandler:addKeyword({ "support" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Support spells: {Enchant Party} (Sorcerer), {Heal Party} (Druid), {Protect Party} (Paladin), {Train Party} (Knight)." })

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I have spells for level {32}." })

nodeLevels:addChildKeyword({ "32" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 32 I have {Enchant Party} for 4000 gold, {Heal Party} for 4000 gold, {Protect Party} for 4000 gold and {Train Party} for 4000 gold." })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|. If you're interested in {spells} to support your party, I can be your teacher.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye, |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
