local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	for _, target in ipairs(combat:getTargets(creature, var)) do
		creature:addDamageCondition(target, CONDITION_FREEZING, DAMAGELIST_VARYING_PERIOD, 8, {8, 10}, 10)
	end
	return true
end

spell:name("quara constrictor freeze")
spell:words("###19")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
