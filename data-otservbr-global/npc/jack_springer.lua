local internalNpcName = "Jack Springer"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 289,
	lookHead = 114,
	lookBody = 114,
	lookLegs = 114,
	lookFeet = 113,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = "Always be on guard."},
	{text = "Hmm."}
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

local GraveDanger = Storage.Quest.U12_20.GraveDanger
local function greetCallback(npc, creature)
	local player = Player(creature)

	if player:getStorageValue(GraveDanger.QuestLine) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! There is much we have to {discuss}.")
	elseif player:getStorageValue(GraveDanger.QuestLine) >= 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome, |PLAYERNAME|! Is there anything to {report}?")
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)

	if MsgContains(message, "late") then
		if player:getStorageValue(GraveDanger.QuestLine) < 1 then
			npcHandler:say({
				"While you travel and fight the threat where it arises, we will put all our resources into researching the ultimate plans of the legion. Perhaps I can tell you more when you {report} back. ...",
				"Don't forget that you'll need very potent holy water for your task. If you need some, just ask me for a {trade}."}, npc, creature)
			player:setStorageValue(GraveDanger.QuestLine, 1)
			player:setStorageValue(GraveDanger.Graves.Edron, 1)
			player:setStorageValue(GraveDanger.Graves.DarkCathedral, 1)
			player:setStorageValue(GraveDanger.Graves.Ghostlands, 1)
			player:setStorageValue(GraveDanger.Graves.Cormaya, 1)
			player:setStorageValue(GraveDanger.Graves.FemorHills, 1)
			player:setStorageValue(GraveDanger.Graves.Ankrahmun, 1)
			player:setStorageValue(GraveDanger.Graves.Kilmaresh, 1)
			player:setStorageValue(GraveDanger.Graves.Vengoth, 1)
			player:setStorageValue(GraveDanger.Graves.Darashia, 1)
			player:setStorageValue(GraveDanger.Graves.Thais, 1)
			player:setStorageValue(GraveDanger.Graves.Orclands, 1)
			player:setStorageValue(GraveDanger.Graves.IceIslands, 1)
		end
	end
	return true
end
--Basic

npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, my friend.")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "vial of potent holy water", clientId = 31612, buy = 100 }
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

npcType:register(npcConfig)
