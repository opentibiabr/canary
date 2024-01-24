local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	return creature:conjureItem(3147, 3174, 10, CONST_ME_MAGIC_BLUE)
end

spell:name("Lightest Magic Missile")
spell:words("adori dis min vis")
spell:group("support")
spell:vocation("none")
spell:cooldown(DEFAULT_COOLDOWN.SPELL)
spell:groupCooldown(DEFAULT_COOLDOWN.SPELL_GROUP)
spell:level(1)
spell:mana(5)
spell:soul(0)
spell:needLearn(false)
spell:register()
