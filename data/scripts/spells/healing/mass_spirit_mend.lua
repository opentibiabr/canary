local function targetFunction(creature, target)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local min = math.floor(((player:getLevel() / 5) + (player:getMagicLevel() * 5.7) + 26))
	local max = math.floor(((player:getLevel() / 5) + (player:getMagicLevel() * 10.43) + 62))

	local harmony = player:getHarmony()
	local multiplier = 1 + (harmony * 0.6)
	local healAmount = math.floor(math.random(min, max) * multiplier)

	local bonusFactor = 1

	healAmount = math.ceil(healAmount * bonusFactor)

	local excludeCreature = "specific_creature_name"

	local bosses = {
		"ravenous hunger",
		"dorokoll the mystic",
		"eshtaba the conjurer",
		"eliz the unyielding",
		"mezlon the defiler",
		"malkhar deathbringer",
		"azaram's soul",
		"containment crystal",
		"rift fragment",
	}
	local damageMechanicCreatures = {
		"leiden",
	}

	if target:isPlayer() and target:getName():lower() ~= excludeCreature then
		target:addHealth(healAmount)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	elseif target:isMonster() and table.contains(damageMechanicCreatures, target:getName():lower()) and target:getName():lower() ~= excludeCreature then
		target:addHealth(healAmount)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	elseif target:isMonster() and table.contains(bosses, target:getName():lower()) and target:getName():lower() ~= excludeCreature then
		target:addHealth(healAmount)
		target:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	end
end

function onTargetCreature(creature, target)
	targetFunction(creature, target)
	return true
end

local combat = Combat()
combat:setCallback(CALLBACK_PARAM_TARGETCREATURE, "onTargetCreature")
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_MAGIC_BLUE)
combat:setParameter(COMBAT_PARAM_AGGRESSIVE, 0)
combat:setParameter(COMBAT_PARAM_DISPEL, CONDITION_PARALYZE)
combat:setArea(createCombatArea(AREA_CIRCLE3X4))

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	return combat:execute(creature, var)
end

spell:name("Mass Spirit Mend")
spell:words("exura mas nia")
spell:group("healing")
spell:vocation("monk;true", "exalted monk;true")
spell:id(296)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:level(150)
spell:mana(250)
spell:harmony(true)
spell:isPremium(true)
spell:isAggressive(false)
spell:needLearn(false)
spell:castSound(SOUND_EFFECT_TYPE_SPELL_MASS_SPIRIT_MEND)
spell:register()
