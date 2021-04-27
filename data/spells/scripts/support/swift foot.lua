local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local exhaust = Condition(CONDITION_EXHAUST_COMBAT)
exhaust:setParameter(CONDITION_PARAM_TICKS, 10000)
combat:addCondition(exhaust)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 10000)
condition:setFormula(0.8, -72, 0.8, -72)
combat:addCondition(condition)

local exhaustAttackGroup = Condition(CONDITION_SPELLGROUPCOOLDOWN)
exhaustAttackGroup:setParameter(CONDITION_PARAM_SUBID, 1)
exhaustAttackGroup:setParameter(CONDITION_PARAM_TICKS, 10000)
combat:addCondition(exhaustAttackGroup)

local disable = Condition(CONDITION_PACIFIED)
disable:setParameter(CONDITION_PARAM_TICKS, 10000)
combat:addCondition(disable)

function onCastSpell(creature, var)
	local summons = creature:getSummons()
	if summons and type(summons) == 'table' and #summons > 0 then
		for i = 1, #summons do
			local summon = summons[i]
			local summon_t = summon:getType()
			if summon_t and summon_t:isPet() then
				local deltaSpeed = math.max(creature:getBaseSpeed() - summon:getBaseSpeed(), 0)
				local PetSpeed = ((summon:getBaseSpeed() + deltaSpeed) * 0.8) - 72
				local PetHaste = createConditionObject(CONDITION_HASTE)
				setConditionParam(PetHaste, CONDITION_PARAM_TICKS, 10000)
				setConditionParam(PetHaste, CONDITION_PARAM_SPEED, PetSpeed)
				summon:addCondition(PetHaste)
			end
		end
	end
	return combat:execute(creature, var)
end
