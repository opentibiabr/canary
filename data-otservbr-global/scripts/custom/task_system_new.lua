local config = {
	[62001] = 2,
	[62002] = 3,
	[62003] = 4,
	[62004] = 5,
	[62005] = 6,
	[62006] = 7,
	[62007] = 8,
	[62008] = 9,
	[62009] = 10,
	[62010] = 11,
	[62011] = 12,
	[62012] = 13,
	[62013] = 14,
	[62014] = 15,
	[62015] = 16,
	[62016] = 17,
	[62017] = 18,
	[62018] = 19,
	[62019] = 20,
	[62020] = 21,
	[62021] = 22,
	[62022] = 23,
	[62023] = 24,
	[62024] = 25,
	[62025] = 26,
	[62026] = 27,
	[62027] = 28,
	[62028] = 29,
	[62029] = 30,
	[62030] = 31,
	[62031] = 32,
	[62032] = 33,
	[62033] = 34,
	[62034] = 35,
	[62035] = 36,
	[62036] = 37,
	[62037] = 38,
	[62038] = 39,
	[62039] = 40,
	[62040] = 41,
	[62041] = 42,
	[62042] = 43,
	[62043] = 44,
	[62044] = 45,
	[62045] = 46,
	[62046] = 47,
	[62047] = 48,
	[62048] = 49,
	[62049] = 50,
	[62050] = 51,
	[62051] = 52,
	[62052] = 53,
	[62053] = 54,
	[62054] = 55,
	[62055] = 56,
	[62056] = 57,
	[62057] = 58,
	[62058] = 59,
	[62059] = 60,
	[62060] = 61,
	[62061] = 62,
	[62062] = 63,
	[62063] = 64,
	[62064] = 65,
	[62065] = 66,
	[62066] = 67,
	[62067] = 68,
	[62068] = 69,
	[62069] = 70,
	[62070] = 71,
	[62071] = 72,
	[62072] = 73,
}

--[[ TASK HUNTING ]]--
local tasksystemMonsters = Action("tasksystemMonsters")

function tasksystemMonsters.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if player:getStorageValue(Storage.HuntingTasks.Questline) < 1
    or player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) < 3 then
        player:setStorageValue(Storage.HuntingTasks.Questline, 1)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
    elseif player:getStorageValue(Storage.HuntingTasks.Questline) == 1
    and player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) == 3 then
        -- check if clicked in first action (starting 1)
        if config[item.actionid] == 2 then
            -- authorize first hunting task
            player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))))
            -- seta primeira hunting ativa
            player:setStorageValue(Storage.HuntingTasks.Questline, 2)
            -- seta mission 2
            player:setStorageValue(taskSystem[config[item.actionid]].start, 2)
        else
            player:sendCancelMessage("[Task System] - Error! You should start from Rats Infestation.")
            player:getPosition():sendMagicEffect(CONST_ME_POFF)
            return false
        end
    elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and player:getStorageValue(taskSystem[config[item.actionid]].start) == 2
    and player:getTaskMission() == config[item.actionid] then
        -- verify if finished the quest
        local task = player:getTaskMission()
        if not(task == null)  then
            local v = taskSystem[config[item.actionid]]
            -- give reward if finished
            if player:getStorageValue(Storage.HuntingTasks.KillCount) >= v.count then
                if #v.items > 0 and not player:doRemoveItemsFromList(v.items) then
                    player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you also need to deliver the items on this list: %s"), getItemsFromList(v.items))
                    return false
                end

                local str = ""

                if v.exp > 0 then
                    player:addExperience(v.exp)
                    str = str.." "..v.exp.." experience,"
                end
                if v.points > 0 then
                    player:setStorageValue(Storage.HuntingTasks.Points, (player:getTaskPoints() + v.points))
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
                player:setStorageValue(Storage.HuntingTasks.KillCount, 0)
                player:setStorageValue(taskSystem[config[item.actionid]].start, 3)
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(Storage.HuntingTasks.KillCount) < 0 and v.count or -(player:getStorageValue(Storage.HuntingTasks.KillCount) - v.count)).." of these terrible monsters!", v.name))
                return true
            end
            return true
        end
	elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and player:getStorageValue(taskSystem[config[item.actionid]].start) == 2
    and player:getTaskMission() ~= config[item.actionid] then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, You need to finish other task first."))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
    elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and player:getStorageValue(taskSystem[config[item.actionid]].start) == 3
    and player:getTaskMission() == config[item.actionid] then
        -- if start == 2, and none of the above, then have no tasks to do.
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, you already did this task."))
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and (player:getStorageValue(Storage.HuntingTasks.Questline) + 1) == config[item.actionid]
	and player:getStorageValue(taskSystem[config[item.actionid] - 1].start) == 3 then
        player:setStorageValue(Storage.HuntingTasks.Questline, config[item.actionid])
		player:setStorageValue(taskSystem[config[item.actionid]].start, 2)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))))
    end
    return true
end

for index, value in pairs(config) do
	tasksystemMonsters:aid(index)
end
tasksystemMonsters:register()

