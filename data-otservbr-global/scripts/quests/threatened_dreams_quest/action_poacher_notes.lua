local poacherNotes = Action()
function poacherNotes.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission01.TroubledAnimals) == 7 and player:getStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission01.PoacherNotes) < 1 then
		player:addItem(25242, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found notes of a poacher.")
		player:setStorageValue(Storage.Quest.U11_40.ThreatenedDreams.Mission01.PoacherNotes, 1)
	else
		player:sendCancelMessage("It is empty.")
	end
	return true
end
poacherNotes:aid(20002)
poacherNotes:register()
