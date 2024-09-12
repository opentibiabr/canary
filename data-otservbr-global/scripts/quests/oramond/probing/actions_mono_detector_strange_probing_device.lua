if not MONO_DETECTOR_MAP then
	MONO_DETECTOR_MAP = {}
end

local primary_area = {
	from = Position(33612, 31867, 10),
	to = Position(33679, 31983, 10),
}

local secondary_area = {
	from = Position(33607, 31905, 11),
	to = Position(33664, 31953, 11),
}

local function isPositionInArea(pos, area)
	return pos.x >= area.from.x and pos.x <= area.to.x and pos.y >= area.from.y and pos.y <= area.to.y and pos.z >= area.from.z and pos.z <= area.to.z
end

local function getRandomPositionInPrimaryArea()
	local randomPos
	repeat
		randomPos = Position(math.random(primary_area.from.x, primary_area.to.x), math.random(primary_area.from.y, primary_area.to.y), primary_area.from.z)
	until isPositionInArea(randomPos, primary_area)
	return randomPos
end

local function getRandomPositionInSecondaryArea()
	local randomPos
	repeat
		randomPos = Position(math.random(secondary_area.from.x, secondary_area.to.x), math.random(secondary_area.from.y, secondary_area.to.y), secondary_area.from.z)
	until isPositionInArea(randomPos, secondary_area)
	return randomPos
end

local actions_mono_detector = Action()

function actions_mono_detector.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stat = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission)

	if stat == 0 or stat >= 2 then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	local current = MONO_DETECTOR_MAP[player:getGuid()]
	if not current then
		local random
		if isPositionInArea(player:getPosition(), primary_area) then
			random = getRandomPositionInPrimaryArea()
		else
			random = getRandomPositionInSecondaryArea()
		end
		MONO_DETECTOR_MAP[player:getGuid()] = random
		current = random
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The probe has been adjusted.")
		return true
	end

	local playerPos = player:getPosition()
	local dx = math.abs(playerPos.x - current.x)
	local dy = math.abs(playerPos.y - current.y)
	local dz = math.abs(playerPos.z - current.z)

	if dx <= 15 and dy <= 15 and dz == 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The device reads: 'abnormal glooth structure detected, possible probing location'")
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Hm... the device reads: 0,0,zero,0,zero which may roughly translate to: NOTHING OF INTEREST HERE")
	end

	return true
end

actions_mono_detector:id(21192)
actions_mono_detector:register()

local actions_strange_probing_device = Action()

function actions_strange_probing_device.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stat = player:getStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission)
	local current = MONO_DETECTOR_MAP[player:getGuid()]

	if stat == 0 or stat >= 2 then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if fromPosition.x ~= item:getPosition().x or fromPosition.y ~= item:getPosition().y or fromPosition.z ~= item:getPosition().z then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	if current and item:getPosition() then
		local itemPos = item:getPosition()
		local dx = math.abs(itemPos.x - current.x)
		local dy = math.abs(itemPos.y - current.y)
		local dz = math.abs(itemPos.z - current.z)

		if dx <= 15 and dy <= 15 and dz == 0 then
			item:remove()
			player:setStorageValue(Storage.Quest.U10_50.OramondQuest.Probing.Mission, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have successfully gathered the data.")
		end
	end

	return true
end

actions_strange_probing_device:id(21208)
actions_strange_probing_device:register()
