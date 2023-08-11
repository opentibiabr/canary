local down = TalkAction("/down")

function down.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local position = player:getPosition()
	position.z = position.z + 1
	player:teleportTo(position)
	return true
end

down:separator(" ")
down:groupType("gamemaster")
down:register()
