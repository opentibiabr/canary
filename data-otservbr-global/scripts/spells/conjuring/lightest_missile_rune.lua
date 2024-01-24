local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 21352, 10)
end

spell:name("Lightest Missile Rune")
spell:words("adori infir vis")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(1)
spell:mana(6)
spell:soul(0)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
