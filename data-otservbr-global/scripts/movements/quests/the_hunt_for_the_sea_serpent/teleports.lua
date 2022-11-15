local TheHuntForTheSeaSerpent = Storage.Quest.U8_2.TheHuntForTheSeaSerpent
local config = {
	{teleportPos = {x = 31943, y = 31046, z = 7}, destination = Position(31943, 31045, 2)},
	{teleportPos = {x = 31943, y = 31046, z = 2}, destination = Position(31943, 31044, 7)},
	{teleportPos = {x = 31938, y = 31041, z = 6}, destination = Position(31938, 31041, 8), condition = TheHuntForTheSeaSerpent.QuestLine},
	{teleportPos = {x = 31939, y = 31050, z = 6}, destination = Position(31912, 31187, 9), condition = TheHuntForTheSeaSerpent.QuestLine}
}

local teleports = MoveEvent()
function teleports.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end
	for b = 1, #config do
		if player:getPosition() == Position(config[b].teleportPos) then
			if config[b].condition then
				if player:getStorageValue(config[b].condition) == 2 then
					if player:getSlotItem(CONST_SLOT_HEAD) then
						if isInArray({5460, 11585, 13995}, player:getSlotItem(CONST_SLOT_HEAD).itemid) then
							player:teleportTo(config[b].destination)
							player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						else
							player:teleportTo(fromPosition)
							player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wear a helmet of the deep.")
						end
					else
						player:teleportTo(fromPosition)
						player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have to wear a helmet of the deep.")
					end
				else
					player:teleportTo(fromPosition)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not yet at the right spot.")
				end
			else
				player:teleportTo(config[b].destination)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	end
	return true
end

for a = 1, #config do
	teleports:position(config[a].teleportPos)
end
teleports:register()
