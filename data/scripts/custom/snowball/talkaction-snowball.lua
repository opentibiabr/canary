local snowball = TalkAction("!snowball")
function snowball.onSay(player, words, param)
	if not isInArena(player) then
		return false
	end

	local value1 = player:getStorageValue(SnowBallConfig.Storage.Value1)

	if param == "shoot" then
		if player:getStorageValue(SnowBallConfig.Storage.Value3) > 1 then
			return true
		end

		if not SnowBallConfig.Ammo_Configurations.Ammo_Infinity then
			if value1 > 0 then
				player:setStorageValue(SnowBallConfig.Storage.Value1, value1 - 1)
				player:sendCancelMessage("Still left " .. value1 .. " snow balls.")
			else
				player:sendCancelMessage("You are without snow balls.")
				return true
			end
		end

		player:setStorageValue(SnowBallConfig.Storage.Value3, SnowBallConfig.Ammo_Configurations.Ammo_Exhaust)
		Event_sendSnowBall(player:getId(), player:getPosition(), SnowBallConfig.Ammo_Configurations.Ammo_Distance, player:getDirection())
		return false
	elseif param == "info" then
		local str = "     ## -> Player Infos <- ##\n\nPoints: " .. player:getStorageValue(SnowBallConfig.Storage.Value2) .. "\nSnow balls: " .. value1

		str = str .. "\n\n          ## -> Ranking <- ##\n\n"
		for i = 1, 5 do
			if CACHE_GAMEPLAYERS[i] then
				str = str .. i .. ". " .. Player(CACHE_GAMEPLAYERS[i]):getName() .. "\n"
			end
		end
		for pos, players in ipairs(CACHE_GAMEPLAYERS) do
			if player:getId() == players then
				str = str .. "My Ranking Pos: " .. pos
			end
		end

		player:showTextDialog(2111, str)
		return false
	end
end

snowball:separator(" ")
snowball:groupType("normal")
snowball:register()
