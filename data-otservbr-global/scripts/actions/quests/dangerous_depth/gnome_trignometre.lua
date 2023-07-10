local config = {
	locationA = {fromPosition = Position(33921, 32141, 14), toPosition = Position(33926, 32146, 14)},
	locationB = {fromPosition = Position(33965, 32139, 14), toPosition = Position(33975, 32149, 14)},
	locationC = {fromPosition = Position(33911, 32176, 14), toPosition = Position(33914, 32180, 14)},
	locationD = {fromPosition = Position(33947, 32206, 14), toPosition = Position(33952, 32209, 14)},
	locationE = {fromPosition = Position(33877, 32173, 14), toPosition = Position(33881, 32179, 14)},
}

local dangerousDepthTrignometre = Action()
function dangerousDepthTrignometre.onUse(player, item, isHotkey)
	if not player then
		return true
	end
	if player:getStorageValue(Storage.DangerousDepths.Gnomes.Measurements) == 1 then
		if player:getPosition():isInRange(config.locationA.fromPosition, config.locationA.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationA) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationA, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You probed the location successfully.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.locationB.fromPosition, config.locationB.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationB) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationB, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You probed the location successfully.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.locationC.fromPosition, config.locationC.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationC) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationC, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You probed the location successfully.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.locationD.fromPosition, config.locationD.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationD) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationD, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You probed the location successfully.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
		if player:getPosition():isInRange(config.locationE.fromPosition, config.locationE.toPosition) then
			if player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationE) < 1 then
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationE, 1)
				player:setStorageValue(Storage.DangerousDepths.Gnomes.LocationCount, player:getStorageValue(Storage.DangerousDepths.Gnomes.LocationCount) + 1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You probed the location successfully.")
				player:getPosition():sendMagicEffect(CONST_ME_HITAREA)
			end
		end
	end
	return true
end

dangerousDepthTrignometre:id(31930)
dangerousDepthTrignometre:register()