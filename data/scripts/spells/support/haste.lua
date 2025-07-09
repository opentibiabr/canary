local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_GREEN)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, false)

local condition = Condition(CONDITION_HASTE)
condition:setParameter(CONDITION_PARAM_TICKS, 30000)
condition:setFormula(1.3, 40, 1.3, 40)
combat:addCondition(condition)

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local summons = creature:getSummons()
	if summons and type(summons) == "table" and #summons > 0 then
		for i = 1, #summons do
			local summon = summons[i]
			local summon_t = summon:getType()
			if summon_t and summon_t:familiar() then
				local deltaSpeed = math.max(creature:getBaseSpeed() - summon:getBaseSpeed(), 0)
				local FamiliarSpeed = ((summon:getBaseSpeed() + deltaSpeed) * 0.3) - 24
				local FamiliarHaste = Condition(CONDITION_HASTE)
				FamiliarHaste:setParameter(CONDITION_PARAM_TICKS, 33000)
				FamiliarHaste:setParameter(CONDITION_PARAM_SPEED, FamiliarSpeed)
				summon:addCondition(FamiliarHaste)
			end
		end
	end
	return combat:execute(creature, variant)
end

spell:name("Haste")
spell:words("utani hur")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "knight;true", "elite knight;true", "paladin;true", "royal paladin;true", "sorcerer;true", "master sorcerer;true", "monk;true", "exalted monk;true")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_HASTE)
spell:id(6)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(14)
spell:mana(60)
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
