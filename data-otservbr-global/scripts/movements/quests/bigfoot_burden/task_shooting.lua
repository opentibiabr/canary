local function doCreateDummy(cid, position, storv)
	local player = Player(cid)
	if not player then
		return true
	end

	local tile = Tile(position)
	if tile then
		local thing = tile:getTopVisibleThing()
		if thing and isInArray({15710, 15711}, thing.itemid) then
			thing:remove()
		end
	end

	if Game.getStorageValue(storv) == 0 then -- Only spawn the target if the storage corresponds that someone is there shooting
		return true
	end

	position:sendMagicEffect(CONST_ME_POFF)
	Game.createItem(math.random(15710, 15711), 1, position)
	addEvent(doCreateDummy, 4 * 1000, cid, position, storv)
end

local shootingPos = {
	{x = 32751, y = 31789, z = 10},
	{x = 32753, y = 31789, z = 10},
	{x = 32755, y = 31789, z = 10}
}

local taskShooting = MoveEvent()
function taskShooting.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.BigfootBurden.QuestLine) ~= 13 then
		player:teleportTo(fromPosition)
		return true
	end

	thingpos = Position(position.x, position.y - 5, position.z)
	local tile = Tile(thingpos)
	if tile then
		local thing = tile:getTopVisibleThing()
		if thing and isInArray({15710, 15711}, thing.itemid) then
			thing:remove()
		end
	end

	Game.setStorageValue(position.x, 1) -- Set global storage for the script to know if someone is there shooting
	local playerPosition = player:getPosition()
	position:sendMagicEffect(CONST_ME_POFF)
	doCreateDummy(player.uid, Position(playerPosition.x, playerPosition.y - 5, 10), position.x)
	return true
end

for a = 1, #shootingPos do
	taskShooting:position(shootingPos[a])
end
taskShooting:register()

taskShooting = MoveEvent()
function taskShooting.onStepOut(creature, item, position, fromPosition)
	Game.setStorageValue(fromPosition.x, 0)

	-- Remove the target if it remains there
	thingpos = Position(position.x, position.y - 5, position.z)
	local tile = Tile(thingpos)
	if tile then
		local thing = tile:getTopVisibleThing()
		if thing and isInArray({15710, 15711}, thing.itemid) then
			thing:remove()
		end
	end
end

for b = 1, #shootingPos do
	taskShooting:position(shootingPos[b])
end
taskShooting:register()