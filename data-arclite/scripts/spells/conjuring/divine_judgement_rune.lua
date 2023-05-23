local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3187, 3)
end

spell:name("Divine Judgement Rune")
spell:words("adori gran san")
spell:group("support")
spell:vocation("paladin;true", "royal paladin;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(75)
spell:mana(1050)
spell:soul(3)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
