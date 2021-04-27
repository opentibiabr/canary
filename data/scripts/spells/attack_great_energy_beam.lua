local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setArea(createCombatArea(AREA_BEAM8))

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 3.6) + 22
	local max = (level / 5) + (maglevel * 6) + 37
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Great Energy Beam")
spell:words("exevo gran vis lux")
spell:group("attack")
spell:vocation("sorcerer", true)
spell:id(23)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(29)
spell:mana(110)
spell:isPremium(false)
spell:needLearn(false)
spell:needDirection(true)
spell:blockWalls(true)
spell:register()
