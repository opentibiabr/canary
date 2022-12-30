local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 0.4) + 3
	local max = (level / 5) + (maglevel * 0.8) + 5
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local rune = Spell("rune")

function rune.onCastSpell(creature, var, isHotkey)
	return combat:execute(creature, var)
end

rune:group("attack")
rune:name("lightest missile rune")
rune:runeId(21352)
rune:allowFarUse(true)
rune:charges(10)
rune:level(1)
rune:magicLevel(0)
rune:cooldown(2 * 1000)
rune:groupCooldown(2 * 1000)
rune:needTarget(true)
rune:isBlocking(true) -- True = Solid / False = Creature
rune:vocation("sorcerer;true", "master sorcerer;true", "druid;true", "elder druid;true", "paladin;true", "royal paladin;true")
rune:register()