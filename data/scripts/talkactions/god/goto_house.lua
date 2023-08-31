local sellHouse = TalkAction("/gotohouse")

function sellHouse.onSay(player, words, param)
	local targetPlayer = Player(param)
	if targetPlayer then
		local targetHouse = targetPlayer:getHouse()
		if not targetHouse then
			targetPlayer:sendCancelMessage(string.format("The player %s not have house.", player:getName()))
			return
		end

		targetPlayer:teleportTo(targetHouse:getExitPosition())
	else
		local house = player:getHouse()
		if not house then
			player:sendCancelMessage("You not have house. For goto house of one player use the player name param, usage: /gotohouse playername")
			return
		end

		player:teleportTo(house:getExitPosition())
	end

	return false
end

sellHouse:separator(" ")
sellHouse:groupType("god")
sellHouse:register()
