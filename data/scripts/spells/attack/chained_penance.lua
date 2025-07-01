-- harmony gain (builder)

local creaturesArray = {}

local function creatureArrayListChain(startCreatureId, maxTargets)
	local currentCreature = Creature(startCreatureId)
	if not currentCreature then
		return false
	end

	creaturesArray = {}

	local visited = {}

	while #creaturesArray < maxTargets do
		local bestMonsterId = nil
		local bestPathLength = math.huge
		local bestHealthPercent = -1
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
							local candidateHealthPercent = (candidate:getHealth() / candidate:getMaxHealth()) * 100

							local isBetter = false
							if not bestMonsterId then
								isBetter = true
							elseif candidatePathLength < bestPathLength then
								isBetter = true
							elseif candidatePathLength == bestPathLength and candidateHealthPercent > bestHealthPercent then
								isBetter = true
							end

							if isBetter then
								bestMonsterId = candidateId
								bestPathLength = candidatePathLength
								bestHealthPercent = candidateHealthPercent
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

local function executeChain(player, min, max, effectData)
	if #creaturesArray == 0 then
		return false
	end

	local oldCreature = player
	for jump, targetId in ipairs(creaturesArray) do
		local newCreature = Creature(targetId)
		if newCreature then
			local targetPos = newCreature:getPosition()
			if not oldCreature:getPosition():isSightClear(targetPos) then
				break
			end
			local path = oldCreature:getPathTo(targetPos)
			if path and #path > 0 then
				local tempPos = Position(oldCreature:getPosition())
				for _, dir in ipairs(path) do
					tempPos:getNextPosition(dir, 1)
					tempPos:sendMagicEffect(effectData.effect)
				end
			end

			local damageMultiplier = 1.03 ^ jump
			local adjustedMin = math.floor(min * damageMultiplier + 0.5)
			local adjustedMax = math.floor(max * damageMultiplier + 0.5)
			doTargetCombatHealth(player, newCreature, effectData.combat, adjustedMin, adjustedMax, effectData.effect)
			oldCreature = newCreature
		else
			break
		end
	end

	creaturesArray = {}

	return true
end

local config = {
	["energy"] = { effect = CONST_ME_YELLOW_ENERGYSHOCK, combat = COMBAT_ENERGYDAMAGE },
	["earth"] = { effect = CONST_ME_GREEN_ENERGYSHOCK, combat = COMBAT_EARTHDAMAGE },
	["physical"] = { effect = CONST_ME_WHITE_ENERGYSHOCK, combat = COMBAT_PHYSICALDAMAGE },
}

local function onGetFormulaValues(player, weaponDamage)
	local basePower = 99

	--[[
	local helmetItem = player:getSlotItem(CONST_SLOT_HEAD)
	if helmetItem and helmetItem:getId() == 50274 then -- coned hat of enlightenment
		basePower = math.floor(basePower * 1.06) -- 6%
	end
	]]
	--

	local skill = player:getSkillLevel(SKILL_FIRST)
	local attackValue = calculateAttackValue(player, skill, weaponDamage)

	local spellFactor = 2.0
	local total = (basePower * attackValue) / 100 + (spellFactor * attackValue)

	local minDamage = -total * 0.9
	local maxDamage = -total * 1.1

	return minDamage, maxDamage
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local maxTargets = 4
	maxTargets = maxTargets + creature:getWheelSpellAdditionalTarget("Chained Penance") or 0

	local legsItem = creature:getSlotItem(CONST_SLOT_LEGS)
	if legsItem and legsItem:getId() == 50146 then -- Sanguine Trousers
		maxTargets = maxTargets + 1
	end

	--logger.warn("[SPELL CHAINED PENANCE] addTargetWheel {}", maxTargets)

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
		if itemType and itemType.getElementalBond then
			weaponDamage = itemType:getAttack()
			local elementalBondType = itemType:getElementalBond()
			if elementalBondType then
				effectData = config[elementalBondType]
			end
		end
	end

	local min, max = onGetFormulaValues(creature, weaponDamage)
	executeChain(creature, min, max, effectData)
	creature:addHarmony(1)
	return true
end

spell:group("attack")
spell:id(288)
spell:name("Chained Penance")
spell:words("exori med pug")
spell:level(70)
spell:mana(180)
spell:isPremium(true)
spell:blockWalls(true)
spell:needWeapon(false)
spell:castSound(SOUND_EFFECT_TYPE_SPELL_FLURRY_OF_BLOWS)
spell:groupCooldown(2 * 1000)
spell:cooldown(4 * 1000)
spell:needLearn(false)
spell:vocation("monk;true", "exalted monk;true")
spell:register()
