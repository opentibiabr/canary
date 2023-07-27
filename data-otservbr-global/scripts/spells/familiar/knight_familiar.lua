local spell = Spell("instant")
local spellid = 194

function spell.onCastSpell(player, variant)
	return player:CreateFamiliarSpell(spellid)
end

spell:group("support")
spell:id(spellid)
spell:name("Knight familiar")
spell:words("utevo gran res eq")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_KNIGHT_FAMILIAR)
spell:level(200)
spell:mana(1000)
spell:cooldown(0) -- calculated in CreateFamiliarSpell
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation("knight;true", "elite knight;true")
spell:register()
