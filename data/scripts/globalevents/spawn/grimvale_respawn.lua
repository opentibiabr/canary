local config = {
	position = {fromPosition = Position(33330, 31670, 7), toPosition = Position(33350, 31690, 7)}
}
local spawnDay = 13
local currentDay = os.date("%d")
local monsters = {}

function Game.createRandom(position)
	local tile = Tile(position)
	if not tile or Tile(position):getItemById(3139) then
		return false
	end

	local ground = tile:getGround()
	if not ground or ground:hasProperty(CONST_PROP_BLOCKSOLID) or tile:getTopCreature() then
		return false
	end
	local monsterName = monsters[math.random(#monsters)]
	local monster = Game.createMonster(monsterName, position)
	if monster then
		monster:setSpawnPosition()
		monster:remove()
	end
	return true
end

local grimvaleRespawn = GlobalEvent("grimvale respawn")
function grimvaleRespawn.onStartup()
	local contador = 1
	if spawnDay == tonumber(currentDay) then
		table.insert(monsters, 'wereboar')
		table.insert(monsters, 'werebadger')
		for x = config.position.fromPosition.x, config.position.toPosition.x do
			for y = config.position.fromPosition.y, config.position.toPosition.y do
				if math.random(1000) >= 983 then
					if Game.createRandom(Position(x, y, 7)) then
					end
				end
			end
		end
	else
		table.insert(monsters, 'bandit')
		table.insert(monsters, 'badger')
		table.insert(monsters, 'blue butterfly')
		table.insert(monsters, 'yellow butterfly')
		for x = config.position.fromPosition.x, config.position.toPosition.x do
			for y = config.position.fromPosition.y, config.position.toPosition.y do
				if math.random(1000) >= 983 then
					if Game.createRandom(Position(x, y, 7)) then
					end
				end
			end
		end
	end
	return true
end
grimvaleRespawn:register()
