local firstFloor = {
	[1] = { hisPosition = Position(32749, 32628, 8) },
	[2] = { hisPosition = Position(32745, 32613, 8) },
	[3] = { hisPosition = Position(32811, 32645, 8) },
	[4] = { hisPosition = Position(32781, 32641, 8) },
}

local secondFloor = {
	[1] = { hisPosition = Position(32808, 32612, 9) },
	[2] = { hisPosition = Position(32775, 32600, 9) },
	[3] = { hisPosition = Position(32743, 32612, 9) },
	[4] = { hisPosition = Position(32761, 32630, 9) },
}

local thirdFloor = {
	[1] = { hisPosition = Position(32742, 32636, 10) },
	[2] = { hisPosition = Position(32757, 32606, 10) },
	[3] = { hisPosition = Position(32767, 32638, 10) },
	[4] = { hisPosition = Position(32789, 32613, 10) },
}

local function setActionId(itemid, position, aid)
	local crystal = Tile(position):getItemById(itemid)

	if crystal and crystal:getActionId() ~= aid then
		crystal:setActionId(aid)
	end
end

local function tryCrystal(player, itemid, position, actionid, message, rewardid)
	local player = Player(player)
	local r = math.random(1, 10)
	local crystal = Tile(position):getItemById(itemid)

	if player then
		if crystal then
			if crystal:getActionId() == actionid then
				if r == 1 then
					player:say(message, TALKTYPE_MONSTER_SAY)
					player:addItem(rewardid, 1)
					crystal:setActionId(0)
					addEvent(setActionId, 1000 * 30, itemid, position, actionid)
				else
					crystal:getPosition():sendMagicEffect(CONST_ME_POFF)
				end
			else
				player:sendCancelMessage("You must wait a while to use this item again.")
			end
		end
	end
end

local storage = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.GotAxe

local actions_goldenAxe = Action()

function actions_goldenAxe.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local tPos = target:getPosition()
	local tId = target:getId()

	if player:getStorageValue(storage) >= 1 then
		if target.itemid == 8865 then
			for _, k in pairs(firstFloor) do
				if tPos == k.hisPosition then
					tryCrystal(player:getId(), tId, tPos, 23121, "You got a blue crystal!", 29287)
				end
			end
		elseif target.itemid == 14940 then
			for _, k in pairs(secondFloor) do
				if tPos == k.hisPosition then
					tryCrystal(player:getId(), tId, tPos, 23122, "You got a green crystal!", 29288)
				end
			end
		elseif target.itemid == 14974 then
			for _, k in pairs(thirdFloor) do
				if tPos == k.hisPosition then
					tryCrystal(player:getId(), tId, tPos, 23123, "You got a purple crystal!", 29289)
				end
			end
		end
	end

	return true
end

actions_goldenAxe:id(29286)
actions_goldenAxe:register()
