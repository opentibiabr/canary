function sendConditionCults(playerid, info, fromPos, toPos, fromPos2, toPos2, time)
	local player = Player(playerid)
	if not player then
		return false
	end

	if ( not player:getPosition():isInRange(fromPos2, toPos2) ) then
		if (not player:getPosition():isInRange(fromPos, toPos)) then
			return true
		end
	end

	time = time + 2
	if time == 30 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[2])
	elseif time == 60 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[2])
	elseif time == 90 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[2])
	elseif time >= 120 then
		local storage = player:getStorageValue(info.storageBarkless) < 0 and 0 or
		player:getStorageValue(info.storageBarkless)
		if storage < 3 and storage ~= 1 and storage ~= 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[3])
			player:setStorageValue(info.storageBarkless, 1)
		end
	end
	player:getPosition():sendMagicEffect(info.effect)
	addEvent(sendConditionCults, 2000, playerid, info, fromPos, toPos, fromPos2, toPos2, time)
end

local function floorPassage(playerid, info, time)
	local player = Player(playerid)
	if not player then
		return true
	end
	local storage = player:getStorageValue(info.storageBarkless) < 0 and 0 or
	player:getStorageValue(info.storageBarkless)
	if time == 0 and storage < 3 then
		player:setStorageValue(info.storageBarkless, 0)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, info.msgs[6])
		return true
	end
	if storage == 3 then
		return true
	end
	addEvent(floorPassage, 1000, playerid, info, time - 1)
end

local ice = MoveEvent()

function ice.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	local setting = {
		fromPos = Position(32677, 31393, 8),
		toPos = Position(32722, 31440, 8),
		fromPos2 = Position(32696, 31429, 8),
		toPos2 = Position(32728, 31435, 8),
		effect = CONST_ME_GIANTICE,
		firstSqm = Position(32698, 31405, 8),
		storageBarkless = Storage.CultsOfTibia.Barkless.Ice,
		msgs = {
			"As you enter the icy cavern, you feel an unnatural frostiness. \z
			The ice cold air stings in your face. Survive and prove worthy.", -- on enter
			"Your body temperature sinks. You can see your breath freezing in the cold.", -- 30/60 seconds
			"The icy cold is grasping to you. You can barely move anymore.", -- 120 seconds
			"You are now washed and ready to purify yourself in the chambers of purification.", -- step in the first tile
			"You are now ready to prove your worth. Take heart and cross the threshold of ice.", -- step in the second tile
			"You took so long. You are no longer purified.", -- there's no time to step
		}
	}
	if fromPosition.y == 31441 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.msgs[1])
		sendConditionCults(player:getId(), setting, setting.fromPos,
		setting.toPos, setting.fromPos2, setting.toPos2, 0)
		return true
	end

	if item:getPosition():compare(setting.firstSqm) then
		if player:getStorageValue(setting.storageBarkless) ~= 1 then
			return true
		end
		player:setStorageValue(setting.storageBarkless, 2)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.msgs[4])
		floorPassage(player:getId(), setting, 60)
		return true
	end

	if fromPosition.y == 31439 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A bit of warmth returns to your body as you leave the icy cavern.")
		return true
	end
	return true
end

ice:type("stepin")
ice:aid(5532)
ice:register()
