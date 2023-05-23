local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_BLOCKHIT)

local condition = Condition(CONDITION_ENERGY)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(4, 10000, -25)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("charged energy elemental electrify")
spell:words("###259")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()