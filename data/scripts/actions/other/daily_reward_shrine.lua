local dailyRewardShrine = Action()

function dailyRewardShrine.onUse(player, item, fromPosition, itemEx, toPosition)
	DailyReward.loadDailyReward(player,0)
	return true
end

dailyRewardShrine:id(29021, 29022, 29023, 29024, 29089, 29090)
dailyRewardShrine:register()
