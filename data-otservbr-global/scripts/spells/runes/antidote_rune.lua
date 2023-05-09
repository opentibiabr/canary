local combat = Combat()
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_POISON)

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("healing")
rune:name("antidote rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_CURE_POISON_RUNE)
rune:runeId(3153)
rune:allowFarUse(true)
rune:charges(1)
rune:level(15)
rune:magicLevel(0)
rune:cooldown(1 * 1000)
rune:groupCooldown(1 * 1000)
rune:isAggressive(false)
rune:needTarget(true)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()