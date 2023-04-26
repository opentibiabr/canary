local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	player:CreateFamiliarSpell()
	return true
end

spell:group("support")
spell:id(194)
spell:name("Knight familiar")
spell:words("utevo gran res eq")
spell:level(200)
spell:mana(1000)
spell:cooldown(configManager.getNumber(configKeys.FAMILIAR_TIME) * 60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation("knight;true", "elite knight;true")
spell:register()
