local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGYBALL)
combat:setParameter(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP)
combat:setArea(createCombatArea(AREA_WALLFIELD_ENERGY, AREADIAGONAL_WALLFIELD_ENERGY))

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("attack")
rune:name("energy wall rune")
rune:castSound(SOUND_EFFECT_TYPE_SPELL_OR_RUNE)
rune:impactSound(SOUND_EFFECT_TYPE_SPELL_ENERGY_WALL_RUNE)
rune:runeId(3166)
rune:allowFarUse(true)
rune:setPzLocked(true)
rune:charges(4)
rune:level(41)
rune:magicLevel(9)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()
