local transformid = {
	[10029] = 10030,
	[10030] = 10029
}

local cultsOfTibiaLeverMota = Action()
function cultsOfTibiaLeverMota.onUse(player, item, fromPosition, itemEx, toPosition)
	local posPedra = Position()
	local posPedra2 = Position()
	local posPedra3 = Position()
	local pedraid = 18008
	if player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) ~= 12 then
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end
	for i = 33300, 33305, 1 do
		local newpos = Position(i, 32144, 10)
		if(Tile(newpos):getItemCountById(pedraid) == 1)then
			posPedra = newpos
		end
		newpos = Position(i, 32146, 10)
		if(Tile(newpos):getItemCountById(pedraid) == 1)then
			posPedra2 = newpos
		end
		newpos = Position(i, 32148, 10)
		if(Tile(newpos):getItemCountById(pedraid) == 1)then
			posPedra3 = newpos
		end
	end
	local pedra1 = math.random(0,5)
	local pedra2 = math.random(0,5)
	local pedra3 = math.random(0,5)
	-- pedra 1
	local itpedra1 = Tile(posPedra):getItemById(pedraid)
	local newpos = {x = 33300 + pedra1, y = itpedra1:getPosition().y, z = itpedra1:getPosition().z}
	itpedra1:moveTo(newpos)
	Position(newpos):sendMagicEffect(CONST_ME_POFF)

	-- pedra 2
	local itpedra2 = Tile(posPedra2):getItemById(pedraid)
	local newpos = {x = 33300 + pedra2, y = itpedra2:getPosition().y, z = itpedra2:getPosition().z}
	itpedra2:moveTo(newpos)
	Position(newpos):sendMagicEffect(CONST_ME_POFF)

	-- pedra 3
	local itpedra3 = Tile(posPedra3):getItemById(pedraid)
	local newpos = {x = 33300 + pedra3, y = itpedra3:getPosition().y, z = itpedra3:getPosition().z}
	itpedra3:moveTo(newpos)
	Position(newpos):sendMagicEffect(CONST_ME_POFF)

	player:setStorageValue(Storage.CultsOfTibia.MotA.Stone1, Stone1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Stone2, Stone2)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Stone3, Stone3)
	player:setStorageValue(Storage.CultsOfTibia.MotA.AccessDoorGareth, -1)
	player:setStorageValue(Storage.CultsOfTibia.MotA.Mission, player:getStorageValue(Storage.CultsOfTibia.MotA.Mission) + 1)
	item:transform(transformid[item:getId()])
	return true
end

cultsOfTibiaLeverMota:aid(5520)
cultsOfTibiaLeverMota:register()