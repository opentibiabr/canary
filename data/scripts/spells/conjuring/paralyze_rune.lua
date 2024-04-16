local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3165, 1)
end

spell:name("Paralyze Rune")
spell:words("adana ani")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(54)
spell:mana(1400)
spell:soul(3)
spell:isAggressive(false)
spell:isPremium(true)
spell:needLearn(false)
spell:register()
