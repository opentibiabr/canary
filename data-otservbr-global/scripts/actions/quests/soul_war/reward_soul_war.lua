local rewards = {
	{ id = 34082, name = "Soulcutter" },
	{ id = 34083, name = "Soulshredder" },
	{ id = 34084, name = "Soulbiter" },
	{ id = 34085, name = "Souleater" },
	{ id = 34086, name = "Soulcrusher" },
	{ id = 34087, name = "Soulmaimer" },
	{ id = 34088, name = "Soulbleeder" },
	{ id = 34089, name = "Soulpiercer" },
	{ id = 34090, name = "Soultainter" },
	{ id = 34091, name = "Soulhexer" },
	{ id = 34092, name = "Soulshanks" },
	{ id = 34093, name = "Soulstrider" },
	{ id = 34094, name = "Soulshell" },
	{ id = 34095, name = "Soulmantel" },
	{ id = 34096, name = "Soulshroud" },
	{ id = 34097, name = "Pair of Soulwalkers" },
	{ id = 34098, name = "Pair of Soulstalkers" },
	{ id = 34099, name = "Soulbastion" },
}
local outfits = { 1322, 1323 }

local function addOutfits(player)
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.OutfitReward) < 0 then
		player:addOutfit(outfits[1], 0)
		player:addOutfit(outfits[2], 0)
		player:setStorageValue(Storage.Quest.U12_40.SoulWar.OutfitReward, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Revenant Outfit.")
	end
end

local rewardSoulWar = Action()
function rewardSoulWar.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.QuestReward) < 0 then
		player:addItem(rewardItem.id, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. rewardItem.name .. ".")
		player:setStorageValue(Storage.Quest.U12_40.SoulWar.QuestReward, 1)
		addOutfits(player)
		return true
	else
		addOutfits(player)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already collected your reward")
		return false
	end
end

rewardSoulWar:position({ x = 33620, y = 31400, z = 10 })
rewardSoulWar:register()

-----------------------------
-- Phantasmal Jade Mount function

local phantasmalJadeMount = Action()
function phantasmalJadeMount.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local storage = Storage.Quest.U12_40.SoulWar.MountReward
	if player:getStorageValue(storage) == 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You already have Phantasmal Jade mount!")
		return false
	end

	if table.contains({ 34072, 34073, 34074 }, item.itemid) then
		-- check items
		if player:getItemCount(34072) >= 4 and player:getItemCount(34073) >= 1 and player:getItemCount(34074) >= 1 then
			player:removeItem(34072, 4)
			player:removeItem(34073, 1)
			player:removeItem(34074, 1)
			player:addMount(167)
			player:setStorageValue(storage, 1)
			player:addAchievement("You got Horse Power")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You won Phantasmal Jade mount.")
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations! You won You got Horse Power achievement.")
			player:getPosition():sendMagicEffect(CONST_ME_HOLYDAMAGE)
			return true
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You don't have the necessary items!")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end
end

phantasmalJadeMount:id(34072, 34073, 34074)
phantasmalJadeMount:register()
