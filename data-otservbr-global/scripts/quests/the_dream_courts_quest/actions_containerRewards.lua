local containers = {
	[1] = {
		uniqueid = 23102,
		cPosition = Position(32736, 32282, 8),
		storage = Storage.Quest.U12_00.TheDreamCourts.HauntedHouse.SkeletonContainer,
		value = 1,
		reward = 29310,
		defaultItem = true,
	},
	[2] = {
		uniqueid = 23103,
		cPosition = Position(33693, 32185, 8),
		storage = Storage.Quest.U12_00.TheDreamCourts.Main.CourtChest,
		value = 1,
		reward = 30146,
		defaultItem = true,
	},
	[3] = {
		uniqueid = 23104,
		cPosition = Position(33711, 32108, 4),
		storage = Storage.Quest.U12_00.TheDreamCourts.Main.CourtChest,
		value = 1,
		reward = 30146,
		defaultItem = true,
	},
	[4] = {
		uniqueid = 23105,
		cPosition = Position(33578, 32527, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.FishingRod,
		value = 1,
		reward = 29950,
		defaultItem = true,
	},
	[5] = {
		uniqueid = 23106,
		cPosition = Position(33599, 32533, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.BarrelWord,
		value = 1,
		defaultItem = false,
		text = "The inside of this barrel's lid has a word written onto it: 'O'kteth'.",
	},
	[6] = {
		uniqueid = 23107,
		cPosition = Position(33618, 32518, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.EstatueWord,
		value = 1,
		defaultItem = false,
		text = "This statue has a word written on her hand: 'N'ogalu'.",
	},
	[7] = {
		uniqueid = 23108,
		cPosition = Position(33638, 32507, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.BedWord,
		value = 1,
		defaultItem = false,
		text = "This end of the bed has a stack of notes hidden under it. There is only one word on all of them: 'T'sough'.",
	},
	[8] = {
		uniqueid = 23109,
		cPosition = Position(33703, 32185, 5),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.RoseBush,
		value = 1,
		reward = 29993,
		defaultItem = true,
	},
	[9] = {
		uniqueid = 23110,
		cPosition = Position(33663, 32192, 7),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MushRoom,
		value = 1,
		reward = 30009,
		defaultItem = true,
	},
	[10] = {
		uniqueid = 23111,
		cPosition = Position(33671, 32203, 7),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Book,
		value = 1,
		reward = 29991,
		defaultItem = true,
	},
	[11] = {
		uniqueid = 23112,
		cPosition = Position(33683, 32125, 6),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.OrcSkull,
		value = 1,
		reward = 29989,
		defaultItem = true,
	},
	[12] = {
		uniqueid = 23113,
		cPosition = Position(31996, 31981, 13),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Recipe,
		value = 1,
		reward = 30147,
		defaultItem = true,
	},
	[13] = {
		uniqueid = 23114,
		cPosition = Position(32017, 31981, 14),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.MinotaurSkull,
		value = 1,
		reward = 29988,
		defaultItem = true,
	},
	[14] = {
		uniqueid = 23115,
		cPosition = Position(32054, 31936, 13),
		storage = Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.TrollSkull,
		value = 1,
		reward = 29990,
		defaultItem = true,
	},
}

local actions_containerRewards = Action()

function actions_containerRewards.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local iPos = item:getPosition()

	for _, k in pairs(containers) do
		if iPos == k.cPosition and item:getUniqueId() == k.uniqueid then
			if player:getStorageValue(k.storage) < k.value then
				if k.defaultItem then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. ItemType(k.reward):getName() .. ".")
					player:addItem(k.reward, 1)
				else
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, k.text)
					if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount) < 0 then
						player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount, 0)
					end
					player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount, player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount) + 1)
					if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.BurriedCatedral.WordCount) == 4 then
						player:addAchievement("Tied the Knot")
					end
				end
				player:setStorageValue(k.storage, k.value)
			else
				if k.defaultItem then
					player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "It is empty.")
				end
			end
		end
	end

	return true
end

for _, k in pairs(containers) do
	actions_containerRewards:uid(k.uniqueid)
end

actions_containerRewards:register()
