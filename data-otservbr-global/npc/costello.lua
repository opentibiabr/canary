local internalNpcName = "Costello"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 57
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

	if MsgContains(message, 'fugio') then
		if player:getStorageValue(Storage.Quest.U7_24.FamilyBrooch.Brooch) == 1 then
			npcHandler:say('To be honest, I fear the omen in my dreams may be true. \z
					Perhaps Fugio is unable to see the danger down there. \z
					Perhaps ... you are willing to investigate this matter?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'diary') then
		if player:getStorageValue(Storage.WhiteRavenMonastery.Diary) == 1 then
			npcHandler:say('Do you want me to inspect a diary?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, 'holy water') then
		local cStorage = player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline)
		if cStorage == 1 then
			npcHandler:say('Who are you to demand holy water from the White Raven Monastery? Who sent you??', npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif cStorage == 2 then
			npcHandler:say('I already filled your vial with holy water.', npc, creature)
		end
	elseif MsgContains(message, 'amanda') and npcHandler:getTopic(playerId) == 0 then
		if player:getStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline) == 1 then
			npcHandler:say('Ahh, Amanda from Edron sent you! I hope she\'s doing well. So why did she send you here?', npc, creature)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say('Thank you very much! From now on you may open the warded doors to the catacombs.', npc, creature)
			player:setStorageValue(Storage.WhiteRavenMonastery.Diary, 1)
			player:setStorageValue(Storage.WhiteRavenMonastery.Door, 1)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeItem(3212, 1) then
				npcHandler:say('Uhm, as you wish.', npc, creature)
				return true
			end

			npcHandler:say('By the gods! This is brother Fugio\'s handwriting and what I read is horrible indeed! You have done our order a great favour by giving this diary to me! Take this blessed Ankh. May it protect you in even your darkest hours.', npc, creature)
			player:addItem(3214, 1)
			player:setStorageValue(Storage.WhiteRavenMonastery.Diary, 2)
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		if not MsgContains(message, 'amanda') then
			npcHandler:say('I never heard that name and you won\'t get holy water for some stranger.', npc, creature)
			npcHandler:setTopic(playerId, 0)
			return true
		end

		player:addItem(133, 1)
		player:setStorageValue(Storage.TibiaTales.RestInHallowedGround.Questline, 2)
		npcHandler:say('Ohh, why didn\'t you tell me before? Sure you get some holy water if it\'s for Amanda! Here you are.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'no') and isInArray({1, 2}, npcHandler:getTopic(playerId)) then
		npcHandler:say('Uhm, as you wish.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Feel free to tell me what has brought you here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye. Come back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
