-- Terrastorm arrow (Vocation Adjustment) - earth AoE, 13 squares
local area = createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_OUTBURST_GREEN)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_TERRASTORMARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

local terrastormArrow = Weapon(WEAPON_AMMO)

function terrastormArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

terrastormArrow:id(53170)
terrastormArrow:level(125)
terrastormArrow:attack(21)
terrastormArrow:action("removecount")
terrastormArrow:ammoType("arrow")
terrastormArrow:shootType(CONST_ANI_TERRASTORMARROW)
terrastormArrow:maxHitChance(100)
terrastormArrow:register()
