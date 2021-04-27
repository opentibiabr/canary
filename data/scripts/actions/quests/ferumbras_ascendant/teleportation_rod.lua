local config = {
	[24830] = {storageKey = Storage.FerumbrasAscension.Razzagorn},
	[24831] = {storageKey = Storage.FerumbrasAscension.Ragiaz},
	[24832] = {storageKey = Storage.FerumbrasAscension.Zamulosh},
	[24833] = {storageKey = Storage.FerumbrasAscension.Mazoran},
	[24834] = {storageKey = Storage.FerumbrasAscension.Tarbaz},
	[24835] = {storageKey = Storage.FerumbrasAscension.Shulgrax},
	[24836] = {storageKey = Storage.FerumbrasAscension.Plagirath}
}

local ferumbrasAscendantTeleportation = Action()
function ferumbrasAscendantTeleportation.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local targetItem = config[target.itemid]
	if not targetItem then
		return false
	end
	if player:getStorageValue(targetItem.storageKey) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already teleported this part of the Godbreaker to Mazarius.')
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

ferumbrasAscendantTeleportation:id(24838)
ferumbrasAscendantTeleportation:register()