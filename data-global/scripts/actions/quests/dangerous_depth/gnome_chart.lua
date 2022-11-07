local config = {
	OldGate = {fromPosition = Position(33978, 32177, 14), toPosition = Position(33982, 32177, 14)},
	LostRuin = {fromPosition = Position(33946, 32161, 14), toPosition = Position(33951, 32163, 14)},
	TheGaze = {fromPosition = Position(33962, 32139, 14), toPosition = Position(33976, 32148, 14)},
	Outpost = {fromPosition = Position(33865, 32008, 14), toPosition = Position(33875, 32021, 14)},
	Bastion = {fromPosition = Position(33923, 31983, 14), toPosition = Position(33942, 31998, 14)},
	BrokenTower = {fromPosition = Position(33859, 32358, 14), toPosition = Position(33867, 32363, 14)},
}

local dangerousDepthChart = Action()
function dangerousDepthChart.onUse(player, item, isHotkey)
	if not player then
		return true
	end

	if player:getStorageValue(Storage.DangerousDepths.Gnomes.Charting) == 1 then
		if player:getPosition():isInRange(config.OldGate.fromPosition, config.OldGate.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.OldGate) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.OldGate, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charted the location and dimensions of a strange structure, an ancient gate.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.LostRuin.fromPosition, config.LostRuin.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.LostRuin) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LostRuin, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charted the location and dimensions of a strange structure, a small ruin.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.TheGaze.fromPosition, config.TheGaze.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.TheGaze) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.TheGaze, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charted the location and dimensions of a strange structure, resembling a stone face.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.Outpost.fromPosition, config.Outpost.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.Outpost) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Outpost, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charted the location and dimensions of a strange structure, an outpost.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.Bastion.fromPosition, config.Bastion.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.Bastion) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.Bastion, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charted the location and dimensions of a strange structure, a bastion.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.BrokenTower.fromPosition, config.BrokenTower.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.BrokenTower) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.BrokenTower, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.ChartingCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You charted the location and dimensions of a strange structure, a broken tower.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
	end
	return true
end

dangerousDepthChart:id(31931)
dangerousDepthChart:register()