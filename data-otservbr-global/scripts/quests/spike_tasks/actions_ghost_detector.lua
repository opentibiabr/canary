if not GHOST_DETECTOR_MAP then
	GHOST_DETECTOR_MAP = {}
end

ghost_detector_area = {
	from = Position(32171, 32512, 8),
	to = Position(32352, 32671, 10),
}

local function getSearchString(fromPos, toPos)
	local distance = 0
	local direction = 0
	local level = 0

	local dx = fromPos.x - toPos.x
	local dy = fromPos.y - toPos.y
	local dz = fromPos.z - toPos.z

	level = (dz > 0) and 0 or (dz < 0) and 1 or 2

	if math.abs(dx) < 5 and math.abs(dy) < 5 then
		distance = 0
	else
		local tmp = dx * dx + dy * dy
		distance = (tmp < 10000) and 1 or (tmp < 75625) and 2 or 3
	end

	local tang = (dx ~= 0) and dy / dx or 10
	if math.abs(tang) < 0.4142 then
		direction = (dx > 0) and 3 or 2
	elseif math.abs(tang) < 2.4142 then
		direction = (tang > 0) and ((dy > 0) and 5 or 6) or ((dx > 0) and 7 or 4)
	else
		direction = (dy > 0) and 0 or 1
	end

	local text = {
		[0] = {
			[0] = "above you",
			[1] = "below you",
			[2] = "next to you",
		},
		[1] = {
			[0] = "on a higher level to the ",
			[1] = "on a lower level to the ",
			[2] = "to the ",
		},
		[2] = "far to the ",
		[3] = "very far to the ",
	}

	local dirs = {
		[0] = "north",
		[1] = "south",
		[2] = "east",
		[3] = "west",
		[4] = "north-east",
		[5] = "north-west",
		[6] = "south-east",
		[7] = "south-west",
	}

	return ((type(text[distance]) == "table") and text[distance][level] or text[distance]) .. ((distance ~= 0) and dirs[direction] or "")
end

local spikeTasksGhost = Action()
function spikeTasksGhost.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local stat = player:getStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Track_Main)

	if table.contains({ -1, 3 }, stat) then
		return player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
	end

	local current = GHOST_DETECTOR_MAP[player:getGuid()]
	if not current then
		local levelZ = 8 + stat
		local random = Position(math.random(32171, 32352), math.random(32512, 32671), levelZ)
		GHOST_DETECTOR_MAP[player:getGuid()] = random
		current = random
	end

	local playerPos = player:getPosition()
	local dx = math.abs(playerPos.x - current.x)
	local dy = math.abs(playerPos.y - current.y)
	local dz = math.abs(playerPos.z - current.z)

	if dx <= 4 and dy <= 4 and dz == 0 then
		if stat == 2 then
			item:remove()
			GHOST_DETECTOR_MAP[player:getGuid()] = nil
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Report the task to Gnomilly.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a malignant presence, the glowing detector signals that it does not need any further data.")
		else
			local levelZ = 8 + (stat + 1) % 3
			local random = Position(math.random(32171, 32352), math.random(32512, 32671), levelZ)
			GHOST_DETECTOR_MAP[player:getGuid()] = random
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You found a malignant presence, the glowing detector signals another presence nearby.")
		end
		player:setStorageValue(Storage.Quest.U10_20.SpikeTaskQuest.Spike_Upper_Track_Main, stat + 1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The detector points " .. getSearchString(player:getPosition(), current) .. ".")
	end
	return true
end

spikeTasksGhost:id(19205)
spikeTasksGhost:register()
