local function revertItem(position, itemId, transformId)
	local item = Tile(position):getItemById(itemId)
	if item then
		item:transform(transformId)
	end
end
local function activeBasin(position)
	local basinOne = Tile(Position(position.x - 1, position.y - 2, position.z)):getItemById(11494)
	local basinTwo = Tile(Position(position.x, position.y - 2, position.z)):getItemById(11495)
	local basinThree = Tile(Position(position.x - 1, position.y - 1, position.z)):getItemById(11496)
	local basinFour = Tile(Position(position.x, position.y - 1, position.z)):getItemById(11497)
	if not basinOne or not basinTwo or not basinThree or not basinFour then
		return false
	end
	basinOne:transform(19092)
	basinTwo:transform(19093)
	basinThree:transform(19094)
	basinFour:transform(19095)
end

local function revertBasin(position)
	local basinOne = Tile(Position(position.x - 1, position.y - 2, position.z)):getItemById(19092)
	local basinTwo = Tile(Position(position.x, position.y - 2, position.z)):getItemById(19093)
	local basinThree = Tile(Position(position.x - 1, position.y - 1, position.z)):getItemById(19094)
	local basinFour = Tile(Position(position.x, position.y - 1, position.z)):getItemById(19095)
	if not basinOne or not basinTwo or not basinThree or not basinFour then
		return false
	end
	basinOne:transform(11494)
	basinTwo:transform(11495)
	basinThree:transform(11496)
	basinFour:transform(11497)
end

function revertStorages()
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Active, 0)
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.First, 0)
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Second, 0)
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Third, 0)
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Four, 0)
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Done, 0)
end

local blueGem = MoveEvent()

function blueGem.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player or player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Active) >= 1 then
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end
	if item.itemid == 8647 then
		local leverFirst = Tile(Position(33671, 32638, 13)):getItemById(9110) or Tile(Position(33671, 32638, 13)):getItemById(9111) -- lever blue
		local leverSecond = Tile(Position(33613, 32691, 13)):getItemById(9110) or Tile(Position(33613, 32691, 13)):getItemById(9111) -- lever green
		local leverThird = Tile(Position(33651, 32661, 13)):getItemById(9110) or Tile(Position(33651, 32661, 13)):getItemById(9111) -- lever red
		local leverFour = Tile(Position(33672, 32688, 13)):getItemById(9110) or Tile(Position(33672, 32688, 13)):getItemById(9111) -- lever green
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.First, 3) -- blue
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Second, 2) -- green
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Third, 1) -- red
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Four, 5) -- grass
		player:sendTextMessage(
			MESSAGE_EVENT_ADVANCE,
			"You hear a whisper: \z
		'You will not be guided but your path shines in the colours blue, green and red. Heed this hierarchy.'"
		)
		if not leverFirst or not leverSecond or not leverThird or not leverFour then
			return false
		end
		leverFirst:setActionId(53821)
		leverSecond:setActionId(53822)
		leverThird:setActionId(53823)
		leverFour:setActionId(53824)
	end
	player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.Elements.Active, 1)
	item:transform(8648)
	addEvent(activeBasin, 1 * 1000, position)
	addEvent(revertBasin, 60 * 60 * 1000, position)
	addEvent(revertStorages, 60 * 60 * 1000)
	addEvent(revertItem, 60 * 60 * 1000, position, 8648, item.itemid)
	return true
end

blueGem:type("stepin")
blueGem:aid(53813)
blueGem:register()
