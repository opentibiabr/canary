local signs = {
	{
		pos = {x = 33095, y = 32244, z = 9},
		storage = Storage.LionsRock.InnerSanctum.SnakeSign,
		message1 = "With the aid of the old scroll you translate the inscriptions on the floor: And the mighty lion defeated the jealous snake.",
		message2 = "As a sign of victory he tooks its eye, yellow as envy and malevolence, and out of a foul creature created a precious treasure."
	},
	{
		pos = {x = 33128, y = 32300, z = 9},
		storage = Storage.LionsRock.InnerSanctum.LizardSign,
		message1 = "With the aid of the old scroll you translate the inscriptions on the floor: And the mighty lion defeated the lazy lizard.",
		message2 = "As a sign of victory he tooks its egg, blue as sloth and conceit, and out of a foul creature created a precious treasure."
	},
	{
		pos = {x = 33109, y = 32329, z = 9},
		storage = Storage.LionsRock.InnerSanctum.ScorpionSign,
		message1 = "With the aid of the old scroll you translate the inscriptions on the golden altar: And the mighty lion defeated the treacherous scorpion.",
		message2 = "As a sign of victory he tooks its poison, violet as deceit and betrayal, and created a precious treasure."
	},
	{
		pos = {x = 33127, y = 32340, z = 9},
		storage = Storage.LionsRock.InnerSanctum.HyenaSign,
		message1 = "With the aid of the old scroll you translate the inscriptions on the golden statue: And the mighty lion defeated the greedy hyaena.",
		message2 = "As a sign of victory he tooks its blood, red as voracity and lust, and created a precious treasure."
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

lionsRockEntrance:position({x = 33128, y = 32308, z = 8})
lionsRockEntrance:register()

-- Rock translation scroll
local checkPos = {
	{x = 33118, y = 32246, z = 9},
	{x = 33119, y = 32246, z = 9},
	{x = 33120, y = 32246, z = 9},
	{x = 33118, y = 32247, z = 9},
	{x = 33120, y = 32247, z = 9},
	{x = 33118, y = 32248, z = 9},
	{x = 33119, y = 32248, z = 9},
	{x = 33120, y = 32248, z = 9}
}
local lionsRockTranslationScroll = MoveEvent()

function lionsRockTranslationScroll.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local amphoraPos = Position(33119, 32247, 9)
	local amphoraID = 21945
	local amphoraBrokenID = 21946
	local function reset()
		local brokenAmphora = Tile(amphoraPos):getItemById(amphoraBrokenID)
		if brokenAmphora then
			brokenAmphora:transform(amphoraID)
		end
	end

	if player:getStorageValue(Storage.LionsRock.Questline) == 4 then
		local amphora = Tile(amphoraPos):getItemById(amphoraID)
		if amphora then
			amphora:transform(amphoraBrokenID)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "As you pass incautiously, the ancient amphora crumbles to shards and dust. Amidst the debris you discover an old scroll.")
			player:setStorageValue(Storage.LionsRock.Questline, 5)
			player:addItem(21467, 1)
			amphoraPos:sendMagicEffect(CONST_ME_GROUNDSHAKER)
			addEvent(reset, 15 * 1000)
		end
	end
	return true
end

for a = 1, #checkPos do
	lionsRockTranslationScroll:position(checkPos[a])
end
lionsRockTranslationScroll:register()

-- Lions rock sign
local lionsRockSigns = MoveEvent()

function lionsRockSigns.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end
	local setting
	for c = 1, #signs do
		setting = signs[c]
		if player:getStorageValue(setting.storage) < 1 and player:getItemCount(21467) >= 1 and player:getPosition() == Position(setting.pos) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message1)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, setting.message2)
			player:setStorageValue(setting.storage, 1)
			player:setStorageValue(Storage.LionsRock.Questline, player:getStorageValue(Storage.LionsRock.Questline) + 1)
		end
	end
	return true
end

for b = 1, #signs do
	lionsRockSigns:position(signs[b].pos)
end

lionsRockSigns:register()

-- Lions rock message
local lionsRockMessage = MoveEvent()

function lionsRockMessage.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return
	end
	if player:getStorageValue(Storage.LionsRock.InnerSanctum.Message) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You enter a temple area which is gorgeously decorated and mysteriously unaffected by the course of time.")
		player:setStorageValue(Storage.LionsRock.InnerSanctum.Message, 1)
	end
	return true
end

lionsRockMessage:position({x = 33080, y = 32274, z = 10})
lionsRockMessage:register()
