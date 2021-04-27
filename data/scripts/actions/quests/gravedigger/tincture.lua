local gravediggerTincture = Action()
function gravediggerTincture.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4635 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission23) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission24) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission24,1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You crash the vial and spill the blood tincture. This altar is anointed.')
		item:remove()
	end
	return true
end

gravediggerTincture:id(21245)
gravediggerTincture:register()
