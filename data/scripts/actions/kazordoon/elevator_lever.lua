local config = {
	[50011] = Position(32636, 31881, 2),
	[50012] = Position(32636, 31881, 7)
}

local elevatorLever = Action()

function elevatorLever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.actionid]
	if not targetPosition then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	toPosition.x = toPosition.x - 1
	local creature = Tile(toPosition):getTopCreature()
	if not creature or not creature:isPlayer() then
		return true
	end

	if item.itemid ~= 1945 then
		return true
	end

	creature:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	creature:teleportTo(targetPosition)
	targetPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

elevatorLever:aid(50011, 50012)
elevatorLever:register()
