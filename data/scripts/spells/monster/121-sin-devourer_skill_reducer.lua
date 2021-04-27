local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 6 * 1000},
	{key = CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, value = nil}
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	parameters[2].value = math.random(20, 70)

	for _, target in ipairs(combat:getTargets(creature, var)) do
		target:addAttributeCondition(parameters)
	end
	return true
end

spell:name("sin devourer skill reducer")
spell:words("###121")
spell:needTarget(true)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
