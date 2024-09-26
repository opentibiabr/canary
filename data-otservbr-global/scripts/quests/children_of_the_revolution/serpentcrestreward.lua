local rewards = {
	{ id = 10199, name = "Serpent Crest" },

}


local rewardCrest = Action()
function rewardCrest.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.SerpentCrestReward) < 0 then
		player:addItem(rewardItem.id, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have found a " .. rewardItem.name .. ".")
		player:setStorageValue(Storage.Quest.U12_40.SoulWar.SerpentCrestReward, 1)
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have already collected your reward")
		return false
	end
end

rewardCrest:position({x = 33261, y = 31099, z = 7})
rewardCrest:register()