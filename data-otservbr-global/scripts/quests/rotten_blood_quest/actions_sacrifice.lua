local sacrificialPlate = Action()

function sacrificialPlate.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local access = player:kv():scoped("rotten-blood-quest"):get("access") or 0
	if access > 3 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have access.")
		return true
	end

	if player:getItemCount(32594) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Find the keeper of the sanguine tears and offer his life fluids to the sanguine master of this realm.")
		return false
	end

	if access == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Reinforce your sacrifice for a blooded tear to the sanguine master of this realm to seal this trade.")
		player:kv():scoped("rotten-blood-quest"):set("access", 2)
		return true
	end

	if player:removeItem(32594, 1) then
		if access == 2 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your sacrifice has been accepted by the sanguine master of this realm.")
		elseif access == 3 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your sacrifices have been accepted by the sanguine master of this realm. Go forth and bedew your root with the waters of life.")
		end
		player:kv():scoped("rotten-blood-quest"):set("access", access + 1)
	end

	return true
end

sacrificialPlate:id(43891)
sacrificialPlate:register()
