local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3178, 1)
end

spell:name("Chameleon Rune")
spell:words("adevo ina")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(27)
spell:mana(600)
spell:soul(2)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
