local hazardSystemStepPod = MoveEvent()

function hazardSystemStepPod.onStepIn(creature, item, position, fromPosition)
	if not configManager.getBoolean(configKeys.TOGGLE_HAZARDSYSTEM) then
		item:remove()
		return
	end

	local player = creature:getPlayer()
	if not player then
		return
	end

	local timer = item:getCustomAttribute("HazardSystem_PodTimer")
	if timer then
		local timeMs = os.time() * 1000
		timer = timeMs - timer
		if timer >= configManager.getNumber(configKeys.HAZARD_PODS_TIME_TO_DAMAGE) and timer < configManager.getNumber(configKeys.HAZARD_PODS_TIME_TO_SPAWN) then
			player:sendCancelMessage("You stepped too late on the primal pod and it explodes.")
			player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
			local damage = math.ceil((player:getMaxHealth() * configManager.getNumber(configKeys.HAZARD_PODS_DAMAGE)) / 100)
			local points = player:getHazardSystemPoints()
			if points ~= 0 then
				damage = math.ceil((damage * (100 + points)) / 100)
			end
			damage = damage + 500
			doTargetCombatHealth(0, player, COMBAT_LIFEDRAIN, -damage, -damage, CONST_ME_DRAWBLOOD)
		end
	end

	item:remove()
	return true
end

hazardSystemStepPod:id(ITEM_PRIMAL_POD)
hazardSystemStepPod:register()

local SpawnHazardSystemFungosaurus = function(position)
	local tile = Tile(position)
	if tile then
		local podItem = tile:getItemById(ITEM_PRIMAL_POD)
		if podItem then
			local monster = Game.createMonster("Fungosaurus", position, false, true)
			if monster then
				monster:say("The primal pod explode and wild emerges from it.")
			end
			podItem:remove()
		end
	end
end

local hazardSystemSpawnPod = CreatureEvent("HazardSystemCombat")

function hazardSystemSpawnPod.onKill(player, creature, lastHit)
	if not configManager.getBoolean(configKeys.TOGGLE_HAZARDSYSTEM) then
		return true
	end

	local monster = creature:getMonster()
	if not creature or not monster or not monster:isOnHazardSystem() then
		return true
	end

	local points = player:getHazardSystemPoints()
	if points > 0 then
		local party = player:getParty()
		if party then
			for _, member in ipairs(party:getMembers()) do
				if member and member:getHazardSystemPoints() < points then
					points = member:getHazardSystemPoints()
				end
			end

			local leader = party:getLeader()
			if leader and leader:getHazardSystemPoints() < points then
				points = leader:getHazardSystemPoints()
			end
		end
	end

	if points == 0 then
		return true
	end

	local chanceTo = math.random(1, 10000)
	if chanceTo <= (points * configManager.getNumber(configKeys.HAZARD_PODS_DROP_MULTIPLIER)) then
		local closesestPosition = player:getClosestFreePosition(monster:getPosition(), 4, true)
		local primalPod = Game.createItem(ITEM_PRIMAL_POD, 1, closesestPosition.x == 0 and monster:getPosition() or closesestPosition)
		if primalPod then
			primalPod:setCustomAttribute("HazardSystem_PodTimer", os.time() * 1000)
			local podPos = primalPod:getPosition()
			addEvent(SpawnHazardSystemFungosaurus, configManager.getNumber(configKeys.HAZARD_PODS_TIME_TO_SPAWN), podPos)
		end
		return true
	end

	chanceTo = math.random(1, 10000)
	if chanceTo <= (points * configManager.getNumber(configKeys.HAZARDSYSTEM_SPAWN_PLUNDER_MULTIPLIER)) then
		local closesestPosition = player:getClosestFreePosition(monster:getPosition(), 4, true)
		local monster = Game.createMonster("Plunder Patriarch", closesestPosition.x == 0 and monster:getPosition() or closesestPosition, false, true)
		if monster then
			monster:say("The Plunder Patriarch rises from the ashes.")
		end
		return true
	end

	return true
end

hazardSystemSpawnPod:register()
