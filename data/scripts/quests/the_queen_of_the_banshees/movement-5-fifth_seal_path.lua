local fifthSealTile = MoveEvent()

function fifthSealTile.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local storage = Storage.Quest.TheQueenOfTheBanshees.FifthSealTile
	local getStorage = player:getStorageValue(storage)
	if item.actionid == 25020 then
		if getStorage >= 1 and getStorage <= 8 then
			player:setStorageValue(storage, getStorage + 1)
		end
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	elseif item.actionid == 25021 then
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
		player:setStorageValue(storage, 1)
	end
	return true
end

fifthSealTile:aid(25020, 25021)
fifthSealTile:register()
