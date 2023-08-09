local teleportToCreature = TalkAction("/goto")

function teleportToCreature.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local target = Creature(param)
	if target then
		player:teleportTo(target:getPosition())
	else
		player:sendCancelMessage("Creature not found.")
	end
	return false
end

teleportToCreature:separator(" ")
teleportToCreature:groupType("gamemaster")
teleportToCreature:register()
