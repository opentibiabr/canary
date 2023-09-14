local config = {
	{ name="Buried Cathedral", position = Position(32722, 32268, 8) },
    { name="Buster Spectre", position = Position(33092, 32389, 8) },
    { name="Gazer Spectre", position = Position(32674, 32650, 7) },
    { name="Ripper Spectre", position = Position(32691, 32236,7) },
   }

local teleportGazer = MoveEvent()
function teleportGazer.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	local window = ModalWindow {
		title = "Teleport Hunts",
		message = "Hunts"
	}
	for i, info in pairs(config) do
		window:addChoice(string.format("%s", info.name), function (player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
			player:teleportTo(info.position)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end)
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
	return true
end
teleportGazer:type("stepin")
teleportGazer:aid(33315)
teleportGazer:register()
