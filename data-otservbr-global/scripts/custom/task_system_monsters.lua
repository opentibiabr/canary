local config = {
	[62001] = 1,
	[62002] = 2,
	[62003] = 3,
	[62004] = 4,
	[62005] = 5,
	[62006] = 6,
	[62007] = 7,
	[62008] = 8,
	[62009] = 9,
	[62010] = 10,
	[62011] = 11,
	[62012] = 12,
	[62013] = 13,
	[62014] = 14,
	[62015] = 15,
	[62016] = 16,
	[62017] = 17,
	[62018] = 18,
	[62019] = 19,
	[62020] = 20,
	[62021] = 21,
	[62022] = 22,
	[62023] = 23,
	[62024] = 24,
}

local tasksystemMonsters = Action("tasksystemMonsters")

function tasksystemMonsters.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    --local outfit = outfits[math.random(1, #outfits)]
    --local addon = math.random(1, 2)

	local task, daily, hours = player:getTaskMission(), player:getDailyTaskMission(), 24

	-- Aceitar Task Comum
	if taskSystem[config[item.actionid]] then
		if player:getStorageValue(taskSystem[config[item.actionid]].start) <= 0 then
			if player:getLevel() >= taskSystem[config[item.actionid]].level then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))))
				player:setStorageValue(taskSystem_storages[1], config[item.actionid])
				player:setStorageValue(taskSystem[config[item.actionid]].start, 1)
				player:setStorageValue(taskSystem_storages[9], 0)
				return true
			else
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you need to reach level %d to be able to participate in the Task of %s!", taskSystem[config[item.actionid]].level, taskSystem[config[item.actionid]].name))
				return true
			end
		else
			local task = player:getTaskMission()
			if not(task == null)  then
				if (player:getStorageValue(taskSystem[task].start) == 1 and (task == config[item.actionid])) then
					local v, k = taskSystem[config[item.actionid]], dailyTasks[config[item.actionid]]
					-- give reward if finished
					if player:getStorageValue(taskSystem_storages[3]) >= v.count then
						if #v.items > 0 and not player:doRemoveItemsFromList(v.items) then
							player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you also need to deliver the items on this list: %s"), getItemsFromList(v.items))
							return true
						end

						local str = ""

						if v.exp > 0 then
							player:addExperience(v.exp)
							str = str.." "..v.exp.." experience,"
						end
						if v.points > 0 then
							player:setStorageValue(taskSystem_storages[2], (player:getTaskPoints() + v.points))
							str = str.." "..v.points.." task points,"
						end
						if v.money > 0 then
							player:addMoney(v.money)
							str = str.." "..v.money.." gold coins,"
						end
						if table.maxn(v.reward) > 0 then
							player:giveRewardsTask(v.reward)
							str = str.." and "..getItemsFromList(v.reward).."."
						end
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Thank you for your help! Rewards: "..(str == "" and "none" or str).." for completing the task of %s", v.name))
						player:setStorageValue(taskSystem_storages[3], 0)
						player:setStorageValue(taskSystem_storages[9], -1)
						player:setStorageValue(taskSystem[config[item.actionid]].start, -1)
						player:setStorageValue(taskSystem_storages[1], -1)
						return true
					else
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(taskSystem_storages[3]) < 0 and v.count or -(player:getStorageValue(taskSystem_storages[3]) - v.count)).." of these terrible monsters!", v.name))
						return true
					end
					return true
				else
					-- if clicked in different altar of tasks
					local task = player:getTaskMission()
					if taskSystem[task] and player:getStorageValue(taskSystem[task].start) == 1 then
						player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you haven't finished your task %s yet.", taskSystem[task].name))
						return true
					end
					return true
				end
			else

			end

			return true
		end
	-- aceitar daily task
	elseif dailyTasks[config[item.actionid]] then
		if player:getStorageValue(taskSystem_storages[6]) - os.time() > 0 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, you must wait until %s to start a new daily task!", os.date("%d %B %Y %X ", player:getStorageValue(taskSystem_storages[6]))))
            return true
        elseif dailyTasks[config[item.actionid]] and player:getStorageValue(taskSystem_storages[5]) >= dailyTasks[config[item.actionid]].count then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] Sorry, you already did your daily tasks!")
            return true
        end
        local r = player:randomDailyTask()
        if r == 0 then
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] Sorry, but you don't have the level to complete any daily tasks.")
            return true
        end
        player:setStorageValue(taskSystem_storages[4], r)
        player:setStorageValue(taskSystem_storages[6], os.time() + hours * 3600)
        player:setStorageValue(taskSystem_storages[7], 1)
        player:setStorageValue(taskSystem_storages[5], 0)
        local dtask = dailyTasks[r]
		player:setStorageValue(taskSystem_storages[9], 0)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Congratulations, you are now participating in the Daily Task of %s and shall kill %d monsters from this list: %s up until %s. Good luck!" , dtask.name, dtask.count, getMonsterFromList(dtask.monsters_list), os.date("%d %B %Y %X ", player:getStorageValue(taskSystem_storages[6]))))
		--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Sorry, no tasks available!"))
	end
    return true
end

for index, value in pairs(config) do
	tasksystemMonsters:aid(index)
end
tasksystemMonsters:register()