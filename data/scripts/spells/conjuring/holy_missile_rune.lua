local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3182, 5)
end

spell:name("Holy Missile Rune")
spell:words("adori san")
spell:group("support")
spell:vocation("paladin;true", "royal paladin;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(27)
spell:mana(300)
spell:soul(3)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
