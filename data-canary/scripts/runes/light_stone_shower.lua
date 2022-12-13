local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_STONES)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_EARTH)
combat:setArea(createCombatArea(AREA_CIRCLE1X1))

function onGetFormulaValues(player, level, maglevel)
	level = math.min(level, 20)
	maglevel = math.min(maglevel, 20)
	local min = (level / 5) + (maglevel * 0.3) + 2
	local max = (level / 5) + (maglevel * 0.45) + 3
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("attack")
rune:name("light stone shower rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_LIGHT_STONE_SHOWER_RUNE)
rune:runeId(21351)
rune:allowFarUse(true)
rune:charges(4)
rune:level(1)
rune:magicLevel(0)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:register()