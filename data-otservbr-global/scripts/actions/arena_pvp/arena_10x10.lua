local setting = {
	centerRoom = {x = 32255, y = 32178, z = 9},
	range = 10
}

local playerPositions = {
	{fromPos = {x = 32242, y = 32175, z = 8}, toPos = {x = 32246, y = 32175, z = 9}},
	{fromPos = {x = 32242, y = 32176, z = 8}, toPos = {x = 32246, y = 32177, z = 9}},
	{fromPos = {x = 32242, y = 32177, z = 8}, toPos = {x = 32246, y = 32179, z = 9}},
	{fromPos = {x = 32242, y = 32178, z = 8}, toPos = {x = 32246, y = 32181, z = 9}},
	{fromPos = {x = 32242, y = 32180, z = 8}, toPos = {x = 32264, y = 32174, z = 9}},
	{fromPos = {x = 32242, y = 32181, z = 8}, toPos = {x = 32264, y = 32176, z = 9}},
	{fromPos = {x = 32242, y = 32182, z = 8}, toPos = {x = 32264, y = 32178, z = 9}},
	{fromPos = {x = 32242, y = 32183, z = 8}, toPos = {x = 32264, y = 32180, z = 9}},
	{fromPos = {x = 32242, y = 32184, z = 8}, toPos = {x = 32264, y = 32182, z = 9}},
	{fromPos = {x = 32241, y = 32179, z = 8}, toPos = {x = 32246, y = 32183, z = 9}}, -- Player 1 pos
}

local arena10x10 = Action()

function arena10x10.onUse(player, item, fromPosition, target, toPosition, monster, isHotkey)
	if toPosition == Position(32240, 32179, 8) then
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
				player:say("You need 10 players for enter in the arena.", TALKTYPE_ORANGE_1)
				return true
			else
				player:say("You need 10 players for enter in the arena.", TALKTYPE_ORANGE_1)
				return true
			end
		end
	else
		return false
	end
	return true
end

arena10x10:id(24181)
arena10x10:register()

