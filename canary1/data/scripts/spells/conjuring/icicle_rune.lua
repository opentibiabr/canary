local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3158, 5)
end

spell:name("Icicle Rune")
spell:words("adori frigo")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(28)
spell:mana(460)
spell:soul(3)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
