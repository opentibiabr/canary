local internalNpcName = "Cledwyn"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 150
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 114,
	lookBody = 0,
	lookLegs = 76,
	lookFeet = 94,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.currency = 22516

npcConfig.shop = {
	{ itemName = "earthheart cuirass", clientId = 22521, buy = 100},
	{ itemName = "earthheart hauberk", clientId = 22522, buy = 100, },
	{ itemName = "earthheart platemail", clientId = 22523, buy = 100, },
	{ itemName = "earthmind raiment", clientId = 22535, buy = 100, },
	{ itemName = "earthsoul tabard", clientId = 22531, buy = 100, },
	{ itemName = "fireheart cuirass", clientId = 22518, buy = 100, },
	{ itemName = "fireheart hauberk", clientId = 22519, buy = 100, },
	{ itemName = "fireheart platemail", clientId = 22520, buy = 100 },
	{ itemName = "firemind raiment", clientId = 22534, buy = 100 },
	{ itemName = "firesoul tabard", clientId = 22530, buy = 100},
	{ itemName = "frostheart cuirass", clientId = 22527, buy = 100},
	{ itemName = "frostheart hauberk", clientId = 22528, buy = 100, },
	{ itemName = "frostheart platemail", clientId = 22529, buy = 100 },
	{ itemName = "frostmind raiment", clientId = 22537, buy = 100 },
	{ itemName = "frostsoul tabard", clientId = 22533, buy = 100 },
	{ itemName = "magic shield potion", clientId = 35563, buy = 1 },
	{ itemName = "thunderheart cuirass", clientId = 22524, buy = 100 },
	{ itemName = "thunderheart hauberk", clientId = 22525, buy = 100 },
	{ itemName = "thunderheart platemail", clientId = 22526, buy = 100 },
	{ itemName = "thundermind raiment", clientId = 22536, buy = 100 },
	{ itemName = "thundersoul tabard", clientId = 22532, buy = 100 }
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

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Trading tokens! First-class bargains!' },
	{ text = 'Bespoke armor for all vocations! For the cost of some tokens only!' },
	{ text = 'Tokens! Bring your tokens!' }
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

local charge = {}

local chargeItem = {
	['pendulet'] = {noChargeID = 29429, ChargeID = 30344},
	['sleep shawl'] = {noChargeID = 29428, ChargeID = 30342},
	['blister ring'] = {noChargeID = 31621, ChargeID = 31557},
	['theurgic amulet'] = {noChargeID = 30401, ChargeID = 30403},
	['ring of souls'] = {noChargeID = 32636, ChargeID = 32621},
	['spiritthorn ring'] = {noChargeID = 39179, ChargeID = 39177},
	['alicorn ring'] = {noChargeID = 39182, ChargeID = 39180},
	['arcanomancer sigil'] = {noChargeID = 39185, ChargeID = 39183},
	['arboreal ring'] = {noChargeID = 39188, ChargeID = 39187},
	['turtle amulet'] = {noChargeID = 39235, ChargeID = 39233}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if not player or not playerId then
		return false
	end

	if MsgContains(message, 'token') or MsgContains(message, 'tokens') then
		npcHandler:say("If you have any {silver} tokens with you, let's have a look! Maybe I can offer you something in exchange.", npc, creature)
	elseif MsgContains(message, 'information') then
		npcHandler:say("With pleasure. <bows> I trade {token}s. There are several ways to obtain the {token}s I am interested in - killing certain bosses, for example. In exchange for a certain amount of tokens, I can offer you some first-class items.", npc, creature)
	elseif MsgContains(message, 'talk') then
		npcHandler:say({"Why, certainly! I'm always up for some small talk. ...",
						 "The weather continues just fine here, don't you think? Just the day for a little walk around the town! ...",
						 "Actually, I haven't been around much yet, but I'm looking forward to exploring the city once I've finished trading {token}s."}, npc, creature)
	elseif MsgContains(message, 'silver') then
		npc:openShopWindow(creature)
		npcHandler:say({"Here's the deal, " .. player:getName() .. ". For 100 of your silver tokens, I can offer you some first-class torso armor. These armors provide a solid boost to your main attack skill, as well as ...",
		"some elemental protection of your choice! I also sell a magic shield potion for one silver token. So these are my offers."}, npc, creature)
	elseif MsgContains(message, 'enchant') then
		npcHandler:say({"The following items can be enchanted: {pendulet}, {sleep shawl}, {blister ring}, {theurgic amulet}, {ring of souls}. ...",
						"For sufficient silver tokens you can also enchant: {spiritthorn ring}, {alicorn ring}, {arcanomancer sigil}, {arboreal ring}, {turtle amulet}. Make you choice!"}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif isInArray({'pendulet', 'sleep shawl', 'blister ring', 'theurgic amulet', 'ring of souls', 'turtle amulet'}, message:lower()) and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Should I enchant the item " .. message .. " for 2 ".. ItemType(npc:getCurrency()):getPluralName():lower() .."?", npc, creature)
		charge = message:lower()
		npcHandler:setTopic(playerId, 2)
	elseif isInArray({'spiritthorn ring', 'alicorn ring', 'arcanomancer sigil', 'arboreal ring'}, message:lower()) and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Should I enchant the item " .. message .. " for 5 ".. ItemType(npc:getCurrency()):getPluralName():lower() .."?", npc, creature)
		charge = message:lower()
		npcHandler:setTopic(playerId, 2)
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			if not chargeItem[charge] then
				npcHandler:say("Sorry, you don't have an unenchanted ".. charge ..".", npc, creature)
			else
				if (player:getItemCount(npc:getCurrency()) >= 2) and (player:getItemCount(chargeItem[charge].noChargeID) >= 1) then
					player:removeItem(npc:getCurrency(), 2)
					player:removeItem(chargeItem[charge].noChargeID, 1)
					local itemAdd = player:addItem(chargeItem[charge].ChargeID, 1)
					npcHandler:say("Ah, excellent. Here is your " .. itemAdd:getName():lower() .. ".", npc, creature)
				else
					npcHandler:say("Sorry, friend, but one good turn deserves another. Bring enough ".. ItemType(npc:getCurrency()):getPluralName():lower() .." and it's a deal.", npc, creature)
				end
				npcHandler:setTopic(playerId, 0)
			end
		elseif MsgContains(message, 'no') then
			npcHandler:say("Alright, come back if you have changed your mind.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'addon') then
		if player:hasOutfit(846, 0) or player:hasOutfit(845, 0) then
			npcHandler:say("Ah, very good. Now choose your addon: {first} or {second}.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		else
			npcHandler:say("Sorry, friend, but one good turn deserves another. You need to obtain the rift warrior outfit first.", npc, creature)
		end
	elseif isInArray({'first', 'second'}, message:lower()) and npcHandler:getTopic(playerId) == 3 then
		if message:lower() == 'first' then
			if not(player:hasOutfit(846, 1)) and not(player:hasOutfit(845, 1)) then
				if player:removeItem(22516, 100) then
					npcHandler:say("Ah, excellent. Obtain the first addon for your rift warrior outfit.", npc, creature)
					player:addOutfitAddon(846, 1)
					player:addOutfitAddon(845, 1)
					if (player:hasOutfit(846, 1) or player:hasOutfit(845, 1)) and (player:hasOutfit(846, 2) or player:hasOutfit(845, 2)) then
						player:addAchievement("Rift Warrior")
					end
				else
					npcHandler:say("Sorry, friend, but one good turn deserves another. Bring enough ".. ItemType(npc:getCurrency()):getPluralName():lower() .." and it's a deal.", npc, creature)
				end
			else
				npcHandler:say("Sorry, friend, you already have the first Rift Warrior addon.", npc, creature)
			end
		elseif message:lower() == 'second' then
			if not(player:hasOutfit(846, 2)) and not(player:hasOutfit(845, 2)) then
				if player:removeItem(22516, 100) then
					npcHandler:say("Ah, excellent. Obtain the second addon for your rift warrior outfit.", npc, creature)
					player:addOutfitAddon(846, 2)
					player:addOutfitAddon(845, 2)
					if (player:hasOutfit(846, 1) or player:hasOutfit(845, 1)) and (player:hasOutfit(846, 2) or player:hasOutfit(845, 2)) then
						player:addAchievement("Rift Warrior")
					end
				else
					npcHandler:say("Sorry, friend, but one good turn deserves another. Bring enough ".. ItemType(npc:getCurrency()):getPluralName():lower() .." and it's a deal.", npc, creature)
				end
			else
				npcHandler:say("Sorry, friend, you already have the second Rift Warrior addon.", npc, creature)
			end
		end
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Blessings, Player! How may I be of service? Do you wish to trade some {token}s, or would you like some {information} or {talk}? Should I {enchant} certain items for you?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
