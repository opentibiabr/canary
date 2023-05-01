function onRecvbyte(player, msg, byte)
	local rewards = player:getRewardList()
	for i = 1, #rewards do
		local container = player:getReward(rewards[i])
		if(container) then
			player:lootContainer(container)
		end
	end
end
