local config = {
	{ name="Hunts Room", position = Position(17002, 17123, 3) },
	{ name="Boss Room", position = Position(1225, 862, 8) },
	{ name="Trainer", position = Position(1228, 862, 8) },
	{ name="Thais", position = Position(32369, 32241, 7) }
}

local teleportCube = Action()
function teleportCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and  player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked() then
        player:sendCancelMessage("Voce nao pode usar esse item com battle.")
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end
	local window = ModalWindow {
		title = "Teleport Modal",
		message = "Locations"
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
teleportCube:id(44840)
teleportCube:register()
