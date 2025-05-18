local ferumbrasAscendantMysterious = Action()
function ferumbrasAscendantMysterious.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U10_90.FerumbrasAscension.RiftRunner) >= 1 or player:getStorageValue(24850) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "No matter how often you try, you cannot decipher anything.")
		return true
	else
		player:addMount(87)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You decipher something! You get a rift runner to accompany you on your journey.")
		player:setStorageValue(Storage.Quest.U10_90.FerumbrasAscension.RiftRunner, 1)
	end
	return true
end

ferumbrasAscendantMysterious:id(22865)
ferumbrasAscendantMysterious:register()
