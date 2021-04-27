local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

local condition = Condition(COMBAT_PHYSICALDAMAGE)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(3, 100, -35)
combat:addCondition(condition)

function onCastSpell(creature, var)
 return combat:execute(creature, var)
end
