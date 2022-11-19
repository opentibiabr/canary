local dailyRewardShrine = Action()

function dailyRewardShrine.onUse(player, item, fromPosition, itemEx, toPosition)
	DailyReward.loadDailyReward(player,0)
	return true
end

dailyRewardShrine:id(25720, 25721, 25722, 25723, 25802, 25803)
dailyRewardShrine:register()
