local internalNpcName = "Taegen"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 980,
	lookHead = 100,
	lookBody = 41,
	lookLegs = 94,
	lookFeet = 41,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Id like to take a walk with Aurita." },
	{ text = "I miss Aurita golden hair.*sigh*" },
	{ text = "Pas in boldly tyll thow com to an hall the feyrist undir sky ... *sings*" },
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

npcConfig.shop = {
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bow", clientId = 3350, buy = 400, sell = 100 },
	{ itemName = "crossbow", clientId = 3349, buy = 500, sell = 120 },
	{ itemName = "crystalline arrow", clientId = 15793, buy = 20 },
	{ itemName = "diamond arrow", clientId = 35901, buy = 130 },
	{ itemName = "drill bolt", clientId = 16142, buy = 12 },
	{ itemName = "earth arrow", clientId = 774, buy = 5 },
	{ itemName = "envenomed arrow", clientId = 16143, buy = 12 },
	{ itemName = "flaming arrow", clientId = 763, buy = 5 },
	{ itemName = "flash arrow", clientId = 761, buy = 5 },
	{ itemName = "onyx arrow", clientId = 7365, buy = 7 },
	{ itemName = "piercing bolt", clientId = 7363, buy = 5 },
	{ itemName = "power bolt", clientId = 3450, buy = 7 },
	{ itemName = "prismatic bolt", clientId = 16141, buy = 20 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "royal spear", clientId = 7378, buy = 15 },
	{ itemName = "shiver arrow", clientId = 762, buy = 5 },
	{ itemName = "sniper arrow", clientId = 7364, buy = 5 },
	{ itemName = "spear", clientId = 3277, buy = 9, sell = 3 },
	{ itemName = "spectral bolt", clientId = 35902, buy = 70 },
	{ itemName = "tarsal arrow", clientId = 14251, buy = 6 },
	{ itemName = "throwing star", clientId = 3287, buy = 42 },
	{ itemName = "vortex bolt", clientId = 14252, buy = 6 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) < 1 then
			npcHandler:say({
				"Yes, there is something. It's a bit embarassing, you must promise not to tell anyone else. I'm in love with Aurita. Well, that wouldn't be a reson to be ashamed, but she is a mermaid. ...",
				"A faun on the other hand is inhabiting the forests, dancing with fairies and, well, nymphs. But I lost my heart to the lovely Aurita. I can't help it. We would love to spend some time together, but not just sitting on the beach. ...",
				"I'd love to show her the deep forest I love so much. I have an idea but I can't do it alone. Would you help me?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 1 then
			npcHandler:say({
				"There is a fairy who once told me about this spell. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 2 and player:getItemCount(25782) >= 1 then
			npcHandler:say({
				"We are so happy. Now Aurita can take a walk on the beach. But I still can't visit her secret underwater grotto. To achieve this, we need something else: a very rare plant called raven herb. ...",
				"If eaten it allows an air breathing creature to breathe underwater for a while. Please find this plant for me. But know that you'll only find it at night. It resembles a common fern but its leaves are of a lighter green.",
			}, npc, creature)
			player:removeItem(25782, 1)
			player:setStorageValue(ThreatenedDreams.Mission03[1], 3)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 4)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say({
				"Thank you! We are so happy. Now Aurita can take a walk on the beach. And I can visit her secret underwater grotto.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "sun catcher") then
		if player:getStorageValue(ThreatenedDreams.Mission03[1]) == 3 then
			npcHandler:say({
				"Have you found some raven herb?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(ThreatenedDreams.Mission03[1]) == 4 then
			npcHandler:say({
				"Thank you again, mortal being. A sun catcher is similar to a dream catcher but other than the latter it can preserve sunlight rather than bad dreams. I can craft one out of enchanted branches of a fairy tree as well as several enchanted gems. ...",
				"The branches are no problem, I will find some in the forest. But I don't have any gems. If you bring me some, I can craft a sun catcher for you. Do you have gems?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"That's very kind of you, my friend! Listen: I know there is a spell to transform her fishtail into legs. It is a temporary effect, so she could return to the ocean as soon as the spell ends. Unfortunately I don't know how to cast this spell. ...",
				"But there is a fairy who once told me about it. Perhaps she will share her knowledge. You can find her in a small fairy village in the southwest of Feyrist.",
			}, npc, creature)
			player:setStorageValue(ThreatenedDreams.Mission03[1], 1)
			player:setStorageValue(ThreatenedDreams.Mission03.UnlikelyCouple, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getItemCount(5953) > 0 then
				npcHandler:say({
					"Thank you, friend! Now I can visit Aurita in her underwater grotto!",
				}, npc, creature)
				player:removeItem(5953, 1)
				npcHandler:setTopic(playerId, 3)
				player:setStorageValue(ThreatenedDreams.Mission03[1], 4)
			else
				npcHandler:say({
					"Please find this plant for me. But know that you'll only find it at night. It resembles a common fern but its leaves are of a lighter green.",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(ThreatenedDreams.Mission03.DarkSunCatcher) == 1 then
				npcHandler:say({
					"I already crafted one sun catcher for you.",
				}, npc, creature)
			elseif player:getItemCount(675) >= 2 and player:getItemCount(676) >= 2 and player:getItemCount(677) >= 2 and player:getItemCount(678) >= 2 and player:getStorageValue(ThreatenedDreams.Mission03.DarkSunCatcher) < 1 then
				npcHandler:say({
					"Alright, I will craft a sun catcher for you.",
				}, npc, creature)
				player:removeItem(675, 2)
				player:removeItem(676, 2)
				player:removeItem(677, 2)
				player:removeItem(678, 2)
				player:addItem(25733, 1)
				player:setStorageValue(ThreatenedDreams.Mission03.DarkSunCatcher, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({
					"I don't have any gems. If you bring me some, I can craft a sun catcher for you. Do you have gems?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("Then not.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Be greeted, mortal being!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May enlightenment be your path, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May enlightenment be your path, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, " Im carving bolts and arrows and i also craft bows anda spears.If you'd like to buy some ammunition, take a look.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
