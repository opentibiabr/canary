local removeEmptyParcelsEvent = CreatureEvent("RemoveEmptyParcelsOnLogin")

function removeEmptyParcelsEvent.onLogin(player)
	local inbox = player:getInbox()
	if not inbox then
		logger.warn("[RemoveEmptyParcelsOnLogin] Inbox not found for player {}.", player:getName())
		return true
	end

	local parcelsToRemove = {}
	for _, item in ipairs(inbox:getItems(true)) do
		if item:getId() == ITEM_PARCEL_STAMPED and item:getEmptySlots() == 10 then
			table.insert(parcelsToRemove, item)
		end
	end

	if #parcelsToRemove > 0 then
		for _, parcel in ipairs(parcelsToRemove) do
			parcel:remove()
		end

		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, #parcelsToRemove .. " empty parcels were removed from your store inbox.")
	end
	return true
end

removeEmptyParcelsEvent:register()
