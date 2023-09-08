local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_DELAYED, 1)
condition:addDamage(3, 100, -35)

local area = createCombatArea(AREA_CIRCLE3X3)
combat:setArea(area)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("vile grandmaster")
spell:words("##405")
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
