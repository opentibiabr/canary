local function setStorage()
	local upConer = { x = 32192, y = 31311, z = 14 } -- upLeftCorner
	local downConer = { x = 32225, y = 31343, z = 14 } -- downRightCorner
	for i = upConer.x, downConer.x do
		for j = upConer.y, downConer.y do
			for k = upConer.z, downConer.z do
				local room = { x = i, y = j, z = k }
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, creature in pairs(creatures) do
							local player = Player(creature)
							if player then
								if player:getStorageValue(14322) < 1 then
									player:setStorageValue(14322, 1) -- Access to boss Anomaly
								end
							end
						end
					end
				end
			end
		end
	end
end

local depolarizedDeath = CreatureEvent("DepolarizedDeath")
function depolarizedDeath.onDeath(creature)
	Game.setStorageValue(14323, Game.getStorageValue(14323) + 1)
	if Game.getStorageValue(14323) == 10 then
		setStorage()
		creature:say("You have reached enough charges to pass further into the destruction!", TALKTYPE_MONSTER_YELL, isInGhostMode, pid, { x = 32209, y = 31326, z = 14 })
		Game.setStorageValue(14323, -1)
	end
	return true
end

depolarizedDeath:register()
