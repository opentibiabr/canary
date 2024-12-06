local sequenceSkulls = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.SequenceSkulls
local Count = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count

local bookId = 29991

local sequence = {
	[1] = {
		id = 29988,
		number = 0,
		position = Position(32071, 31977, 14),
		msg = "You put the minotaur skull into the coffin within the minotaur skeleton. One of the door's locks clicks.",
	},
	[2] = {
		id = 29989,
		number = 1,
		position = Position(32074, 31977, 14),
		msg = "You put the orc skull into the coffin within the orc skeleton. One of the door's locks clicks.",
	},
	[3] = {
		id = 29990,
		number = 2,
		position = Position(32077, 31977, 14),
		msg = "You put the minotaur skull into the coffin within the minotaur skeleton. One of the door's locks clicks.",
	},
}

local actions_sequenceSkulls = Action()

function actions_sequenceSkulls.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	if player:getStorageValue(sequenceSkulls) < 0 then
		player:setStorageValue(sequenceSkulls, 0)
	end

	local tPos = target:getPosition()

	if player:getItemCount(bookId) >= 1 and player:getStorageValue(sequenceSkulls) < 3 then
		for _, skull in pairs(sequence) do
			if tPos == skull.position and skull.id == item.itemid then
				if player:getStorageValue(sequenceSkulls) == skull.number then
					player:setStorageValue(sequenceSkulls, player:getStorageValue(sequenceSkulls) + 1)
					tPos:sendMagicEffect(CONST_ME_MAGIC_GREEN)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, skull.msg)
					item:remove(1)
					if player:getStorageValue(sequenceSkulls) == 3 then
						player:setStorageValue(Count, player:getStorageValue(Count) + 1)
					end
				end
			end
		end
	end

	return true
end

for _, k in pairs(sequence) do
	actions_sequenceSkulls:id(k.id)
end

actions_sequenceSkulls:register()