--[[ TASK DAILY ]]--
local tasksystemDaily = Action("tasksystemDaily")

function tasksystemDaily.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local daily, hours = player:getDailyTaskMission(), 20
	-- check if player is doing a daily
	if daily == null or daily <= 0 then
		-- check if able to take the daily task
		if player:getStorageValue(Storage.HuntingTasks.DailyTime) - os.time() > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, you must wait until %s to start a new daily task!", os.date("%d %B %Y %X ", player:getStorageValue(Storage.HuntingTasks.DailyTime))))
			return true
		end
		-- able then select a random daily task
		local r = player:randomDailyTask()
		if r == 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] Sorry, but you don't have the level to complete any daily tasks.")
			return true
		end
		-- set all the storages necessary
		player:setStorageValue(Storage.HuntingTasks.DailyTask, r)
		--set time to start again (24h)
		player:setStorageValue(Storage.HuntingTasks.DailyTime, os.time() + hours * 3600)
		--Set daily start 1
		player:setStorageValue(Storage.HuntingTasks.DailyStart, 1)
		--daily count
		player:setStorageValue(Storage.HuntingTasks.DailyCount, 0)

		local dtask = dailyTasks[r]
		--atualiza o hunting task quest tracker
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Congratulations, you are now participating in the Daily Task of %s and shall kill %d monsters from this list: %s up until %s. Good luck!" , dtask.name, dtask.count, getMonsterFromList(dtask.monsters_list), os.date("%d %B %Y %X ", player:getStorageValue(Storage.HuntingTasks.DailyTime))))

	else
		-- already doing a daily, verify and deliver reward
		local v = dailyTasks[daily]
		if player:getStorageValue(Storage.HuntingTasks.DailyCount) >= v.count then
			if #v.items > 0 and not player:doRemoveItemsFromList(v.items) then
				player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Sorry, but you also need to deliver the items on this list: %s"), getItemsFromList(v.items))
				return true
			end

			local str = ""

			if v.exp > 0 then
				player:addExperience(v.exp)
				str = str.." "..v.exp.." experience,"
			end
			if v.points > 0 then
				player:setStorageValue(Storage.HuntingTasks.Points, (player:getTaskPoints() + v.points))
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

			-- set all the storages necessary
			player:setStorageValue(Storage.HuntingTasks.DailyTask, -1)
			--Set daily start 1
			player:setStorageValue(Storage.HuntingTasks.DailyStart, -1)
			--daily count
			player:setStorageValue(Storage.HuntingTasks.DailyCount, -1)

			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Thank you for your help! Rewards: "..(str == "" and "none" or str).." for completing the task of %s", v.name))

			return true
		else
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(Storage.HuntingTasks.DailyCount) < 0 and v.count or -(player:getStorageValue(Storage.HuntingTasks.DailyCount) - v.count)).." of these terrible monsters!", v.name))
			return true
		end
	end
	return true
end

tasksystemDaily:aid(62073)
tasksystemDaily:register()


--[[ TELEPORT ACCESS ]]--

local teleportAccessTasks = MoveEvent()

function teleportAccessTasks.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(31879, 33451, 6)

	if player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) < 2 then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("[Hunting Task] No Access. Talk with Joel.")
		return false
	else
		player:teleportTo(destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

teleportAccessTasks:type("stepin")
teleportAccessTasks:aid(62074)
teleportAccessTasks:register()


--[[ TELEPORT STAGE 1 ]]--

local teleportAccessTasks1 = MoveEvent()

function teleportAccessTasks1.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(31861, 33460, 6)

	if player:getStorageValue(Storage.HuntingTasks.Steps.LearningTheTruth) < 3 then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("[Hunting Task] No Access. Talk with Juliet.")
	else
		player:teleportTo(destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

teleportAccessTasks1:type("stepin")
teleportAccessTasks1:aid(62075)
teleportAccessTasks1:register()

--[[ TELEPORT STAGE 2 ]]--

local teleportAccessTasks2 = MoveEvent()

function teleportAccessTasks2.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(31879, 33460, 6)

	if (player:getStorageValue(Storage.HuntingTasks.Questline) < 24) 
	and player:getStorageValue(taskSystem[24].start) < 3 then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("[Hunting Task] No Access. You should finish the Stage 1 first.")
	else
		player:teleportTo(destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

teleportAccessTasks2:type("stepin")
teleportAccessTasks2:aid(62076)
teleportAccessTasks2:register()

--[[ TELEPORT STAGE 3 ]]--

local teleportAccessTasks3 = MoveEvent()

function teleportAccessTasks3.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = Position(31897, 33460, 6)

	if player:getStorageValue(Storage.HuntingTasks.Questline) < 48
	and player:getStorageValue(taskSystem[48].start) < 3 then
		player:teleportTo(fromPosition)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		player:sendCancelMessage("[Hunting Task] No Access. You should finish the Stage 2 first.")
	else
		player:teleportTo(destination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

teleportAccessTasks3:type("stepin")
teleportAccessTasks3:aid(62077)
teleportAccessTasks3:register()