local config = {
	[3184] = Position(33082, 31110, 2),
	[3185] = Position(33078, 31080, 13)
}

local wrathEmperorMiss8Uninvited = Action()
function wrathEmperorMiss8Uninvited.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetPosition = config[item.uid]
	if not targetPosition then
		return true
	end

	item:transform(item.itemid == 1945 and 1946 or 1945)

	toPosition.y = toPosition.y + 1
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

wrathEmperorMiss8Uninvited:uid(3184,3185)
wrathEmperorMiss8Uninvited:register()