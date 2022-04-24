local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)

function onGetFormulaValues(player, skill, attack, factor)
	local skillTotal = skill * attack
	local levelTotal = player:getLevel() / 5
	return -(((skillTotal * 0.17) + 13) + (levelTotal)) * 1.28, -(((skillTotal * 0.20) + 34) + (levelTotal)) * 1.28 -- TODO : Use New Real Formula instead of an %
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(62)
spell:name("Annihilation")
spell:words("exori gran ico")
spell:level(110)
spell:mana(300)
spell:isPremium(true)
spell:range(1)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(true)
spell:cooldown(30 * 1000)
spell:groupCooldown(4 * 1000)
spell:needLearn(false)
spell:vocation("knight;true", "elite knight;true")
spell:register()