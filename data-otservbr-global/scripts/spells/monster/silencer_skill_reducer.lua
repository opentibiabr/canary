local combat = {}

for i = 40, 70 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
	combat[i]:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, i)

	local area = createCombatArea(AREA_CIRCLE2X2)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(40, 70)]:execute(creature, var)
end

spell:name("silencer skill reducer")
spell:words("###29")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needTarget(true)
spell:needLearn(true)
spell:register()