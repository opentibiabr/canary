local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

local parameters = {
	{key = CONDITION_PARAM_TICKS, value = 6 * 1000},
	{key = CONDITION_PARAM_SKILL_SHIELDPERCENT, value = nil}
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	parameters[2].value = math.random(13, 50)

	for _, target in ipairs(combat:getTargets(creature, var)) do
		target:addAttributeCondition(parameters)
	end
	return true
end

spell:name("enslaved dwarf skill reducer 1")
spell:words("###45")
spell:needTarget(false)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:register()
