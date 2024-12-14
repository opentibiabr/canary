local sequenceBooks = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.SequenceBooks
local questline = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline

local sequence = {
	[1] = {
		number = 0,
		position = Position(33613, 32515, 15),
		msg = "The chants in this book often contain the word 'K'muuh'.",
	},
	[2] = {
		number = 1,
		position = Position(33621, 32520, 15),
		msg = "The chants in this book often contain the word 'N'ogalu'.",
	},
	[3] = {
		number = 2,
		position = Position(33616, 32520, 15),
		msg = "The chants in this book often contain the word 'O'kteth.'.",
	},
	[4] = {
		number = 3,
		position = Position(33624, 32515, 15),
		msg = "All chants have been sung in the right order, you are deemed worthy. You are transported away...",
	},
}

local actions_sequenceBooks = Action()

function actions_sequenceBooks.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	if player:getStorageValue(sequenceBooks) < 0 then
		player:setStorageValue(sequenceBooks, 0)
	end

	local tPos = item:getPosition()

	if player:getStorageValue(questline) == 3 then
		for _, book in pairs(sequence) do
			if tPos == book.position then
				if player:getStorageValue(sequenceBooks) == book.number then
					player:setStorageValue(sequenceBooks, player:getStorageValue(sequenceBooks) + 1)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, book.msg)
					tPos:sendMagicEffect(CONST_ME_SOUND_WHITE)
				else
					player:setStorageValue(sequenceBooks, 0)
					tPos:sendMagicEffect(CONST_ME_SOUND_RED)
				end
			end
			if player:getStorageValue(sequenceBooks) == 4 then
				player:teleportTo(Position(33640, 32561, 13))
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				player:setStorageValue(sequenceBooks, 0)
				if player:getStorageValue(questline) < 4 then
					player:setStorageValue(questline, 4)
				end
			end
		end
	end

	return true
end

actions_sequenceBooks:id(29957)
actions_sequenceBooks:register()
