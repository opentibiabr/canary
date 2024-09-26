local rewards = {
		{ id = 43864, name = "sanguine blade" },
		{ id = 43866, name = "sanguine cudgel" },
		{ id = 43868, name = "sanguine hatchet" },
		{ id = 43870, name = "sanguine razor" },
		{ id = 43872, name = "sanguine bludgeon" },
		{ id = 43874, name = "sanguine battleaxe" },
		{ id = 43876, name = "sanguine legs" },
		{ id = 43877, name = "sanguine bow" },
		{ id = 43879, name = "sanguine crossbow" },
		{ id = 43881, name = "sanguine greaves" },
		{ id = 43882, name = "sanguine coil" },
		{ id = 43884, name = "sanguine boots" },
		{ id = 43885, name = "sanguine rod" },
		{ id = 43887, name = "sanguine galoshes" },
}
local outfits = { 1663, 1662 }

local function addOutfits(player)
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.RottenOutfitReward) < 0 then
		player:addOutfit(outfits[1], 0)
		player:addOutfit(outfits[2], 0)
		player:setStorageValue(Storage.Quest.U12_40.SoulWar.RottenOutfitReward, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Congratulations you received the Decaying Defender Outfit.")
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
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.RottenQuestReward) < 0 then
		player:addItem(rewardItem.id, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. rewardItem.name .. ".")
		player:setStorageValue(Storage.Quest.U12_40.SoulWar.RottenQuestReward, 1)
		addOutfits(player)
		return true
	else
		addOutfits(player)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already collected your reward")
		return false
	end
end

rewardSoulWar:position({ x = 34086, y = 32049, z = 13 })
rewardSoulWar:register()