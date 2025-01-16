local dust = Action()

function dust.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local amount = 100
	local limitDusts = 200

	local totalDusts = player:getForgeDusts()
	if (totalDusts + amount) < limitDusts then
		player:addForgeDusts(amount)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You received " .. amount .. " dusts.")
		item:remove(1)
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is impossible to have more than " .. limitDusts .. " dusts!")
	end

	return true
end

dust:id(33893)
dust:register()
