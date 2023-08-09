local pushTown = TalkAction("/t")

function pushTown.onSay(player, words, param)
	player:teleportTo(player:getTown():getTemplePosition())
	return false
end

pushTown:groupType("gamemaster")
pushTown:register()
