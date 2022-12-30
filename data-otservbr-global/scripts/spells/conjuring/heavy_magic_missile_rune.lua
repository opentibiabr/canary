local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3198, 10)
end

spell:name("Heavy Magic Missile Rune")
spell:words("adori vis")
spell:group("support")
spell:vocation("druid;true", "elder druid;true", "sorcerer;true", "master sorcerer;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(25)
spell:mana(350)
spell:soul(2)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
