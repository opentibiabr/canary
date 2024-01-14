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
	for k, v in pairs(chargeItem) do
		local chargeableCount = player:getItemCount(v.noChargeID)
		local silverTokensCount = player:getItemCount(silverTokenID)

		if (chargeableCount >= 1 and silverTokensCount >= v.cost) then
			player:removeItem(silverTokenID, v.cost)
			player:removeItem(v.noChargeID, 1)
			player:addItem(v.ChargeID, 1)
			player:sendTextMessage(MESSAGE_LOOK, "Refilled " .. k .. '.')
		end
	end

	return true
end

refill:separator(" ")
refill:groupType("normal")
refill:register()
