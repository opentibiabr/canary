local snowball = Action()
function snowball.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local value1, value2 = player:getStorageValue(SnowBallConfig.Storage.Value1), player:getStorageValue(SnowBallConfig.Storage.Value2)
	if value2 > 0 and value1 <= 30 then
		player:setStorageValue(SnowBallConfig.Storage.Value1, value1 + SnowBallConfig.Ammo_Configurations.Ammo_Ammount)
		player:setStorageValue(SnowBallConfig.Storage.Value2, value2 - SnowBallConfig.Ammo_Configurations.Ammo_Price)
		player:sendTextMessage(29, "You just bought" .. SnowBallConfig.Ammo_Configurations.Ammo_Ammount .. " snow balls for " .. SnowBallConfig.Ammo_Configurations.Ammo_Price .. "\nYou have " .. value1 .. " bolas de neve\nYou have " .. value2 .. " point(s).")
	elseif value2 < 1 then
		player:sendCancelMessage("You do not have " .. SnowBallConfig.Ammo_Configurations.Ammo_Price .. " point(s).")
	elseif value1 > 30 then
		player:sendCancelMessage("You can only buy snowballs with a minimum of 30 balls.")
	end
	return true
end

snowball:aid(7900)
snowball:register()
