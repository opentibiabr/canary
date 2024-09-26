local table = 
{
	-- [level] = type = "item", id = {ITEM_ID, QUANTITY}, msg = "MESSAGE"},
	-- [level] = type = "bank", id = {QUANTITY, 0}, msg = "MESSAGE"},
	-- [level] = type = "addon", id = {ID_ADDON_FEMALE, ID_ADDON_MALE}, msg = "MESSAGE"},
	-- [level] = type = "coin", id = {QUANTITY, 0}, msg = "MESSAGE"},
	-- [level] = type = "mount", id = {ID_MOUNT, 0}, msg = "MESSAGE"},

	[8] = {type = "item", id = {3725, 100}, msg = "You win 100 brown mushrooms for reaching level 8!"},
	[13] = {type = "item", id = {268, 30}, msg = "You win 30 mana potions for reaching level 13!"},
	[20] = {type = "item", id = {3035, 200}, msg = "You win 20k for reaching level 20!"},
	[25] = {type = "mount", id = {2, 0}, msg = "You win the mount Terror Bird for reaching level 25!"},
	[30] = {type = "item", id = {3079, 1}, msg = "You win a boots of haste for reaching level 30!"},
	[40] = {type = "item", id = {237, 100}, msg = "You win 100 strong mana potions for reaching level 40!"},
	[50] = {type = "bank", id = {60000, 0}, msg = "You win 60k to your Bank for reaching level 50!"},

}

local storage = 15000

local levelReward = CreatureEvent("Level Reward")
function levelReward.onAdvance(player, skill, oldLevel, newLevel)

	if skill ~= SKILL_LEVEL or newLevel <= oldLevel then
		return true
	end

	for level, _ in pairs(table) do
		if newLevel >= level and player:getStorageValue(storage) < level then
			if table[level].type == "item" then	
				player:addItem(table[level].id[1], table[level].id[2])
			elseif table[level].type == "bank" then
				player:setBankBalance(player:getBankBalance() + table[level].id[1])
			elseif table[level].type == "addon" then
				player:addOutfitAddon(table[level].id[1], 3)
				player:addOutfitAddon(table[level].id[2], 3)
			elseif table[level].type == "coin" then
				player:addTibiaCoins(table[level].id[1])
			elseif table[level].type == "mount" then
				player:addMount(table[level].id[1])
			else
				return false
			end

			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, table[level].msg)
			player:setStorageValue(storage, level)
		end
	end

	player:save()

	return true
end

levelReward:register()