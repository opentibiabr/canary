local internalNpcName = "Rock Steady"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 13424
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


	if MsgContains(message, "addon") or MsgContains(message, "help") then
		if player:getStorageValue(72326) < 1 then
			npcHandler:say("If you want anything, you should talk to Old Rock Boy over there. I do {collect} stuff, though. So just ask if you're interested in helping me.", npc, creature)
			player:setStorageValue(72326, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "collect") then
		if player:getStorageValue(72326) == 1 then
			npcHandler:say(
				{
					"I collect everything that reflects light in strange ways. However, I am bored by my collection. And there wasn't anything new to add for years. ...",
					"I like pearls for example - but I have already enough. I also like shells - but I can't even count how many I already own. ...",
					"If you find anything of REAL VALUE - bring it to me. I will reward you well. You don't already have something for me by chance?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(72326) == 2 then
			npcHandler:say("Have you got anything for me today?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(72326) == 3 then
			npcHandler:say("Have you got anything for me today?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(72326) == 4 and player:removeItem(14021, 1) then
			npcHandler:say(
				{
					"Have you got anything... what? You want what? A reward? HAHAHAHAAAA!! ...",
					"No I'm just teasing you. I'm really happy about my collection now. ...",
					"Well, I found some kind of weapon a long time ago. I believe it may be especially helpful underwater as it is from the deep folk. In any case it is of more use for you than it would be for me."
				},
				npc,
				creature
			)
			player:addOutfitAddon(464, 1)
			player:addOutfitAddon(463, 1)
			player:setStorageValue(72326, 5)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Great! Let me see. Amazing! I will take this, thank you!", npc, creature)
			player:setStorageValue(72326, 2)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 and player:removeItem(14022, 1) then
			npcHandler:say("Great! Let me see. Amazing! I will take this, thank you!", npc, creature)
			player:setStorageValue(72326, 3)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 and player:removeItem(14023, 1) then
			npcHandler:say("Great! Let me see. Amazing! I will take this, thank you!", npc, creature)
			player:setStorageValue(72326, 4)
			npcHandler:setTopic(playerId, 0)
			else npcHandler:say("You dont have the required items!", npc, creature)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
