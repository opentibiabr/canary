local internalNpcName = "Valindara"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 138,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 114,
	lookFeet = 97,
	lookAddons = 0,
}

npcConfig.respawnType = {
	period = RESPAWNPERIOD_DAY,
	underground = false,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "I'm eager for a bath in the lake." },
	{ text = "I'm interested in shiny precious things, if you have some." },
	{ text = "No, you can't have this cloak." },
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


	if MsgContains(message, "cloak") or MsgContains(message, "swan") then
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission03.AnUnlikelyCouple) < 4 then
			npcHandler:say("We can talk about this later if you help Maelyrra first.", npc, creature)
		end
		if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission03.AnUnlikelyCouple) == 4 then
			npcHandler:say("You did us a great favour, mortal being! Well, as I promised I will craft you a feathery cloak. Bring me one hundred swan feathers and I will make them into a beautiful robe. Do you have enough feathers yet?", npc, creature)
			player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCloak, 1)			
			npcHandler:setTopic(playerId, 1)
		else
			return false
		end
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:removeItem(26181, 100) then
			npcHandler:say("Very good. I will craft the cloak for you. ... Here, take the cloak I crafted for you. Thanks again for helping us, mortal being.", npc, creature)
			player:addItem(25779, 1)
			player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission05.SwanFeatherCloak, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You don't have enough swan feathers.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end

	return true
end

