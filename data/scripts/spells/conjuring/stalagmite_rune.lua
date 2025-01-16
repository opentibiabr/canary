local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3179, 10)
end

spell:name("Stalagmite Rune")
spell:words("adori tera")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(24)
spell:mana(350)
spell:soul(2)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
