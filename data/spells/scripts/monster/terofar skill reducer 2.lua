local combat = {}

for i = 1, 10 do
combat[i] = Combat()
combat[i]:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)

local condition = Condition(CONDITION_ATTRIBUTES)
condition:setParameter(CONDITION_PARAM_TICKS, 15000)
condition:setParameter(CONDITION_PARAM_STAT_MAGICPOINTSPERCENT, i)

	local area = createCombatArea({
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0},
		{0, 0, 0, 0, 0, 3, 0, 0, 0, 0, 0}
	})

combat[i]:setArea(area)
combat[i]:addCondition(condition)

end

function onCastSpell(creature, var)
	return combat[math.random(1, 10)]:execute(creature, var)
end
