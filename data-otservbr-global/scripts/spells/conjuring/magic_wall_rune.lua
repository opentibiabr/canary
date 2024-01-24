local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3180, 3)
end

spell:name("Magic Wall Rune")
spell:words("adevo grav tera")
spell:group("support")
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(32)
spell:mana(750)
spell:soul(5)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
