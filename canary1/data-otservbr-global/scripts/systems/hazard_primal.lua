local hazard = Hazard.new({
	name = "hazard.gnomprona-gardens",
	from = Position(33502, 32740, 13),
	to = Position(33796, 32996, 15),
	maxLevel = 12,

	crit = true,
	dodge = true,
	damageBoost = true,
	defenseBoost = true,
})

hazard:register()

-- Magma Bubble's fight is not affected by the hazard system
local hazardZone = Zone.getByName("hazard.gnomprona-gardens")
if not hazardZone then
	return
end
hazardZone:subtractArea({ x = 33633, y = 32915, z = 15 }, { x = 33649, y = 32928, z = 15 })
hazardZone:subtractArea({ x = 33630, y = 32887, z = 15 }, { x = 33672, y = 32921, z = 15 })

local primalPod = MoveEvent()

function primalPod.onStepIn(creature, item, position, fromPosition)
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

primalPod:id(ITEM_PRIMAL_POD)
primalPod:register()

local spawnFungosaurus = function(position)
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

-- Used by the primal menace
function createPrimalPod(position)
	local primalPod = Game.createItem(ITEM_PRIMAL_POD, 1, position)
	if primalPod then
		primalPod:setCustomAttribute("HazardSystem_PodTimer", os.time() * 1000)
		local podPos = primalPod:getPosition()
		addEvent(spawnFungosaurus, configManager.getNumber(configKeys.HAZARD_PODS_TIME_TO_SPAWN), podPos)
	end
end

local spawnEvent = ZoneEvent(hazardZone)
function spawnEvent.onSpawn(monster, position)
	monster:registerEvent("PrimalHazardDeath")
end
spawnEvent:register()

local deathEvent = CreatureEvent("PrimalHazardDeath")
function deathEvent.onDeath(creature)
	if not configManager.getBoolean(configKeys.TOGGLE_HAZARDSYSTEM) then
		return true
	end

	local monster = creature:getMonster()
	if not creature or not monster or not monster:hazard() or not hazard:isInZone(monster:getPosition()) then
		return true
	end
	-- don't spawn pods or plunder if the monster is a reward boss
	if monster:getType():isRewardBoss() then
		return true
	end

	local player, points = hazard:getHazardPlayerAndPoints(monster:getDamageMap())
	if points < 1 then
		return true
	end

	-- Pod
	local chanceTo = math.random(1, 10000)
	if chanceTo <= (points * configManager.getNumber(configKeys.HAZARD_PODS_DROP_MULTIPLIER)) then
		local closestFreePosition = player:getClosestFreePosition(monster:getPosition(), 4, true)
		createPrimalPod(closestFreePosition)
		return true
	end

	-- Plunder patriarch
	chanceTo = math.random(1, 100000)
	if chanceTo <= (points * configManager.getNumber(configKeys.HAZARD_SPAWN_PLUNDER_MULTIPLIER)) then
		local closestFreePosition = player:getClosestFreePosition(monster:getPosition(), 4, true)
		local monster = Game.createMonster("Plunder Patriarch", closestFreePosition.x == 0 and monster:getPosition() or closestFreePosition, false, true)
		if monster then
			monster:say("The Plunder Patriarch rises from the ashes.")
		end
		return true
	end
	return true
end

deathEvent:register()
