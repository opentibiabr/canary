
local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	player:CreateFamiliarSpell()
	return true
end

spell:group("support")
spell:id(196)
spell:name("Sorcerer familiar")
spell:words("utevo gran res ven")
spell:level(200)
spell:mana(3000)
spell:cooldown(configManager.getNumber(configKeys.FAMILIAR_TIME) * 60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
