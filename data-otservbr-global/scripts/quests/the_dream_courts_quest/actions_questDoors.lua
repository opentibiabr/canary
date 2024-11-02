local doors = {
	[1] = {
		doorPosition = Position(32761, 32630, 7),
		storage = Storage.Quest.U12_00.TheDreamCourts.UnsafeRelease.Questline,
		value = 1,
	},
	[2] = {
		doorPosition = Position(32700, 32244, 9),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 1,
	},
	[3] = {
		doorPosition = Position(32700, 32255, 9),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 1,
	},
	[4] = {
		doorPosition = Position(32700, 32275, 8),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 1,
	},
	[5] = {
		doorPosition = Position(32719, 32264, 8),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Cellar,
		value = 1,
	},
	[6] = {
		doorPosition = Position(33088, 32388, 8),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 1,
	},
	[7] = {
		doorPosition = Position(32606, 32629, 9),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Temple,
		value = 1,
		help = "Tomb",
	},
	[8] = {
		doorPosition = Position(32671, 32652, 7),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline,
		value = 1,
	},
	[9] = {
		doorPosition = Position(33625, 32525, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount,
		value = 3,
	},
	[10] = {
		doorPosition = Position(33640, 32551, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount,
		value = 3,
	},
	[11] = {
		doorPosition = Position(33657, 32551, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount,
		value = 3,
	},
	[12] = {
		doorPosition = Position(31983, 31960, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.DoorMedusa,
		value = 1,
		help = "Medusa",
	},
	[13] = {
		doorPosition = Position(32051, 31998, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MushRoom,
		value = 2,
	},
	[14] = {
		doorPosition = Position(32074, 31974, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.SequenceSkulls,
		value = 3,
	},
	[15] = {
		doorPosition = Position(32091, 31970, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline,
		value = 2,
		help = "Lock",
	},
	[16] = {
		doorPosition = Position(31983, 32000, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline,
		value = 2,
		help = "Open/Close",
	},
}

local function closeDoor(position, closedId)
	local door = Tile(position):getItemById(closedId + 1)
	if door then
		door:transform(closedId)
	end
end

local actions_questDoors = Action()

function actions_questDoors.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local iPos = item:getPosition()

	for _, p in pairs(doors) do
		if iPos == p.doorPosition and not (player:getPosition() == p.doorPosition) then
			if p.help == "Tomb" then
				if player:getStorageValue(p.storage) < p.value then
					player:teleportTo(toPosition, true)
					item:transform(item.itemid + 1)
					addEvent(closeDoor, 2000, iPos, item.itemid)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
				end
			elseif p.help == "Medusa" then
				if player:getStorageValue(p.storage) < 1 then
					player:setStorageValue(p.storage, 1)
					local count = player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count)
					player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Count, (count < 0 and 1 or count + 1))
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "As Medusa's Ointment takes effect, the door is unpetrified. You can use it now.")
				end
				local newPos = (iPos.y < player:getPosition().y) and Position(iPos.x, iPos.y - 3, iPos.z) or Position(iPos.x, iPos.y + 3, iPos.z)
				player:teleportTo(newPos)
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				addEvent(closeDoor, 2000, iPos, item.itemid)
			elseif p.help == "Lock" then
				if player:getStorageValue(p.storage) >= p.value then
					local newPos = (iPos.y < player:getPosition().y) and Position(iPos.x, iPos.y - 1, iPos.z) or Position(iPos.x, iPos.y + 1, iPos.z)
					player:teleportTo(newPos)
					player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
					addEvent(closeDoor, 2000, iPos, item.itemid)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The lock in this door is missing. Perhaps you can find a matching lock somewhere?")
					return true
				end
			elseif p.help == "Open/Close" then
				if player:getStorageValue(p.storage) >= p.value then
					item:transform((item.itemid == 30033) and 30035 or 30033)
				end
			else
				if player:getStorageValue(p.storage) >= p.value then
					player:teleportTo(toPosition, true)
					item:transform(item.itemid + 1)
					addEvent(closeDoor, 2000, iPos, item.itemid)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "The door seems to be sealed against unwanted intruders.")
				end
			end
		end
	end

	return true
end

actions_questDoors:aid(23101)
actions_questDoors:register()
