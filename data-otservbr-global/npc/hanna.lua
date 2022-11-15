local internalNpcName = "Hanna"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 136,
	lookHead = 96,
	lookBody = 65,
	lookLegs = 0,
	lookFeet = 96,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Gems and jewellery! Best prices in town!'}
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

	if MsgContains(message, "addon") or MsgContains(message, "outfit") or MsgContains(message, "hat") then
		local addonProgress = player:getStorageValue(Storage.OutfitQuest.Citizen.AddonHat)
		if addonProgress < 1 then
			npcHandler:say("Pretty, isn't it? My friend Amber taught me how to make it, but I could help you with one if you like. What do you say?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif addonProgress == 1 then
			npcHandler:say("Oh, you're back already? Did you bring a legion helmet, 100 chicken feathers and 50 honeycombs?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif addonProgress == 2 then
			npcHandler:say('Pretty hat, isn\'t it?', npc, creature)
		end
		return true
	end

	if npcHandler:getTopic(playerId) == 1 then
		if MsgContains(message, 'yes') then
			player:setStorageValue(Storage.OutfitQuest.Ref, math.max(0, player:getStorageValue(Storage.OutfitQuest.Ref)) + 1)
			player:setStorageValue(Storage.OutfitQuest.Citizen.AddonHat, 1)
			player:setStorageValue(Storage.OutfitQuest.Citizen.MissionHat, 1)
			npcHandler:say('Okay, here we go, listen closely! I need a few things... a basic hat of course, maybe a legion helmet would do. Then about 100 chicken feathers... and 50 honeycombs as glue. That\'s it, come back to me once you gathered it!', npc, creature)
		else
			npcHandler:say('Aw, I guess you don\'t like feather hats. No big deal.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)

	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, 'yes') then
			if player:getItemCount(3374) < 1 then
				npcHandler:say('Sorry, but I can\'t see a legion helmet.', npc, creature)
			elseif player:getItemCount(5890) < 100 then
				npcHandler:say('Sorry, but you don\'t enough chicken feathers.', npc, creature)
			elseif player:getItemCount(5902) < 50 then
				npcHandler:say('Sorry, but you don\'t have enough honeycombs.', npc, creature)
			else
				npcHandler:say('Great job! That must have taken a lot of work. Okay, you put it like this... then glue like this... here!', npc, creature)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

				player:removeItem(3374, 1)
				player:removeItem(5902, 50)
				player:removeItem(5890, 100)

				player:addOutfitAddon(136, 2)
				player:addOutfitAddon(128, 2)

				player:setStorageValue(Storage.OutfitQuest.Ref, math.min(0, player:getStorageValue(Storage.OutfitQuest.Ref) - 1))
				player:setStorageValue(Storage.OutfitQuest.Citizen.MissionHat, 0)
				player:setStorageValue(Storage.OutfitQuest.Citizen.AddonHat, 2)
			end
		else
			npcHandler:say('Maybe another time.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I am a jeweler. Maybe you want to have a look at my wonderful offers.'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I am Hanna.'})

npcHandler:setMessage(MESSAGE_GREET, 'Oh, please come in, |PLAYERNAME|. What do you need? Have a look at my wonderful {offers} in gems and jewellery.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "amber", clientId = 32626, sell = 20000 },
	{ itemName = "amber with a bug", clientId = 32624, sell = 41000 },
	{ itemName = "amber with a dragonfly", clientId = 32625, sell = 56000 },
	{ itemName = "ancient coin", clientId = 24390, sell = 350 },
	{ itemName = "black pearl", clientId = 3027, buy = 560, sell = 280 },
	{ itemName = "blue crystal shard", clientId = 16119, sell = 1500 },
	{ itemName = "blue crystal splinter", clientId = 16124, sell = 400 },
	{ itemName = "bronze goblet", clientId = 5807, buy = 2000 },
	{ itemName = "brown crystal splinter", clientId = 16123, sell = 400 },
	{ itemName = "coral brooch", clientId = 24391, sell = 750 },
	{ itemName = "crunor idol", clientId = 30055, sell = 30000 },
	{ itemName = "cyan crystal fragment", clientId = 16125, sell = 800 },
	{ itemName = "dragon figurine", clientId = 30053, sell = 45000 },
	{ itemName = "gemmed figurine", clientId = 24392, sell = 3500 },
	{ itemName = "giant amethyst", clientId = 30061, sell = 60000 },
	{ itemName = "giant emerald", clientId = 30060, sell = 90000 },
	{ itemName = "giant ruby", clientId = 30059, sell = 70000 },
	{ itemName = "giant sapphire", clientId = 30061, sell = 50000 },
	{ itemName = "giant shimmering pearl", clientId = 281, sell = 3000 }, -- green
	{ itemName = "giant shimmering pearl", clientId = 282, sell = 3000 }, -- brown
	{ itemName = "giant topaz", clientId = 32623, sell = 80000 },
	{ itemName = "gold ingot", clientId = 9058, sell = 5000 },
	{ itemName = "gold nugget", clientId = 3040, sell = 850 },
	{ itemName = "golden amulet", clientId = 3013, buy = 6600 },
	{ itemName = "golden goblet", clientId = 5805, buy = 5000 },
	{ itemName = "green crystal fragment", clientId = 16127, sell = 800 },
	{ itemName = "green crystal shard", clientId = 16121, sell = 1500 },
	{ itemName = "green crystal splinter", clientId = 16122, sell = 400 },
	{ itemName = "lion figurine", clientId = 33781, sell = 10000 },
	{ itemName = "onyx chip", clientId = 22193, sell = 400 },
	{ itemName = "opal", clientId = 22194, sell = 500 },
	{ itemName = "ornate locket", clientId = 30056, sell = 18000 },
	{ itemName = "prismatic quartz", clientId = 24962, sell = 450 },
	{ itemName = "red crystal fragment", clientId = 16126, sell = 800 },
	{ itemName = "ruby necklace", clientId = 3016, buy = 3560 },
	{ itemName = "silver goblet", clientId = 5806, buy = 3000 },
	{ itemName = "skull coin", clientId = 32583, sell = 12000 },
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
	{ itemName = "tiger eye", clientId = 24961, sell = 350 },
	{ itemName = "unicorn figurine", clientId = 30054, sell = 50000 },
	{ itemName = "violet crystal shard", clientId = 16120, sell = 1500 },
	{ itemName = "white silk flower", clientId = 34008, sell = 9000 },
	{ itemName = "wedding ring", clientId = 3004, buy = 990, sell = 100 },
	{ itemName = "white pearl", clientId = 3026, buy = 320, sell = 160 }
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
