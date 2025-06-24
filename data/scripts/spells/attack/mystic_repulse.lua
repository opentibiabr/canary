-- harmony gain (builder)

local combatPhysical = Combat()
combatPhysical:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatPhysical:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_ENERGYPULSE)

local combatEnergy = Combat()
combatEnergy:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatEnergy:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PINK_ENERGYPULSE)

local combatEarth = Combat()
combatEarth:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatEarth:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_ENERGYPULSE)

function onGetFormulaValues(player, skill, weaponDamage, attackFactor)
	local basePower = 72
	local attackValue = calculateAttackValue(player, skill, weaponDamage)
	local spellFactor = 0.7
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
spell:id(290)
spell:name("Mystic Repulse")
spell:words("exori amp pug")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_MYSTIC_REPULSE)
spell:level(30)
spell:mana(150)
spell:isPremium(true)
spell:range(7)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(false)
spell:cooldown(14 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
