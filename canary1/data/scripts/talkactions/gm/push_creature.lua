local pushCreature = TalkAction("/c")

function pushCreature.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local creature = Creature(param)
	if not creature then
		player:sendCancelMessage("A creature with that name could not be found.")
		return true
	end

	local oldPosition = creature:getPosition()
	local newPosition = creature:getClosestFreePosition(player:getPosition(), false)
	if newPosition.x == 0 then
		player:sendCancelMessage("You can not teleport " .. creature:getName() .. ".")
		return true
	elseif creature:teleportTo(newPosition) then
		if not creature:isInGhostMode() then
			oldPosition:sendMagicEffect(CONST_ME_POFF)
			newPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return true
end

pushCreature:separator(" ")
pushCreature:groupType("gamemaster")
pushCreature:register()
