local traps = {
	[2145] = {transformTo = 2146, damage = {-50, -100}},
	[2147] = {transformTo = 2148, damage = {-50, -100}},
	[3481] = {transformTo = 3482, damage = {-15, -30}},
	[3944] = {transformTo = 3945, damage = {-15, -30}, type = COMBAT_EARTHDAMAGE}
}

local trap = MoveEvent()
trap:type("stepin")

function trap.onStepIn(creature, item, position, fromPosition)
	local trap = traps[item.itemid]
	if not trap then
		return true
	end

	if creature:isMonster() then
		doTargetCombatHealth(0, creature, trap.type or COMBAT_PHYSICALDAMAGE, trap.damage[1], trap.damage[2], CONST_ME_NONE)
	end

	if trap.transformTo then
		item:transform(trap.transformTo)
	end
	return true
end

trap:id(2145, 2147, 3481, 3944)
trap:register()

trap = MoveEvent()
trap:type("stepout")

function trap.onStepOut(creature, item, position, fromPosition)
	item:transform(item.itemid - 1)
	return true
end

trap:id(2146)
trap:register()

trap = MoveEvent()
trap:type("removeitem")

function trap.onRemoveItem(item, position)
	local itemPosition = item:getPosition()
	if itemPosition:getDistance(position) > 0 then
		item:transform(tileitem.itemid - 1)
		position:sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

trap:id(3482)
trap:register()
