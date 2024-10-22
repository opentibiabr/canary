local doors = {
	[1] = { doorPosition = Position(33376, 31335, 3), value = 1 },
	[2] = { doorPosition = Position(33371, 31349, 4), value = 2 },
	[3] = { doorPosition = Position(33376, 31349, 4), value = 2 },
	[4] = { doorPosition = Position(33375, 31346, 5), value = 2 },
	[5] = { doorPosition = Position(33363, 31346, 7), value = 4 },
	[6] = { doorPosition = Position(33366, 31343, 7), value = 4 },
}

local boats = {
	[1] = {
		boatPosition = Position(33373, 31309, 7),
		value = 3,
		toPosition = Position(33382, 31292, 7),
		message = "A small island emerges out of the mist as you row towards a tiny light inside a dark, forehoding chapel.",
	},
	[2] = {
		boatPosition = Position(33382, 31294, 7),
		value = 3,
		toPosition = Position(33374, 31310, 7),
		message = "Your heart lightens as you return from the gloomy isle.",
	},
	[3] = {
		boatPosition = Position(33344, 31348, 7),
		value = 3,
		toPosition = Position(33326, 31352, 7),
	},
	[4] = {
		boatPosition = Position(33328, 31352, 7),
		value = 3,
		toPosition = Position(33346, 31348, 7),
	},
}

local actions_falcon_doors = Action()

function actions_falcon_doors.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if item:getActionId() == 4920 then
		for _, p in pairs(doors) do
			local door = p.doorPosition
			local value = p.value
			if (item:getPosition() == door) and not (Tile(item:getPosition()):getTopCreature()) then
				if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses) >= value then
					player:teleportTo(toPosition, true)
					item:transform(item.itemid + 1)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
				end
			end
		end
	elseif item:getActionId() == 4921 then
		for _, p in pairs(boats) do
			local boat = p.boatPosition
			local value = p.value
			local toPos = p.toPosition
			local message = p.message
			if item:getPosition() == boat then
				if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.KillingBosses) >= value then
					player:teleportTo(toPos, true)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					if message then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
					end
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can not use this boat yet.")
				end
			end
		end
	end

	return true
end

actions_falcon_doors:aid(4920, 4921)
actions_falcon_doors:register()
