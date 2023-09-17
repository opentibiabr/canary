local config = {
	{ name="Temple", action = "teleportTemple" },
	{ name="House", action = "teleportHouse" },
}

local teleportCube = Action()

function teleportTemple(player)
    player:teleportTo(getTownTemplePosition(player:getTown():getId()))
		return true
end

function teleportHouse(player)
    local house = player:getHouse()
	if not house then
		player:sendCancelMessage("You don't have a house.")
		return false
	else
		player:teleportTo(house:getExitPosition())
		return true
	end
end

function teleportCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local window = ModalWindow {
		title = "Teleport Cube",
		message = "Locations",
	}
	for i, info in pairs(config) do
		window:addChoice(string.format("%s", info.name), function (player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			if player:getTile():hasFlag(TILESTATE_PROTECTIONZONE) or not player:isPzLocked() or not player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) then
				if player:getStorageValue(Storage.SupremeCubeTimer) < os.time() then
					sucess = _G[info.action](player)
					if sucess then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. info.name)
						player:getPosition():sendMagicEffect(CONST_ME_SUPREME_CUBE)
						player:setStorageValue(Storage.SupremeCubeTimer, os.time() + 60 * 2)
				else
					player:sendCancelMessage("You're on cube cooldown.")
					end
				return false
				end
			return true
			end
		end)
	end
	window:addButton("Select", setDefaultEnterButton)
	window:addButton("Close", setDefaultEscapeButton)
	window:sendToPlayer(player)
	return true
end
teleportCube:id(31633)
teleportCube:register()
