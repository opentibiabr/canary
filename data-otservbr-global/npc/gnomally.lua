local internalNpcName = "Gnomally"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 507,
	lookHead = 52,
	lookBody = 90,
	lookLegs = 90,
	lookFeet = 90,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.shop = {
	{ itemName = "bell", clientId = 15832, buy = 50 },
	{ itemName = "gnomish crystal package", clientId = 15802, buy = 1000 },
	{ itemName = "gnomish extraction crystal", clientId = 15696, buy = 50 },
	{ itemName = "gnomish repair crystal", clientId = 15703, buy = 50 },
	{ itemName = "gnomish spore gatherer", clientId = 15821, buy = 50 },
	{ itemName = "little pig", clientId = 15828, buy = 150 }
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

local topic = {}
local renown = {}

local config = {
	['supply'] = {itemid = 15698, token = {type = 'minor', id = 16128, count = 2}},
	['muck'] = {itemid = 16101, token = {type = 'minor', id = 16128, count = 8}},
	['mission'] = {itemid = 16242, token = {type = 'minor', id = 16128, count = 10}},
	['lamp'] = {itemid = 16094, token = {type = 'minor', id = 16128, count = 15}},
	['backpack'] = {itemid = 16099, token = {type = 'minor', id = 16128, count = 15}},
	['addition to the soil guardian outfit'] = {itemid = 16253, token = {type = 'minor', id = 16128, count = 70}},
	['addition to the crystal warlord armor outfit'] = {itemid = 16256, token = {type = 'minor', id = 16128, count = 70}},
	['gill gugel'] = {itemid = 16104, token = {type = 'major', id = 16129, count = 10}},
	['gill coat'] = {itemid = 16105, token = {type = 'major', id = 16129, count = 10}},
	['gill legs'] = {itemid = 16106, token = {type = 'major', id = 16129, count = 10}},
	['spellbook'] = {itemid = 16107, token = {type = 'major', id = 16129, count = 10}},
	['prismatic helmet'] = {itemid = 16109, token = {type = 'major', id = 16129, count = 10}},
	['prismatic armor'] = {itemid = 16110, token = {type = 'major', id = 16129, count = 10}},
	['prismatic legs'] = {itemid = 16111, token = {type = 'major', id = 16129, count = 10}},
	['prismatic boots'] = {itemid = 16112, token = {type = 'major', id = 16129, count = 10}},
	['prismatic shield'] = {itemid = 16116, token = {type = 'major', id = 16129, count = 10}},
	['basic soil guardian outfit'] = {itemid = 16252, token = {type = 'major', id = 16129, count = 20}},
	['basic crystal warlord outfit'] = {itemid = 16255, token = {type = 'major', id = 16129, count = 20}},
	['iron loadstone'] = {itemid = 16153, token = {type = 'major', id = 16129, count = 20}},
	['glow wine'] = {itemid = 16154, token = {type = 'major', id = 16129, count = 20}}
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'equipment') then
		npcHandler:say({
			'You can buy different equipment for minor or for major tokens. So, which is the equipment you are interested in, the one for {minor} or {major} tokens? ...',
			'By the way, if you want to have a look on the prismatic and gill items first, just head over to the depot and check the market.'
		}, npc, creature)
	elseif MsgContains(message, 'major') then
		npcHandler:say({
			'For ten major tokens, I can offer you a {gill gugel}, a {gill coat}, {gill legs}, a {spellbook} of vigilance, a {prismatic helmet}, a {prismatic armor}, {prismatic legs}, {prismatic boots} or a {prismatic shield} ...',
			'For twenty major tokens, I can offer you a {basic soil guardian outfit}, a {basic crystal warlord outfit}, an {iron loadstone} or a {glow wine}.'
		}, npc, creature)
	elseif MsgContains(message, 'minor') then
		npcHandler:say({
			'For two minor tokens, you can buy one gnomish {supply} package! For eight tokens, you can buy a {muck} remover! For ten tokens, you can buy a {mission} crystal. For fifteen tokens, you can buy a crystal {lamp} or a mushroom {backpack}. ...',
			'For seventy tokens, I can offer you a voucher for an {addition to the soil guardian outfit}, or a voucher for an {addition to the crystal warlord armor outfit}.'
		}, npc, creature)
	elseif config[message] then
		local itemType = ItemType(config[message].itemid)
		npcHandler:say(string.format('Do you want to trade %s %s for %d %s tokens?', (itemType:getArticle() ~= "" and itemType:getArticle() or ""), itemType:getName(), config[message].token.count, config[message].token.type), npc, creature)
		npcHandler:setTopic(playerId, 1)
		topic[playerId] = message
	elseif MsgContains(message, 'relations') then
		local player = Player(creature)
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 25 then
			npcHandler:say('Our relations improve with every mission you undertake on our behalf. Another way to improve your relations with us gnomes is to trade in minor crystal tokens. ...', npc, creature)
			npcHandler:say('Your renown amongst us gnomes is currently {' .. math.max(0, player:getStorageValue(Storage.BigfootBurden.Rank)) .. '}. Do you want to improve your standing by sacrificing tokens? One token will raise your renown by 5 points. ', npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say('You are not even a recruit of the Bigfoots. Sorry I can\'t help you.', npc, creature)
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		local amount = getMoneyCount(message)
		if amount > 0 then
			npcHandler:say('Do you really want to trade ' .. amount .. ' minor tokens for ' .. amount * 5 .. ' renown?', npc, creature)
			renown[playerId] = amount
			npcHandler:setTopic(playerId, 4)
		end
	elseif MsgContains(message, 'items') then
		npcHandler:say('Do you need to buy any mission items?', npc, creature)
		npcHandler:setTopic(playerId, 5)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			local player, targetTable = Player(creature), config[topic[playerId]]
			if player:getItemCount(targetTable.token.id) < targetTable.token.count then
				npcHandler:say('Sorry, you don\'t have enough ' .. targetTable.token.type .. ' tokens with you.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			local item = Game.createItem(targetTable.itemid, 1)
			local weight = 0
			weight = ItemType(item.itemid):getWeight(item:getCount())

			if player:addItemEx(item) ~= RETURNVALUE_NOERROR then
				if player:getFreeCapacity() < weight then
					npcHandler:say('First make sure you have enough capacity to hold it.', npc, creature)
				else
					npcHandler:say('First make sure you have enough space in your inventory.', npc, creature)
				end
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:removeItem(targetTable.token.id, targetTable.token.count)
			npcHandler:say('Here have one of our ' .. item:getPluralName() .. '.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("How many tokens do you want to trade?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 4 then
			local player = Player(creature)
			if player:removeItem(16128, renown[playerId]) then
				player:setStorageValue(Storage.BigfootBurden.Rank, math.max(0, player:getStorageValue(Storage.BigfootBurden.Rank)) + renown[playerId] * 5)
				player:checkGnomeRank()
				npcHandler:say('As you wish! Your new renown is {' .. player:getStorageValue(Storage.BigfootBurden.Rank) .. '}.', npc, creature)
			else
				npcHandler:say('You don\'t have these many tokens.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npc:openShopWindow(creature)
			npcHandler:say('Let us see if I have what you need.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') and isInArray({1, 3, 4, 5}, npcHandler:getTopic(playerId)) then
		npcHandler:say('As you like.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	topic[playerId], renown[playerId] = nil, nil
end

npcHandler:setMessage(MESSAGE_GREET, 'Oh, hello! I\'m the gnome-human relations assistant. I am here for you to trade your tokens for {equipment}, resupply you with mission {items} and talk to you about your {relations} to us gnomes! ...')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
