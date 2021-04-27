local config = {
	bet = {
		min = 10000, -- gold coins // 30k
		max = 10000000000, 
		win = 180, -- 170% high/low
		winNum = 500, -- 300% numbers
	},
	playerPosition = Position(32352, 32226, 7), -- NpcPos(x-2) player must stay on this position to talk with npc
	dicerCounter = Position(32352, 32225, 7), --	NpcPos(x-1, y-1) 	counter position
	diePos = Position(32354, 32225, 7) --NpcPos(y-1)
}

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
	local tile = Tile(config.playerPosition)
	if tile then
		local player = tile:getTopCreature()
		if not player then
			npcHandler.focuses = {}
			npcHandler:updateFocus()
		end
	end
end

local function getCoinValue(id)
	if id == 2160 then
		return 10000
	elseif id == 2152 then
		return 100
	elseif id == 2148 then
		return 1
	end
	return 0
end

local function getBetValue()
	local value = 0
	local tile = Tile(config.dicerCounter)
	if tile then
		local items = tile:getItems()
		if not items or #items == 0 then
			return 0
		end

		local tempMoney = {}
		for _, item in pairs(items) do
			if table.contains({2160, 2152, 2148}, item:getId()) then
				value = value + getCoinValue(item:getId()) * item:getCount()
				tempMoney[#tempMoney + 1] = item
			end
		end

		if value >= config.bet.min and value <= config.bet.max then -- valid bet
			for _, item in pairs(tempMoney) do
				item:remove()
			end
			return value
		end
	end
	return nil
end

local function createMoney(money)
	local table = {}
	local currentMoney = money
	local crystals = math.floor(currentMoney / 10000)
	currentMoney = currentMoney - crystals * 10000
	while crystals > 0 do
		local count = math.min(100, crystals)
		table[#table + 1] = {2160, count}
		crystals = crystals - count
	end

	local platinums = math.floor(currentMoney / 100)
	if platinums ~= 0 then
		table[#table + 1] = {2152, platinums}
		currentMoney = currentMoney - platinums * 100
	end

	if currentMoney ~= 0 then
		table[#table + 1] = {2148, currentMoney}
	end
	return table
end

local function greetCallback(cid)
	local player = Player(cid)
	if player:getPosition() ~= config.playerPosition then
		npcHandler:say("If you want to play with me please come near me.", cid)
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if player:getPosition() ~= config.playerPosition then
		npcHandler:unGreet(cid)
		return false
	end
	local thisNpc = Npc(getNpcCid())
	if table.contains({"low", "high", "h", "l", "1", "2", "3", "4", "5", "6", "odd", "impar", "par", "even"}, msg) then
		local bet = getBetValue()
		if not bet then
			npcHandler:say("Your bet is lower than the min {".. config.bet.min .."}gps or higher than the max {"..config.bet.max.."}gps bet.", cid)
			npcHandler.topic[cid] = 0
			return true
		end
player:say(msg, TALKTYPE_SAY, false, true, player:getPosition())
		local number = math.random(6)

local dadimid = {5792, 5793, 5794, 5795, 5796, 5797}
local daddd = 0
local haveDie = false
	for x = 1, 6 do
		daddd = Tile(config.diePos):getItemById(dadimid[x])
		if daddd then
		haveDie = true
			break
		end
	end
	if haveDie then
		daddd:transform(dadimid[number])
	else
		Game.createItem((5791+number), 1, config.diePos)
	end
		thisNpc:say(thisNpc:getName() .. " rolled a ".. number .. ".", TALKTYPE_MONSTER_SAY, false, true, config.diePos)
		config.diePos:sendMagicEffect(CONST_ME_CRAPS)
		if table.contains({"low", "l"}, msg) then
			if table.contains({1, 2, 3}, number) then
				local wonMoney = math.ceil(bet * (config.bet.win / 100))
				thisNpc:say("You won! Here's your ".. wonMoney .." gold coins.", TALKTYPE_SAY)
				config.dicerCounter:sendMagicEffect(math.random(29, 31))
				for _, coin in pairs(createMoney(wonMoney)) do
					Game.createItem(coin[1], coin[2], config.dicerCounter)
				end
			else

				thisNpc:say("You have lost your "..bet.." gold coins.", TALKTYPE_SAY)

			end
		elseif table.contains({"high", "h"}, msg) then
			if table.contains({4, 5, 6}, number) then
				local wonMoney = math.ceil(bet * (config.bet.win / 100))
				thisNpc:say("You won! Here's your ".. wonMoney .." gold coins.", TALKTYPE_SAY)
				config.dicerCounter:sendMagicEffect(math.random(29, 31))
				for _, coin in pairs(createMoney(wonMoney)) do
					Game.createItem(coin[1], coin[2], config.dicerCounter)
				end
			else

				thisNpc:say("You have lost your "..bet.." gold coins.", TALKTYPE_SAY)

			end
		elseif table.contains({"odd", "impar"}, msg) then
			if table.contains({1, 3, 5}, number) then
				local wonMoney = math.ceil(bet * (config.bet.win / 100))
				thisNpc:say("You won! Here's your ".. wonMoney .." gold coins.", TALKTYPE_SAY)
				config.dicerCounter:sendMagicEffect(math.random(29, 31))
				for _, coin in pairs(createMoney(wonMoney)) do
					Game.createItem(coin[1], coin[2], config.dicerCounter)
				end
			else

				thisNpc:say("You have lost your "..bet.." gold coins.", TALKTYPE_SAY)

		end
		elseif table.contains({"par", "even"}, msg) then
			if table.contains({2, 4, 6}, number) then
				local wonMoney = math.ceil(bet * (config.bet.win / 100))
				thisNpc:say("You won! Here's your ".. wonMoney .." gold coins.", TALKTYPE_SAY)
				config.dicerCounter:sendMagicEffect(math.random(29, 31))
				for _, coin in pairs(createMoney(wonMoney)) do
					Game.createItem(coin[1], coin[2], config.dicerCounter)
				end
			else

				thisNpc:say("You have lost your "..bet.." gold coins.", TALKTYPE_SAY)

		end
		elseif table.contains({"1", "2", "3", "4", "5", "6"}, msg) then
			if number == tonumber(msg) then
				local wonMoney = math.ceil(bet * (config.bet.winNum / 100))
				thisNpc:say("You won! Here's your ".. wonMoney .." gold coins.", TALKTYPE_SAY)
				config.dicerCounter:sendMagicEffect(math.random(29, 31))
				for _, coin in pairs(createMoney(wonMoney)) do
					Game.createItem(coin[1], coin[2], config.dicerCounter)
				end
			else

				thisNpc:say("You have lost your "..bet.." gold coins.", TALKTYPE_SAY)

			end
		end
	end
	return true
end
npcHandler:setMessage(MESSAGE_GREET, "Welcome to the Cassino! Here we play with: \n [PAYOUT 180%] {HIGH / LOW}: High for 4, 5, 6 and Low for 1, 2, and 3 - {ODD / EVEN }: Odd for 1, 3, 5 and Even for 2, 4 and 6 \n [PAYOUT 500%] {NUMBERS}: You choose the number, and if you get it right ... {$$$$$}")
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye.')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
