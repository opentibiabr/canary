local spell = Spell("instant")

function spell.onCastSpell(player, variant)
	player:createFamiliarSpell()
	return true
end

spell:group("support")
spell:id(194)
spell:name("Knight familiar")
spell:words("utevo gran res eq")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_KNIGHT_FAMILIAR)
spell:level(200)
spell:mana(1000)
spell:cooldown(30 * 60 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("knight;true", "elite knight;true")
spell:register()
