-- Froststorm arrow (Vocation Adjustment) - ice AoE, 13 squares
local area = createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEATTACK)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FROSTSTORMARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

local froststormArrow = Weapon(WEAPON_AMMO)

function froststormArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

froststormArrow:id(53171)
froststormArrow:level(125)
froststormArrow:attack(21)
froststormArrow:action("removecount")
froststormArrow:ammoType("arrow")
froststormArrow:shootType(CONST_ANI_FROSTSTORMARROW)
froststormArrow:maxHitChance(100)
froststormArrow:register()
