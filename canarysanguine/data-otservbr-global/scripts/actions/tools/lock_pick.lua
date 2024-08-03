local lockPick = Action()

function lockPick.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if target.actionid ~= 12503 then
		return false
	end

	if math.random(100) <= 30 then
		if player:getStorageValue(Storage.ThievesGuild.Mission02) == 1 then
			player:addItem(227, 1)
			player:setStorageValue(Storage.ThievesGuild.Mission02, 2)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your lock pick open this chest!")
		end
	else
		item:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your lock pick broke.")
	end
	return true
end

lockPick:id(7889)
lockPick:register()
