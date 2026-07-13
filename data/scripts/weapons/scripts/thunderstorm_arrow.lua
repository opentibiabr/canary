local area = createCombatArea({
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 0, 1, 0, 0 },
})

local combat = Combat()
combat:setOrigin(ORIGIN_RANGED)
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
combat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_THUNDERSTORMARROW)
combat:setParameter(COMBAT_PARAM_CASTSOUND, SOUND_EFFECT_TYPE_DIST_ATK_BOW)
combat:setParameter(COMBAT_PARAM_BLOCKARMOR, true)
combat:setArea(area)

function onGetFormulaValues(player, skill, attack, factor)
	local distanceSkill = player:getEffectiveSkillLevel(SKILL_DISTANCE)
	local min = player:getLevel() / 5
	local max = (0.09 * factor) * distanceSkill * attack + (player:getLevel() / 5)
	return -min, -max
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")

local weapon = Weapon(WEAPON_AMMO)

function weapon.onUseWeapon(player, variant)
	return combat:execute(player, variant)
end

weapon:id(53172)
weapon:level(125)
weapon:attack(21)
weapon:action("removecount")
weapon:ammoType("arrow")
weapon:shootType(CONST_ANI_THUNDERSTORMARROW)
weapon:maxHitChance(100)
weapon:wieldUnproperly(true)
weapon:register()
