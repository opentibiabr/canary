local silveredTrap = MoveEvent()

function silveredTrap.onStepIn(creature, item, position, fromPosition)
	local monster = creature:getMonster()
	if not monster then
		return true
	end

	if monster:getName():lower() ~= "feroxa" then
		return true
	end
	if monster:getMaxHealth() == 50000 then
		doTargetCombatHealth(0, monster, COMBAT_UNDEFINEDDAMAGE, -1000, -1000, CONST_ME_DRAWBLOOD)
	end
	item:transform(24730)
	position:sendMagicEffect(CONST_ME_BLOCKHIT)
	return true
end

silveredTrap:type("stepin")
silveredTrap:id(24715)
silveredTrap:register()
