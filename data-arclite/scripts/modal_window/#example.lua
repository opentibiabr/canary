local config = {
	{ name="Hunts", position = Position(1054, 1040, 7) },
	{ name="Trainer", position = Position(1116, 1094, 7) },
	{ name="Temple", position = Position(32369, 32241, 7) }
}

local modalTeleport = TalkAction("!teleport")

function modalTeleport.onSay(player, words, param)
	local menu = ModalWindow{
		title = "Teleport Modal",
		message = "Locations"
	}

	for i, info in pairs(config) do
		menu:addChoice(string.format("%s", info.name), function (player, button, choice)
			if button.name ~= "Select" then
				return
			end

			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
			player:teleportTo(info.position)
		end)
	end

	menu:addButton("Select")
	menu:addButton("Close")
	menu:sendToPlayer(player)
	return false
end

modalTeleport:register()
