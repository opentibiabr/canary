local config = {
	position = {fromPosition = Position(33415, 31522, 11), toPosition = Position(33445, 31554, 11)}
}

local spawnByDay = true
local spawnDay = 13
local currentDay = os.date("%d")
local waitPosition = Position(33442, 31559, 10)
local oldpos = {}
local function teleport(player, pos)
	if player:getName() ~= nil then
		player:teleportTo(pos)
	end
end

local function loadMap()
	Game.loadMap('data/world/feroxa/final.otbm')
end

local function removeFeroxa(feroxa)
	if not feroxa then
		return true
	end
	feroxa = Game.createMonster('Feroxa', Position(33380, 31537, 11), true, true)
	addEvent(removeFeroxa, 5 * 60 * 1000, feroxa:getId())
end

local function final()
	local specs, spec = Game.getSpectators(Position(33430, 31537, 11), false, false, 18, 18, 18, 18)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			spec:teleportTo(Position(33419, 31539, 10))
		end
	end
	local teleport = Tile(Position(33430, 31537, 11)):getItemById(1387)
	if teleport and teleport:isTeleport() then
		teleport:transform(25417)
		teleport:setDestination(Position(33419, 31539, 10))
		teleport:setActionId(12450)
	end
	if spec then
		spec:say('You are the contenders. This is your only chance to break the Curse of The Full Moon. Make it count!', TALKTYPE_MONSTER_SAY, false, nil, Position(33419, 31539, 10))
	end
	local feroxa = Game.createMonster('Feroxa', Position(33380, 31537, 11), true, true)
	addEvent(removeFeroxa, 5 * 60 * 1000, feroxa:getId())
end

local function removeItems()
	for x = config.position.fromPosition.x, config.position.toPosition.x do
		for y = config.position.fromPosition.y, config.position.toPosition.y do
			for z = config.position.fromPosition.z, config.position.toPosition.z do
				local tile = Tile(Position(x, y, z))
				if not tile then
					break
				end
				local items = tile:getItems()
				if items then
					for i = 1, #items do
						items[i]:remove()
					end
				end
				local ground = tile:getGround()
				if ground then
					ground:remove()
				end
			end
		end
	end
end

local function spectators()
	local specs, spec = Game.getSpectators(Position(33430, 31537, 11), false, false, 18, 18, 18, 18)
	for i = 1, #specs do
		spec = specs[i]
		if spec:isPlayer() then
			oldpos = spec:getPosition()
		end
		addEvent(teleport, 1, 60 * 1000, spec, oldpos)
	end
	if Game.getStorageValue(GlobalStorage.Feroxa.Active) == 2 then
		addEvent(removeItems, 15 * 60 * 1000)
		addEvent(loadMap, 15 * 60 * 1000)
		addEvent(Game.broadcastMessage, 15 * 60 * 1000, 'The full moon is completely exposed: Feroxa awaits!', MESSAGE_EVENT_ADVANCE)
		addEvent(final, 30 * 60 * 1000)
		Game.setStorageValue(GlobalStorage.Feroxa.Active, 3)
		return true
	end
	Game.setStorageValue(GlobalStorage.Feroxa.Active, 2)
	addEvent(spectators, 15 * 60 * 1000)
	addEvent(Game.broadcastMessage, 15 * 60 * 1000, 'Half of the current full moon is visible now, there are still a lot of clouds in front of it.', MESSAGE_EVENT_ADVANCE)
end

local grimVale = GlobalEvent("grimvale")
function grimVale.onThink(interval, lastExecution)
	local chance = Game.getStorageValue(GlobalStorage.Feroxa.Chance)
	if Game.getStorageValue(GlobalStorage.Feroxa.Active) >= 1 then
		return true
	end
	if spawnByDay then
		if Game.getStorageValue(GlobalStorage.Feroxa.Active) < 1 then
			if spawnDay == tonumber(currentDay) then
				if chance <= 5 then
					addEvent(removeItems, 30 * 60 * 1000)
					addEvent(Game.loadMap, 30 * 60 * 1000, 'data/world/feroxa/middle.otbm')
					addEvent(spectators, 30 * 60 * 1000)
					Game.setStorageValue(GlobalStorage.Feroxa.Active, 1)
					Game.broadcastMessage('Grimvale drowns in werecreatures as the full moon reaches its apex and ancient evil returns.', MESSAGE_EVENT_ADVANCE)
				else
					Game.setStorageValue(GlobalStorage.Feroxa.Chance, math.random(1, 10))
				end
			end
		end
	end
	return true
end
grimVale:interval(60000)
grimVale:register()
