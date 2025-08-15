local internalNpcName = "Uzgod"
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
	lookHead = 96,
	lookBody = 60,
	lookLegs = 97,
	lookFeet = 116,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "piece of draconian steel") and player:getStorageValue(Storage.Quest.U7_8.ObsidianKnife) < 1 then
		npcHandler:say("You bringing me draconian steel and obsidian lance in exchange for obsidian knife?", npc, creature)
		npcHandler:setTopic(playerId, 15)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 15 then
		if player:getItemCount(5889) >= 1 and player:getItemCount(3313) >= 1 then
			if player:removeItem(5889, 1) and player:removeItem(3313, 1) then
				npcHandler:say("Here you have it.", npc, creature)
				player:addItem(5908, 1)
				player:setStorageValue(Storage.Quest.U7_8.ObsidianKnife, 1)
				npcHandler:setTopic(playerId, 0)
			end
		else
			npcHandler:say("You don't have these items.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end

	if MsgContains(message, "pickaxe") then
		if player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.JoiningTheExplorers) == 1 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 1 then
			npcHandler:say("True dwarven pickaxes having to be maded by true weaponsmith! You wanting to get pickaxe for explorer society?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "crimson sword") then
		if player:getStorageValue(Storage.Quest.U8_1.TheTravellingTrader.Mission05) == 1 then
			npcHandler:say("Me don't sell crimson sword.", npc, creature)
			npcHandler:setTopic(playerId, 5)
		end
	elseif MsgContains(message, "forge") then
		if npcHandler:getTopic(playerId) == 5 then
			npcHandler:say("You telling me to forge one?! Especially for you? You making fun of me?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		end
	elseif MsgContains(message, "brooch") then
		if player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.JoiningTheExplorers) == 3 and player:getStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine) == 3 then
			npcHandler:say("You got me brooch?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("Me order book quite full is. But telling you what: You getting me something me lost and Uzgod seeing that your pickaxe comes first. Jawoll! You interested?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Good good. You listening: Me was stolen valuable heirloom. Brooch from my family. Good thing is criminal was caught. Bad thing is, criminal now in dwarven prison of dwacatra is and must have taken brooch with him ...", npc, creature)
			npcHandler:say("To get into dwacatra you having to get several keys. Each key opening way to other key until you get key to dwarven prison ...", npc, creature)
			npcHandler:say("Last key should be in the generals quarter near armory. Only General might have key to enter there too. But me not knowing how to enter Generals private room at barracks. You looking on your own ...", npc, creature)
			npcHandler:say("When got key, then you going down to dwarven prison and getting me that brooch. Tell me that you got brooch when having it.", npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.JoiningTheExplorers, 2)
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.DwacatraDoor, 1)
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 2)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(4834, 1) then -----
				npcHandler:say("Thanking you for brooch. Me guessing you now want your pickaxe?", npc, creature)
				npcHandler:setTopic(playerId, 4)
			end
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("Here you have it.", npc, creature)
			player:addItem(4845, 1) -----
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.JoiningTheExplorers, 4)
			player:setStorageValue(Storage.Quest.U7_6.ExplorerSociety.QuestLine, 4)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 9 then
			if player:getMoney() + player:getBankBalance() >= 250 and player:getItemCount(5880) >= 3 then
				if player:removeMoneyBank(250) and player:removeItem(5880, 3) then
					npcHandler:say("Ah, that's how me like me customers. Ok, me do this... <pling pling> ... another fine swing of the hammer here and there... <ploing>... here you have it!", npc, creature)
					player:addItem(7385, 1)
					player:setStorageValue(Storage.Quest.U8_1.TheTravellingTrader.Mission05, 2)
					npcHandler:setTopic(playerId, 0)
				end
			end
		end
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("Well. Thinking about it, me a smith, so why not. 1000 gold for your personal crimson sword. Ok?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("Too expensive?! You think me work is cheap? Well, if you want cheap, I can make cheap. Hrmpf. I make cheap sword for 300 gold. Ok?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say("Cheap but good quality? Impossible. Unless... you bring material. Three iron ores, 250 gold. Okay?", npc, creature)
			npcHandler:setTopic(playerId, 9)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hiho |PLAYERNAME|! Wanna weapon, eh?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Guut bye. Coming back soon.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Guut bye. Coming back soon.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "arrow", clientId = 3447, buy = 3 },
	{ itemName = "axe", clientId = 3274, buy = 20, sell = 7 },
	{ itemName = "battle axe", clientId = 3266, buy = 235, sell = 80 },
	{ itemName = "battle hammer", clientId = 3305, buy = 350, sell = 120 },
	{ itemName = "blue quiver", clientId = 35848, buy = 400 },
	{ itemName = "bolt", clientId = 3446, buy = 4 },
	{ itemName = "bone club", clientId = 3337, sell = 5 },
	{ itemName = "bone sword", clientId = 3338, buy = 75, sell = 20 },
	{ itemName = "bow", clientId = 3350, buy = 400 },
	{ itemName = "carlin sword", clientId = 3283, buy = 473, sell = 118 },
	{ itemName = "club", clientId = 3270, buy = 5, sell = 1 },
	{ itemName = "crossbow", clientId = 3349, buy = 500 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "dagger", clientId = 3267, buy = 5, sell = 2 },
	{ itemName = "double axe", clientId = 3275, sell = 260 },
	{ itemName = "durable exercise axe", clientId = 35280, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise bow", clientId = 35282, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise club", clientId = 35281, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise shield", clientId = 44066, buy = 1250000, count = 1800 },
	{ itemName = "durable exercise sword", clientId = 35279, buy = 1250000, count = 1800 },
	{ itemName = "exercise axe", clientId = 28553, buy = 347222, count = 500 },
	{ itemName = "exercise bow", clientId = 28555, buy = 347222, count = 500 },
	{ itemName = "exercise club", clientId = 28554, buy = 347222, count = 500 },
	{ itemName = "exercise shield", clientId = 44065, buy = 347222, count = 500 },
	{ itemName = "exercise sword", clientId = 28552, buy = 347222, count = 500 },
	{ itemName = "fire sword", clientId = 3280, sell = 1000 },
	{ itemName = "halberd", clientId = 3269, sell = 310 },
	{ itemName = "hand axe", clientId = 3268, buy = 8, sell = 4 },
	{ itemName = "hatchet", clientId = 3276, sell = 25 },
	{ itemName = "katana", clientId = 3300, sell = 35 },
	{ itemName = "lasting exercise axe", clientId = 35286, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise bow", clientId = 35288, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise club", clientId = 35287, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise shield", clientId = 44067, buy = 10000000, count = 14400 },
	{ itemName = "lasting exercise sword", clientId = 35285, buy = 10000000, count = 14400 },
	{ itemName = "longsword", clientId = 3285, buy = 160, sell = 51 },
	{ itemName = "mace", clientId = 3286, buy = 90 },
	{ itemName = "morning star", clientId = 3282, buy = 430 },
	{ itemName = "quiver", clientId = 35562, buy = 400 },
	{ itemName = "rapier", clientId = 3272, buy = 15 },
	{ itemName = "red quiver", clientId = 35849, buy = 400 },
	{ itemName = "sabre", clientId = 3273, buy = 35 },
	{ itemName = "short sword", clientId = 3294, buy = 26 },
	{ itemName = "sickle", clientId = 3293, buy = 7 },
	{ itemName = "spear", clientId = 3277, buy = 9 },
	{ itemName = "spike sword", clientId = 3271, buy = 8000 },
	{ itemName = "sword", clientId = 3264, buy = 85 },
	{ itemName = "throwing knife", clientId = 3298, buy = 25 },
	{ itemName = "two handed sword", clientId = 3265, buy = 950 },
	{ itemName = "war hammer", clientId = 3279, buy = 10000 },
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
