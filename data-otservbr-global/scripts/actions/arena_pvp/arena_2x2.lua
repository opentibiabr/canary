local setting = {
	centerRoom = {x = 32255, y = 32178, z = 9},
	range = 10
}

local playerPositions = {
	{fromPos = {x = 32269, y = 32180, z = 8}, toPos = {x = 32247, y = 32178, z = 9}}, -- Player 2
	{fromPos = {x = 32270, y = 32180, z = 8}, toPos = {x = 32264, y = 32178, z = 9}} -- Player 1
}

local positions = {
}

local arena2x2 = Action()

function arena2x2.onUse(player, item, fromPosition, target, toPosition, monster, isHotkey)
	if toPosition == Position(32271, 32180, 8) then
		if roomIsOccupied(setting.centerRoom, setting.range, setting.range) then
			player:say("Please wait for the fighters come out of the arena.", TALKTYPE_ORANGE_1)
			return true
		end
		for i = 1, #playerPositions do
			local creature = Tile(playerPositions[i].fromPos):getTopCreature()
			if creature and creature:getPlayer() then
				creature:teleportTo(playerPositions[i].toPos)
				creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			elseif not creature then
				player:say("You need 2 players for enter in the arena.", TALKTYPE_ORANGE_1)
				return true
			else
				player:say("You need 2 players for enter in the arena.", TALKTYPE_ORANGE_1)
				return true
			end
		end
	else
		return false
	end
	return true
end

arena2x2:id(24173)
arena2x2:register()

