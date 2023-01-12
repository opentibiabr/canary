local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_WEAPONTYPE)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
combat:setParameter(COMBAT_PARAM_USECHARGES, 1)

function onGetFormulaValues(player, skill, attack, factor)
	local level = player:getLevel()	
	local min = (level / 5) + (skill + attack) / 3
	local max = (level / 5) + skill + attack
	return -min * 1.28, -max * 1.28 -- TODO : Use New Real Formula instead of an %
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(107)
spell:name("Whirlwind Throw")
spell:words("exori hur")
spell:level(28)
spell:mana(40)
spell:isPremium(true)
spell:range(5)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(true)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("knight;true", "elite knight;true")
spell:register()