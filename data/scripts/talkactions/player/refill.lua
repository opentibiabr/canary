-- Usage talkaction: "!refill will refill all your amulets and rings for silver tokens"
local refill = TalkAction("!refill")

local chargeItem = {
	["pendulet"] = { noChargeID = 29429, ChargeID = 30344, cost = 2 },
	["sleep shawl"] = { noChargeID = 29428, ChargeID = 30342, cost = 2 },
	["blister ring"] = { noChargeID = 31621, ChargeID = 31557, cost = 2 },
	["theurgic amulet"] = { noChargeID = 30401, ChargeID = 30403, cost = 2 },
	["ring of souls"] = { noChargeID = 32636, ChargeID = 32621, cost = 2 },
	["turtle amulet"] = { noChargeID = 39235, ChargeID = 39233, cost = 2 },
	["spiritthorn ring"] = { noChargeID = 39179, ChargeID = 39177, cost = 5 },
	["alicorn ring"] = { noChargeID = 39182, ChargeID = 39180, cost = 5 },
	["arcanomancer sigil"] = { noChargeID = 39185, ChargeID = 39183, cost = 5 },
	["arboreal ring"] = { noChargeID = 39188, ChargeID = 39187, cost = 5 },
}
local silverTokenID = 22516

function refill.onSay(player, words, param)
	logger.debug("!refill executed")
	local refilledItems = {}
	local totalCost = 0
	for itemName, itemData in pairs(chargeItem) do
		local chargeableCount = player:getItemCount(itemData.noChargeID)
		local silverTokensCount = player:getItemCount(silverTokenID)
		if chargeableCount >= 1 and silverTokensCount >= itemData.cost then
			totalCost = totalCost + itemData.cost
			table.insert(refilledItems, itemName)
			player:removeItem(silverTokenID, itemData.cost)
			player:removeItem(itemData.noChargeID, 1)
			player:addItem(itemData.ChargeID, 1)
		end
	end
	if #refilledItems == 0 then
		player:sendTextMessage(MESSAGE_LOOK, "You do not have any items to refill or lack silver tokens.")
	else
		local itemList = table.concat(refilledItems, ", ")
		player:sendTextMessage(MESSAGE_LOOK, "Refilled " .. itemList .. " for a total of " .. totalCost .. " silver tokens.")
	end
	return true
end

refill:separator(" ")
refill:groupType("normal")
refill:register()
