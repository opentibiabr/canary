local sacrophagus = {
	[1] = { hisPosition = Position(33081, 32355, 8) },
	[2] = { hisPosition = Position(33093, 32356, 8) },
	[3] = { hisPosition = Position(33081, 32349, 8) },
	[4] = { hisPosition = Position(33092, 32347, 8) },
	[5] = { hisPosition = Position(33083, 32338, 8) },
	[6] = { hisPosition = Position(33093, 32338, 8) },
	[7] = { hisPosition = Position(33054, 32335, 8) },
	[8] = { hisPosition = Position(33058, 32323, 8) },
	[9] = { hisPosition = Position(33051, 32309, 8) },
	[10] = { hisPosition = Position(33055, 32297, 8) },
	[11] = { hisPosition = Position(33091, 32301, 8) },
	[12] = { hisPosition = Position(33091, 32319, 8) },
	[13] = { hisPosition = Position(33103, 32344, 8) },
	[14] = { hisPosition = Position(33091, 32319, 8) },
}

local function setActionId(itemid, position, aid)
	local item = Tile(position):getItemById(itemid)

	if item and item:getActionId() ~= aid then
		item:setActionId(aid)
	end
end

local function resetActionId(player, itemid, position, actionid, message, rewardid)
	local player = Player(player)
	local r = math.random(1, 10)
	local check = Tile(position):getItemById(itemid)

	if player then
		if check then
			if check:getActionId() == actionid then
				if r >= 7 then
					player:say(message, TALKTYPE_MONSTER_SAY)
					local item = player:addItem(rewardid, 1)
					item:decay()
				else
					Game.createMonster("Mummy", check:getPosition())
					check:getPosition():sendMagicEffect(CONST_ME_POFF)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The curse of disturbing this fragile, ancient peace is your price to pay!")
				end

				check:setActionId(0)
				addEvent(setActionId, 1000 * 30, itemid, position, actionid)
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The opening of the last sarcophagus still haunts you. Wait some time for your spirits to return.")
			end
		end
	end
end

local storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline

local actions_sacrophagusUse = Action()

function actions_sacrophagusUse.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local rewardId = 29351
	local tPos = item:getPosition()
	local tId = item:getId()
	local isInQuest = player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Tomb)

	if player:getStorageValue(storage) == 1 and isInQuest < 1 then
		for _, k in pairs(sacrophagus) do
			if tPos == k.hisPosition then
				resetActionId(player:getId(), tId, tPos, 23104, "You got a " .. ItemType(rewardId):getName() .. "!", rewardId)
			end
		end
	end

	return true
end

actions_sacrophagusUse:id(29349)
actions_sacrophagusUse:register()
