local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	creature:setVirtue(VIRTUE_JUSTICE)
	return true
end

spell:group("support")
spell:id(275)
spell:name("Virtue of Justice")
spell:words("utito virtu")
spell:level(20)
spell:mana(210)
spell:isPremium(false)
spell:needLearn(false)
spell:groupCooldown(2 * 1000)
spell:cooldown(2 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:isSelfTarget(true)
spell:isAggressive(false)
spell:register()
