local wardPosition = Position(32769, 32621, 10)
local storage = Storage.Quest.U12_00.TheDreamCourts.WardStones.PortHopeStone
local count = Storage.Quest.U12_00.TheDreamCourts.WardStones.Count

local function revertStone(position, on, off)
	local activeStone = Tile(position):getItemById(on)

	if activeStone then
		activeStone:transform(off)
	end
end

local actions_chargedCompass = Action()

function actions_chargedCompass.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local tPos = target:getPosition()
	local isInQuest = player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline)

	if tPos == wardPosition then
		if isInQuest == 3 and player:getStorageValue(storage) < 1 then
			player:setStorageValue(count, player:getStorageValue(count) + 1)
			player:setStorageValue(storage, 1)
			player:say("The energy is transferred to the rune stone. It glows now!", TALKTYPE_MONSTER_SAY)
			target:getPosition():sendMagicEffect(CONST_ME_THUNDER)
			target:transform(29335)
			item:transform(29291)
			addEvent(revertStone, 1000 * 30, tPos, 33828, 33827)
		end
	end

	return true
end

actions_chargedCompass:id(29294)
actions_chargedCompass:register()
