local storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.LakeWord
local count = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount

local actions_acidFishingRod = Action()

function actions_acidFishingRod.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local tPos = target:getPosition()
	local fromPos = Position(33553, 32558, 15)
	local toPos = Position(33569, 32562, 15)

	if tPos:isInRange(fromPos, toPos) then
		if player:getStorageValue(storage) < 1 then
			if player:getStorageValue(count) < 0 then
				player:setStorageValue(count, 0)
			end
			player:setStorageValue(count, player:getStorageValue(count) + 1)
			player:setStorageValue(storage, 1)
			tPos:sendMagicEffect(CONST_ME_GREEN_RINGS)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You dare not touch there remains. A word has been carved into these bones over and over: 'K'muuh'.")
		end
	end

	return true
end

actions_acidFishingRod:id(29950)
actions_acidFishingRod:allowFarUse(true)
actions_acidFishingRod:register()
