local internalNpcName = "Moe"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 118,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "The menu of the day sounds delicious!" },
	{ text = "The last visit to the theatre was quite rewarding." },
	{ text = "Such a beautiful and wealthy city - with so many opportunities ..." },
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

	if MsgContains(message, "help") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 1 then
			npcHandler:say("I guess I could do this, yes. But I have to impose a condition. If you bring me ten sphinx feathers I will steal this ring for you.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 2)
		end
	elseif MsgContains(message, "feathers") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 2 then
			if player:getItemById(31437, 10) then
				npcHandler:say("Thank you! They look so pretty, I'm very pleased. Agreed, now I will steal the ring from the Ambassador of Rathleton. Just be patient, I have to wait for a good moment.", npc, creature)
				player:removeItem(31437, 10)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 3)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.MoeTimer, os.time() + 60 * 60)
			else
				npcHandler:say("If you bring me ten sphinx feathers, I will steal this ring for you.", npc, creature)
			end
		else
			npcHandler:say("You already delivered the feathers. Be patient while I steal the ring.", npc, creature)
		end
	elseif MsgContains(message, "ring") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 3 then
			local timeLeft = player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.MoeTimer) - os.time()
			if timeLeft <= 0 then
				npcHandler:say("You're arriving at the right time. I have the ring you asked for. It was not too difficult. I just had to wait until the Ambassador left his residence and then I climbed in through the window. Here it is.", npc, creature)
				player:addItem(31306, 1)
				player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 4)
			else
				npcHandler:say("I will steal it, promised. I'm just waiting for a good moment.", npc, creature)
			end
		elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 1 then
			npcHandler:say("I guess I could do this, yes. But I have to impose a condition. If you bring me ten sphinx feathers I will steal this ring for you.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 2)
		else
			npcHandler:say("You don't need this ring anymore.", npc, creature)
		end
	elseif MsgContains(message, "lyre") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre) == 1 then
			npcHandler:say("I'm upset to accuse myself, the lyre is hidden in a tomb west of Kilmaresh.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Thirteen.Lyre, 2)
		else
			npcHandler:say("You already know about the lyre's location.", npc, creature)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, traveller. It seems, you're a {guest} here, just like me.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
