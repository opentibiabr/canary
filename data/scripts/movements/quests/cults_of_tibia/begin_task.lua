function fallFloor(pid, id)
	local player = Player(pid)
	if not player then
		return true
	end

	local amulet = player:getSlotItem(CONST_SLOT_NECKLACE)
	if not amulet or amulet:getId() ~= id then
		return true
	end

	local chance = math.random(0, 100)
	if chance <= 1 then
		amulet:moveTo(player:getPosition())
	end
	addEvent(fallFloor, 10000, player:getId(), id)
	return true
end

local beginTask = MoveEvent()

function beginTask.onEquip(player, item, slot, isCheck)
	if isCheck then
		return true
	end

	if player:getStorageValue(Storage.CultsOfTibia.Misguided.Mission) >= 2 and
	player:getStorageValue(Storage.CultsOfTibia.Misguided.Mission) <= 3 then
		local equippedBefore = item:getSpecialAttribute("task") or 0
		if equippedBefore ~= player:getGuid() and
		player:getStorageValue(Storage.CultsOfTibia.Misguided.Monsters) < 10 then
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Monsters, 0)
			item:setSpecialAttribute("task", player:getGuid())
		end
		if player:getStorageValue(Storage.CultsOfTibia.Misguided.Mission) == 2 then
			player:setStorageValue(Storage.CultsOfTibia.Misguided.Mission, 3)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE,"The amulet burns your skin. \z
			It hungers for energy right now, gather a large amount of energy as fast as possible to charge it. ")
		end
	end
	addEvent(fallFloor, 10000, player:getId(), item:getId())
	return true
end

beginTask:type("equip")
beginTask:id(28657, 28658)
beginTask:register()

beginTask = MoveEvent()

function beginTask.onDeEquip(player, item, slot, isCheck)
	item:setAttribute(ITEM_ATTRIBUTE_DECAYSTATE, 0)
	return true
end

beginTask:type("deequip")
beginTask:id(28657, 28658)
beginTask:register()
