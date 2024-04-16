local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3153, 1)
end

spell:name("Cure Poison Rune")
spell:words("adana pox")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(15)
spell:mana(200)
spell:soul(1)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
