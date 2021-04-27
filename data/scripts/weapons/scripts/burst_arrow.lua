local area = createCombatArea({
 	{1, 1, 1},
 	{1, 3, 1},
 	{1, 1, 1}
 })

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

local burstArrow = Weapon(WEAPON_AMMO)

burstArrow.onUseWeapon = function(player, variant)
	if player:getSkull() == SKULL_BLACK then
		return false
	end

	return combat:execute(player, variant)
end

burstArrow:id(2546)
burstArrow:attack(27)
burstArrow:action("removecount")
burstArrow:ammoType("arrow")
burstArrow:shootType(CONST_ANI_BURSTARROW)
burstArrow:maxHitChance(100)
burstArrow:register()
