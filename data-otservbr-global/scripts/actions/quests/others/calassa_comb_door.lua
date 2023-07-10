local othersCalassa = Action()
function othersCalassa.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.itemid ~= 5745 then
		return false
	end

	if player:getStorageValue(Storage.OutfitQuest.firstOrientalAddon) ~= 1 or player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 150 or 146, 1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The door seems to be sealed against unwanted intruders.')
		return true
	end

	item:transform(item.itemid + 1)
	player:teleportTo(toPosition, true)
	return true
end

othersCalassa:aid(50161)
othersCalassa:register()