local positions = {
	[Position(33117, 31672, 7)] = {
		toPosition = Position(33327, 31481, 15),
		storageValue = 10,
	},
	[Position(32367, 31596, 7)] = {
		toPosition = Position(32299, 31698, 8),
		storageValue = 8,
	},
	[Position(32301, 31697, 8)] = {
		toPosition = Position(32368, 31598, 7),
		storageValue = 8,
		boss = "Fryclops"
	},
	[Position(32297, 31706, 8)] = {
		toPosition = Position(32246, 31834, 7),
		storageValue = 8,
	},
	[Position(32246, 31832, 7)] = {
		toPosition = Position(32298, 31704, 8),
		storageValue = 8,
	},
	[Position(32591, 31936, 5)] = {
		toPosition = Position(33319, 31443, 15),
		storageValue = 2,
	},
	[Position(32591, 31936, 5)] = {
		toPosition = Position(32587, 31937, 5),
		storageValue = 4,
		boss = "The Rest of Ratha"
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
		return false
	end

	playerStorage = player:getStorageValue(Storage.Quest.U13_30.TwentyYearsACook.QuestLine) or -1
	hasBossCooldown = false

	for position, data in pairs(positions) do
		logger.warn(data.storageValue)
		if position == player:getPosition() and playerStorage >= data.storageValue then
			if data.boss and creature:getBossCooldown(data.boss) > os.time() then
				hasBossCooldown = true
				break
			end
			fromPosition:sendMagicEffect(CONST_ME_POFF)
			player:teleportTo(data.toPosition)
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return true
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, hasBossCooldown and "You need to wait to challenge again." or "You are not ready for this yet")

	player:teleportTo(fromPosition, true)

	return true
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
