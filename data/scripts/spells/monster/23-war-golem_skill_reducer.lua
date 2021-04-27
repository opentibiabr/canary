local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_STUN)
combat:setArea(createCombatArea(AREA_BEAM8))

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 3 * 1000},
	{key = CONDITION_PARAM_SKILL_SHIELDPERCENT, value = 70}
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	for _, target in ipairs(combat:getTargets(creature, var)) do
		target:addAttributeCondition(parameters)
	end
	return true
end

spell:name("war golem skill reducer")
spell:words("###23")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:needDirection(true)
spell:register()
