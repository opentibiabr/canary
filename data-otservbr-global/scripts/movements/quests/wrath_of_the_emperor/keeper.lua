local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end

local keeper = MoveEvent()

function keeper.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if not monster then
		return true
	end

	if monster:getName():lower() ~= 'the keeper' then
		return true
	end

	doTargetCombatHealth(0, monster, COMBAT_PHYSICALDAMAGE, -6000, -8000, CONST_ME_BIGPLANTS)
	item:transform(11379)
	addEvent(revertItem, math.random(10, 30) * 1000, position, 11379, 11378)
	return true
end

keeper:type("stepin")
keeper:id(11378)
keeper:register()
