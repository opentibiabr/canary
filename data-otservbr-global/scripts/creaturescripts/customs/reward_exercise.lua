local winReward = CreatureEvent("WinReward")

function winReward.onLogin(player)
	if configManager.getBoolean(configKeys.TOGGLE_RECEIVE_REWARD) then
		-- check user won exercise weapon and send message
		if not table.contains({ TOWNS_LIST.DAWNPORT, TOWNS_LIST.DAWNPORT_TUTORIAL }, player:getTown():getId()) then
			if player:getStorageValue(tonumber(Storage.PlayerWeaponReward)) ~= 1 then
				player:sendTextMessage(MESSAGE_LOGIN, "You can receive an exercise weapon using command !reward")
			end
		end
	end
	return true
end

winReward:register()
