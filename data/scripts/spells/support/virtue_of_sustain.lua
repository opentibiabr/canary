local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	creature:setVirtue(VIRTUE_SUSTAIN)
	return true
end

spell:group("support")
spell:id(276)
spell:name("Virtue of Sustain")
spell:words("utura tio")
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
