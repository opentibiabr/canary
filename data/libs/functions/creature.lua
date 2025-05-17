function Creature.getClosestFreePosition(self, position, maxRadius, mustBeReachable)
	maxRadius = maxRadius or 1

	-- backward compatability (extended)
	if maxRadius == true then
		maxRadius = 2
	end

	local checkPosition = Position(position)
	local closestDistance = -1
	local closestPosition = Position()
	for radius = 0, maxRadius do
		checkPosition.x = checkPosition.x - math.min(1, radius)
		checkPosition.y = checkPosition.y + math.min(1, radius)
		if closestDistance ~= -1 then
			return closestPosition
		end

		local total = math.max(1, radius * 8)
		for i = 1, total do
			if radius > 0 then
				local direction = math.floor((i - 1) / (radius * 2))
				checkPosition:getNextPosition(direction)
			end

			local tile = Tile(checkPosition)
			if tile and tile:getCreatureCount() == 0 and not tile:hasProperty(CONST_PROP_IMMOVABLEBLOCKSOLID) and (not mustBeReachable or self:getPathTo(checkPosition)) then
				local distance = self:getPosition():getDistance(checkPosition)
				if closestDistance == -1 or closestDistance > distance then
					closestDistance = distance
					closestPosition = Position(checkPosition)
				end
			end
		end
	end
	return closestPosition
end

function Creature.getMonster(self)
	return self:isMonster() and self or nil
end

function Creature.getPlayer(self)
	return self:isPlayer() and self or nil
end

function Creature.isContainer(self)
	return false
end

function Creature.isItem(self)
	return false
end

function Creature.isMonster(self)
	return false
end

function Creature.isNpc(self)
	return false
end

function Creature.isPlayer(self)
	return false
end

function Creature.isTeleport(self)
	return false
end

function Creature.isTile(self)
	return false
end

function Creature:setMonsterOutfit(monster, time)
	local monsterType = MonsterType(monster)
	if not monsterType then
		return false
	end

	local condition = Condition(CONDITION_OUTFIT)
	condition:setOutfit(monsterType:getOutfit())
	condition:setTicks(time)
	self:addCondition(condition)

	return true
end

function Creature:setItemOutfit(item, time)
	local itemType = ItemType(item)
	if not itemType then
		return false
	end

	local condition = Condition(CONDITION_OUTFIT)
	condition:setOutfit({
		lookTypeEx = itemType:getId(),
	})
	condition:setTicks(time)
	self:addCondition(condition)

	return true
end

function Creature:setSummon(monster)
	local summon = Monster(monster)
	if not summon then
		return false
	end

	summon:setMaster(self, true)
	summon:setTarget(self.attackedCreature)
	return true
end

function Creature:removeSummon(monster)
	local summon = Monster(monster)
	if not summon or summon:getMaster() ~= self then
		return false
	end

	summon:setTarget(nil)
	summon:setFollowCreature(nil)
	summon:setDropLoot(true)
	summon:setSkillLoss(true)
	summon:setMaster(nil)

	return true
end

function Creature:addDamageCondition(target, type, list, damage, period, rounds)
	if damage <= 0 or not target or target:isImmune(type) then
		return false
	end

	local condition = Condition(type)
	condition:setParameter(CONDITION_PARAM_OWNER, self:getId())
	condition:setParameter(CONDITION_PARAM_DELAYED, true)

	if list == DAMAGELIST_EXPONENTIAL_DAMAGE then
		local exponent, value = -10, 0
		while value < damage do
			value = math.floor(10 * math.pow(1.2, exponent) + 0.5)
			condition:addDamage(1, period or 4000, -value)

			if value >= damage then
				local permille = math.random(10, 1200) / 1000
				condition:addDamage(1, period or 4000, -math.max(1, math.floor(value * permille + 0.5)))
			else
				exponent = exponent + 1
			end
		end
	elseif list == DAMAGELIST_LOGARITHMIC_DAMAGE then
		local n, value = 0, damage
		while value > 0 do
			value = math.floor(damage * math.pow(2.718281828459, -0.05 * n) + 0.5)
			if value ~= 0 then
				condition:addDamage(1, period or 4000, -value)
				n = n + 1
			end
		end
	elseif list == DAMAGELIST_VARYING_PERIOD then
		for _ = 1, rounds do
			condition:addDamage(1, math.random(period[1], period[2]) * 1000, -damage)
		end
	elseif list == DAMAGELIST_CONSTANT_PERIOD then
		condition:addDamage(rounds, period * 1000, -damage)
	end

	target:addCondition(condition)
	return true
end

function Creature.checkCreatureInsideDoor(player, toPosition)
	local tile = Tile(toPosition)

	if not tile then
		player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
		return true
	end

	local creature = tile:getTopCreature()
	if creature then
		toPosition.x = toPosition.x + 1
		local query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))

		if query ~= RETURNVALUE_NOERROR then
			toPosition.x = toPosition.x - 1
			toPosition.y = toPosition.y + 1
			query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
		end

		if query ~= RETURNVALUE_NOERROR then
			toPosition.y = toPosition.y - 2
			query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
		end

		if query ~= RETURNVALUE_NOERROR then
			toPosition.x = toPosition.x - 1
			toPosition.y = toPosition.y + 1
			query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
		end

		if query ~= RETURNVALUE_NOERROR then
			player:sendCancelMessage(RETURNVALUE_NOTPOSSIBLE)
			return true
		end

		creature:teleportTo(toPosition, true)
	end
end

function Creature:canAccessPz()
	if self:isMonster() or (self:isPlayer() and self:isPzLocked()) then
		return false
	end
	return true
end

function Creature.getKillers(self, onlyPlayers)
	local killers = {}
	local inFightTicks = configManager.getNumber(configKeys.PZ_LOCKED)
	local timeNow = systemTime()
	local getCreature = onlyPlayers and Player or Creature
	for cid, cb in pairs(self:getDamageMap()) do
		local creature = getCreature(cid)
		if creature and creature ~= self and (timeNow - cb.ticks) <= inFightTicks then
			killers[#killers + 1] = {
				creature = creature,
				damage = cb.total,
			}
		end
	end

	table.sort(killers, function(a, b)
		return a.damage > b.damage
	end)
	for i, killer in pairs(killers) do
		killers[i] = killer.creature
	end
	return killers
end

function Creature:addEventStamina(target)
	local player = self:getPlayer()
	local monster = target:getMonster()
	if player and monster and monster:getName() == staminaBonus.target then
		local playerId = player:getId()
		if not staminaBonus.eventsTrainer[playerId] then
			staminaBonus.eventsTrainer[playerId] = addEvent(addStamina, staminaBonus.period, playerId)
		end
	end
end
