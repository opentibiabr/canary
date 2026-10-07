-- Thunderstorm arrow (Vocation Adjustment) - energy AoE, 13 squares
local area = createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_YELLOWENERGY)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_THUNDERSTORMARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

local thunderstormArrow = Weapon(WEAPON_AMMO)

function thunderstormArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

thunderstormArrow:id(53172)
thunderstormArrow:level(125)
thunderstormArrow:attack(21)
thunderstormArrow:action("removecount")
thunderstormArrow:ammoType("arrow")
thunderstormArrow:shootType(CONST_ANI_THUNDERSTORMARROW)
thunderstormArrow:maxHitChance(100)
thunderstormArrow:register()
