local spell = Spell("instant")
local spellId = 195

function spell.onCastSpell(player, variant)
	return player:CreateFamiliarSpell(spellId)
end

spell:group("support")
spell:id(spellId)
spell:name("Paladin familiar")
spell:words("utevo gran res sac")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SUMMON_PALADIN_FAMILIAR)
spell:level(200)
spell:mana(2000)
spell:cooldown(0) -- calculated in CreateFamiliarSpell
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:isAggressive(false)
spell:vocation("paladin;true", "royal paladin;true")
spell:register()
