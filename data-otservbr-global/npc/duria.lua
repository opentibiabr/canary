local internalNpcName = "Duria"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 70
}

npcConfig.flags = {
	floorchange = false
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

keywordHandler:addSpellKeyword({'find', 'person'}, {npcHandler = npcHandler, spellName = 'Find Person', price = 80, level = 8, vocation = VOCATION.BASE_ID.KNIGHT})
keywordHandler:addSpellKeyword({'light'}, {npcHandler = npcHandler, spellName = 'Light', price = 0, level = 8, vocation = VOCATION.BASE_ID.KNIGHT})
keywordHandler:addSpellKeyword({'cure', 'poison'}, {npcHandler = npcHandler, spellName = 'Cure Poison', price = 150, level = 10, vocation = VOCATION.BASE_ID.KNIGHT})
keywordHandler:addSpellKeyword({'wound', 'cleansing'}, {npcHandler = npcHandler, spellName = 'Wound Cleansing', price = 0, level = 8, vocation = VOCATION.BASE_ID.KNIGHT})
keywordHandler:addSpellKeyword({'great', 'light'}, {npcHandler = npcHandler, spellName = 'Great Light', price = 500, level = 13, vocation = VOCATION.BASE_ID.KNIGHT})

keywordHandler:addKeyword({'healing', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Wound Cleansing}' and '{Cure Poison}'."})
keywordHandler:addKeyword({'support', 'spells'}, StdModule.say, {npcHandler = npcHandler, text = "In this category I have '{Light}', '{Find Person}' and '{Great Light}'."})
keywordHandler:addKeyword({'spells'}, StdModule.say, {npcHandler = npcHandler, text = 'I can teach you {healing spells} and {support spells}. What kind of spell do you wish to learn? You can also tell me for which level you would like to learn a spell, if you prefer that.'})

npcHandler:setMessage(MESSAGE_GREET, 'Hiho, fellow knight |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Goodbye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Be carefull out there, jawoll.')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
