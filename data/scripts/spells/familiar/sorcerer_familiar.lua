local spell = Spell("instant")
local spellId = 196

function spell.onCastSpell(player, variant)
	return player:CreateFamiliarSpell(spellId)
end

spell:group("support")
spell:id(spellId)
spell:name("Sorcerer familiar")
spell:words("utevo gran res ven")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_SORCERER_FAMILIAR)
spell:level(200)
spell:mana(3000)
spell:cooldown(0) -- calculated in CreateFamiliarSpell
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
