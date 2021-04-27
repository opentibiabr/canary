local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)
combat:setParameter(COMBAT_PARAM_VALIDTARGETS, COMBAT_TARGET_PARAM_ALL)
combat:setArea(createCombatArea(AREA_SQUARE1X1))

function onGetFormulaValues(player, skill, attack, factor)
	local skillTotal = skill * attack
	local levelTotal = player:getLevel() / 5
	return -(((skillTotal * 0.07) + 7) + (levelTotal)), -(((skillTotal * 0.09) + 11) + (levelTotal))
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Berserk")
spell:words("exori")
spell:group("attack")
spell:vocation("knight", true)
spell:id(80)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(35)
spell:mana(115)
spell:isPremium(true)
spell:needWeapon(true)
spell:needLearn(false)
spell:blockWalls(true)
spell:register()
