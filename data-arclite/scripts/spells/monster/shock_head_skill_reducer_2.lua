local combat = {}

for i = 20, 50 do
	combat[i] = Combat()
	combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_RED)

	local condition = Condition(CONDITION_ATTRIBUTES)
	condition:setParameter(CONDITION_PARAM_TICKS, 6000)
	condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, i)

arr = {
{0, 0, 0, 1, 1, 1, 0, 0, 0},
{0, 0, 1, 1, 1, 1, 1, 0, 0},
{0, 1, 1, 1, 1, 1, 1, 1, 0},
{1, 1, 1, 1, 1, 1, 1, 1, 1},
{1, 1, 1, 1, 3, 1, 1, 1, 1},
{1, 1, 1, 1, 1, 1, 1, 1 ,1},
{0, 1, 1, 1, 1, 1, 1, 1 ,0},
{0, 0, 1, 1, 1, 1, 1, 0 ,0},
{0, 0, 0, 1, 1, 1, 0, 0, 0}
}

	local area = createCombatArea(arr)
	combat[i]:setArea(area)
	combat[i]:addCondition(condition)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat[math.random(20, 50)]:execute(creature, var)
end

spell:name("shock head skill reducer 2")
spell:words("###44")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()