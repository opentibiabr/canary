local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_CARNIPHILA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SMALLEARTH)

function onGetFormulaValues(player, level, maglevel)
	local min = (level / 5) + (maglevel * 1.4) + 8
	local max = (level / 5) + (maglevel * 2.2) + 14
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Terra Strike")
spell:words("exori tera")
spell:group("attack")
spell:vocation("druid", "sorcerer", true, true)
spell:id(113)
spell:cooldown(2 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(13)
spell:mana(20)
spell:range(3)
spell:isPremium(false)
spell:needLearn(false)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:register()
