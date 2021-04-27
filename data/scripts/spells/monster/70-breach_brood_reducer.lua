local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, -15)

local area = createCombatArea(AREA_SQUARE1X1)

combat:setArea(area)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("breach brood reducer")
spell:words("###70")
spell:needTarget(true)
spell:needLearn(true)
spell:isAggressive(true)
spell:blockWalls(true)
spell:needDirection(true)
spell:range(5)
spell:register()
