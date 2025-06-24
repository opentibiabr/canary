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
	local basePower = 62
	local attackValue = calculateAttackValue(player, skill, weaponDamage)
	local spellFactor = 1.0
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

	--[[
	local success = combat:execute(creature, var)

	local infoParty = {
		playerGuid = 0,
		lifePercent = 100,
	}

	local party = player:getParty()
	if party then
		for _, member in ipairs(party:getMembers()) do
			local percentageHealth = (member:getHealth() * 100) / member:getMaxHealth()
			logger.info("[TESTE] O membro da party {} tem {}% de life", member:getName(), percentageHealth)
			if percentageHealth < infoParty.lifePercent then
				logger.info("[TESTE] a porcentagem de {}% do jogador {} foi salva como a menor da party por enquanto", percentageHealth, member:getName())
				infoParty.playerGuid = member:getGuid()
			end
		end

		if infoParty.playerGuid ~= 0 then
			local memberParty = Player(infoParty.playerGuid)
			if memberParty then
				local lifeAdd = infoParty.lifePercent * (memberParty:getMaxHealth() / 100)
				--memberParty:addHealth(lifeAdd)
				logger.info("[TESTE] O jogador {} teve a menor porcentagem de {}% da party", memberParty:getName(), percentageHealth)
			end
		end
	end

	return success
	]]
	--
end

spell:group("attack")
spell:id(293)
spell:name("Devastating Knockout")
spell:words("exori gran nia")
spell:castSound(SOUND_EFFECT_TYPE_SPELL_DEVASTATING_KNOCKOUT)
spell:level(125)
spell:mana(210)
spell:range(1)
spell:harmony(true)
spell:isPremium(true)
spell:needTarget(true)
spell:blockWalls(true)
spell:needWeapon(false)
spell:cooldown(24 * 1000)
spell:groupCooldown(2 * 1000)
spell:needLearn(false)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
