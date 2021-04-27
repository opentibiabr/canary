	local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

local t = {}
local renown = {}

local config = {
	['supply'] = {itemid = 18215, token = {type = 'minor', id = 18422, count = 2}},
	['muck'] = {itemid = 18395, token = {type = 'minor', id = 18422, count = 8}},
	['mission'] = {itemid = 18509, token = {type = 'minor', id = 18422, count = 10}},
	['lamp'] = {itemid = 18388, token = {type = 'minor', id = 18422, count = 15}},
	['backpack'] = {itemid = 18393, token = {type = 'minor', id = 18422, count = 15}},
	['addition to the soil guardian outfit'] = {itemid = 18518, token = {type = 'minor', id = 18422, count = 70}},
	['addition to the crystal warlord armor outfit'] = {itemid = 18521, token = {type = 'minor', id = 18422, count = 70}},
	['gill gugel'] = {itemid = 18398, token = {type = 'major', id = 18423, count = 10}},
	['gill coat'] = {itemid = 18399, token = {type = 'major', id = 18423, count = 10}},
	['gill legs'] = {itemid = 18400, token = {type = 'major', id = 18423, count = 10}},
	['spellbook'] = {itemid = 18401, token = {type = 'major', id = 18423, count = 10}},
	['prismatic helmet'] = {itemid = 18403, token = {type = 'major', id = 18423, count = 10}},
	['prismatic armor'] = {itemid = 18404, token = {type = 'major', id = 18423, count = 10}},
	['prismatic legs'] = {itemid = 18405, token = {type = 'major', id = 18423, count = 10}},
	['prismatic boots'] = {itemid = 18406, token = {type = 'major', id = 18423, count = 10}},
	['prismatic shield'] = {itemid = 18410, token = {type = 'major', id = 18423, count = 10}},
	['basic soil guardian outfit'] = {itemid = 18517, token = {type = 'major', id = 18423, count = 20}},
	['basic crystal warlord outfit'] = {itemid = 18520, token = {type = 'major', id = 18423, count = 20}},
	['iron loadstone'] = {itemid = 18447, token = {type = 'major', id = 18423, count = 20}},
	['glow wine'] = {itemid = 18448, token = {type = 'major', id = 18423, count = 20}}
}

local function getTable()
	local itemsList = {
		{name = "bell", id = 18343, buy = 50},
		{name = "gnomish crystal package", id = 18313, buy = 1000},
		{name = "gnomish extraction crystal", id = 18213, buy = 50},
		{name = "gnomish repair crystal", id = 18219, buy = 50},
		{name = "gnomish spore gatherer", id = 18328, buy = 50},
		{name = "little pig", id = 18339, buy = 150}
	}
	return itemsList
end

local function setNewTradeTable(table)
	local items, item = {}
	for i = 1, #table do
		item = table[i]
		items[item.id] = {itemId = item.id, buyPrice = item.buy, sellPrice = item.sell, subType = 0, realName = item.name}
	end
	return items
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	local items = setNewTradeTable(getTable(player))
	if not ignoreCap and player:getFreeCapacity() < ItemType(items[item].itemId):getWeight(amount) then
		return player:sendTextMessage(MESSAGE_FAILURE, 'You don\'t have enough cap.')
	end
	if not player:removeMoneyNpc(items[item].buyPrice * amount) then
		selfSay("You don't have enough money.", cid)
	else
		player:addItem(items[item].itemId, amount)
		return player:sendTextMessage(MESSAGE_TRADE, 'Bought '..amount..'x '..items[item].realName..' for '..items[item].buyPrice * amount..' gold coins.')
	end
	return true
end

