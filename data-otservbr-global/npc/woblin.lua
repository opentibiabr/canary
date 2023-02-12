local internalNpcName = "Woblin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 297
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "key") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) == 1 then
			npcHandler:say("Me not give key! Key my precious now! \z
				By old goblin law all that one has in his pockets for two days is family heirloom! \z
				Me no part with my precious ... hm unless you provide Woblin with some {reward}!", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "reward") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Me good angler but one fish eludes me since many many weeks. I call fish ''Old Nasty''. \z
				You might catch him in this cave, in that pond there. Bring me Old Nasty and I'll give you key!", npc, creature)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 2)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "old nasty") then
		if player:getStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey) == 3 and player:getItemCount(21402) >= 1 then
			npcHandler:say("You bring me Old Nasty?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Wonderful. I don't believe you will find Dormovo alive, though. \z
				He would not have stayed abroad that long without refilling his inkpot for his research notes. \z
				But at least the amulet should be retrieved.", npc, creature)
			player:removeItem(21402, 1)
			local TheDormKey = player:addItem(21392, 1)
			TheDormKey:setActionId(103)
			player:setStorageValue(Storage.Quest.U10_55.Dawnport.TheDormKey, 4)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end
keywordHandler:addKeyword({"goblins"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "No part of clan. Me prefer company of precious. Or mirror image. Always nice to see pretty me!"
	}
)
keywordHandler:addKeyword({"quest"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "What you on quest for? Go leave Woblin alone with {precious}"
	}
)
keywordHandler:addKeyword({"precious"}, StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Me not give {key}! Key my precious now! By old goblin law all that one has in his pockets for two days \z
			is family heirloom! Me no part with my precious ... hm unless you provide Woblin with some {reward}!"
	}
)

npcHandler:setMessage(MESSAGE_GREET, "Hi there human!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