npcConfig.shop = {
	{ itemName = "amber with a bug", clientId = 32624, sell = 41000 },
	{ itemName = "amber with a dragonfly", clientId = 32625, sell = 56000 },
	{ itemName = "amber", clientId = 32626, sell = 20000 },
	{ itemName = "ancient coin", clientId = 24390, sell = 350 },
	{ itemName = "bar of gold", clientId = 14112, sell = 10000 },
	{ itemName = "black pearl", clientId = 3027, buy = 560, sell = 280 },
	{ itemName = "blue crystal shard", clientId = 16119, sell = 1500 },
	{ itemName = "blue crystal splinter", clientId = 16124, sell = 400 },
	{ itemName = "blue rose", clientId = 3659, sell = 200 },
	{ itemName = "bronze goblet", clientId = 5807, buy = 2000 },
	{ itemName = "brown crystal splinter", clientId = 16123, sell = 400 },
	{ itemName = "brown giant shimmering pearl", clientId = 282, sell = 3000 },
	{ itemName = "butterfly ring", clientId = 25698, sell = 2000 },
	{ itemName = "colourful snail shell", clientId = 25696, sell = 250 },
	{ itemName = "coral brooch", clientId = 24391, sell = 750 },
	{ itemName = "crunor idol", clientId = 30055, sell = 30000 },
	{ itemName = "cyan crystal fragment", clientId = 16125, sell = 800 },
	{ itemName = "dandelion seeds", clientId = 25695, sell = 200 },
	{ itemName = "diamond", clientId = 32770, sell = 15000 },
	{ itemName = "dragon figurine", clientId = 30053, sell = 45000 },
	{ itemName = "dream blossom staff", clientId = 25700, sell = 5000 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "fairy wings", clientId = 25694, sell = 200 },
	{ itemName = "fern", clientId = 3737, sell = 20 },
	{ itemName = "gemmed figurine", clientId = 24392, sell = 3500 },
	{ itemName = "giant amethyst", clientId = 32622, sell = 60000 },
	{ itemName = "giant emerald", clientId = 30060, sell = 90000 },
	{ itemName = "giant ruby", clientId = 30059, sell = 70000 },
	{ itemName = "giant sapphire", clientId = 30061, sell = 50000 },
	{ itemName = "giant topaz", clientId = 32623, sell = 80000 },
	{ itemName = "goat grass", clientId = 3674, sell = 50 },
	{ itemName = "gold ingot", clientId = 9058, sell = 5000 },
	{ itemName = "gold nugget", clientId = 3040, sell = 850 },
	{ itemName = "golden amulet", clientId = 3013, buy = 6600 },
	{ itemName = "golden figurine", clientId = 5799, sell = 3000 },
	{ itemName = "golden goblet", clientId = 5805, buy = 5000 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 158 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
	{ itemName = "greater guardian gem", clientId = 44604, sell = 10000 },
	{ itemName = "greater marksman gem", clientId = 44607, sell = 10000 },
	{ itemName = "greater mystic gem", clientId = 44613, sell = 10000 },
	{ itemName = "greater sage gem", clientId = 44610, sell = 10000 },
	{ itemName = "green crystal fragment", clientId = 16127, sell = 800 },
	{ itemName = "green crystal shard", clientId = 16121, sell = 1500 },
	{ itemName = "green crystal splinter", clientId = 16122, sell = 400 },
	{ itemName = "green giant shimmering pearl", clientId = 281, sell = 3000 },
	{ itemName = "guardian gem", clientId = 44603, sell = 5000 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "hexagonal ruby", clientId = 30180, sell = 30000 },
	{ itemName = "hibiscus dress", clientId = 8045, sell = 3000 },
	{ itemName = "leaf star", clientId = 25735, sell = 50 },
	{ itemName = "lesser guardian gem", clientId = 44602, sell = 1000 },
	{ itemName = "lesser marksman gem", clientId = 44605, sell = 1000 },
	{ itemName = "lesser mystic gem", clientId = 44611, sell = 1000 },
	{ itemName = "lesser sage gem", clientId = 44608, sell = 1000 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "mandrake", clientId = 5014, sell = 5000 },
	{ itemName = "marksman gem", clientId = 44606, sell = 5000 },
	{ itemName = "moonstone", clientId = 32771, sell = 13000 },
	{ itemName = "mystic gem", clientId = 44612, sell = 5000 },
	{ itemName = "onyx chip", clientId = 22193, sell = 500 },
	{ itemName = "opal", clientId = 22194, sell = 500 },
	{ itemName = "ornate lion figurine", clientId = 33781, sell = 10000 },
	{ itemName = "ornate locket", clientId = 30056, sell = 18000 },
	{ itemName = "panpipes", clientId = 2953, sell = 150 },
	{ itemName = "powder herb", clientId = 3739, sell = 10 },
	{ itemName = "prismatic quartz", clientId = 24962, sell = 450 },
	{ itemName = "rainbow quartz", clientId = 25737, sell = 500 },
	{ itemName = "red crystal fragment", clientId = 16126, sell = 800 },
	{ itemName = "red rose", clientId = 3658, sell = 10 },
	{ itemName = "ruby necklace", clientId = 3016, buy = 3560 },
	{ itemName = "sage gem", clientId = 44609, sell = 5000 },
	{ itemName = "shimmering beetles", clientId = 25693, sell = 150 },
	{ itemName = "silver goblet", clientId = 5806, buy = 3000 },
	{ itemName = "skull coin", clientId = 32583, sell = 12000 },
	{ itemName = "sling herb", clientId = 3738, sell = 10 },
	{ itemName = "small amethyst", clientId = 3033, buy = 400, sell = 200 },
	{ itemName = "small diamond", clientId = 3028, buy = 600, sell = 300 },
	{ itemName = "small emerald", clientId = 3032, buy = 500, sell = 250 },
	{ itemName = "small enchanted amethyst", clientId = 678, sell = 200 },
	{ itemName = "small enchanted emerald", clientId = 677, sell = 250 },
	{ itemName = "small enchanted ruby", clientId = 676, sell = 250 },
	{ itemName = "small enchanted sapphire", clientId = 675, sell = 250 },
	{ itemName = "small ruby", clientId = 3030, buy = 500, sell = 250 },
	{ itemName = "small sapphire", clientId = 3029, buy = 500, sell = 250 },
	{ itemName = "small topaz", clientId = 9057, sell = 200 },
	{ itemName = "star herb", clientId = 3736, sell = 15 },
	{ itemName = "stone herb", clientId = 3735, sell = 20 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 108 },
	{ itemName = "summer dress", clientId = 8046, sell = 1500 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
	{ itemName = "swan feather", clientId = 26181, buy = 500 },
	{ itemName = "tiger eye", clientId = 24961, sell = 350 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
	{ itemName = "unicorn figurine", clientId = 30054, sell = 50000 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
	{ itemName = "violet crystal shard", clientId = 16120, sell = 1500 },
	{ itemName = "watering can", clientId = 650, buy = 50 },
	{ itemName = "watermelon tourmaline", clientId = 33780, sell = 230000 },
	{ itemName = "wedding ring", clientId = 3004, buy = 990, sell = 100 },
	{ itemName = "white gem", clientId = 32769, sell = 12000 },
	{ itemName = "white pearl", clientId = 3026, buy = 320, sell = 160 },
	{ itemName = "white silk flower", clientId = 34008, sell = 9000 },
	{ itemName = "wild flowers", clientId = 25691, sell = 120 },
	{ itemName = "wood cape", clientId = 3575, sell = 5000 },
	{ itemName = "wooden spellbook", clientId = 25699, sell = 12000 },
}

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Greetings, mortal being.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Yes, I have some potions and runes if you are interested. Or do you want to buy only potions or only runes? Oh, if you want sell or buy gems, you may also ask me. I am also interested in {swan} feathers.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May enlightenment be your path, |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)