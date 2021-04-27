local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISONARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)

local condition = Condition(CONDITION_POISON)
condition:setParameter(CONDITION_PARAM_DELAYED, true)
condition:addDamage(4, 4000, -3)
condition:addDamage(9, 4000, -2)
condition:addDamage(20, 4000, -1)
combat:addCondition(condition)

local poisonArrow = Weapon(WEAPON_AMMO)

function poisonArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

poisonArrow:id(2545)
poisonArrow:attack(21)
poisonArrow:action("removecount")
poisonArrow:ammoType("arrow")
poisonArrow:shootType(CONST_ANI_POISONARROW)
poisonArrow:maxHitChance(91)
poisonArrow:register()
