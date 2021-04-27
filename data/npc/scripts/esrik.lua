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
		{name="durable exercise axe", id=40115, buy=945000, subType = 1800},
		{name="durable exercise bow", id=40117, buy=945000, subType = 1800},
		{name="durable exercise club", id=40116, buy=945000, subType = 1800},
		{name="durable exercise sword", id=40114, buy=945000, subType = 1800},
		{name="exercise sword", id=32384, buy=262500, subType = 500},
		{name="exercise axe", id=32385, buy=262500, subType = 500},
		{name="exercise club", id=32386, buy=262500, subType = 500},
		{name="exercise bow", id=32387, buy=262500, subType = 500},
		{name="lasting exercise axe", id=40121, buy=7560000, subType = 14400},
		{name="lasting exercise bow", id=40123, buy=7560000, subType = 14400},
		{name="lasting exercise club", id=40122, buy=7560000, subType = 14400},
		{name="lasting exercise sword", id=40120, buy=7560000, subType = 14400},
		{name="axe", id=2386, buy=20, sell=7},
		{name="battle axe", id=2378, buy=235, sell=80},
		{name="battle hammer", id=2417, buy=350, sell=120},
		{name="battle shield", id=2417, sell=95},
		{name="brass armor", id=2465, buy=450, sell=150},
		{name="brass helmet", id=2460, buy=120, sell=30},
		{name="brass legs", id=2478, buy=195, sell=49},
		{name="brass shield", id=2511, buy=65, sell=25},
		{name="carlin sword", id=2395, buy=473, sell=118},
		{name="chain armor", id=2464, buy=200, sell=70},
		{name="chain helmet", id=2458, buy=52, sell=17},
		{name="chain legs", id=2648, buy=80, sell=25},
		{name="club", id=2382, buy=5, sell=1},
		{name="coat", id=2651, buy=8, sell=1},
		{name="crowbar", id=2416, buy=260, sell=50},
		{name="dagger", id=2379, buy=5, sell=2},
		{name="doublet", id=2485, buy=16, sell=3},
		{name="dwarven shield", id=2525, buy=500, sell=100},
		{name="hand axe", id=2380, buy=8, sell=4},
		{name="leather armor", id=2467, buy=35, sell=12},
		{name="leather boots", id=2643, buy=10, sell=2},
		{name="leather helmet", id=2461, buy=12, sell=9},
		{name="leather legs", id=2649, buy=10, sell=9},
		{name="longsword", id=2397, buy=160, sell=51},
		{name="mace", id=2398, buy=90, sell=30},
		{name="morning star", id=2394, buy=430, sell=100},
		{name="plate armor", id=2463, buy=1200, sell=400},
		{name="plate shield", id=2510, buy=125, sell=45},
		{name="rapier", id=2384, buy=15, sell=5},
		{name="sabre", id=2385, buy=35, sell=12},
		{name="scale armor", id=2483, buy=260, sell=75},
		{name="spear", id=2389, buy=10, sell=3},
		{name="short sword", id=2406, buy=26, sell=10},
		{name="sickle", id=2405, buy=7, sell=3},
		{name="soldier helmet", id=2481, buy=110, sell=16},
		{name="spike sword", id=2383, buy=8000, sell=240},
		{name="steel helmet", id=2457, buy=580, sell=293},
		{name="steel shield", id=2509, buy=240, sell=80},
		{name="studded armor", id=2484, buy=90, sell=25},
		{name="studded helmet", id=2482, buy=63, sell=20},
		{name="studded legs", id=2468, buy=50, sell=15},
		{name="studded shield", id=2526, buy=50, sell=16},
		{name="swampling club", id=20104, sell=40},
		{name="sword", id=2376, buy=85, sell=25},
		{name="throwing knife", id=2410, buy=25},
		{name="wooden shield", id=2512, buy=15, sell=3},
		{name="two handed sword", id=2377, sell=450},
		{name="bone shoulderplate", id=11321, sell=150},
		{name="broken draken mail", id=12616, sell=340},
		{name="broken halberd", id=11335, sell=100},
		{name="broken slicer", id=12617, sell=120},
		{name="cursed shoulder spikes", id=11327, sell=320},
		{name="drachaku", id=11308, sell=10000},
		{name="draken boots", id=12646, sell=40000},
		{name="draken wristbands", id=12615, sell=430},
		{name="drakinata", id=11305, sell=10000},
		{name="elite draken mail", id=12607, sell=50000},
		{name="guardian boots", id=11240, sell=35000},
		{name="high guard's shoulderplates", id=11333, sell=130},
		{name="sais", id=11306, sell=16500},
		{name="spiked iron ball", id=11325, sell=100},
		{name="twiceslicer", id=12613, sell=28000},
		{name="twin hooks", id=11309, buy=1100, sell=500},
		{name="wailing widow's necklace", id=11329, sell=3000},
		{name="warmaster's wristguards", id=11322, sell=200},
		{name="zaoan armor", id=11301, sell=14000},
		{name="zaoan halberd", id=11323, buy=1200, sell=500},
		{name="zaoan helmet", id=11302, sell=45000},
		{name="zaoan legs", id=11304, sell=14000},
		{name="zaoan shoes", id=11303, sell=5000},
		{name="zaoan sword", id=11307, sell=30000},
		{name="zaogun's shoulderplates", id=11331, sell=150}
}

	local tomes = {
		{
			-- 3 tomes
		{name="lizard weapon rack kit", id=11126, buy=500}
		},
		{
			-- 9 tomes
		{name="bone shoulderplate", id=11321, sell=150},
		{name="broken draken mail", id=12616, sell=340},
		{name="broken halberd", id=11335, sell=100},
		{name="Broken Slicer", id=12617, sell=120},
		{name="cursed shoulder spikes", id=11327, sell=320},
		{name="drachaku", id=11308, sell=10000},
		{name="draken boots", id=12646, sell=40000},
		{name="draken wristbands", id=12615, sell=430},
		{name="drakinata", id=11305, sell=10000},
		{name="Elite Draken Mail", id=12607, sell=50000},
		{name="guardian boots", id=11240, sell=35000},
		{name="high guard's shoulderplates", id=11333, sell=130},
		{name="sais", id=11306, sell=16500},
		{name="spiked iron ball", id=11325, sell=100},
		{name="twiceslicer", id=12613, sell=28000},
		{name="twin hooks", id=11309, buy=1100, sell=500},
		{name="wailing widow's necklace", id=11329, sell=3000},
		{name="warmaster's wristguards", id=11322, sell=200},
		{name="zaoan armor", id=11301, sell=14000},
		{name="zaoan halberd", id=11323, buy=1200, sell=500},
		{name="zaoan helmet", id=11302, sell=45000},
		{name="zaoan legs", id=11304, sell=14000},
		{name="zaoan shoes", id=11303, sell=5000},
		{name="zaoan sword", id=11307, sell=30000},
		{name="zaogun's shoulderplates", id=11331, sell=150}
		}
}

	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 3 then
		-- 3 tomes
		for i = 1, #tomes[1] do
			itemsList[#itemsList] = tomes[1][i]
		end
	end

	if player:getStorageValue(Storage.TheNewFrontier.TomeofKnowledge) >= 9 then
		-- 9 tomes
		for i = 1, #tomes[2] do
			itemsList[#itemsList] = tomes[2][i]
		end
	end

	return itemsList
end

local function setNewTradeTable(table)
	local items, item = {}
	for i = 1, #table do
		item = table[i]
		items[item.id] = {itemId = item.id, buyPrice = item.buy, sellPrice = item.sell, subType = item.subType, realName = item.name}
	end
	return items
end

local function onBuy(cid, item, subType, amount, ignoreCap, inBackpacks)
	local player = Player(cid)
	local items = setNewTradeTable(getTable(player))
	local backpack = player:getSlotItem(CONST_SLOT_BACKPACK)
	if not backpack or backpack:getEmptySlots(true) < 1 then
		player:sendCancelMessage(RETURNVALUE_NOTENOUGHROOM)
		return false
	end
	if not ignoreCap and player:getFreeCapacity() < ItemType(items[item].itemId):getWeight(amount) then
		return player:sendTextMessage(MESSAGE_FAILURE, 'You don\'t have enough cap.')
	end
	if not player:removeMoneyNpc(items[item].buyPrice * amount) then
		selfSay("You don't have enough money.", cid)
	else
		player:addItem(items[item].itemId, amount, true, subType)
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

	if msgcontains(msg, "trade") then
		local player = Player(cid)
		local items = setNewTradeTable(getTable(player))
		openShopWindow(cid, getTable(player), onBuy, onSell)
		npcHandler:say("Of course, just browse through my wares.", cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Hello, |PLAYERNAME| and welcome to my little forge.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
