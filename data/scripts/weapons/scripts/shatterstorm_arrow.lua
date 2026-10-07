-- Shatterstorm arrow (Vocation Adjustment) - physical AoE, 13 squares
local area = createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
})

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_OUTBURST_WHITE)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_SHATTERSTORMARROW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setFormula(COMBAT_FORMULA_SKILL, 0, 0, 1, 0)
combat:setArea(area)

local shatterstormArrow = Weapon(WEAPON_AMMO)

function shatterstormArrow.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

shatterstormArrow:id(53168)
shatterstormArrow:level(50)
shatterstormArrow:attack(27)
shatterstormArrow:action("removecount")
shatterstormArrow:ammoType("arrow")
shatterstormArrow:shootType(CONST_ANI_SHATTERSTORMARROW)
shatterstormArrow:maxHitChance(100)
shatterstormArrow:register()
