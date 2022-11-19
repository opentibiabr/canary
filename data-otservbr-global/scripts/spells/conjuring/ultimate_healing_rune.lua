local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3160, 1)
end

spell:name("Ultimate Healing Rune")
spell:words("adura vita")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(24)
spell:mana(400)
spell:soul(3)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
