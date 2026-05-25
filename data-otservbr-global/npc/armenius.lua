local internalNpcName = "Armenius"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 132,
	lookHead = 114,
	lookBody = 78,
	lookLegs = 113,
	lookFeet = 115,
	lookAddons = 0,
	lookMount = 0,
}

npcConfig.flags = {
	floorchange = false,
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

local BloodBrothers = Storage.Quest.U8_4.BloodBrothers
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()
	if message == "cookie" then
		if player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission02) == 1 and player:getItemCount(8199) > 0 and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Armenius) < 0 then
			npcHandler:say("What kind of strange offer is this? You're actually offering me a cookie?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		else
			npcHandler:say("It'd be better for you to leave now.", npc, creature)
		end
	elseif message == "yes" then
		if npcHandler:getTopic(playerId) == 1 and player:removeItem(8199, 1) then -- garlic cookie
			npcHandler:say("Errrkss - coughcough - what the - heck did you put in there? Get out of my sight!", npc, creature)
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Cookies.Armenius, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif message:lower() == "alori mort" and player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 1 or player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03) == 2 then
		if npcHandler:getTopic(playerId) == 0 then
			npcHandler:say("Stop mumbling and don't bug me.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("There's something about these words which makes me feel awkward. Or maybe it's you who causes that feeling. You better get lost.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("Whatever that's supposed to mean.", npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say({
				"...... ...... ...",
				"HAHAHAHAHA! What the... HAHAHAHA! Come on, say it again, just because it's so funny - and then I'll get rid of you, little mouse!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 5 then
			local rand = math.random(3)
			if rand == 1 then
				npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh, the nerve. Go to the rats which raised you.")
				player:teleportTo(Position(32759, 31241, 9))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			elseif rand == 2 then
				npcHandler:setMessage(MESSAGE_WALKAWAY, "You dare say that again?! I'll send you straight to your grave!")
				player:teleportTo(Position(32856, 31324, 8))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				Game.createMonster("Armenius", Position(32857, 31324, 8))
				if not player:hasAchievement("His True Face") then
					player:addAchievement("His True Face")
				end
			else
				npcHandler:say("Oh, the nerve. Sod off.", npc, creature)
			end
			player:setStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission03, 2)
		end
	end
end
-- Basic
keywordHandler:addKeyword({ "blood crystal" }, StdModule.say, { npcHandler = npcHandler, text = "If you want blood, go kill a pig." }, function(player)
	return player:getStorageValue(Storage.Quest.U8_4.BloodBrothers.Mission05) == 1
end)

npcHandler:setMessage(MESSAGE_GREET, "Ah, an adventurer. Be greeted and have a seat. How may I {serve} you?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "bread", clientId = 3600, buy = 3 },
	{ itemName = "cheese", clientId = 3607, buy = 5 },
	{ itemName = "egg", clientId = 3606, buy = 2 },
	{ itemName = "ham", clientId = 3582, buy = 8 },
	{ itemName = "meat", clientId = 3577, buy = 5 },
	{ itemName = "mug of beer", clientId = 2880, buy = 3, count = 3 },
	{ itemName = "mug of rum", clientId = 2880, buy = 10, count = 13 },
	{ itemName = "mug of wine", clientId = 2880, buy = 4, count = 2 },
	{ itemName = "tomato", clientId = 3596, buy = 3 },
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

npcType:register(npcConfig)
