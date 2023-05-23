local internalNpcName = "Corym Servant"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 533,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 115,
	lookFeet = 0,
	lookAddons = 0
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

local HiddenThreats = Storage.Quest.U11_50.HiddenThreats
local function greetCallback(npc, creature, message)
	local player = Player(creature)

	if player:getStorageValue(HiddenThreats.QuestLine) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'We work as hard we can, my master! Wait, I haven\'t seen you here before. You were sent by the Corym Ratter, I see. He misses the courage to visit us and find the reason for {decreasing resources}? He\'s the coward I have expected.'
		})
	elseif player:getStorageValue(HiddenThreats.corymRescueMission) == 8 and player:getStorageValue(HiddenThreats.QuestLine) == 3 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'Well done! The riot progesses! No fight without weapons. In the mine the temperature is quite high, higher as expected in this depth. Therefore we need heat-resistent weapons and armors. ...',
			'This effect can be reached by adding rare earth to the common materials. But this can only be found in the stomaches of stonerefiners. 20 of these should be enough. Well, I see you have already collected enough of them! Would you give it to me?'
		})
		player:setStorageValue(HiddenThreats.QuestLine, 4)
	elseif player:getStorageValue(HiddenThreats.QuestLine) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'Well, I see you have already collected enough rare earth! Would you give it to me?'
		})
	elseif player:getStorageValue(HiddenThreats.QuestLine) == 3 then
		npcHandler:setMessage(MESSAGE_GREET, {
			'You have to liberate all the Corym I told you. Unlock the three affected areas.'
		})
	else
		npcHandler:setMessage(MESSAGE_GREET, 'Every man is the architect of his own fortune. The times of repression are finally over.')
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if(MsgContains(message, "decreasing resources")) then
			npcHandler:say({
				"You have to know, that our work is very hard and the conditions we have are terrible. The wanted amount is abolutely unrealistic. Beyond that the food we get is never enough. ...",
				"Our workers should give their best while starving. This is not possible. That's the point to {defy} the authority."
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
	elseif(MsgContains(message, "defy")) then
		if(npcHandler:getTopic(playerId) == 1) then
			if player:getStorageValue(HiddenThreats.QuestLine) == 1 then
				player:setStorageValue(HiddenThreats.QuestLine, 2)
				player:setStorageValue(HiddenThreats.ServantDoor, 1)
				player:setStorageValue(HiddenThreats.corymRescueMission, 0)
			end
			npcHandler:say({
				"I see you are interested to change our sitation. The first thing I like you to do is to liberate the jailed coryms. There are three areas with locked doors. You have to find a way to get access. ...",
				"For this reason I will give you access to the second floor. It was closed because it wasn't possible to continue working at these enourmous high temperatures. Furthermore we were instantly attacked by stonerefiners. So take care of you!"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif(MsgContains(message, "yes")) and player:getStorageValue(HiddenThreats.QuestLine) == 4 then
		if player:removeItem(27301, 20) then
			npcHandler:say({
				"Thank you very much! Our smiths are now able to craft heat-resistent weapons and armor. A little reward for you is this. ...",
				"There is one last thing I would like to say to you, there are rumours that this dungeon can only be entered alive. This could mean that there's an unknown dungeon keeper guarding this place, so take care of you!"
			}, npc, creature)
			player:addItem(3040, 2)
			player:setStorageValue(HiddenThreats.QuestLine, 5)
			player:setStorageValue(HiddenThreats.corymRescueMission, 9)
		else
			npcHandler:say("You don't have enough, return when could you bring 20 of rare earth to me.", npc, creature)
			npcHandler:removeInteraction(npc, creature)
			npcHandler:resetNpc(creature)
		end
	end
	return true
end

-- Greeting message
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
