local achievementStorage = 20000

local function migrateAchievementProgress(player)
	for id, achievement in pairs(ACHIEVEMENTS) do
		local oldStorageKey = achievementStorage + id
		local progressNumber = player:getStorageValue(oldStorageKey)
		if progressNumber > 0 then
			player:kv():scoped("achievements"):set("progress", progressNumber)
			player:setStorageValue(oldStorageKey, -1)
		end
	end
end

local migration = Migration("20241708000535_move_achievement_to_kv")

function migration:onExecute()
	self:forEachPlayer(migrateAchievementProgress)
end

migration:register()
