local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)

local condition = Condition(CONDITION_ENERGY)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(25, 10000, -25)
combat:addCondition(condition)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("ushuriel electrify")
spell:words("###225")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()