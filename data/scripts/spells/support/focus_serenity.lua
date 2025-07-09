local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:setHarmony(5)
	creature:setSereneCooldown(7000)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)

	creature:clearSpellCooldowns()

	local cooldown = spell:cooldown()
	if cooldown and cooldown > 0 then
		local condition = Condition(CONDITION_SPELLCOOLDOWN)
		condition:setParameter(CONDITION_PARAM_TICKS, cooldown)
		condition:setParameter(CONDITION_PARAM_SUBID, spell:id())
		creature:addCondition(condition)
	end

	local groupCooldown = spell:groupCooldown()
	if groupCooldown and groupCooldown > 0 then
		local conditionGroup = Condition(CONDITION_SPELLGROUPCOOLDOWN)
		conditionGroup:setParameter(CONDITION_PARAM_TICKS, groupCooldown)
		conditionGroup:setParameter(CONDITION_PARAM_SUBID, spell:group())
		creature:addCondition(conditionGroup)
	end

	return true
end

spell:group("support")
spell:id(281)
spell:name("Focus Serenity")
spell:words("utamo tio")
spell:level(150)
spell:mana(500)
spell:isPremium(false)
spell:needLearn(false)
spell:groupCooldown(2 * 1000)
spell:cooldown(10 * 60 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
