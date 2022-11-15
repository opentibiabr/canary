local internalNpcName = "The Bone Master"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 145,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 2
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
		if player:getStorageValue(Storage.OutfitQuest.NightmareOutfit) < 1 and player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) < 1 then
			npcHandler:say({
				"The Brotherhood of Bones has suffered greatly in the past, but we did survive as we always will ...",
				"You have proven resourceful by beating the silly riddles the Nightmare Knights set up to test their candidates ...",
				"It's an amusing thought that after passing their test you might choose to join the ranks of their sworn enemies ...",
				"For the irony of this I ask you, |PLAYERNAME|: Do you want to join the Brotherhood of Bones?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "advancement") then
		if player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) == 1 then
			npcHandler:say("So you want to advance to a {Hyaena} rank? Did you bring 500 demonic essences with you?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) == 2 then
			npcHandler:say("So you want to advance to a {Death Dealer} rank? Did you bring 1000 demonic essences with you?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif player:getStorageValue(Storage.OutfitQuest.BrotherhoodOutfit) == 3 then
			npcHandler:say("So you want to advance to a {Dread Lord} rank? Did you bring 1500 demonic essences with you?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"But know that your decision will be irrevocable. You will abandon the opportunity to join any order whose doctrine is incontrast to our own ...",
				"Do you still want to join the Brotherhood?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Welcome to the Brotherhood! From now on you will walk the path of Bones. A life full of promises and power has just beenoffered to you ...",
				"Take it, if you are up to that challenge ... or perish in agony if you deserve this fate ...",
				"You can always ask me about your current rank and about the privileges the ranks grant to those who hold them."
			}, npc, creature)
			player:setStorageValue(Storage.OutfitQuest.BrotherhoodOutfit, 1)
			player:addAchievement('Bone Brother')
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(6499, 500) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.BrotherhoodOutfit, 2)
				npcHandler:say("You advanced to {Hyaena} rank! You are now able to use teleports of second floor of Knightwatch Tower.", npc, creature)
			else
				npcHandler:say("Come back when you gather all essences.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			if player:removeItem(6499, 1000) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.BrotherhoodOutfit, 3)
				player:addItem(6432, 1)
				player:addAchievement('Skull and Bones')
				npcHandler:say("You advanced to {Death Dealer} rank!", npc, creature)
			else
				npcHandler:say("Come back when you gather all essences.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:removeItem(6499, 21465) then
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:setStorageValue(Storage.OutfitQuest.BrotherhoodOutfit, 4)
				player:setStorageValue(Storage.OutfitQuest.BrotherhoodDoor, 1)
				player:setStorageValue(Storage.KnightwatchTowerDoor, 1)
				player:addAchievement('Dread Lord')
				npcHandler:say("You advanced to {Dread Lord} rank! You are now able to use teleports of fourth floor of Knightwatch Tower and to create addon scrolls.", npc, creature)
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
