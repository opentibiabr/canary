local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PIXIE_EXPLOSION)

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_TICKS, 6000)
condition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, 30)
condition:setParameter(CONDITION_PARAM_SKILL_SHIELDPERCENT, 30)
condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, 30)

local area = createCombatArea(AREA_CIRCLE2X2)

combat:setArea(area)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("pixie skill reducer")
spell:words("###469")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:cooldown("2000")
spell:register()