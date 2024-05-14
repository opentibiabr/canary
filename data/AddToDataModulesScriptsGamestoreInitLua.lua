GameStore.ExpBoostValues = {
	[1] = 250,
	[2] = 250,
	[3] = 250,
	[4] = 250,
	[5] = 250,
}

function GameStore.processExpBoostPurchase(player)
	local currentXpBoostTime = player:getXpBoostTime()
	local expBoostCount = player:getStorageValue(GameStore.Storages.expBoostCount)

	player:setXpBoostPercent(20)
	player:setXpBoostTime(currentXpBoostTime + 36000)

	if expBoostCount == -1 or expBoostCount == 6 then
		expBoostCount = 1
	end

	player:setStorageValue(GameStore.Storages.expBoostCount, expBoostCount + 1)
end