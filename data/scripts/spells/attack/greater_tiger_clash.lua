-- harmony loses (spender)

local combatPhysical = Combat()
combatPhysical:setParameter(COMBAT_PARAM_TYPE, COMBAT_PHYSICALDAMAGE)
combatPhysical:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_WHITE_TIGERCLASH)

local combatEnergy = Combat()
combatEnergy:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combatEnergy:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PINK_TIGERCLASH)

local combatEarth = Combat()
combatEarth:setParameter(COMBAT_PARAM_TYPE, COMBAT_EARTHDAMAGE)
combatEarth:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREEN_TIGERCLASH)

function onGetFormulaValues(player, skill, weaponDamage, attackFactor)
	local basePower = 44
	local attackValue = calculateAttackValue(player, skill, weaponDamage)
	local spellFactor = 0.9
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
		if itemType then
			local elementalBondType = itemType:getElementalBond()
			if elementalBondType then
				combat = combatTypes[elementalBondType] or combat
			end
		end
	end
	return combat:execute(creature, var)
end

spell:group("attack")
spell:id(292)
spell:name("Greater Tiger Clash")
spell:words("exori nia")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_GREATER_TIGER_CLASH)
spell:level(18)
spell:mana(50)
spell:range(1)
spell:harmony(true)
spell:isPremium(true)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(false)
spell:needLearn(false)
spell:cooldown(8 * 1000)
spell:groupCooldown(2 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
