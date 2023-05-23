local internalNpcName = "Kazzan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 95,
	lookBody = 13,
	lookLegs = 14,
	lookFeet = 76,
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

local function greetCallback(npc, creature)
	local playerId = creature:getId()
	npcHandler:setTopic(playerId, 0)
	return true
end
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	-- Pegando a quest
	if MsgContains(message, "mission") and player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) < 1 then
			if player:getStorageValue(Storage.DjinnWar.Faction.MaridDoor) < 1 and player:getStorageValue(Storage.DjinnWar.Faction.EfreetDoor) < 1 then
			npcHandler:say({
				'Do you know the location of the djinn fortresses in the mountains south of here?'}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif npcHandler:getTopic(playerId) == 1 and MsgContains(message, "yes") then
			npcHandler:say({
				'Alright. The problem is that I want to know at least one of them on my side. You never know. I don\'t mind if it\'s the evil Efreet or the Marid. ...',
				'Your mission will be to visit one kind of the djinns and bring them a peace-offering. Are you interested in that mission?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "yes") then
			npcHandler:say({
				'Very good. I hope you are able to convince one of the fractions to stand on our side. If you haven\'t done yet, you should first go and look for old Melchior in Ankrahmun. ...',
				'He knows many things about the djinn race and he may have some hints for you.'
			}, npc, creature)
			if player:getStorageValue(Storage.TibiaTales.DefaultStart) <= 0 then
				player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
			end
			player:setStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest, 1)
		-- Entregando
	elseif player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) == 3 then
		npcHandler:say({
		'Well, I don\'t blame you for that. I am sure you did your best. Now we can just hope that peace remains. Here, take this small gratification for your effort to help and Daraman may bless you!'
		}, npc, creature)
		player:setStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest, player:getStorageValue(Storage.TibiaTales.ToAppeaseTheMightyQuest) + 1)
		player:addItem(3035, 20)
end

	if player:getStorageValue(Storage.WhatAFoolish.Questline) == 35
			and player:getStorageValue(Storage.WhatAFoolish.ScaredKazzan) ~= 1
			and player:getOutfit().lookType == 65 then
		player:setStorageValue(Storage.WhatAFoolish.ScaredKazzan, 1)
		npcHandler:say('WAAAAAHHH!!!', npc, creature)
		return false
	end
	return true
end

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
