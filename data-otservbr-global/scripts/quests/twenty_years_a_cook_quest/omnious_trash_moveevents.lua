local positions = {
	[Position(32367, 31596, 7)] = {
		toPosition = Position(32301, 31697, 8),
		storageValue = 8,
	},
	[Position(32301, 31697, 8)] = {
		toPosition = Position(32368, 31598, 7),
		storageValue = 8,
	},
	[Position(32246, 31832, 7)] = {
		toPosition = Position(32298, 31704, 8),
		storageValue = 8,
	},
	[Position(32591, 31936, 5)] = {
		toPosition = Position(32587, 31937, 5),
		storageValue = 4,
	},
	[Position(32591, 31936, 5)] = {
		toPosition = Position(33319, 31443, 15),
		storageValue = 2,
	},
	[Position(32974, 32110, 7)] = {
		toPosition = Position(32973, 32087, 8),
		storageValue = 1,
	},
	[Position(32973, 32089, 8)] = {
		toPosition = Position(32975, 32112, 7),
		storageValue = 1,
	},
}

local omniousTrashCan = MoveEvent()

function omniousTrashCan.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	playerStorage = player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) or -1

	for position, data in pairs(positions) do
		if position == player:getPosition() and playerStorage >= data.storageValue and player:getLevel() >= 250 then
			fromPosition:sendMagicEffect(CONST_ME_POFF)
			player:teleportTo(data.toPosition)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not ready for this yet")
	player:teleportTo(fromPosition, true)
end

local addedPositions = {}

for key, _ in pairs(positions) do
	if not table.contains(addedPositions, key) then
		omniousTrashCan:position(key)
	end
	table.insert(addedPositions, key)
end

omniousTrashCan:type("stepin")
omniousTrashCan:register()
