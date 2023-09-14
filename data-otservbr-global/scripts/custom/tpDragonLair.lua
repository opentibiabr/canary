local config = {
	{ name="Dragon Lair[Darashia]", position = Position(33266, 32280, 7) },
    { name="Dragon Lair[Ankrahmun]", position = Position(33092, 32690, 6) },
    { name="Dragon Lair[Edron]", position = Position(33097, 31701, 7) },
    { name="Dragon Lair[Fenrock]", position = Position(32601, 31397, 14) },
    { name="Dragon Lair[Kazordoon]", position = Position(32658, 31904, 7) },
    { name="Dragon Lair[Kazordoon Mines]", position = Position(32476, 31856, 10) },
    { name="Dragon Lair[Kha'zeel]", position = Position(32993, 32643, 8) },
    { name="Dragon Lair[Kha'zeel 2]", position = Position(33008, 32620, 8) },
   }

local teleportDragon = MoveEvent()
function teleportDragon.onStepIn(creature, item, position, fromPosition)
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
teleportDragon:type("stepin")
teleportDragon:aid(33317)
teleportDragon:register()
