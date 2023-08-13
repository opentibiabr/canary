local teleportToCreature = TalkAction("/goto")

function teleportToCreature.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local target = Creature(param)
	if target then
		player:teleportTo(target:getPosition())
	else
		player:sendCancelMessage("Creature not found.")
	end
	return true
end

teleportToCreature:separator(" ")
teleportToCreature:groupType("gamemaster")
teleportToCreature:register()
