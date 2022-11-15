local combat = {}

for i = 35, 60 do
combat[i] = Combat()
combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_YELLOW_RINGS)

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_TICKS, 8000)
condition:setParameter(CONDITION_PARAM_SKILL_MELEEPERCENT, i)
condition:setParameter(CONDITION_PARAM_SKILL_FISTPERCENT, i)

arr = {
{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
}

local area = createCombatArea(arr)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)

end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(35, 60)]:execute(creature, var)
end

spell:name("feversleep skill reducer")
spell:words("###42")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()