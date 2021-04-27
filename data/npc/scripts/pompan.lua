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

local function getTable(player)
	local itemsList = {
		{name='backpack', id=1988, buy=20},
		{name='bag', id=1987, buy=5},
		{name='basket', id=1989, buy=6},
		{name='blue quiver', id=40683, buy=400},
		{name='bucket', id=2005, buy=4},
		{name='candlestick', id=2047, buy=2},
		{name='closed trap', id=2578, buy=280, sell=75},
		{name='crowbar', id=2416, buy=260, sell=50},
		{name='expedition backpack', id=11241, buy=100},
		{name='expedition bag', id=11242, buy=50},
		{name='fishing rod', id=2580, buy=150, sell=40},
		{name='lamp', id=2044, buy=8},
		{name='pick', id=2553, buy=50, sell=15},
		{name='quiver', id=40397, buy=400},
		{name='red quiver', id=40684, buy=400},
		{name='rope', id=2120, buy=50, sell=15},
		{name='scythe', id=2550, buy=50, sell=10},
		{name='shovel', id=2554, buy=50, sell=8},
		{name='torch', id=2050, buy=2},
		{name='watch', id=2036, buy=20, sell=6},
		{name='worm', id=3976, buy=1},
		{name='inkwell', id=2600, sell=8},
		{name='mirror', id=2560, sell=10},
		{name='sickle', id=2405, sell=3}
	}

	local tomes = {
		-- 1 tome
		{
			{name='arrow', id=2544, buy=3},
			{name='bolt', id=2543, buy=4},
			{name='bow', id=2456, buy=400, sell=100},
			{name='crossbow', id=2455, buy=500, sell=120},
			{name='crystalline arrow', id=18304, buy=20},
			{name='diamond arrow', id=40736, buy=100},
			{name='dragon tapestry', id=11264, buy=80},
			{name='drill bolt', id=18436, buy=12},
			{name='earth arrow', id=7850, buy=5},
			{name='envenomed arrow', id=18437, buy=12},
			{name='flaming arrow', id=7840, buy=5},
			{name='flash arrow', id=7838, buy=5},
			{name='onyx arrow', id=7365, buy=7},
			{name='piercing bolt', id=7363, buy=5},
			{name='power bolt', id=2547, buy=7},
			{name='prismatic bolt', id=18435, buy=20},
			{name='royal spear', id=7378, buy=15},
			{name='shiver arrow', id=7839, buy=5},
			{name='sniper arrow', id=7364, buy=5},
			{name='spear', id=2389, buy=9, sell=3},
			{name='spectral bolt', id=40737, buy=70},
			{name='tarsal arrow', id=15648, buy=6},
			{name='throwing star', id=2399, buy=42},
			{name='vortex bolt', id=15649, buy=6},
			{name='corrupted flag', id=11326, sell=700},
			{name='high guard flag', id=11332, sell=550},
			{name='legionnaire flags', id=11334, sell=500},
			{name='zaogun flag', id=11330, sell=600}
		},
		-- 2 tomes
		{
			{name='minotaur backpack', id=11244, buy=200}
		},
		-- 5 tomes
		{
			{name='dragon backpack', id=11243, buy=200}
		}
	}

	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 1 then
		-- 1 tome
		for i = 1, #tomes[1] do
			itemsList[#itemsList] = tomes[1][i]
		end
	end
	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 2 then
		-- 2 tomes
		for i = 1, #tomes[2] do
			itemsList[#itemsList] = tomes[2][i]
		end
	end
	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 5 then
		-- 5 tomes
		for i = 1, #tomes[3] do
			itemsList[#itemsList] = tomes[3][i]
		end
	end

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

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'trade') then
		local player = Player(cid)
		local items = setNewTradeTable(getTable(player))
		openShopWindow(cid, getTable(player), onBuy, onSell)
		npcHandler:say('Keep in mind you won\'t find better offers here. Just browse through my wares.', cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hello.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'It was a pleasure to help you, |PLAYERNAME|.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
