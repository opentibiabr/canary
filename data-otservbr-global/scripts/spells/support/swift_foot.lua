local spellDuration = 10000

local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, spellDuration)
condition:setFormula(0.8, -72, 0.8, -72)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local summons = creature:getSummons()
	if summons and type(summons) == 'table' and #summons > 0 then
		for i = 1, #summons do
			local summon = summons[i]
			local summon_t = summon:getType()
			if summon_t and summon_t:familiar() then
				local deltaSpeed = math.max(creature:getBaseSpeed() - summon:getBaseSpeed(), 0)
				local FamiliarSpeed = ((summon:getBaseSpeed() + deltaSpeed) * 0.8) - 72
				local FamiliarHaste = createConditionObject(CONDITION_HASTE)
				setConditionParam(FamiliarHaste, CONDITION_PARAM_TICKS, spellDuration)
				setConditionParam(FamiliarHaste, CONDITION_PARAM_SPEED, FamiliarSpeed)
				summon:addCondition(FamiliarHaste)
			end
		end
	end

	if (combat:execute(creature, var)) then
		local grade = creature:upgradeSpellsWORD("Swift Foot")
		if (grade == 0) then
			local exhaust = Condition(CONDITION_EXHAUST_COMBAT)
			exhaust:setParameter(CONDITION_PARAM_TICKS, spellDuration)
			creature:addCondition(exhaust)
			local disable = Condition(CONDITION_PACIFIED)
			disable:setParameter(CONDITION_PARAM_TICKS, spellDuration)
			creature:addCondition(disable)
			local exhaustAttackGroup = Condition(CONDITION_SPELLGROUPCOOLDOWN)
			exhaustAttackGroup:setParameter(CONDITION_PARAM_SUBID, 1)
			exhaustAttackGroup:setParameter(CONDITION_PARAM_TICKS, spellDuration)
			creature:addCondition(exhaustAttackGroup)			
		elseif (grade == 1) then
			local damageDebuff = Condition(CONDITION_ATTRIBUTES)
			damageDebuff:setParameter(CONDITION_PARAM_TICKS, spellDuration)
			damageDebuff:setParameter(CONDITION_PARAM_BUFF_DAMAGEDEALT, 50)
			creature:addCondition(damageDebuff)
		end
		return true
	end

	return false
end

spell:name("Swift Foot")
spell:words("utamo tempo san")
spell:group("support", "Focus")
spell:vocation("paladin;true", "royal paladin;true")
spell:id(134)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(55)
spell:mana(400)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
