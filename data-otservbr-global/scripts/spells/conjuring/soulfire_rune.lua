local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3195, 3)
end

spell:name("Soulfire Rune")
spell:words("adevo res flam")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(27)
spell:mana(420)
spell:soul(3)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
