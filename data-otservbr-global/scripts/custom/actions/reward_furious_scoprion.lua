local rewards = {
    {id = 7383, name = "Relic Sword"},
    {id = 3318, name = "Knight Axe"},
    {id = 3035, name = "Platinum Coin"},
    {id = 3381, name = "Crown Armor"},
    {id = 3382, name = "Crown Legs"},
    {id = 3385, name = "Crown Helmet"},
    {id = 3370, name = "Knight Armor"},
    {id = 3436, name = "Medusa Shield"},
}

local furiousScoprionReward = Action()
function furiousScoprionReward.onUse(creature, item, fromPosition, target, toPosition, isHotkey)
	local randId = math.random(1, #rewards)
	local rewardItem = rewards[randId]
	local player = creature:getPlayer()
	if not player then
		return false
	end
    if player:getStorageValue(117017) == 1 then
		player:addItem(rewardItem.id, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You have found a ' .. rewardItem.name .. '.')
        player:setStorageValue(117017, 0)
    else
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You already collected your reward.')

    end
end
furiousScoprionReward:position({x = 32944, y = 32309, z = 8})
furiousScoprionReward:register()
