local removeEmptyParcelsEvent = CreatureEvent("RemoveEmptyParcelsOnLogin")

function removeEmptyParcelsEvent.onLogin(player)
	local emptyParcelsToRemove = {}
	for _, parcel in ipairs(player:getStoreInbox():getItems(true)) do
		if parcel:getId() == ITEM_PARCEL_STAMPED and parcel:getEmptySlots() == 10 then
			table.insert(emptyParcelsToRemove, parcel)
		end
	end

	if #emptyParcelsToRemove > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, #emptyParcelsToRemove .. " empty parcels were removed from your store inbox!")
		for _, parcel in pairs(emptyParcelsToRemove) do
			parcel:remove()
		end
	end
	return true
end

removeEmptyParcelsEvent:register()
