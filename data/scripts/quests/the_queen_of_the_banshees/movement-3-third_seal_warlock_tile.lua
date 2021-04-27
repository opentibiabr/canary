local thirdSealWarlockTile = MoveEvent()

function thirdSealWarlockTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.Quest.TheQueenOfTheBanshees.ThirdSealWarlocks) < 1 then
		player:setStorageValue(Storage.Quest.TheQueenOfTheBanshees.ThirdSealWarlocks, 1)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		Game.createMonster('Warlock', {x = 32215, y = 31835, z = 15}, false, true)
		Game.createMonster('Warlock', {x = 32215, y = 31840, z = 15}, false, true)
	end
	return true
end

thirdSealWarlockTile:aid(25023)
thirdSealWarlockTile:type("stepin")
thirdSealWarlockTile:register()
