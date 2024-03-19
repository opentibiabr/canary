--put this file in: canary\data-otservbr-global\scripts\creaturescripts\customs\receive_items.lua

local playerLogin = CreatureEvent("ItemsToWinLogin")

function playerLogin.onLogin(player)

	local itemsCreated = {}
	local items = {}

	local resultId = db.storeQuery("SELECT `id`, `item_id`, `item_name`, `item_count` FROM `myaac_send_items` WHERE `account_id` = " .. player:getAccountId() .. " AND `status` = '1';")
	if not resultId then
		return true
	end

	repeat
		items[#items + 1] = {
			transaction_id = Result.getNumber(resultId, 'id'),
			id = Result.getNumber(resultId, 'item_id'),
			name = Result.getString(resultId, 'item_name'),
			count = Result.getNumber(resultId, 'item_count'),
		}
	until not Result.next(resultId)
	Result.free(resultId)

	if #items > 0 then
		for _, item in ipairs(items) do
			local updateAt = os.date("%Y-%m-%d %H:%M:%S", os.time())
			db.query("UPDATE `myaac_send_items` SET `status` = '2', `updated_at` = " .. db.escapeString(updateAt) .. " WHERE `id` = " .. item.transaction_id .. ";")

			local count = item.count or 1
			local itemType = ItemType(item.id)
			if itemType then
				local inbox = player:getStoreInbox()
				if inbox then
					local pendingCount = 0
					while pendingCount < count do
						inbox:addItem(item.id, 1)
						pendingCount = pendingCount + 1
					end
				end
				table.insert(itemsCreated, string.format("%d %s in your store inbox.", count, itemType:getName():lower()))
			end
		end
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Congratulations! \zYou have received the followed items:\n%s", table.concat(itemsCreated, "\n")))
		player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
	end

	return true
end

playerLogin:register()
