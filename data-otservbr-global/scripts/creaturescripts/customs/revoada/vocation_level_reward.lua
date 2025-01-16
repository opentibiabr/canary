local table = {

	--[{ VOC_ID, VOC_ID }] = {
	-- [LEVEL] = { items = { { uid = ITEM_ID, count = COUNT } }, storage = YOU_CHOOSE, msg = "MESSAGE FOR THE PLAYER" },
	--},

	-- all win crystal coin
	[{ 0, 1, 2, 3, 4, 5, 6, 7, 8 }] = {
		[20] = { items = { { uid = 3043, count = 3 } }, storage = "all-kk-20" },
		[50] = { items = { { uid = 3043, count = 5 } }, storage = "all-kk-50" },
		[100] = { items = { { uid = 3043, count = 7 } }, storage = "all-kk-100" },
		[200] = { items = { { uid = 3043, count = 10 } }, storage = "all-kk-200" },
		[300] = { items = { { uid = 3043, count = 10 } }, storage = "all-kk-300" },
		[500] = { items = { { uid = 3043, count = 10 } }, storage = "all-kk-500" },
		[600] = { items = { { uid = 3043, count = 10 } }, storage = "all-kk-600" },
		[700] = { items = { { uid = 3043, count = 10 } }, storage = "all-kk-700" },
		[800] = { items = { { uid = 3043, count = 10 } }, storage = "all-kk-800" },
		[1000] = { items = { { uid = 3043, count = 20 } }, storage = "all-kk-1000" },
		[2000] = { items = { { uid = 3043, count = 30 } }, storage = "all-kk-2000" },
	},
	-- ek, rp
	--[{ 3, 4, 7, 8 }] = {
	--	[30] = { items = { { uid = 3043, count = 3 } }, storage = "k-p-30" },
	--	[50] = { items = { { uid = 3043, count = 5 } }, storage = "k-p-50" },
	--	[70] = { items = { { uid = 3043, count = 7 } }, storage = "k-p-70" },
	--},
	-- sorcerer
	[{ 1, 5 }] = {
		[22] = { items = { { uid = 8093, count = 1 } }, storage = "s-22" }, --draconia
		[26] = { items = { { uid = 3073, count = 1 } }, storage = "s-26" }, --woce
		[33] = { items = { { uid = 3071, count = 1 } }, storage = "s-33" }, --woi
		[37] = { items = { { uid = 8092, count = 1 } }, storage = "s-37" }, --starstorm
		[42] = { items = { { uid = 8094, count = 1 } }, storage = "s-42" }, --voodoo
		[80] = { items = { { uid = 25700, count = 1 } }, storage = "s-80" }, --dream blossom staff
	},
	-- druid
	[{ 2, 6 }] = {
		[22] = { items = { { uid = 8083, count = 1 } }, storage = "d-22" }, --northwind
		[26] = { items = { { uid = 3065, count = 1 } }, storage = "d-26" }, --terra
		[33] = { items = { { uid = 3067, count = 1 } }, storage = "d-33" }, --hailstorm
		[37] = { items = { { uid = 8084, count = 1 } }, storage = "d-37" }, --spring
		[42] = { items = { { uid = 8082, count = 1 } }, storage = "d-42" }, --underworld
		[80] = { items = { { uid = 25700, count = 1 } }, storage = "d-80" }, --dream blossom staff
	},
	-- paladin
	[{ 3, 7 }] = {
		[20] = { items = { { uid = 3415, count = 1 } }, storage = "p-20" }, --guardian shield
		[25] = { items = { { uid = 7378, count = 20 } }, storage = "p-25" }, --royal spear
		[42] = { items = { { uid = 7367, count = 20 } }, storage = "p-42" }, --enchant spear
		[80] = { items = { { uid = 7368, count = 200 } }, storage = "p-80" }, --ass start
	},
	-- knight
	[{ 4, 8 }] = {
		[12] = { items = { { uid = 3351, count = 1 }, { uid = 3357, count = 1 }, { uid = 3557, count = 1 } }, storage = "k-12" }, --plate set
		[20] = { items = { { uid = 3415, count = 1 } }, storage = "k-20" }, --guardian shield
	},
	-- rooker
	--[{ 0 }] = {
	--	[30] = { items = { { uid = 3351, count = 1 }, { uid = 3357, count = 1 }, { uid = 3557, count = 1 } }, storage = 40403 }, --plate set
	--	[30] = { items = { { uid = 3415, count = 1 } }, storage = 40404 }, --guardian shield
	--},
}

local rewardLevel = CreatureEvent("RewardLevel")
function rewardLevel.onAdvance(player, skill, oldLevel, newLevel)
	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	for voc, x in pairs(table) do
		if isInArray(voc, player:getVocation():getId()) then
			for level, z in pairs(x) do
				local kvCheck = player:kv():scoped("reward-by-voc-level"):get(z.storage) or false
				if newLevel >= level and not kvCheck then
					for v = 1, #z.items do
						local ret = ", "
						if v == 1 then
							ret = ""
						end
						local item = ItemType(z.items[v].uid)
						local count = z.items[v].count
						player:addItem(z.items[v].uid, count)
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You won %s for reaching level %i!", string.format("%i %s%s", count, item:getName():lower(), count > 1 and "s" or ""), level))
						player:kv():scoped("reward-by-voc-level"):set(z.storage, true)
					end
				end
			end
			player:save()
		end
	end

	return true
end

rewardLevel:register()
