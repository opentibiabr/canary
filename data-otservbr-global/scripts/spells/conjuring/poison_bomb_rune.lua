local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3173, 2)
end

spell:name("Poison Bomb Rune")
spell:words("adevo mas pox")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(25)
spell:mana(520)
spell:soul(2)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
