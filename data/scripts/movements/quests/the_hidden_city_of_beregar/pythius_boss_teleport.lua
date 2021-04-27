local function roomIsOccupied()
	local spectators = Game.getSpectators(Position(32566, 31406, 15), false, true, 7, 7)
	if #spectators ~= 0 then
		return true
	end
	return false
end

local pythiusBossTeleport = MoveEvent()

function pythiusBossTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if item.actionid == 50126 then
		if player:getStorageValue(Storage.QuestChests.FirewalkerBoots) == 1 or roomIsOccupied() then
			player:teleportTo(fromPosition, true)
			fromPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end

		item:remove()

		local steamPosition = Position(32551, 31379, 15)
		iterateArea(
		function(position)
			local groundItem = Tile(position):getGround()
			if groundItem and groundItem.itemid == 5815 then
				groundItem:transform(598)
			end
		end,
		Position(32550, 31373, 15),
		steamPosition
		)

		Game.createItem(1304, 1, steamPosition)
		local steamItem = Game.createItem(9341, 1, steamPosition)
		if steamItem then
			steamItem:setActionId(50127)
		end

		local destination = Position(32560, 31404, 15)
		player:teleportTo(destination)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		destination:sendMagicEffect(CONST_ME_TELEPORT)

		local monster = Game.createMonster("pythius the rotten", Position(32571, 31406, 15))
		if monster then
			monster:say("WHO IS SNEAKING AROUND BEHIND MY TREASURE?", TALKTYPE_MONSTER_YELL, false, player)
		end

	else

		local spectators, spectator = Game.getSpectators(Position(32566, 31406, 15), false, false, 7, 7)
		for i = 1, #spectators do
			spectator = spectators[i]
			if spectator:isMonster() then
				spectator:remove()
			end
		end

		local destination = Position(32552, 31378, 15)
		player:teleportTo(destination)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

pythiusBossTeleport:type("stepin")
pythiusBossTeleport:aid(50125, 50126)
pythiusBossTeleport:register()
