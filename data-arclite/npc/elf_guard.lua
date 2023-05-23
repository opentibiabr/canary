local internalNpcName = "Elf Guard"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 63
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

keywordHandler:addKeyword({'elf'}, StdModule.say, {npcHandler = npcHandler, text = "The elves of this city are the casts of the Cenath, the Kuridai, and the Deraisim."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am a guardian of this town. I have no time to chat!"})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = "The Cenath are magic users. Look for them on the upper levels of the town."})
keywordHandler:addKeyword({'deraisim'}, StdModule.say, {npcHandler = npcHandler, text = "The Deraisim are scouts and hunters. You may find them on the groundlevel of the city."})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = "There are no Teshial."})
keywordHandler:addKeyword({'weapon'}, StdModule.say, {npcHandler = npcHandler, text = "If you are looking for that kind of equipment you should ask a Kuridai."})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = "Ask around in Ab'Dendriel. Many elves can teach you something about magic. The Cenath love magic most of all."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "The city of the humans lies somewhere far to the south beyond the mountains of the dwarfs."})

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Ashari, |PLAYERNAME|."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Asha Thrazi, |PLAYERNAME|."})

npcHandler:setMessage(MESSAGE_GREET, "Ashari |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Asha Thrazi, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Asha Thrazi, |PLAYERNAME|!')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
