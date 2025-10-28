local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	creature:setHarmony(5)
	creature:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return true
end

spell:group("support")
spell:id(279)
spell:name("Focus Harmony")
spell:words("utevo nia")
spell:level(275)
spell:mana(500)
spell:isPremium(false)
spell:needLearn(false)
spell:groupCooldown(2 * 1000)
spell:cooldown(2 * 60 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
