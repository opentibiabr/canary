local config = {
	[1] = {
		on = 29337,
		off = 29336,
		hisPosition = Position(32251, 31386, 5),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.OkolnirStone,
		hisMessage = "You charge the winter ward stone and the engraved ice crystal glows in a blue light.",
	},
	[2] = {
		on = 29337,
		off = 29336,
		hisPosition = Position(31939, 31653, 10),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.FoldaStone,
		hisMessage = "You charge the winter ward stone and the engraved ice crystal glows in a blue light.",
	},
	[3] = {
		on = 29337,
		off = 29336,
		hisPosition = Position(32058, 32792, 13),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.CalassaStone,
		hisMessage = "You charge the winter ward stone and the engraved ice crystal glows in a blue light.",
	},
	[4] = {
		on = 29335,
		off = 29334,
		hisPosition = Position(33555, 32220, 7),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.FeyristStone,
		hisMessage = "You charge the summer ward stone and the engraved sun crystal glows in a golden light.",
	},
	[5] = {
		on = 29335,
		off = 29334,
		hisPosition = Position(32383, 32610, 7),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.MerianaStone,
		hisMessage = "You charge the summer ward stone and the engraved sun crystal glows in a golden light.",
	},
	[6] = {
		on = 29335,
		off = 29334,
		hisPosition = Position(33273, 31997, 7),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.CormayaStone,
		hisMessage = "You charge the summer ward stone and the engraved sun crystal glows in a golden light.",
	},
	[7] = {
		on = 29335,
		off = 29334,
		hisPosition = Position(33576, 32537, 15),
		hisStorage = Storage.Quest.U12_00.TheDreamCourts.WardStones.CatedralStone,
		hisMessage = "You charge the summer ward stone and the engraved sun crystal glows in a golden light.",
		lastStone = true,
	},
}

local function revertStone(position, on, off)
	local activeStone = Tile(position):getItemById(on)

	if activeStone then
		activeStone:transform(off)
	end
end

local actions_dreamTalisman = Action()

function actions_dreamTalisman.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if not player then
		return true
	end

	local tPos = target:getPosition()

	for _, k in pairs(config) do
		if tPos == k.hisPosition and target:getId() == k.off then
			if player:getStorageValue(k.hisStorage) < 1 then
				if k.lastStone then
					if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline) ~= 5 then
						return true
					else
						player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.Questline, 6)
					end
				end

				player:setStorageValue(k.hisStorage, 1)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Count, player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Count) + 1)
				target:getPosition():sendMagicEffect(CONST_ME_THUNDER)
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, k.hisMessage)
				target:transform(k.on)
				addEvent(revertStone, 1000 * 30, target:getPosition(), k.on, k.off)
			end
		end
	end

	return true
end

actions_dreamTalisman:id(30132)
actions_dreamTalisman:register()
