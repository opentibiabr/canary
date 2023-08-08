local pushCreature = TalkAction("/c")

function pushCreature.onSay(player, words, param)
	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local creature = Creature(param)
	if not creature then
		player:sendCancelMessage("A creature with that name could not be found.")
		return false
	end

	local oldPosition = creature:getPosition()
	local newPosition = creature:getClosestFreePosition(player:getPosition(), false)
	if newPosition.x == 0 then
		player:sendCancelMessage("You can not teleport " .. creature:getName() .. ".")
		return false
	elseif creature:teleportTo(newPosition) then
		if not creature:isInGhostMode() then
			oldPosition:sendMagicEffect(CONST_ME_POFF)
			newPosition:sendMagicEffect(CONST_ME_TELEPORT)
		end
	end
	return false
end

pushCreature:separator(" ")
pushCreature:groupType("god")
pushCreature:register()
