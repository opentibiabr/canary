local internalNpcName = "Andrew Lyze"
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
	lookHead = 38,
	lookBody = 43,
	lookLegs = 75,
	lookFeet = 58,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}
npcConfig.shop = {
	{ itemName = "broken compass", clientId = 25746, buy = 10000 }
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

	if MsgContains(message, "monument") then
		npcHandler:say({
		"Well, a while ago powerful magic devices were used all around Tibia. These are chargeable compasses. There was but one problem: they offered the possibility to make people rich in a quite easy way. ...",
		 "Therefore, these instruments were very coveted. People tried to get their hands on them at all costs. And so it happened what everybody feared - bloody battles forged ahead. ...",
		 "To put an end to these cruel escalations, eventually all of the devices were collected and destroyed. The remains were buried {deep} in the earth."
	 }, npc, creature, 10)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "deep") then
		npcHandler:say("As far as I know it is a place of helish heat with bloodthirsty monsters of all kinds.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "sarcophagus") then
		npcHandler:say("This sarcophagus seals the entrance to the caves down there. Only here you can get all the {materials} you need for a working compass of this kind. So no entrance here - no further magic compasses in Tibia. In theory.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "materials") then
		if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.AndrewDoor) ~= 1 then
			player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.AndrewDoor, 1)
		end
		npcHandler:say({
		 "Only in the cave down there you will find the materials you need to repair the compass. Now you know why the entrance is sealed. There's the seal, but I have a deal for you: ...",
		 "I can repair the compass for you if you deliver what I need. Besides the broken compass you have to bring me the following materials: 50 blue glas plates, 15 green glas plates and 5 violet glas plates. ...",
		 "They all can be found in this closed cave in front of you. I should have destroyed this seal key but things have changed. The entrance is opened now, go down and do what has to be done."}, npc, creature, 10)
	 npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "down") then
		npcHandler:say("On first glance, this cave does not look very spectacular, but the things you find in there, are. You have to know that this is the only place where you can find the respective materials to build the {compass}.", npc, creature)
	 npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "compass") then
		npcHandler:say("It was decided to collect all of the compasses, destroy them and throw them in the fiery {depths} of Tibia. I still have some of them here. I {sell} them for a low price if you want.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "depths") then
		npcHandler:say("As far as I know it is a place of helish heat with bloodthirsty monsters of all kinds.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "sell") then
		npcHandler:say("Would you like to buy a broken compass for 10.000 gold?", npc, creature)
	 npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		local message = "You have bought a compass"
		if not checkWeightAndBackpackRoom(player, 80, message) then
			npcHandler:say("You not have room or capacity to take it.", npc, creature)
			return true
		end
		if player:getMoney() + player:getBankBalance() >= 5000 then
			player:removeMoneyBank(5000)
			player:addItem(10302, 1)
		end
		npcHandler:setTopic(playerId, 0)  
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Hello, I am the warden of this {monument}. The {sarcophagus} in front of you was established to prevent people from going {down} there. But I {doubt} that this step is sufficient.")

npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
