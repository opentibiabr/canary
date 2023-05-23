local internalNpcName = "Nokmir"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 160,
	lookHead = 57,
	lookBody = 87,
	lookLegs = 59,
	lookFeet = 114
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
		if player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) < 1 then
			npcHandler:say("I don't see how you could help me. I'm in deep, deep trouble. I'm accused of having stolen a {ring} from Rerun, but I haven't.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 5 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 6)
			player:setStorageValue(Storage.HiddenCityOfBeregar.DoorNorthMine, 1)
			npcHandler:say("WHAT?! I can't believe it. You saved my life... well, at least one week of it 'cause that would have been the time I had to spend in jail. If you want to, you can pass the door now and take a look at the northern mines. Have fun!", npc, creature)
		end
	elseif MsgContains(message, "ring") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"He said he still had it after work. On that evening, {Grombur}, {Rerun} and me opened a cask of beer in one of the mine tunnels. We had a fun evening there. ...",
				"On the next day, the guards brought me to emperor {Rehal}, and Rerun was there, too. He said I had stolen his ring. I'd never steal, you have to believe me."
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, "grombur") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Maybe Grombur knows more than me. The thing is he won't talk to me, and he will surely not accuse his best friend as a liar. What a dilemma!", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "rerun") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("He's a miner in the southern wing. Maybe he has lost the ring there... but even if I find the ring, no one will believe me. Someone should talk to Grombur. He's Rerun's best friend.", npc, creature)
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, "rehal") then
		if npcHandler:getTopic(playerId) == 4 then
			player:setStorageValue(Storage.HiddenCityOfBeregar.DefaultStart, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 1)
			npcHandler:say("He's a good emperor but I doubt he is wise enough to see the truth behind that false accusation against me. If just someone would find out the truth about that whole mess.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "See you my friend.")
npcHandler:setMessage(MESSAGE_FAREWELL, "See you my friend.")
npcHandler:setMessage(MESSAGE_GREET, "You are....kind of tall! Hello.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
