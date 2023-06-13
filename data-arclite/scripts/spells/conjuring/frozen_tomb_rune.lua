local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3163, 3)
end

spell:name("Frozen Tomb Rune")
spell:words("adori gran frigo")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "arch druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(45)
spell:mana(1085)
spell:soul(3)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
