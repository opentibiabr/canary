-- harmony gain (builder)

local AREA_WAVE = {
	{ 0, 0, 1, 0, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 3, 1, 1 },
	{ 0, 1, 0, 1, 0 },
}

local combatPhysical = Combat()
combatPhysical:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatPhysical:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_FLURRYOFBLOWS)
combatPhysical:setArea(createCombatArea(AREA_WAVE))

local combatEnergy = Combat()
combatEnergy:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatEnergy:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PINK_FLURRYOFBLOWS)
combatEnergy:setArea(createCombatArea(AREA_WAVE))

local combatEarth = Combat()
combatEarth:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatEarth:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_FLURRYOFBLOWS)
combatEarth:setArea(createCombatArea(AREA_WAVE))

function onGetFormulaValues(player, skill, weaponDamage, attackFactor)
	local basePower = 92
	local attackValue = calculateAttackValue(player, skill, weaponDamage)
	local spellFactor = 3
	local total = (basePower * attackValue) / 100 + (spellFactor * attackValue)
	return -total * 0.9, -total * 1.1
end

onGetFormulaValuesEnergy = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesEarth = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesPhysical = loadstring(string.dump(onGetFormulaValues))

combatPhysical:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesPhysical")
combatEnergy:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesEnergy")
combatEarth:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesEarth")

local combatTypes = {
	["physical"] = combatPhysical,
	["energy"] = combatEnergy,
	["earth"] = combatEarth,
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local combat = combatPhysical
	local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	if weapon then
		local itemType = weapon:getType()
		if itemType and itemType.getElementalBond then
			local elementalBondType = itemType:getElementalBond():lower()
			if elementalBondType then
				combat = combatTypes[elementalBondType] or combat
			end
		end
	end

	creature:addHarmony(1)

	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(289)
spell:name("Greater Flurry of Blows")
spell:words("exori gran mas pug")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_FLURRY_OF_BLOWS)
spell:level(90)
spell:mana(300)
spell:isPremium(true)
spell:blockWalls(true)
spell:needLearn(false)
spell:needDirection(true)
spell:cooldown(10 * 1000)
spell:groupCooldown(2 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
