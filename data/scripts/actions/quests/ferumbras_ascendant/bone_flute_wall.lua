local ferumbrasAscendantBoneWall = Action()
function ferumbrasAscendantBoneWall.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(Storage.FerumbrasAscension.BoneFluteWall) < 1 then
		player:addItem(24910)
		player:setStorageValue(Storage.FerumbrasAscension.BoneFluteWall, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a bone flute.')
		toPosition:sendMagicEffect(CONST_ME_THUNDER)
	else
		return false
	end
	return true
end

ferumbrasAscendantBoneWall:aid(54386)
ferumbrasAscendantBoneWall:register()