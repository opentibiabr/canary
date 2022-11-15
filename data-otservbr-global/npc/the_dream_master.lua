local internalNpcName = "The Dream Master"
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
	lookHead = 19,
	lookBody = 39,
	lookLegs = 20,
	lookFeet = 58,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "join") then
		if player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) < 1 and player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) < 1 then
			npcHandler:say({
				"The Nightmare Knights are almost extinct now, and as far as I know I am the only teacher that is left. But you might beright and its time to accept new disciples ...",
				"After all you have passed the Dream Challenge to reach this place, which used to be the process of initiation in the past...",
				"So I ask you: do you wish to become a member of the ancient order of the Nightmare Knights, |PLAYERNAME|?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "advancement") then
		if player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) == 1 then
			npcHandler:say("So you want to advance to a {Initiate} rank? Did you bring 500 demonic essences with you?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) == 2 then
			npcHandler:say("So you want to advance to a {Dreamer} rank? Did you bring 1000 demonic essences with you?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) == 3 then
			npcHandler:say("So you want to advance to a {Lord Protector} rank? Did you bring 1500 demonic essences with you?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Please know that your decision is irrevocable. You will abandon the opportunity to join any order whose doctrine is incontrast to our own ...", npc, creature)
			npcHandler:say("Do you still want to join our order?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"So I welcome you as the latest member of the order of the Nightmare Knights. You entered this place as a stranger, butyou will leave this place as a friend ...",
				"You can always ask me about your current rank and about the privileges the ranks grant to those who hold them."
			}, npc, creature)
			player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 1)
			player:addAchievement('Nightmare Knight')
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(6499, 500) then
				player:addItem(769, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 2)
				npcHandler:say("You advanced to {Initiate} rank! You are now able to use teleports of second floor of Knightwatch Tower.", npc, creature)
			else
				npcHandler:say("Come back when you gather all essences.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(6499, 1000) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 3)
				player:addItem(770, 1)
				player:addItem(6390, 1)
				player:addAchievement('Nightmare Walker')
				npcHandler:say("You advanced to {Dreamer} rank!", npc, creature)
			else
				npcHandler:say("Come back when you gather all essences.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(6499, 21465) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.NightmareOutfit, 4)
				player:setStorageValue(Storage.OutfitQuest.NightmareDoor, 1)
				player:setStorageValue(Storage.KnightwatchTowerDoor, 1)
				player:addAchievement('Lord Protector')
				npcHandler:say("You advanced to {Lord Protector} rank! You are now able to use teleports of fourth floor of Knightwatch Tower and to create addon scrolls.", npc, creature)
			else
				npcHandler:say("Come back when you gather all essences.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
