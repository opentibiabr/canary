local SPELL_BASE_POWER = 140

local AREA_STRONG_ICE_WAVE = {
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 1, 1, 1 },
	{ 0, 3, 0 },
}

local function createStrongIceWaveCombat(area)
	local initCombat = Combat()
	initCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ICEDAMAGE)
	initCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ICEAREA)
	initCombat:setArea(createCombatArea(area))
	return initCombat
end

local combat = createStrongIceWaveCombat(AREA_STRONG_ICE_WAVE)
local enlargedCombat = createStrongIceWaveCombat(AREA_WAVE7)

local function calculateDamage(player, maglevel)
	local damage = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * maglevel) + (SPELL_BASE_POWER / 4)
	return -(damage * 0.9), -(damage * 1.1)
end

function onGetFormulaValues(player, level, maglevel)
	return calculateDamage(player, maglevel)
end

function onGetEnlargedFormulaValues(player, level, maglevel)
	return calculateDamage(player, maglevel)
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
enlargedCombat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetEnlargedFormulaValues")

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local player = creature:getPlayer()
	if player and player:getWheelSpellAdditionalArea("Strong Ice Wave") then
		return enlargedCombat:execute(creature, var)
	end
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(43)
spell:name("Strong Ice Wave")
spell:words("exevo gran frigo hur")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_STRONG_ICE_WAVE)
spell:level(40)
spell:mana(170)
spell:needDirection(true)
spell:cooldown(4 * 1000)
spell:groupCooldown(2 * 1000)

spell:vocation("druid;true", "elder druid;true")
spell:register()
