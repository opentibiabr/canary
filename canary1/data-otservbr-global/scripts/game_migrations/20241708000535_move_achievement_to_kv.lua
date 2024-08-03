local achievementProgressStorage = 20000
local achievementStorage = 30000

local function migrateAchievementProgress(player)
	for id, achievement in pairs(ACHIEVEMENTS) do
		local oldStorageKey = achievementProgressStorage + id
		local progressNumber = player:getStorageValue(oldStorageKey)
		if progressNumber > 0 then
			local achievScopeName = tostring(achievement.name .. "-progress")
			player:kv():scoped(achievScopeName, progressNumber)
			player:setStorageValue(oldStorageKey, -1)
		end
		local oldAchievement = player:getStorageValue(achievementStorage + id)
		if oldAchievement > 0 then
			player:addAchievement(achievement.name)
			player:setStorageValue(achievementStorage + id, -1)
		end
	end
	local points = 0
	local list = player:getAchievements()
	if #list > 0 then
		for i = 1, #list do
			local a = Game.getAchievementInfoById(list[i])
			if a.points > 0 then
				points = points + a.points
			end
		end
	end

	player:addAchievementPoints(points)
end

local migration = Migration("20241708000535_move_achievement_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrateAchievementProgress)
end

migration:register()
