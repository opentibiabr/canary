local SPELL_BASE_POWER = 110
local CHAIN_ADDITIONAL_TARGETS = 2
local CHAIN_DISTANCE = 4

local function calculateDamage(player, maglevel)
	local damage = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * maglevel) + (SPELL_BASE_POWER / 4)
	return -(damage * 0.9), -(damage * 1.1)
end

function onGetFormulaValues(player, level, maglevel)
	return calculateDamage(player, maglevel)
end

function onGetChainFormulaValues(player, level, maglevel)
	return calculateDamage(player, maglevel)
end

function canLightningChain(creature, target)
	return not target:isNpc() and creature ~= target and not target:getTile():hasFlag(TILESTATE_PROTECTIONZONE)
end

function getLightningChainValues(creature)
	return CHAIN_ADDITIONAL_TARGETS, CHAIN_DISTANCE, false
end

local function createLightningCombat(chain)
	local lightningCombat = Combat()
	lightningCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
	lightningCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_ENERGYAREA)
	lightningCombat:setParameter(COMBAT_PARAM_DISTANCEEFFECT, CONST_ANI_ENERGY)
	lightningCombat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, chain and "onGetChainFormulaValues" or "onGetFormulaValues")

	if chain then
		lightningCombat:setParameter(COMBAT_PARAM_CHAIN_EFFECT, CONST_ME_PINK_ENERGY_SPARK)
		lightningCombat:setCallback(CALLBACK_PARAM_CHAINPICKER, "canLightningChain")
		lightningCombat:setCallback(CALLBACK_PARAM_CHAINVALUE, "getLightningChainValues")
	end

	return lightningCombat
end

local combat = createLightningCombat(false)
local chainCombat = createLightningCombat(true)

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	if var:getNumber() ~= 0 then
		return chainCombat:execute(creature, var)
	end

	return combat:execute(creature, var)
end

spell:group("attack", "special")
spell:id(149)
spell:name("Lightning")
spell:element(COMBAT_ENERGYDAMAGE)
spell:words("exori amp vis")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_LIGHTNING)
spell:level(55)
spell:mana(60)
spell:isPremium(true)
spell:range(7)
spell:needCasterTargetOrDirection(true)
spell:blockWalls(true)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000, 8 * 1000)

spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
