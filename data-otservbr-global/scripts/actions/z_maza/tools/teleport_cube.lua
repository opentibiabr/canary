local config = {
	{ name="Hunts", position = Position(34234, 31032, 6) },
	{ name="Towns", position = Position(34234, 31032, 6) },
	{ name="Trainer", position = Position(1116, 1094, 7) },
	{ name="Temple", position = Position(32369, 32241, 7) },
	{ name="Forge", position = Position(32208, 32287, 7) },
	{ name="NPC Island", position = Position(994, 1030, 6) },
	{ name="House", position = Position(994, 1030, 6) }
}

local teleportCube = Action()
function teleportCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE) and  player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked() then
        player:sendCancelMessage("You can't use this while in battle.")
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
			
			if info.name == "House" then
				houseModal(player)
			else
				player:teleportTo(info.position)
			end

			if info.name == "Towns" then
				townsModal(player)
			else
				player:teleportTo(info.position)
			end
			
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
teleportCube:id(31633)
teleportCube:register()


function houseModal(player)
	if not getTileInfo(getThingPos(player)).protection then
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce precisa estar em uma area de Protect Zone para usa-lo!")
    	return true
   	end
	
	if getHouseByPlayerGUID(getPlayerGUID(player)) then        
		doTeleportThing(player, getHouseEntry(getHouseByPlayerGUID(getPlayerGUID(player))))
		player:setStorageValue(stg, os.time() + tempo)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce foi teleportado para sua casa!")                                                  
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Para usar essa opcao, primeiro compre uma casa. Diga !buyhouse em frente a porta da house.")
	end
end

function townsModal(player)
	local towns = {}

	for i, town in ipairs(Game.getTowns()) do
		if table.contains(STARTER_TOWNS, town:getId()) then
			goto continue
		end
		local name = town:getName()

		if name == "Island of Destiny" or name == "Cobra Bastion" or name == "Bounac" then
			goto continue
		end

		table.insert(towns, {
			name = name,
			position = town:getTemplePosition(),
		})
		::continue::
	end
	local extraTowns = {
		{
			name = "Cormaya",
			position = Position(33302, 31969, 7),
		},
		{
			name = "Fibula",
			position = Position(32177, 32437, 7),
		},
	}
	for i, info in pairs(extraTowns) do
		table.insert(towns, info)
	end
	table.sort(towns, function(a, b)
		return a.name < b.name
	end)

	local window = ModalWindow({
		title = "Teleport Cube",
		message = "Towns",
	})
	for i, info in pairs(towns) do
		window:addChoice(string.format("%s", info.name), function(player, button, choice)
			if button.name ~= "Select" then
				return true
			end
			teleportPlayer(player, info)
			return true
		end)
	end
	window:addButton("Select")
	window:addButton("Close")
	window:setDefaultEnterButton(0)
	window:setDefaultEscapeButton(1)
	window:sendToPlayer(player)
end