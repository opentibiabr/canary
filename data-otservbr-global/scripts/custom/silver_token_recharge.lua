local config = {
	currency = 22516, -- silver token

	rechargeables = {
		[29429] = {newItem = 30344, cost = 2}, -- pendulet
		[29428] = {newItem = 30342, cost = 2}, -- sleep shawl
		[31621] = {newItem = 31557, cost = 2}, -- blister ring
		[30401] = {newItem = 30403, cost = 2}, -- amulet of theurgy
		[32636] = {newItem = 32621, cost = 2}, -- ring of souls
		[39179] = {newItem = 39177, cost = 2}, -- spirithorn ring
		[39182] = {newItem = 39180, cost = 2}, -- alicorn ring
		[39185] = {newItem = 39183, cost = 2}, -- arcanomancer sigil
		[39188] = {newItem = 39187, cost = 2}, -- arboreal sigil
		[39235] = {newItem = 39233, cost = 2}  -- turtle amulet
	}
}

local recharging = Action()

function recharging.onUse(player, item)
	local menu = ModalWindow{
		title = "Rechargeable Items",
		message = "Select the item you want to recharge:"
	}

	local found = false

	for i, info in pairs(config.rechargeables) do
		if player:getItemCount(i) > 0 then
			found = true
			menu:addChoice(string.format("%s", ItemType(i):getName()), function (player, button, choice)
				if button.name ~= "Recharge" then
					return
				end

				if player:getItemCount(config.currency) < info.cost then
					player:sendCancelMessage("You need " .. info.cost .. " " .. ItemType(config.currency):getPluralName():lower() .. " to recharge a " .. ItemType(i):getName() .. ".")
					player:getPosition():sendMagicEffect(CONST_ME_POFF)
					return false
				end

				player:removeItem(config.currency, info.cost)
				player:removeItem(i, 1)
				player:addItem(info.newItem, 1)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Your " .. ItemType(i):getName() .. " was recharged.")
			end)
		end
	end

	menu:addButton("Recharge")
	menu:addButton("Close")

	if found == false then
		player:sendCancelMessage(MESSAGE_EVENT_ADVANCE, "You don't have any item to recharge.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	menu:sendToPlayer(player)
	return true
end

recharging:id(22516)
recharging:register()
