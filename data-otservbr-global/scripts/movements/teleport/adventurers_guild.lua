local adventurersGuild = MoveEvent()

function adventurersGuild.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local townId = player:getStorageValue(Storage.Quest.U9_80.AdventurersGuild.Stone)
	local destination = townId ~= -1 and Town(townId):getTemplePosition() or player:getTown():getTemplePosition()

	player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.Stone, -1)
	player:teleportTo(destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

adventurersGuild:type("stepin")
adventurersGuild:aid(4253)
adventurersGuild:register()
