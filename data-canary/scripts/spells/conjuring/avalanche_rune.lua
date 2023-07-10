local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3161, 4)
end

spell:name("Avalanche Rune")
spell:words("adori mas frigo")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(30)
spell:mana(530)
spell:soul(3)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
