local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 22000)
condition:setFormula(0.7, -56, 0.7, -56)
combat:addCondition(condition)

function onCastSpell(creature, var)
	local summons = creature:getSummons()
	if summons and type(summons) == 'table' and #summons > 0 then
		for i = 1, #summons do
			local summon = summons[i]
			local summon_t = summon:getType()
			if summon_t and summon_t:isPet() then
				local deltaSpeed = math.max(creature:getBaseSpeed() - summon:getBaseSpeed(), 0)
				local PetSpeed = ((summon:getBaseSpeed() + deltaSpeed) * 0.7) - 56
				local PetHaste = createConditionObject(CONDITION_HASTE)
				setConditionParam(PetHaste, CONDITION_PARAM_TICKS, 22000)
				setConditionParam(PetHaste, CONDITION_PARAM_SPEED, PetSpeed)
				summon:addCondition(PetHaste)
			end
		end
	end
	return combat:execute(creature, var)
end
