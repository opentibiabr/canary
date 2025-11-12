-- harmony loses (spender)

local AREA_WAVE_1 = {
	{ 0, 1, 1, 1, 0 },
	{ 1, 1, 1, 1, 1 },
	{ 1, 0, 0, 0, 1 },
	{ 1, 0, 2, 0, 1 },
	{ 1, 0, 0, 0, 1 },
}

local combatPhysical1 = Combat()
combatPhysical1:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatPhysical1:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_EXPLOSIONHIT)
combatPhysical1:setArea(createCombatArea(AREA_WAVE_1))

local combatEnergy1 = Combat()
combatEnergy1:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatEnergy1:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PINK_EXPLOSIONHIT)
combatEnergy1:setArea(createCombatArea(AREA_WAVE_1))

local combatEarth1 = Combat()
combatEarth1:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatEarth1:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_EXPLOSIONHIT)
combatEarth1:setArea(createCombatArea(AREA_WAVE_1))

local AREA_WAVE_2 = {
	{ 1, 1, 1 },
	{ 1, 3, 1 },
	{ 1, 0, 1 },
}

local combatPhysical2 = Combat()
combatPhysical2:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatPhysical2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_EXPLOSIONHIT)
combatPhysical2:setArea(createCombatArea(AREA_WAVE_2))

local combatEnergy2 = Combat()
combatEnergy2:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatEnergy2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PINK_EXPLOSIONHIT)
combatEnergy2:setArea(createCombatArea(AREA_WAVE_2))

local combatEarth2 = Combat()
combatEarth2:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatEarth2:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_EXPLOSIONHIT)
combatEarth2:setArea(createCombatArea(AREA_WAVE_2))

function onGetFormulaValues(player, skill, weaponDamage, attackFactor)
	local basePower = 48
	local attackValue = calculateAttackValue(player, skill, weaponDamage)
	local spellFactor = 1.0
	local total = (basePower * attackValue) / 100 + (spellFactor * attackValue)
	return -total * 0.9, -total * 1.1
end

onGetFormulaValuesPhysical1 = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesEnergy1 = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesEarth1 = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesPhysical2 = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesEnergy2 = loadstring(string.dump(onGetFormulaValues))
onGetFormulaValuesEarth2 = loadstring(string.dump(onGetFormulaValues))

combatPhysical1:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesPhysical1")
combatEnergy1:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesEnergy1")
combatEarth1:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesEarth1")
combatPhysical2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesPhysical2")
combatEnergy2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesEnergy2")
combatEarth2:setCallback(CALLBACK_PARAM_SKILLVALUE, "onGetFormulaValuesEarth2")

local combatTypes1 = {
	["physical"] = combatPhysical1,
	["energy"] = combatEnergy1,
	["earth"] = combatEarth1,
}

local combatTypes2 = {
	["physical"] = combatPhysical2,
	["energy"] = combatEnergy2,
	["earth"] = combatEarth2,
}

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local combat1 = combatPhysical1
	local combat2 = combatPhysical2
	local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	if weapon then
		local itemType = weapon:getType()
		if itemType and itemType.getElementalBond then
			local elementalBondType = itemType:getElementalBond():lower()
			if elementalBondType then
				combat1 = combatTypes1[elementalBondType] or combat1
				combat2 = combatTypes2[elementalBondType] or combat2
			end
		end
	end

	combat1:execute(creature, var)
	combat2:execute(creature, var)

	return true
end

spell:group("attack")
spell:id(294)
spell:name("Sweeping Takedown")
spell:words("exori mas nia")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_SWEEPING_TAKEDOWN)
spell:level(60)
spell:mana(195)
spell:isPremium(true)
spell:blockWalls(true)
spell:needLearn(false)
spell:needDirection(true)
spell:harmony(true)
spell:groupCooldown(2 * 1000)
spell:cooldown(8 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
