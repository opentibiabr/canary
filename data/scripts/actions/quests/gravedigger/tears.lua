local gravediggerTears = Action()
function gravediggerTears.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4632 then
		return false
	end

	if player:getStorageValue(Storage.GravediggerOfDrefia.Mission14) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission15) < 1 then
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission15, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The dragon tears glow and disappear. The old powers are appeased.')
		item:remove(3)
	end
	return true
end

gravediggerTears:id(21401)
gravediggerTears:register()