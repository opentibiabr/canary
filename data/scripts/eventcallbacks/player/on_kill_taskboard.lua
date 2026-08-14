local callback = EventCallback("TaskboardPlayerOnKill")

function callback.playerOnKill(player, monster)
	local taskboard = rawget(_G, "Taskboard")
	if not taskboard or not taskboard.isEnabled() or not player or not monster then
		return
	end

	local monsterType = monster:getType()
	if not monsterType then
		return
	end

	local isRewardBoss = false
	if type(monsterType.isRewardBoss) == "function" then
		local ok, result = pcall(monsterType.isRewardBoss, monsterType)
		isRewardBoss = ok and result == true
	end
	if isRewardBoss then
		return
	end

	taskboard.onMonsterKilled(player, monsterType:raceId())
end

callback:register()
