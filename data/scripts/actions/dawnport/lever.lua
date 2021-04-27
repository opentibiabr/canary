local positions = {
	{x = 32106, y = 31903, z = 7},
	{x = 32106, y = 31904, z = 7},
	{x = 32105, y = 31903, z = 7},
	{x = 32105, y = 31904, z = 7}
}

local lever = Action()

function lever.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Dawnport.Lever) < 1 then
		player:setStorageValue(Storage.Dawnport.Lever, 1)
	end

	if item.itemid == 10044 and player:getStorageValue(Storage.Dawnport.Lever) == 1 then
		for i = 1, #positions do
			local tile = Tile(positions[i])
			local createBridge = tile:getItemById(4665)
			if createBridge then
				createBridge:transform(5769)
			end
		end
		player:say("<squeaak>", TALKTYPE_MONSTER_SAY, false, player, {x = 32107, y = 31904, z = 7})
		player:setStorageValue(Storage.Dawnport.Lever, 2)
		item:transform(23661)
		addEvent(function()
			item:transform(10044)
		end, 8 * 1000)
	elseif item.itemid == 10044 and player:getStorageValue(Storage.Dawnport.Lever) == 2 then
		for i = 1, #positions do
			local tile = Tile(positions[i])
			if tile then
				local creature = tile:getTopCreature()
				if creature then
					toPosition.x = toPosition.x + 1
					local query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
					if query ~= RETURNVALUE_NOERROR then
						toPosition.x = toPosition.x - 1
						toPosition.y = toPosition.y + 1
						query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
					end
					if query ~= RETURNVALUE_NOERROR then
						toPosition.y = toPosition.y - 2
						query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
					end
					if query ~= RETURNVALUE_NOERROR then
						toPosition.x = toPosition.x - 1
						toPosition.y = toPosition.y + 1
						query = Tile(toPosition):queryAdd(creature, bit.bor(FLAG_IGNOREBLOCKCREATURE, FLAG_PATHFINDING))
					end
					creature:teleportTo(toPosition, true)
				end

				local removeBridge = tile:getItemById(5769)
				if removeBridge then
					removeBridge:transform(4665)
				end
			end
		end
		player:say("<crrk>", TALKTYPE_MONSTER_SAY, false, player, {x = 32107, y = 31904, z = 7})
		player:setStorageValue(Storage.Dawnport.Lever, 1)
		item:transform(23661)
		addEvent(function()
			item:transform(10044)
		end, 8 * 1000)
	end
	return true
end

lever:aid(30001)
lever:register()
