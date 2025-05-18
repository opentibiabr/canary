local mountIds = { 22, 25, 26 }

local rentedMounts = GlobalEvent("rentedmounts")
function rentedMounts.onThink(interval)
	local players = Game.getPlayers()
	if #players == 0 then
		return true
	end

	local player, outfit
	for i = 1, #players do
		player = players[i]
		if player:getStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer) < 1 or player:getStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer) >= os.time() then
			break
		end

		outfit = player:getOutfit()
		if table.contains(mountIds, outfit.lookMount) then
			outfit.lookMount = nil
			player:setOutfit(outfit)
		end

		for m = 1, #mountIds do
			player:removeMount(mountIds[m])
		end

		player:setStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer, -1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your contract with your horse expired and it returned back to the horse station.")
	end
	return true
end

rentedMounts:interval(15000)
rentedMounts:register()
