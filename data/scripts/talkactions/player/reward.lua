local config = {
	items = {
		{ id = 35284, charges = 2400 },
		{ id = 35279, charges = 2400 },
		{ id = 35281, charges = 2400 },
		{ id = 35283, charges = 2400 },
		{ id = 35282, charges = 2400 },
		{ id = 35280, charges = 2400 },
	},
	storage = tonumber(Storage.PlayerWeaponReward), -- storage key, player can only win once
}

local function sendExerciseRewardModal(player)
	local window = ModalWindow({
		title = "Exercise Reward",
		message = "choose a item",
	})
	for _, it in pairs(config.items) do
		local iType = ItemType(it.id)
		if iType then
			window:addChoice(iType:getName(), function(player, button, choice)
				if button.name ~= "Select" then
					return true
				end

				local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)
				if inbox and inbox:getEmptySlots() > 0 then
					local item = inbox:addItem(it.id, it.charges)
					if item then
						item:setAttribute(ITEM_ATTRIBUTE_STORE, systemTime())
					else
						player:sendTextMessage(MESSAGE_LOOK, "Voce precisa ter capacidade e slots vazios para receber.")
						return
					end
					player:sendTextMessage(MESSAGE_LOOK, string.format("Parabens, voce recebeu %s com %i cobranças na caixa de entrada da sua loja.", iType:getName(), it.charges))
					player:setStorageValue(config.storage, 1)
				else
					player:sendTextMessage(MESSAGE_LOOK, "Voce precisa ter capacidade e slots vazios para receber.")
				end
			end)
		end
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end

local exerciseRewardModal = TalkAction("!reward")
function exerciseRewardModal.onSay(player, words, param)
	if not configManager.getBoolean(configKeys.TOGGLE_RECEIVE_REWARD) or player:getTown():getId() < TOWNS_LIST.AB_DENDRIEL then
		return true
	end
	if player:getStorageValue(config.storage) > 0 then
		player:sendTextMessage(MESSAGE_LOOK, "Voce ja recebeu sua recompensa de arma de exercicio!")
		return true
	end
	sendExerciseRewardModal(player)
	return true
end

exerciseRewardModal:separator(" ")
exerciseRewardModal:groupType("normal")
exerciseRewardModal:register()
