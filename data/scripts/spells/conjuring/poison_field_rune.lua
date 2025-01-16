local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3172, 3)
end

spell:name("Poison Field Rune")
spell:words("adevo grav pox")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(14)
spell:mana(200)
spell:soul(1)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
