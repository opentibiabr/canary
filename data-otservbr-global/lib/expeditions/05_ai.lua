ExpeditionAI = ExpeditionAI or {}

local function syncAttackTarget(session, player, target)
	if not session or not player then
		return
	end
	local creatureId = 0
	if target then
		creatureId = target:getId()
	end
	if session.lastSyncedAttackCreatureId == creatureId then
		return
	end
	session.lastSyncedAttackCreatureId = creatureId
	ExpeditionProtocol.sendAttackTarget(player, creatureId)
end

-- Idle kick is skipped while exercise-training; INFIGHT blocks ping-timeout logout.
function ExpeditionAI.enablePersistence(player)
	if not player then
		return
	end
	if not player:isTraining() then
		player:setTraining(true)
	end
	local condition = Condition(CONDITION_INFIGHT)
	condition:setParameter(CONDITION_PARAM_TICKS, 60000)
	player:addCondition(condition)
end

local function nearestMonster(player, zone)
	if not player or not zone then
		return nil
	end
	local best, bestDist
	local ppos = player:getPosition()
	for _, monster in ipairs(zone:getMonsters()) do
		if monster and monster:getHealth() > 0 then
			local mpos = monster:getPosition()
			local dist = ppos:getDistance(mpos)
			if not bestDist or dist < bestDist then
				best = monster
				bestDist = dist
			end
		end
	end
	return best
end

local function lootNearby(player)
	if not player then
		return
	end
	local pos = player:getPosition()
	for dx = -1, 1 do
		for dy = -1, 1 do
			local tile = Tile(Position(pos.x + dx, pos.y + dy, pos.z))
			if tile then
				local items = tile:getItems()
				if items then
					for _, item in ipairs(items) do
						if item:isContainer() then
							local container = item
							for i = container:getSize() - 1, 0, -1 do
								local child = container:getItem(i)
								if child then
									child:moveTo(player)
								end
							end
						else
							local itemType = ItemType(item:getId())
							if itemType and itemType:isCorpse() then
								item:moveTo(player)
							end
						end
					end
				end
			end
		end
	end
end

function ExpeditionAI.tick(session)
	if not session or not session.playerId then
		return
	end
	local player = Player(session.playerId)
	if not player then
		return
	end

	ExpeditionAI.enablePersistence(player)

	if session.state == "waiting" or session.state == "idle" then
		player:setFollowCreature(nil)
		player:setTarget(nil)
		syncAttackTarget(session, player, nil)
		return
	end

	local zone = session.instance and session.instance.zone
	local tile = Tile(player:getPosition())
	if not tile or not tile:getGround() then
		player:setFollowCreature(nil)
		player:setTarget(nil)
		syncAttackTarget(session, player, nil)
		return
	end

	local target = nearestMonster(player, zone)
	if target then
		local current = player:getTarget()
		local stolen = current and current:getId() ~= target:getId()
		player:setTarget(target)
		-- If a client Attack briefly won the race before C++ deny, reassert AI target and
		-- force a fresh attackTarget sync so the client red square matches the server.
		if stolen then
			session.lastSyncedAttackCreatureId = nil
		end
		syncAttackTarget(session, player, target)
		local dist = player:getPosition():getDistance(target:getPosition())
		if dist <= 1 then
			player:setFollowCreature(nil)
		else
			local follow = player:getFollowCreature()
			if not follow or follow:getId() ~= target:getId() then
				-- setFollowCreature emits "There is no way." on failure; avoid re-spamming.
				player:setFollowCreature(target)
			end
		end
	else
		player:setFollowCreature(nil)
		player:setTarget(nil)
		syncAttackTarget(session, player, nil)
		lootNearby(player)
	end
end

function ExpeditionAI.onPlayerThink(player)
	if not player then
		return
	end
	local session = ExpeditionManager.getSessionByPlayer(player)
	if not session then
		return
	end
	-- Re-acquire target after Player::sendPing clears attack while disconnected.
	ExpeditionAI.tick(session)
end

function ExpeditionAI.start(session)
	if not session then
		return
	end
	if session.aiEvent then
		stopEvent(session.aiEvent)
	end
	ExpeditionAI.enablePersistence(Player(session.playerId))
	local key = session.key
	local function loop()
		local s = ExpeditionManager.getSessionByKey(key)
		if not s then
			return
		end
		ExpeditionAI.tick(s)
		s.aiEvent = addEvent(loop, ExpeditionConfig.AI_TICK_MS)
	end
	session.aiEvent = addEvent(loop, ExpeditionConfig.AI_TICK_MS)
end

function ExpeditionAI.stop(session)
	if not session then
		return
	end
	if session.aiEvent then
		stopEvent(session.aiEvent)
		session.aiEvent = nil
	end
	local player = Player(session.playerId)
	if player then
		player:setFollowCreature(nil)
		player:setTarget(nil)
		session.lastSyncedAttackCreatureId = nil
		ExpeditionProtocol.sendAttackTarget(player, 0)
		player:setTraining(false)
		player:removeCondition(CONDITION_INFIGHT)
	end
end
