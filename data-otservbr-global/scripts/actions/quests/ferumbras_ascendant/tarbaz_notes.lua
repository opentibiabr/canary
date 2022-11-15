local ferumbrasAscendantTarbazNotes = Action()
function ferumbrasAscendantTarbazNotes.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item.actionid == 54388 then
		if player:getStorageValue(Storage.FerumbrasAscension.BasinCounter) ~= 8 then
			return false
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Suddenly, you see the big picture. It all makes sense now. And then you despair.')
		player:setStorageValue(Storage.FerumbrasAscension.TarbazNotes, 1)
	elseif item.actionid == 54389 then
		if player:getStorageValue(Storage.FerumbrasAscension.BasinCounter) ~= 8 and player:getStorageValue(Storage.FerumbrasAscension.TarbazNotes) < 1 then
			return false
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Suddenly, you see the latter A. It all makes sense now. And then you now the secret.')
		player:setStorageValue(Storage.FerumbrasAscension.TarbazNotes, 2)
	end
	toPosition:sendMagicEffect(CONST_ME_THUNDER)
	return true
end

ferumbrasAscendantTarbazNotes:aid(54388,54389)
ferumbrasAscendantTarbazNotes:register()