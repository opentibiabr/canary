local combat = {}

for i = 25, 55 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_SOUND_PURPLE)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 7000)
	condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, i)
	condition:setParameter(CONDITION_PARAM_SKILL_DISTANCEPERCENT, i)

	local area = createCombatArea(AREA_BEAM1)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(25, 55)]:execute(creature, var)
end

spell:name("pirate corsair skill reducer")
spell:words("###49")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:needDirection(true)
spell:register()