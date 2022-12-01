local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3177, 1)
end

spell:name("Convince Creature Rune")
spell:words("adeta sio")
spell:group("support")
spell:vocation("druid;true", "elder druid;true")
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(16)
spell:mana(200)
spell:soul(3)
spell:isAggressive(false)
spell:needLearn(false)
spell:register()
