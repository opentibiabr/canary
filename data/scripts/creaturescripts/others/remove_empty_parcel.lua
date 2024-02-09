local removeEmptyParcelsEvent = CreatureEvent("RemoveEmptyParcelsOnLogin")

function removeEmptyParcelsEvent.onLogin(player)
	local emptyParcelsToRemove = {}
	local removed = false
	local countRemovedParcels = 0
	for _, parcel in ipairs(player:getStoreInbox():getItems(true)) do
		if parcel:getId() == ITEM_PARCEL_STAMPED and parcel:getEmptySlots() == 10 then
			emptyParcelsToRemove[parcel] = parcel
			countRemovedParcels = countRemovedParcels + 1
		end
	end

	for _, parcel in pairs(emptyParcelsToRemove) do
		parcel:remove()
		removed = true
	end

	if removed then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, countRemovedParcels .. " empty parcels were removed from your store inbox!")
	end
	return true
end

removeEmptyParcelsEvent:register()
