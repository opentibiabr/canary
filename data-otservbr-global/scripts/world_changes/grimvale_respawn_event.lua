local grimvaleConfig = {
	position = { fromPosition = Position(33330, 31670, 7), toPosition = Position(33350, 31690, 7) },
	spawnDay = 13,
}

local function createRandomMonster(position, availableMonsters)
	local tile = Tile(position)
	if not tile or tile:getItemById(486) or tile:hasProperty(CONST_PROP_BLOCKSOLID) or tile:getTopCreature() then
		return false
	end

	local monsterName = availableMonsters[math.random(#availableMonsters)]
	local monster = Game.createMonster(monsterName, position)
	if monster then
		monster:setSpawnPosition()
		monster:remove()
	end
	return true
end

local function spawnMonsters(monstersToSpawn)
	for x = grimvaleConfig.position.fromPosition.x, grimvaleConfig.position.toPosition.x do
		for y = grimvaleConfig.position.fromPosition.y, grimvaleConfig.position.toPosition.y do
			if math.random(1000) >= 983 then
				if createRandomMonster(Position(x, y, 7), monstersToSpawn) then
					break
				end
			end
		end
	end
end

local grimvaleRespawnEvent = GlobalEvent("GrimvaleRespawnEvent")

function grimvaleRespawnEvent.onStartup()
	spawnMonsters(grimvaleConfig.spawnDay == tonumber(os.date("%d")) and { "wereboar", "werebadger" } or { "bandit", "badger", "blue butterfly", "yellow butterfly" })
	return true
end

grimvaleRespawnEvent:register()
