local transformid = {
	[9110] = 9111,
	[9111] = 9110,
}

local cultsOfTibiaLeverMota = Action()

function cultsOfTibiaLeverMota.onUse(player, item, fromPosition, itemEx, toPosition)
	local stonePos1 = Position()
	local stonePos2 = Position()
	local stonePos3 = Position()
	local stoneId = 15487

	local missionStatus = player:getStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission)
	if missionStatus ~= 12 and missionStatus ~= 13 then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	for i = 33300, 33305 do
		local newpos = Position(i, 32144, 10)
		if Tile(newpos):getItemCountById(stoneId) == 1 then
			stonePos1 = newpos
		end
		newpos = Position(i, 32146, 10)
		if Tile(newpos):getItemCountById(stoneId) == 1 then
			stonePos2 = newpos
		end
		newpos = Position(i, 32148, 10)
		if Tile(newpos):getItemCountById(stoneId) == 1 then
			stonePos3 = newpos
		end
	end

	local stone1 = math.random(0, 5)
	local stone2 = math.random(0, 5)
	local stone3 = math.random(0, 5)

	local itstone1 = Tile(stonePos1):getItemById(stoneId)
	local newpos = { x = 33300 + stone1, y = itstone1:getPosition().y, z = itstone1:getPosition().z }
	itstone1:moveTo(newpos)
	Position(newpos):sendMagicEffect(CONST_ME_POFF)

	local itstone2 = Tile(stonePos2):getItemById(stoneId)
	local newpos = { x = 33300 + stone2, y = itstone2:getPosition().y, z = itstone2:getPosition().z }
	itstone2:moveTo(newpos)
	Position(newpos):sendMagicEffect(CONST_ME_POFF)

	local itstone3 = Tile(stonePos3):getItemById(stoneId)
	local newpos = { x = 33300 + stone3, y = itstone3:getPosition().y, z = itstone3:getPosition().z }
	itstone3:moveTo(newpos)
	Position(newpos):sendMagicEffect(CONST_ME_POFF)

	player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone1, stone1)
	player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone2, stone2)
	player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Stone3, stone3)
	player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.AccessDoorGareth, -1)

	if missionStatus == 12 then
		player:setStorageValue(Storage.Quest.U11_40.CultsOfTibia.MotA.Mission, 13)
	end

	item:transform(transformid[item:getId()])
	return true
end

cultsOfTibiaLeverMota:aid(5520)
cultsOfTibiaLeverMota:register()
