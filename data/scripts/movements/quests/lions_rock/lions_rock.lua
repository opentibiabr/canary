local UniqueTable = {
	[25001] = {
		storage = Storage.LionsRock.SnakeSign,
		needStorage = Storage.LionsRock.Questline,
		value = 5,
		item = 23836,
		message1 = "With the aid of the old scroll you translate the inscriptions on the floor: \z
		And the mighty lion defeated the jealous snake.",
		message2 = "As a sign of victory he tooks its eye, yellow as envy and malevolence, and out \z
		of a foul creature created a precious treasure."
	},
	[25002] = {
		storage = Storage.LionsRock.LizardSign,
		needStorage = Storage.LionsRock.Questline,
		value = 5,
		item = 23836,
		message1 = "With the aid of the old scroll you translate the inscriptions on the floor: \z
		And the mighty lion defeated the lazy lizard.",
		message2 = "As a sign of victory he tooks its egg, blue as sloth and conceit, and out \z
		of a foul creature created a precious treasure."
	},
	[25003] = {
		storage = Storage.LionsRock.ScorpionSign,
		needStorage = Storage.LionsRock.Questline,
		value = 5,
		item = 23836,
		message1 = "With the aid of the old scroll you translate the inscriptions on the golden altar: \z
		And the mighty lion defeated the treacherous scorpion.",
		message2 = "As a sign of victory he tooks its poison, violet as deceit and betrayal, and \z
		created a precious treasure."
	},
	[25004] = {
		storage = Storage.LionsRock.HyenaSign,
		needStorage = Storage.LionsRock.Questline,
		value = 5,
		item = 23836,
		message1 = "With the aid of the old scroll you translate the inscriptions on the golden statue: \z
		And the mighty lion defeated the greedy hyaena.",
		message2 = "As a sign of victory he tooks its blood, red as voracity and lust, and \z
		created a precious treasure."
	}
}

-- Lions rock entrance
local lionsRockEntrance = MoveEvent()

function lionsRockEntrance.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	if player:getStorageValue(Storage.LionsRock.Questline) >= 4 then
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo({x = 33122, y = 32308, z = 8})
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have passed the Lion's Tests and are now worthy to enter the inner sanctum!")
		player:getPosition():sendMagicEffect(CONST_ME_THUNDER)
	else
		player:getPosition():sendMagicEffect(CONST_ME_ENERGYHIT)
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to pass the Lion's Tests to enter the inner sanctum!")
	end
	return true
end

lionsRockEntrance:uid(35009)
lionsRockEntrance:register()

-- Lions rock sign
local lionsRockSigns = MoveEvent()

function lionsRockSigns.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end

	local setting = UniqueTable[item.uid]
	if not setting then
		return true
	end

	local currentStorage = player:getStorageValue(setting.needStorage)
	if currentStorage >= setting.value and currentStorage < 10 then
		if player:getStorageValue(setting.storage) < 1 then
			if player:getItemCount(setting.item) == 1 then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message1)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message2)
				player:setStorageValue(setting.needStorage, player:getStorageValue(setting.needStorage) + 1)
				player:setStorageValue(setting.storage, 1)
			end
		end
	end
	
	return true
end

for index, value in pairs(UniqueTable) do
	lionsRockSigns:uid(index)
end

lionsRockSigns:register()
