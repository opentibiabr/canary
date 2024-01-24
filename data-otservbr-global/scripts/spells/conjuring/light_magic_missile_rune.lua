local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3174, 10)
end

spell:name("Light Magic Missile Rune")
spell:words("adori min vis")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(15)
spell:mana(120)
spell:soul(1)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
