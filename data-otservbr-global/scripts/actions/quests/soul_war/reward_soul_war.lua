local rewards = {
    {id = 34082, name = "Soulcutter"},
    {id = 34083, name = "Soulshredder"},
    {id = 34084, name = "Soulbiter"},
    {id = 34085, name = "Souleater"},
    {id = 34086, name = "Soulcrusher"},
    {id = 34087, name = "Soulmaimer"},
    {id = 34088, name = "Soulbleeder"},
    {id = 34089, name = "Soulpiercer"},
    {id = 34090, name = "Soultainter"},
    {id = 34091, name = "Soulhexer"},
    {id = 34092, name = "Soulshanks"},
    {id = 34093, name = "Soulstrider"},
    {id = 34094, name = "Soulshell"},
    {id = 34095, name = "Soulmantel"},
    {id = 34096, name = "Soulshroud"},
    {id = 34097, name = "Pair of Soulwalkers"},
    {id = 34098, name = "Pair of Soulstalkers"},
    {id = 34099, name = "Soulbastion"}
}

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
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a ' .. rewardItem.name .. '.')
		player:setStorageValue(Storage.Quest.U12_40.SoulWar.QuestReward, 1)
		return true
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have already collected your reward')
		return false
	end
end

rewardSoulWar:position({x = 33620, y = 31400, z = 10})
rewardSoulWar:register()
