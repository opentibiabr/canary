local gravediggerTears = Action()
function gravediggerTears.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 4632 then
		return false
	end

	if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission14) == 1 and player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission15) < 1 then
		player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission15, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The dragon tears glow and disappear. The old powers are appeased.")
		item:remove(3)
	end
	return true
end

gravediggerTears:id(19084)
gravediggerTears:register()
