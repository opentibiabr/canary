local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 5000)
condition:setFormula(0.9, -0, 0.9, -0)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local summons = creature:getSummons()
	if summons and type(summons) == 'table' and #summons > 0 then
		for i = 1, #summons do
			local summon = summons[i]
			local summon_t = summon:getType()
			if summon_t and summon_t:familiar() then
				local deltaSpeed = math.max(creature:getBaseSpeed() - summon:getBaseSpeed(), 0)
				local FamiliarSpeed = ((summon:getBaseSpeed() + deltaSpeed) * 0.9) - 72
				local FamiliarHaste = createConditionObject(CONDITION_HASTE)
				setConditionParam(FamiliarHaste, CONDITION_PARAM_TICKS, 5000)
				setConditionParam(FamiliarHaste, CONDITION_PARAM_SPEED, FamiliarSpeed)
				summon:addCondition(FamiliarHaste)
			end
		end
	end
	return combat:execute(creature, variant)
end

spell:name("Charge")
spell:words("utani tempo hur")
spell:group("support")
spell:vocation("knight;true", "elite knight;true")
spell:id(131)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(25)
spell:mana(100)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
