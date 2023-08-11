local up = TalkAction("/up")

function up.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local position = player:getPosition()
	position.z = position.z - 1
	player:teleportTo(position)
	return true
end

up:separator(" ")
up:groupType("gamemaster")
up:register()
