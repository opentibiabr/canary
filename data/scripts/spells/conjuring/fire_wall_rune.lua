local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3190, 4)
end

spell:name("Fire Wall Rune")
spell:words("adevo mas grav flam")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(33)
spell:mana(780)
spell:soul(4)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
