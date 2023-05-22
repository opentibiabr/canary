local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3163, 1)
end

spell:name("Frozen Tomb Rune")
spell:words("adori gran frigo")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(55)
spell:mana(1150)
spell:soul(1)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
