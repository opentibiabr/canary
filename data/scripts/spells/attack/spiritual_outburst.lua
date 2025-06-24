-- harmony loses (spender)

local creaturesArray = {}

local function creatureArrayListChain(startCreature, maxTargets)
	local currentCreature = Creature(startCreature)
	if not currentCreature then
		return false
	end

	creaturesArray = {}

	local visited = {}

	while #creaturesArray < maxTargets do
		local bestMonsterId = nil
		local bestPathLength = math.huge
		local range = 2

		local spectators = Game.getSpectators(currentCreature:getPosition(), false, false, range, range, range, range)
		for _, candidate in ipairs(spectators) do
			if candidate then
				if candidate:isMonster() and not candidate:getMaster() then
					local candidateId = candidate:getId()
					if not visited[candidateId] then
						local path = currentCreature:getPathTo(candidate:getPosition())
						if path then
							local candidatePathLength = #path

							local isBetter = false
							if not bestMonsterId then
								isBetter = true
							elseif candidatePathLength < bestPathLength then
								isBetter = true
							end

							if isBetter then
								bestMonsterId = candidateId
								bestPathLength = candidatePathLength
							end
						end
					end
				end
			end
		end

		if bestMonsterId then
			local nextCreature = Creature(bestMonsterId)
			if nextCreature then
				table.insert(creaturesArray, bestMonsterId)
				visited[bestMonsterId] = true
				currentCreature = nextCreature
			else
				break
			end
		else
			break
		end
	end

	return #creaturesArray > 0
end

local function executeChain(player, min, max, effectData, grade)
	if #creaturesArray == 0 then
		return false
	end

	local oldCreature = player
	for _, targetId in ipairs(creaturesArray) do
		local newCreature = Creature(targetId)
		if newCreature then
			local path = oldCreature:getPathTo(newCreature:getPosition())
			if path and #path > 0 then
				local tempPos = Position(oldCreature:getPosition())
				for _, dir in ipairs(path) do
					tempPos:getNextPosition(dir)
					tempPos:sendMagicEffect(effectData.effect)
				end
			end

			local damageMultiplier = 1.0
			if grade == 1 then
				damageMultiplier = 0.375
			elseif grade == 2 then
				damageMultiplier = 0.5
			elseif grade == 3 then
				damageMultiplier = 0.625
			end

			local adjustedMin = math.floor(min * damageMultiplier + 0.5)
			local adjustedMax = math.floor(max * damageMultiplier + 0.5)
			doTargetCombatHealth(player, newCreature, effectData.combat, -adjustedMax, -adjustedMin, effectData.effect)
			oldCreature = newCreature
		end
	end
end

local config = {
	["energy"] = { effect = CONST_ME_YELLOW_ENERGYSHOCK, combat = COMBAT_ENERGYDAMAGE },
	["earth"] = { effect = CONST_ME_GREEN_ENERGYSHOCK, combat = COMBAT_EARTHDAMAGE },
	["physical"] = { effect = CONST_ME_WHITE_ENERGYSHOCK, combat = COMBAT_PHYSICALDAMAGE },
}

local function onGetFormulaValues(player, weaponDamage)
	local basePower = 42

	local skill = player:getSkillLevel(SKILL_FIRST)
	local attackValue = calculateAttackValue(player, skill, weaponDamage)

	local spellFactor = 2.5
	local total = (basePower * attackValue) / 100 + (spellFactor * attackValue)

	local minDamage = -total * 0.9
	local maxDamage = -total * 1.1

	return minDamage, maxDamage
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local grade = creature:revelationStageWOD("Spiritual Outburst")
	if grade == 0 then
		creature:sendCancelMessage("You cannot cast this spell")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	--logger.warn("[SPELL SPIRITUAL OUTBURST] addTargetWheel {}", maxTargets)

	local maxTargets = 4

	creatureArrayListChain(creature:getId(), maxTargets)

	if #creaturesArray == 0 then
		creature:sendCancelMessage("There are no ranged monsters.")
		creature:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local effectData = config["physical"]
	local weaponDamage = 0

	local weapon = creature:getSlotItem(CONST_SLOT_LEFT)
	if weapon then
		local itemType = weapon:getType()
		weaponDamage = itemType:getAttack()
		if itemType and itemType.getElementalBond then
			local elementalBondType = itemType:getElementalBond():lower()
			if elementalBondType then
				effectData = config[elementalBondType]
			end
		end
	end

	local min, max = onGetFormulaValues(creature, weaponDamage)
	executeChain(creature, min, max, effectData, 0)

	if creature:getHarmony() == 5 then
		addEvent(function()
			creatureArrayListChain(creature, maxTargets)
			if #creaturesArray > 0 then
				local min, max = onGetFormulaValues(creature, weaponDamage)
				executeChain(creature, min, max, effectData, grade)
			end
		end, 1500)
	end
	local cooldownByGrade = { 24, 20, 16 }
	local cooldown = cooldownByGrade[grade]

	local condition = Condition(CONDITION_SPELLCOOLDOWN, CONDITIONID_DEFAULT, 295)
	condition:setTicks((cooldown * 1000) / configManager.getFloat(configKeys.RATE_SPELL_COOLDOWN))
	creature:addCondition(condition)

	return true
end

spell:group("attack")
spell:id(295)
spell:name("Spiritual Outburst")
spell:words("exori gran mas nia")
spell:level(300)
spell:mana(425)
spell:harmony(true)
spell:isPremium(true)
spell:needLearn(false)
spell:groupCooldown(2 * 1000)
spell:cooldown(60 * 1000)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
