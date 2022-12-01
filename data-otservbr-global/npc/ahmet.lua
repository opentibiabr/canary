local internalNpcName = "Ahmet"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 57,
	lookBody = 116,
	lookLegs = 97,
	lookFeet = 114,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}
npcConfig.shop = {	-- Sellable items
	{ itemName = "basket", clientId = 2855, buy = 6 },
	{ itemName = "bottle", clientId = 2875, buy = 3 },
	{ itemName = "bucket", clientId = 2873, buy = 4 },
	{ itemName = "candelabrum", clientId = 2912, buy = 8 },
	{ itemName = "candlestick", clientId = 2917, buy = 2 },
	{ itemName = "closed trap", clientId = 3481, buy = 280, sell = 75 },
	{ itemName = "crowbar", clientId = 3304, buy = 260, sell = 50 },
	{ itemName = "cup", clientId = 2881, buy = 2 },
	{ itemName = "deed of ownership", clientId = 7866, buy = 1000 },
	{ itemName = "document", clientId = 2818, buy = 12 },
	{ itemName = "fishing rod", clientId = 3483, buy = 40, sell = 40 },
	{ itemName = "golden backpack", clientId = 2871, buy = 10 },
	{ itemName = "golden bag", clientId = 2863, buy = 4 },
	{ itemName = "hand auger", clientId = 31334, buy = 25 },
	{ itemName = "machete", clientId = 3308, buy = 6, sell = 6 },
	{ itemName = "net", clientId = 31489, buy = 50 },
	{ itemName = "parchment", clientId = 2817, buy = 8 },
	{ itemName = "pick", clientId = 3456, buy = 50, sell = 15 },
	{ itemName = "plate", clientId = 2905, buy = 6 },
	{ itemName = "present", clientId = 2856, buy = 10 },
	{ itemName = "rope", clientId = 3003, buy = 50, sell = 15 },
	{ itemName = "scroll", clientId = 2815, buy = 5 },
	{ itemName = "scythe", clientId = 3453, buy = 50, sell = 10 },
	{ itemName = "shovel", clientId = 3457, buy = 10, sell = 8 },
	{ itemName = "torch", clientId = 2920, buy = 2 },
	{ itemName = "vial of oil", clientId = 2874, buy = 20, count = 7 },
	{ itemName = "watch", clientId = 2906, buy = 20, sell = 6 },
	{ itemName = "waterskin of water", clientId = 2901, buy = 40, count = 1 },
	{ itemName = "wooden hammer", clientId = 3459, sell = 15 },
	{ itemName = "worm", clientId = 3492, buy = 1 }
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

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'documents') then
		if player:getStorageValue(Storage.ThievesGuild.Mission04) == 2 then
			player:setStorageValue(Storage.ThievesGuild.Mission04, 3)
			npcHandler:say({
				'You need some forged documents? But I will only forge something for a friend. ...',
				'The nomads at the northern oasis killed someone dear to me. Go and kill at least one of them, then we talk about your document.'
			}, npc, creature)
		elseif player:getStorageValue(Storage.ThievesGuild.Mission04) == 4 then
			npcHandler:say('The slayer of my enemies is my friend! For a mere 1000 gold I will create the documents you need. Are you interested?', npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, 'mission') or MsgContains(message, 'quest') then
		if player:getStorageValue(Storage.QuestChests.StealFromThieves) < 1 then
			npcHandler:say({
				"What are you talking about?? I was robbed!!!! Someone catch those filthy thieves!!!!! GUARDS! ...",
				"<nothing happens>....<SIGH> Like usual, they hide at the slightest sign of trouble! YOU! Want to earn some quick money?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.QuestChests.StealFromThieves) == 1 or player:getStorageValue(Storage.QuestChests.StealFromThieves) == 2 then
			npcHandler:say('Did you find my stuff?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, 'book') then
		npcHandler:say('I see: You want me to add an additional story to this book. A legend about how it brings ill luck to kill a white deer. I could do that, yes. It costs 5000 gold, however. Are you still interested?', npc, creature)
		npcHandler:setTopic(playerId, 5)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			if player:removeMoneyBank(1000) then
				player:addItem(7866, 1)
				player:setStorageValue(Storage.ThievesGuild.Mission04, 5)
				npcHandler:say('And here they are! Now forget where you got them from.', npc, creature)
			else
				npcHandler:say('You don\'t have enough money.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Of course you do! Go hunt down the thieves and bring back the stuff they have stolen from me. ...",
				" I saw them running out of town and then to the north. Maybe they hide at the oasis."
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.QuestChests.StealFromThieves, 1)
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:removeItem(235, 1) then
				npcHandler:say('GREAT! If you ever need a job as my personal security guard, let me know. Here is the reward I promised you.', npc, creature)
				player:setStorageValue(Storage.QuestChests.StealFromThieves, 3)
				player:addItem(3031, 100)
				player:addItem(3725, 100)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say('Come back when you find my stuff.', npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 5 then
			if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 1
			and player:getStorageValue(ThreatenedDreams.Mission01.PoacherChest) == 1 then
				if player:getItemCount(25235) >= 1 and player:getMoney() >= 5000 then
					player:removeMoney(5000)
					npcHandler:say({
						"Well then. Here, take the book, I added the story. Oh, just a piece of advice: Not to inflame prejudice but poachers are of rather simple disposition. I doubt they are ardent readers. ...",
						"So if you want to make sure they read this anytime soon, perhaps don't hide the book in a shelf or chest. Make sure to place it somewhere where they will find it easily, like very obviously on a table or something."
					}, npc, creature)
					player:setStorageValue(ThreatenedDreams.Mission01[1], 2)
					npcHandler:setTopic(playerId, 0)
				else
					npcHandler:say("You need 5000 gps and book with ancient legends.", npc, creature)
				end
			else
				npcHandler:say("You are not in this mission.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
