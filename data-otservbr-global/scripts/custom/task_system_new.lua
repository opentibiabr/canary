function Player:sendColoredMessage(message)
	local grey = 3003
	local blue = 3043
	local green = 3415
	local purple = 36792
	local yellow = 34021

	local msg = message:gsub("{grey|", "{" .. grey .. "|"):gsub("{blue|", "{" .. blue .. "|"):gsub("{green|", "{" .. green .. "|"):gsub("{purple|", "{" .. purple .. "|"):gsub("{yellow|", "{" .. yellow .. "|")
	return self:sendTextMessage(MESSAGE_LOOT, msg)
end

----------------------------------------------------------------------------------------------------------------------------

-- Configuration table for task system
local config = {}
for i = 62001, 62072 do
    config[i] = i - 62000 + 1
end

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
            --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))))
            player:sendColoredMessage(string.format("{yellow|[Task System]}: Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))), MESSAGE_EVENT_ADVANCE)
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
                    player:sendColoredMessage(string.format("{yellow|[Task System]}: Sorry, but you also need to deliver the items on this list: %s", getItemsFromList(v.items)), MESSAGE_EVENT_ADVANCE)
                    --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you also need to deliver the items on this list: %s"), getItemsFromList(v.items))
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
								player:sendColoredMessage(string.format("{yellow|[Task System]}: Thank you for your help! Rewards: "..(str == "" and "none" or str).." for completing the task of %s", v.name), MESSAGE_EVENT_ADVANCE)
                --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Thank you for your help! Rewards: "..(str == "" and "none" or str).." for completing the task of %s", v.name))
                player:setStorageValue(Storage.HuntingTasks.KillCount, 0)
                player:setStorageValue(taskSystem[config[item.actionid]].start, 3)
            else
								player:sendColoredMessage(string.format("{yellow|[Task System]}: Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(Storage.HuntingTasks.KillCount) < 0 and v.count or -(player:getStorageValue(Storage.HuntingTasks.KillCount) - v.count)).." of these terrible monsters!", v.name), MESSAGE_EVENT_ADVANCE)
                --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(Storage.HuntingTasks.KillCount) < 0 and v.count or -(player:getStorageValue(Storage.HuntingTasks.KillCount) - v.count)).." of these terrible monsters!", v.name))
                return true
            end
            return true
        end
	elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and player:getStorageValue(taskSystem[config[item.actionid]].start) == 2
    and player:getTaskMission() ~= config[item.actionid] then
			player:sendColoredMessage("{yellow|[Task System]}: Sorry, You need to finish other task first.", MESSAGE_EVENT_ADVANCE)
			--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("{yellow|[Task System]}: Sorry, You need to finish other task first."))
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return true
    elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and player:getStorageValue(taskSystem[config[item.actionid]].start) == 3
    and player:getTaskMission() == config[item.actionid] then
        -- if start == 2, and none of the above, then have no tasks to do.
        --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, you already did this task."))
				player:sendColoredMessage("{yellow|[Task System]}: Sorry, you already did this task.", MESSAGE_EVENT_ADVANCE)
        player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    elseif player:getStorageValue(Storage.HuntingTasks.Questline) > 1
    and (player:getStorageValue(Storage.HuntingTasks.Questline) + 1) == config[item.actionid]
	and player:getStorageValue(taskSystem[config[item.actionid] - 1].start) == 3 then
        player:setStorageValue(Storage.HuntingTasks.Questline, config[item.actionid])
		player:setStorageValue(taskSystem[config[item.actionid]].start, 2)
				player:sendColoredMessage(string.format("{yellow|[Task System]} Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))), MESSAGE_EVENT_ADVANCE)
        --player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Congratulations, you are now participating in the Task of %s and shall kill %d from this list: %s. "..(#taskSystem[config[item.actionid]].items > 0 and "Oh and please bring me %s for me." or "").."" , taskSystem[config[item.actionid]].name, taskSystem[config[item.actionid]].count, getMonsterFromList(taskSystem[config[item.actionid]].monsters_list, getItemsFromList(taskSystem[config[item.actionid]].items))))
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
			player:sendColoredMessage(string.format("{yellow|[Task System]} Sorry, you must wait until %s to start a new daily task!", os.date("%d %B %Y %X ", player:getStorageValue(Storage.HuntingTasks.DailyTime))), MESSAGE_EVENT_ADVANCE)
			--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Task System] Sorry, you must wait until %s to start a new daily task!", os.date("%d %B %Y %X ", player:getStorageValue(Storage.HuntingTasks.DailyTime))))
			return true
		end
		-- able then select a random daily task
		local r = player:randomDailyTask()
		if r == 0 then
			player:sendColoredMessage("{yellow|[Task System]} Sorry, but you don't have the level to complete any daily tasks.", MESSAGE_EVENT_ADVANCE)
			--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] Sorry, but you don't have the level to complete any daily tasks.")
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
		player:sendColoredMessage(string.format("{yellow|[Daily Task System]} Congratulations, you are now participating in the Daily Task of %s and shall kill %d monsters from this list: %s up until %s. Good luck!" , dtask.name, dtask.count, getMonsterFromList(dtask.monsters_list), os.date("%d %B %Y %X ", player:getStorageValue(Storage.HuntingTasks.DailyTime))), MESSAGE_EVENT_ADVANCE)
		--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Congratulations, you are now participating in the Daily Task of %s and shall kill %d monsters from this list: %s up until %s. Good luck!" , dtask.name, dtask.count, getMonsterFromList(dtask.monsters_list), os.date("%d %B %Y %X ", player:getStorageValue(Storage.HuntingTasks.DailyTime))))

	else
		-- already doing a daily, verify and deliver reward
		local v = dailyTasks[daily]
		if player:getStorageValue(Storage.HuntingTasks.DailyCount) >= v.count then
			if #v.items > 0 and not player:doRemoveItemsFromList(v.items) then
				--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Sorry, but you also need to deliver the items on this list: %s"), getItemsFromList(v.items))
				player:sendColoredMessage(string.format("{yellow|[Daily Task System]} Sorry, but you also need to deliver the items on this list: %s", getItemsFromList(v.items)), MESSAGE_EVENT_ADVANCE)
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

			--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Thank you for your help! Rewards: "..(str == "" and "none" or str).." for completing the task of %s", v.name))
			player:sendColoredMessage(string.format("{yellow|[Daily Task System]} Thank you for your help! Rewards: "..(str == "" and "none" or str).." for completing the task of %s", v.name), MESSAGE_EVENT_ADVANCE)

			return true
		else
			--player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("[Daily Task System] Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(Storage.HuntingTasks.DailyCount) < 0 and v.count or -(player:getStorageValue(Storage.HuntingTasks.DailyCount) - v.count)).." of these terrible monsters!", v.name))
			player:sendColoredMessage(string.format("{yellow|[Daily Task System]} Sorry, but you haven't finished your task %s yet. I need you to kill more "..(player:getStorageValue(Storage.HuntingTasks.DailyCount) < 0 and v.count or -(player:getStorageValue(Storage.HuntingTasks.DailyCount) - v.count)).." of these terrible monsters!", v.name), MESSAGE_EVENT_ADVANCE)
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
