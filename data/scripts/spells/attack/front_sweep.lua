local SPELL_BASE_POWER = 80

local AREA_FRONT_SWEEP_WHEEL = {
	{ 1, 1, 3, 1, 1 },
}

local AREADIAGONAL_FRONT_SWEEP_WHEEL = {
	{ 0, 0, 0, 0, 1 },
	{ 0, 0, 0, 1, 0 },
	{ 0, 0, 3, 0, 0 },
	{ 0, 1, 0, 0, 0 },
	{ 1, 0, 0, 0, 0 },
}

local function createFrontSweepCombat(area, diagonalArea)
	local sweepCombat = Combat()
	sweepCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
	sweepCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_HITAREA)
	sweepCombat:setParameter(COMBAT_PARAM_BLOCKARMOR, 1)
	sweepCombat:setParameter(COMBAT_PARAM_USECHARGES, 1)
	sweepCombat:setArea(createCombatArea(area, diagonalArea))
	return sweepCombat
end

local combat = createFrontSweepCombat(AREA_WAVE6, AREADIAGONAL_WAVE6)
local wheelCombat = createFrontSweepCombat(AREA_FRONT_SWEEP_WHEEL, AREADIAGONAL_FRONT_SWEEP_WHEEL)

local function calculateDamage(player, skill, attack)
	local damage = SPELL_BASE_POWER * (skill / 100) * (attack / 10) + player:calculateFlatDamageHealing()
	return -damage * 0.9, -damage * 1.1
end

function onGetFormulaValues(player, skill, attack, factor)
	return calculateDamage(player, skill, attack)
end

function onGetWheelFormulaValues(player, skill, attack, factor)
	return calculateDamage(player, skill, attack)
end

combat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValues")
wheelCombat:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetWheelFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature:getPlayer()
	if player and player:getWheelSpellAdditionalArea("Front Sweep") then
		return wheelCombat:execute(creature, var)
	end
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(59)
spell:name("Front Sweep")
spell:words("exori min")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_FRONT_SWEEP)
spell:level(70)
spell:mana(200)
spell:isPremium(true)
spell:needDirection(true)
spell:needWeapon(true)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)

spell:vocation("knight;true", "elite knight;true")
spell:register()
