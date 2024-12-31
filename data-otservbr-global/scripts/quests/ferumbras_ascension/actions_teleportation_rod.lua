local config = {
	[22174] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Razzagorn },
	[22175] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Ragiaz },
	[22176] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Zamulosh },
	[22177] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Mazoran },
	[22178] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Tarbaz },
	[22179] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Shulgrax },
	[22180] = { storageKey = Storage.Quest.U10_90.FerumbrasAscension.Plagirath },
}

local ferumbrasAscendantTeleportation = Action()

function ferumbrasAscendantTeleportation.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return false
	end
	if player:getStorageValue(targetItem.storageKey) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already teleported this part of the Godbreaker to Mazarius.")
		return true
	end
	player:setStorageValue(targetItem.storageKey, 1)
	local pos = player:getPosition()
	pos.z = pos.z - 1
	player:teleportTo(pos)
	player:getPosition():sendMagicEffect(CONST_ME_THUNDER)
	toPosition:sendMagicEffect(CONST_ME_MORTAREA)
	return true
end

ferumbrasAscendantTeleportation:id(22182)
ferumbrasAscendantTeleportation:register()
