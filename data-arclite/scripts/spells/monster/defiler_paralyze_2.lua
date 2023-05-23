local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_POISONAREA)

local condition = Condition(CONDITION_PARALYZE)
condition:setParameter(CONDITION_PARAM_TICKS, 20000)
condition:setFormula(-0.85, 0, -0.90, 0)
combat:addCondition(condition)


local area = createCombatArea(AREA_SQUARE1X1)
	combat:setArea(area)
	combat:addCondition(condition)


local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("defiler paralyze 2")
spell:words("###65")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()