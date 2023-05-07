local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRE)
combat:setParameter(COMBAT_PARAM_CREATEITEM, ITEM_FIREFIELD_PVP_FULL)

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("attack")
rune:name("fire field rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_FIRE_FIELD_RUNE)
rune:runeId(3188)
rune:allowFarUse(true)
rune:setPzLocked(true)
rune:charges(3)
rune:level(15)
rune:magicLevel(1)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()
