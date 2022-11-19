local internalNpcName = "The Beggar King"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 0,
	lookBody = 114,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 3
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

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.DarkTrails.Mission01) == 2 and player:getStorageValue(Storage.DarkTrails.Mission02) == 1 then
			npcHandler:say("So I guess you are the one that the magistrate is sending to look after us, eh? ", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("You need some quests then come and talk with me again.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say(
				{
					"Fine. But the first thing you have to know is that we are not the city's problem. We are just trying to survive. We usually seek shelter in the sewers.",
					"There we are comparatively warm and safe. At least we were. But recently something has changed. There is {something} in the sewers. And it is hunting us."
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "something") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Yeah. No one has seen it and lived to tell the tale. People are missing and sometimes there are {traces} of blood or someone heard a scream, but that's all. We have no idea if the killer is a man or a beast, but there is something out there", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "traces") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Some of the more daring of us tried to follow the tracks that were left, but they always lost the trail close to the {abandoned sewers}, in the east of the sewer system.", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "abandoned sewers") then
		if npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({
				"Some parts of the sewers were abandoned when they were beyond repair due to old age and earthquakes. ...",
				"That part was never truly well liked. There were rumours that the workers found some ancient structures there and that it was ripe with accidents during the construction. ...",
				"The city sealed those parts off, and I have no idea how anything could get in or out without the permission of the magistrate. ... ",
				"But since you are investigating on their behalf, you might work out some agreement with them, if you're mad enough to enter the sewers at all. ... ",
				"However, you will have to talk to one of the Glooth Brothers who are responsible for the sewer system's maintenance. You'll find them somewhere down there."
			}, npc, creature, 10)
			player:setStorageValue(Storage.DarkTrails.Mission02, 2) -- Mission 2 end
			player:setStorageValue(Storage.DarkTrails.Mission03, 1) -- Mission 3 start
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hi! You look like someone on a {mission}.")
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye!') -- Need revision

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
