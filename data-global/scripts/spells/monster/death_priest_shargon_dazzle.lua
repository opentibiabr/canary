local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_HOLYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MORTAREA)

local condition = Condition(CONDITION_DAZZLED)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(20, 10000, -20)
combat:addCondition(condition)

local area = createCombatArea(AREA_SQUARE1X1)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("death priest shargon dazzle")
spell:words("###377")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()