local SPELL_BASE_POWER = 75
local ECHO_DAMAGE_MULTIPLIER = 0.5
local ECHO_DELAY = 1000
local ELEMENTAL_STANCE_FIELDS = {
	"elementalStanceIntrinsicType",
	"elementalStanceResolvedType",
	"elementalStanceStateRevision",
	"elementalStanceSpellId",
	"elementalStanceDamageMultiplier",
	"elementalStanceCriticalChance",
	"elementalStanceCriticalDamage",
	"elementalStanceConverted",
}

local function copyElementalStanceContext(source, target)
	for _, field in ipairs(ELEMENTAL_STANCE_FIELDS) do
		target[field] = source[field]
	end
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DEATH_ECHO)
combat:setArea(createCombatArea(AREA_CIRCLE2X2))

local echoCombat = Combat()
echoCombat:setParameter(COMBAT_PARAM_TYPE, COMBAT_DEATHDAMAGE)
echoCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_DEATH_ECHO)
echoCombat:setParameter(COMBAT_PARAM_SUPPRESSCHARMS, true)
echoCombat:setParameter(COMBAT_PARAM_IGNORECASTERFLOOR, true)
echoCombat:setArea(createCombatArea(AREA_CIRCLE2X2))

local function calculateDamage(player, magicLevel, multiplier)
	local damage = player:calculateFlatDamageHealing() + (SPELL_BASE_POWER / 25 * magicLevel) + (SPELL_BASE_POWER / 4)
	return -damage * 0.9 * multiplier, -damage * 1.1 * multiplier
end

function onGetFormulaValues(player, level, magicLevel)
	return calculateDamage(player, magicLevel, 1)
end

function onGetEchoFormulaValues(player, level, magicLevel)
	return calculateDamage(player, magicLevel, ECHO_DAMAGE_MULTIPLIER)
end

combat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetFormulaValues")
echoCombat:setCallback(CALLBACK_PARAM_LEVELMAGICVALUE, "onGetEchoFormulaValues")

local function executeEcho(position, playerId, playerGuid, elementalStanceContext)
	local player = Player(playerId)
	if not player or player:getGuid() ~= playerGuid then
		return
	end

	local variant = {
		instantName = "Death Echo",
		runeName = "",
		type = VARIANT_POSITION,
		pos = position,
	}
	copyElementalStanceContext(elementalStanceContext, variant)
	echoCombat:execute(player, variant)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, variant)
	local player = creature and creature:getPlayer() or nil
	if not player then
		return false
	end

	local position = Variant.getPosition(variant)
	if not combat:execute(player, variant) then
		return false
	end

	local elementalStanceContext = {}
	copyElementalStanceContext(variant, elementalStanceContext)
	addEvent(executeEcho, ECHO_DELAY, position, player:getId(), player:getGuid(), elementalStanceContext)
	return true
end

spell:group("attack")
spell:id(310)
spell:name("Death Echo")
spell:element(COMBAT_DEATHDAMAGE)
spell:words("exevo mort ora")
spell:level(120)
spell:mana(150)
spell:isAggressive(true)
spell:isPremium(true)
spell:range(7)
spell:optionalTarget(true)
spell:blockWalls(true)
spell:cooldown(6 * 1000)
spell:groupCooldown(2 * 1000)
spell:vocation("sorcerer;true", "master sorcerer;true")
spell:register()
