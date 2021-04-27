local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_LARGEROCK)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 4 * 1000},
	{key = CONDITION_PARAM_SKILL_SHIELDPERCENT, value = 50},
	{key = CONDITION_PARAM_SKILL_DISTANCEPERCENT, value = 50}
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	for _, target in ipairs(combat:getTargets(creature, var)) do
		target:addAttributeCondition(parameters)
	end
	return true
end

spell:name("forest fury skill reducer")
spell:words("###35")
spell:needTarget(true)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
