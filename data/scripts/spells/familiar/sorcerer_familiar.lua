
local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	player:createFamiliarSpell()
	return true
end

spell:group("support")
spell:id(196)
spell:name("Sorcerer familiar")
spell:words("utevo gran res ven")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_SORCERER_FAMILIAR)
spell:level(200)
spell:mana(3000)
spell:cooldown(30 * 60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
