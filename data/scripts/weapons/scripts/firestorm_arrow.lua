-- Firestorm arrow (Vocation Adjustment) - fire AoE, 13 squares
local area = createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_FIREDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITBYFIRE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_FIRESTORMARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

local firestormArrow = Weapon(WEAPON_AMMO)

function firestormArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

firestormArrow:id(53169)
firestormArrow:level(125)
firestormArrow:attack(21)
firestormArrow:action("removecount")
firestormArrow:ammoType("arrow")
firestormArrow:shootType(CONST_ANI_FIRESTORMARROW)
firestormArrow:maxHitChance(100)
firestormArrow:register()