local function onSell(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	local items = setNewTradeTable(getTable(player))
	if items[item].sellPrice and player:removeItem(items[item].itemId, amount) then
		player:addMoney(items[item].sellPrice * amount)
		return player:sendTextMessage(MESSAGE_TRADE, 'Sold '..amount..'x '..items[item].realName..' for '..items[item].sellPrice * amount..' gold coins.')
	else
		selfSay("You don't have item to sell.", cid)
	end
	return true
end

local function greetCallback(cid)
	npcHandler:setMessage(MESSAGE_GREET, 'Oh, hello! I\'m the gnome-human relations assistant. I am here for you to trade your tokens for {equipment}, resupply you with mission {items} and talk to you about your {relations} to us gnomes! ...')
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'equipment') then
		npcHandler:say({
			'You can buy different equipment for minor or for major tokens. So, which is the equipment you are interested in, the one for {minor} or {major} tokens? ...',
			'By the way, if you want to have a look on the prismatic and gill items first, just head over to the depot and check the market.'
		}, cid)
	elseif msgcontains(msg, 'major') then
		npcHandler:say({
			'For ten major tokens, I can offer you a {gill gugel}, a {gill coat}, {gill legs}, a {spellbook} of vigilance, a {prismatic helmet}, a {prismatic armor}, {prismatic legs}, {prismatic boots} or a {prismatic shield} ...',
			'For twenty major tokens, I can offer you a {basic soil guardian outfit}, a {basic crystal warlord outfit}, an {iron loadstone} or a {glow wine}.'
		}, cid)
	elseif msgcontains(msg, 'minor') then
		npcHandler:say({
			'For two minor tokens, you can buy one gnomish {supply} package! For eight tokens, you can buy a {muck} remover! For ten tokens, you can buy a {mission} crystal. For fifteen tokens, you can buy a crystal {lamp} or a mushroom {backpack}. ...',
			'For seventy tokens, I can offer you a voucher for an {addition to the soil guardian outfit}, or a voucher for an {addition to the crystal warlord armor outfit}.'
		}, cid)
	elseif config[msg] then
		local itemType = ItemType(config[msg].itemid)
		npcHandler:say(string.format('Do you want to trade %s %s for %d %s tokens?', (itemType:getArticle() ~= "" and itemType:getArticle() or ""), itemType:getName(), config[msg].token.count, config[msg].token.type), cid)
		npcHandler.topic[cid] = 1
		t[cid] = msg
	elseif msgcontains(msg, 'relations') then
		local player = Player(cid)
		if player:getStorageValue(Storage.BigfootBurden.QuestLine) >= 25 then
			npcHandler:say('Our relations improve with every mission you undertake on our behalf. Another way to improve your relations with us gnomes is to trade in minor crystal tokens. ...', cid)
			npcHandler:say('Your renown amongst us gnomes is currently {' .. math.max(0, player:getStorageValue(Storage.BigfootBurden.Rank)) .. '}. Do you want to improve your standing by sacrificing tokens? One token will raise your renown by 5 points. ', cid)
			npcHandler.topic[cid] = 2
		else
			npcHandler:say('You are not even a recruit of the Bigfoots. Sorry I can\'t help you.', cid)
		end
	elseif npcHandler.topic[cid] == 3 then
		local amount = getMoneyCount(msg)
		if amount > 0 then
			npcHandler:say('Do you really want to trade ' .. amount .. ' minor tokens for ' .. amount * 5 .. ' renown?', cid)
			renown[cid] = amount
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, 'items') then
		npcHandler:say('Do you need to buy any mission items?', cid)
		npcHandler.topic[cid] = 5
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			local player, targetTable = Player(cid), config[t[cid]]
			if player:getItemCount(targetTable.token.id) < targetTable.token.count then
				npcHandler:say('Sorry, you don\'t have enough ' .. targetTable.token.type .. ' tokens with you.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			local item = Game.createItem(targetTable.itemid, 1)
			local weight = 0
			weight = ItemType(item.itemid):getWeight(item:getCount())

			if player:addItemEx(item) ~= RETURNVALUE_NOERROR then
				if player:getFreeCapacity() < weight then
					npcHandler:say('First make sure you have enough capacity to hold it.', cid)
				else
					npcHandler:say('First make sure you have enough space in your inventory.', cid)
				end
				npcHandler.topic[cid] = 0
				return true
			end

			player:removeItem(targetTable.token.id, targetTable.token.count)
			npcHandler:say('Here have one of our ' .. item:getPluralName() .. '.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("How many tokens do you want to trade?", cid)
			npcHandler.topic[cid] = 3
		elseif npcHandler.topic[cid] == 4 then
			local player = Player(cid)
			if player:removeItem(18422, renown[cid]) then
				player:setStorageValue(Storage.BigfootBurden.Rank, math.max(0, player:getStorageValue(Storage.BigfootBurden.Rank)) + renown[cid] * 5)
				player:checkGnomeRank()
				npcHandler:say('As you wish! Your new renown is {' .. player:getStorageValue(Storage.BigfootBurden.Rank) .. '}.', cid)
			else
				npcHandler:say('You don\'t have these many tokens.', cid)
			end
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			openShopWindow(cid, getTable(), onBuy, onSell)
			npcHandler:say('Let us see if I have what you need.', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') and isInArray({1, 3, 4, 5}, npcHandler.topic[cid]) then
		npcHandler:say('As you like.', cid)
		npcHandler.topic[cid] = 0
	end
	return true
end

local function onReleaseFocus(cid)
	t[cid], renown[cid] = nil, nil
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:addModule(FocusModule:new())
