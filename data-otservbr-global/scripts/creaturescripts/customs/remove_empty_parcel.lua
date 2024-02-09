local playerLogin = CreatureEvent("RemoveParcelsOnLogin")

function playerLogin.onLogin(player)
	local toRemove = {}
	local removed = false
	local countP = 0
	for _, itemZ in ipairs(player:getStoreInbox():getItems(true)) do
		local PARCEL_ID = 3504
		if itemZ:getId() == PARCEL_ID and itemZ:getEmptySlots() == 10 then
			toRemove[itemZ] = itemZ
			countP = countP + 1
		end
	end

	for k, v in pairs(toRemove) do
		v:remove()
		removed = true
	end

	if removed then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, countP .. " empty parcels was be removed from your store inbox!")
	end
	return true
end

playerLogin:register()
