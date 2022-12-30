local config = {
	[VOCATION.BASE_ID.SORCERER] = {x = 33183, y = 32197, z = 13},
	[VOCATION.BASE_ID.DRUID] = {x = 33331, y = 32076, z = 13},
	[VOCATION.BASE_ID.PALADIN] = {x = 33265, y = 32202, z = 13},
	[VOCATION.BASE_ID.KNIGHT] = {x = 33087, y = 32096, z = 13}
}

local elementalSpheresMachine1 = Action()
function elementalSpheresMachine1.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local destination = config[player:getVocation():getBaseId()]
	if table.contains({842, 843}, item.itemid) then
		local gemCount = player:getStorageValue(Storage.ElementalSphere.MachineGemCount)
		if table.contains({33268, 33269}, toPosition.x)
		and toPosition.y == 31830
		and toPosition.z == 10
		and gemCount >= 20 then
			player:teleportTo(destination, false)
			player:setStorageValue(Storage.ElementalSphere.MachineGemCount, gemCount - 20)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
		toPosition.x = toPosition.x + (item.itemid == 842 and 1 or -1)
		local tile = toPosition:getTile()
		if tile then
			local thing = tile:getItemById(item.itemid == 842 and 843 or 842)
			if thing then
				thing:transform(thing.itemid + 4)
			end
		end
		item:transform(item.itemid + 4)
	else
		toPosition.x = toPosition.x + (item.itemid == 846 and 1 or -1)
		local tile = toPosition:getTile()
		if tile then
			local thing = tile:getItemById(item.itemid == 842 and 843 or 842)
			if thing then
				thing:transform(thing.itemid - 4)
			end
		end
		item:transform(item.itemid - 4)
	end
	return true
end

elementalSpheresMachine1:id(842, 843)
elementalSpheresMachine1:register()