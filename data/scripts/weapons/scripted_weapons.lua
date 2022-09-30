local burstArea = createCombatArea({
	{1, 1, 1},
	{1, 3, 1},
	{1, 1, 1}
})

local burstCombat = Combat()
burstCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
burstCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_EXPLOSIONAREA)
burstCombat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_BURSTARROW)
burstCombat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
burstCombat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
burstCombat:setParameter(COMBAT_PARAM_IMPACTSOUND, SOUND_EFFECT_TYPE_BURST_ARROW_EFFECT)
burstCombat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
burstCombat:setArea(burstArea)

local burstarrow = Weapon(WEAPON_AMMO)
burstarrow.onUseWeapon = function(player, variant)
	if player:getSkull() == SKULL_BLACK then
		return false
	end
	
	return burstCombat:execute(player, variant)
end

burstarrow:id(3449)
burstarrow:action("removecount")
burstarrow:register()

local poisonCombat = Combat()
poisonCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
poisonCombat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_POISONARROW)
poisonCombat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
poisonCombat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)

local poisonarrow = Weapon(WEAPON_AMMO)
poisonarrow.onUseWeapon = function(player, variant)
	if not poisonCombat:execute(player, variant) then
		return false
	end
	
	player:addDamageCondition(Creature(variant:getNumber()), CONDITION_POISON, DAMAGELIST_LOGARITHMIC_DAMAGE, 3)
	return true
end

poisonarrow:id(3448)
poisonarrow:action("removecount")
poisonarrow:register()

local viperCombat = Combat()
viperCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
viperCombat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_GREENSTAR)
viperCombat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
viperCombat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)

local viperstar= Weapon(WEAPON_DISTANCE)
viperstar.onUseWeapon = function(player, variant)
	if not viperCombat:execute(player, variant) then
		return false
	end
	
	if math.random(1, 100) <= 90 then
		return false
	end
	
	player:addDamageCondition(Creature(variant:getNumber()), CONDITION_POISON, DAMAGELIST_LOGARITHMIC_DAMAGE, 2)
	return true
end

viperstar:id(7366)
viperstar:breakChance(9)
viperstar:register()

local diamondArea = createCombatArea({
	{0, 1, 1, 1, 0},
	{1, 1, 1, 1, 1},
	{1, 1, 3, 1, 1},
	{1, 1, 1, 1, 1},
	{0, 1, 1, 1, 0},
})

local diamondCombat = Combat()
diamondCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
diamondCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYHIT)
diamondCombat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_DIAMONDARROW)
diamondCombat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
diamondCombat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
diamondCombat:setArea(diamondArea)

local diamondarrow = Weapon(WEAPON_AMMO)
diamondarrow.onUseWeapon = function(player, variant)
	return diamondCombat:execute(player, variant)
end

diamondarrow:id(ITEM_OLD_DIAMOND_ARROW)
diamondarrow:action("removecount")
diamondarrow:level(150)
diamondarrow:wieldUnproperly(true)
diamondarrow:register()
