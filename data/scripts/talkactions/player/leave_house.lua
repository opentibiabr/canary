local leaveHouse = TalkAction("!leavehouse")

function leaveHouse.onSay(player, words, param)
	local position = player:getPosition()
	local tile = Tile(position)
	local house = tile and tile:getHouse()
	if not house then
		player:sendCancelMessage("You are not inside a house.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if house:getOwnerGuid() ~= player:getGuid() then
		player:sendCancelMessage("You are not the owner of this house.")
		position:sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local tiles = house:getTiles()
	if tiles then
		for i, tile in pairs(tiles) do
			if tile then
				local position = Position(tile:getPosition())
				local hireling = getHirelingByPosition(position)
				if (hireling) then
					hireling:returnToLamp(player:getGuid())
				end
			end
		end
	end

	house:setOwnerGuid(0)
	player:sendTextMessage(MESSAGE_LOOK, "You have successfully left your house.")
	position:sendMagicEffect(CONST_ME_POFF)
	return false
end

leaveHouse:separator(" ")
leaveHouse:register()
