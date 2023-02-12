local heroRathletonReward = Action()
function heroRathletonReward.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	if player:getStorageValue(24850) < 1 then
		player:addItem(21203, 5)
		player:addItem(3035, 4)
		player:addItem(21897)
		player:addItem(9058)
		player:addItem(836)
		player:addAchievement('The Professors Nut')
		player:setStorageValue(24850, 1) -- storage da recompensa
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'You opened the Maxxen\'s chest.')
	else
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'The chest is empty.')
	end
	return true
end

heroRathletonReward:uid(24850)
heroRathletonReward:register()