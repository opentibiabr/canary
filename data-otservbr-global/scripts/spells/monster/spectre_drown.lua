local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DROWNDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)

local condition = Condition(CONDITION_DROWN)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(20, 5000, -20)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("spectre drown")
spell:words("###8")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()