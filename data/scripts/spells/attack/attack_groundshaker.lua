local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GROUNDSHAKER)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)
combat:setArea(createCombatArea(AREA_CIRCLE3X3))

function onGetFormulaValues(player, skill, attack, factor)
	local skillTotal = skill * attack
	local levelTotal = player:getLevel() / 5
	return -(((skillTotal * 0.02) + 4) + (levelTotal)), -(((skillTotal * 0.03) + 6) + (levelTotal))
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Groundshaker")
spell:words("exori mas")
spell:group("attack")
spell:vocation("knight", true)
spell:id(106)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(33)
spell:mana(160)
spell:isPremium(true)
spell:needWeapon(true)
spell:needLearn(false)
spell:register()
