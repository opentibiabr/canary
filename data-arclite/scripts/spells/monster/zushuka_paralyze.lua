	local combat = Combat()
	combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_WHITE)
	combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ICE)

	local condition = Condition(CONDITION_PARALYZE)
	condition:setParameter(CONDITION_PARAM_TICKS, 20000)
	condition:setFormula(-0.6, 0, -0.7, 0)

	local area = createCombatArea(AREA_SQUARE1X1)
	combat:setArea(area)
	combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("zushuka paralyze")
spell:words("###233")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()