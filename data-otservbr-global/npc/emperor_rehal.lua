local internalNpcName = "Emperor Rehal"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
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

keywordHandler:addKeyword({'hi'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true})
keywordHandler:addKeyword({'hello'}, StdModule.say, {npcHandler = npcHandler, onlyUnfocus = true})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if (MsgContains(message, "nokmir")) then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 1 then
			npcHandler:say("I always liked him and I still can't believe that he really stole that ring.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) == 4 and player:removeItem(8777, 1) then
			npcHandler:say("Interesting. The fact that you have the ring means that Nokmir can't have stolen it. Combined with the information Grombur gave you, the case appears in a completely different light. ...", npc, creature)
			npcHandler:say("Let there be justice for all. Nokmir is innocent and acquitted from all charges! And Rerun... I want him in prison for this malicious act!", npc, creature)
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 5)
		end	
	elseif (MsgContains(message, "grombur")) then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("He's very ambitious and always volunteers for the long shifts.", npc, creature)
			player:setStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll, 2)
			npcHandler:setTopic(playerId, 0)
		end	
	elseif (MsgContains(message, "mission")) then
		if player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) < 1 and player:getStorageValue(Storage.HiddenCityOfBeregar.JusticeForAll) > 4 then
			npcHandler:say("As you have proven yourself trustworthy I\'m going to assign you a special mission. Are you interested?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue) == 7 then
			npcHandler:say("My son was captured by trolls? Doesn\'t sound like him, but if you say so. Now you want a reward, huh? ...", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end	
	elseif (MsgContains(message, "yes")) then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Splendid! My son Rehon set off on an expedition to the deeper mines. He and a group of dwarfs were to search for new veins of crystal. Unfortunately they have been missing for 2 weeks now. ...", npc, creature)
			npcHandler:say("Find my son and if he's alive bring him back. You will find a reactivated ore wagon tunnel at the entrance of the great citadel which leades to the deeper mines. If you encounter problems within the tunnel go ask Xorlosh, he can help you.", npc, creature)
			player:setStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then	
			npcHandler:say("Look at these dwarven legs. They were forged years ago by a dwarf who was rather tall for our kind. I want you to have them. Thank you for rescuing my son |PLAYERNAME|.", npc, creature)
			player:addItem(3398, 1)
			player:setStorageValue(Storage.HiddenCityOfBeregar.RoyalRescue, 8)
			npcHandler:setTopic(playerId, 0)
		end	
	elseif (MsgContains(message, "no")) then
		if npcHandler:getTopic(playerId) == 1 or npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Alright then, come back when you are ready.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end	
	end 
	return true
end

local node1 = keywordHandler:addKeyword({'promot'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'I can promote you for 20000 gold coins. Do you want me to promote you?'})
node1:addChildKeyword({'yes'}, StdModule.promotePlayer, {npcHandler = npcHandler, cost = 20000, level = 20, promotion = 1, text = 'Congratulations! You are now promoted.'})
node1:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, onlyFocus = true, text = 'Alright then, come back when you are ready.', reset = true})

-- Greeting message
keywordHandler:addGreetKeyword({"hail emperor"}, {npcHandler = npcHandler, text = "May fire and earth bless you, stranger. What leads you to Beregar, the dwarven city?"})
keywordHandler:addGreetKeyword({"salutations emperor"}, {npcHandler = npcHandler, text = "May fire and earth bless you, stranger. What leads you to Beregar, the dwarven city?"})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
