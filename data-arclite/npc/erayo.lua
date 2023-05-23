local internalNpcName = "Erayo"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 152,
	lookHead = 86,
	lookBody = 125,
	lookLegs = 86,
	lookFeet = 87,
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

local topic = {}

local config = {
	['blue cloth'] = {storageValue = 1, text = {'Brought the 50 pieces of blue cloth?', 'Good. Get me 50 pieces of green cloth now.'}, itemId = 5912, count = 50},
	['green cloth'] = {storageValue = 2, text = {'Brought the 50 pieces of green cloth?', 'Good. Get me 50 pieces of red cloth now.'}, itemId = 5910, count = 50},
	['red cloth'] = {storageValue = 3, text = {'Brought the 50 pieces of red cloth?', 'Good. Get me 50 pieces of brown cloth now.'}, itemId = 5911, count = 50},
	['brown cloth'] = {storageValue = 4, text = {'Brought the 50 pieces of brown cloth?', 'Good. Get me 50 pieces of yellow cloth now.'}, itemId = 5913, count = 50},
	['yellow cloth'] = {storageValue = 5, text = {'Brought the 50 pieces of yellow cloth?', 'Good. Get me 50 pieces of white cloth now.'}, itemId = 5914, count = 50},
	['white cloth'] = {storageValue = 6, text = {'Brought the 50 pieces of white cloth?', 'Good. Get me 10 spools of yarn now.'}, itemId = 5909, count = 50},
	['spools of yarn'] = {storageValue = 7, text = {'Brought the 10 spools of yarn?', 'Thanks. That\'s it, you\'re done. Good job, |PLAYERNAME|. I keep my promise. Here\'s my old assassin head piece.'}, itemId = 5886, count = 10},
	['yarn'] = {storageValue = 7, text = {'Brought the 10 spools of yarn?', 'Thanks. That\'s it, you\'re done. Good job, |PLAYERNAME|. I keep my promise. Here\'s my old assassin head piece.'}, itemId = 5886, count = 10}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end


	if MsgContains(message, 'addon') then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 156 or 152) and player:getStorageValue(Storage.OutfitQuest.AssassinFirstAddon) < 1 then
			npcHandler:say('Vescu gave you an assassin outfit? Haha. Noticed it lacks the head piece? You look a bit silly. Want my old head piece?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif config[message] and npcHandler:getTopic(playerId) == 0 then
		if player:getStorageValue(Storage.OutfitQuest.AssassinFirstAddon) == config[message].storageValue then
			npcHandler:say(config[message].text[1], npc, creature)
			npcHandler:setTopic(playerId, 3)
			topic[playerId] = message
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				'Thought so. Could use some help anyway. Listen, I need stuff. Someone gave me a strange assignment - sneak into Thais castle at night and shroud it with cloth without anyone noticing it. ...',
				'I wonder why anyone would want to shroud a castle, but as long as long as the guy pays, no problem, I\'ll do the sneaking part. Need a lot of cloth though. ...',
				'Gonna make it colourful. Bring me 50 pieces of {blue cloth}, 50 pieces of {green cloth}, 50 pieces of {red cloth}, 50 pieces of {brown cloth}, 50 pieces of {yellow cloth} and 50 pieces of {white cloth}. ...',
				'Besides, gonna need 10 {spools of yarn}. Understood?'
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.OutfitQuest.AssassinFirstAddon, 1)
			npcHandler:say('Good. Start with the blue cloth. I\'ll wait.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			local targetMessage = config[topic[playerId]]
			if not player:removeItem(targetMessage.itemId, targetMessage.count) then
				npcHandler:say('You don\'t have the required items.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.OutfitQuest.AssassinFirstAddon, player:getStorageValue(Storage.OutfitQuest.AssassinFirstAddon) + 1)
			if player:getStorageValue(Storage.OutfitQuest.AssassinFirstAddon) == 8 then
				player:addOutfitAddon(156, 1)
				player:addOutfitAddon(152, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			npcHandler:say(targetMessage.text[2], npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') and npcHandler:getTopic(playerId) > 0 then
		npcHandler:say('Maybe another time.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	topic[playerId] = nil
end

npcHandler:setMessage(MESSAGE_GREET, 'What the... I mean, of course I sensed you.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
