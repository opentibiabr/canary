local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_RINGS)

local condition = Condition(CONDITION_FREEZING)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(10, 8000, -8)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("quara constrictor freeze")
spell:words("###19")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()