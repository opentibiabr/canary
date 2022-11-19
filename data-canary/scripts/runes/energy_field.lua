local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGYBALL)
combat:setParameter(COMBAT_PARAM_CREATEITEM, ITEM_ENERGYFIELD_PVP)

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("attack")
rune:name("energy field rune")
rune:runeId(3164)
rune:allowFarUse(true)
rune:setPzLocked(true)
rune:charges(3)
rune:level(18)
rune:magicLevel(3)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:register()
