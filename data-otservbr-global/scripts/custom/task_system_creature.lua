local taskSystemEvent = CreatureEvent("taskSystem")

function taskSystemEvent.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamageUnjustified)
    if killer:isPlayer() and creature:isMonster() then
        local party = killer:getParty()
        local members = {}

        if party then
            members = party:getMembers()
            table.insert(members, party:getLeader())
        else
            members = {killer}
        end

        for _, member in pairs(members) do
            local creaturePos = member:getPosition()
            local killedMobPos = creature:getPosition()
            local tile = Tile(creaturePos)

            if not tile:hasFlag(TILESTATE_PROTECTIONZONE) and killedMobPos:getDistance(creaturePos) < 25 then
                local taskSystem = _G.taskSystem
                local dailyTasks = _G.dailyTasks

                local task = taskSystem[member:getTaskMission()]
                local daily = dailyTasks[member:getDailyTaskMission()]

                if task and isInArray(task.monsters_list, creature:getName()) then
                    local currentCount = member:getStorageValue(taskSystem_storages[3])
                    if currentCount < task.count then
                        member:setStorageValue(taskSystem_storages[3], currentCount + 1)
                        if member:getStorageValue(taskSystem_storages[8]) <= 0 then
                            member:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] Defeated: [" .. (currentCount + 1) .. "/" .. task.count .. "] monsters for the task: " .. task.name .. ".")
                            member:setStorageValue(taskSystem_storages[9], member:getStorageValue(taskSystem_storages[9]))
                        end
                        if currentCount + 1 >= task.count then
                            member:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] Congratulations! You completed the task: " .. task.name .. ", return to the NPC to claim your reward.")
                            member:setStorageValue(taskSystem_storages[9], 1)
                            return true
                        end
                        return true
                    end
                    return true
                end

                if daily and isInArray(daily.monsters_list, creature:getName()) then
                    if os.time() >= 0 then
                        local dailyCount = member:getStorageValue(taskSystem_storages[5])
                        if dailyCount < daily.count then
                            member:setStorageValue(taskSystem_storages[5], dailyCount + 1)
                            if member:getStorageValue(taskSystem_storages[8]) <= 0 then
                                member:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Daily Task System] Defeated: [" .. (dailyCount + 1) .. "/" .. daily.count .. "] monsters for the daily task: " .. daily.name .. ".")
                                member:setStorageValue(taskSystem_storages[9], member:getStorageValue(taskSystem_storages[9]))
                            end
                                if dailyCount + 1 >= daily.count then
                                member:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Daily Task System] Congratulations! You completed the daily task: " .. daily.name .. ", return to the NPC to claim your reward.")
                                member:setStorageValue(taskSystem_storages[9], 1)
                                return true
                            end
                            return true
                        end
                        return true
                    else
                        member:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Daily Task System] Sorry, but you didn't finish the Daily Task in time! Please return to the NPC to start a new Daily Task.")
                        return true
                    end
                    return true
                end
            end
        end
    end
    return true
end

taskSystemEvent:register()

--[[

local taskSystemEventDeath = EventCallback("taskSystemEventDeath")

taskSystemEventDeath.monsterOnSpawn = function(monster, position)
    monster:registerEvent("taskSystem")
	return true
end

taskSystemEventDeath:register()

]]--

----------------------------------------------------------------------------------------------------------------------------


local creatureEvent = CreatureEvent("taskLogin")

function creatureEvent.onLogin(player)
    player:registerEvent("taskSystem")
    return true
end

creatureEvent:register()

local talkAction = TalkAction("!task", "/task")

function talkAction.onSay(player, words, param)
    param = param:lower()
    local taskSystem = _G.taskSystem

    if isInArray({"counter", "contador"}, param) then
        player:setStorageValue(taskSystem_storages[8], player:getStorageValue(taskSystem_storages[8]) <= 0 and 1 or 0)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "[Task System] The counter has been " .. (player:getStorageValue(taskSystem_storages[8]) <= 0 and "activated" or "deactivated") .. ".")
        return true
    elseif isInArray({"daily", "diaria"}, param) then
        local dailyTasks = _G.dailyTasks
        local daily = player:getDailyTaskMission()
        if not dailyTasks[daily] or player:getStorageValue(taskSystem_storages[7]) <= 0 then
            player:sendCancelMessage("Sorry, you are not on any Daily Task.")
            return true
        elseif player:getStorageValue(taskSystem_storages[6]) - os.time() <= 0 and player:getStorageValue(taskSystem_storages[5]) < dailyTasks[daily].count then
            player:showTextDialog("Sorry, but you didn't finish the Daily Task in time! Please return to the NPC to start a new Daily Task.")
            return true
        end
        local taskInfo = "[->] CURRENT DAILY TASK INFO [<-]\n\nName: " .. dailyTasks[daily].name .. "\nProgress: [" .. (player:getStorageValue(taskSystem_storages[5]) < 0 and 0 or player:getStorageValue(taskSystem_storages[5])) .. "/" .. dailyTasks[daily].count .. "]\nDeadline: " .. os.date("%d %B %Y %X", player:getStorageValue(taskSystem_storages[6])) .. "\nMonsters to Hunt: " .. getMonsterFromList(dailyTasks[daily].monsters_list) .. "\n\n[->] CURRENT TASK REWARDS [<-]\n\nMoney: " .. (dailyTasks[daily].money > 0 and dailyTasks[daily].money or 0) .. "\nExperience: " .. (dailyTasks[daily].exp > 0 and dailyTasks[daily].exp or 0) .. "\nTask Points: " .. dailyTasks[daily].points .. "\nItems: " .. (#dailyTasks[daily].reward > 0 and getItemsFromList(dailyTasks[daily].reward) or "No reward items") .. "."
        return player:showTextDialog(34238, taskInfo)
    end

    local task = player:getTaskMission()
    if not taskSystem[task] or player:getStorageValue(taskSystem[task].start) <= 0 then
        player:sendCancelMessage("You are not on any task.")
        return true
    end

    local taskInfo = "-> CURRENT TASK [" .. task .. "/" .. #taskSystem .. "] <-\n\nTask Name: " .. taskSystem[task].name .. "\nTask Level: " .. taskSystem[task].level .. "\nTask Progress: [" .. (player:getStorageValue(taskSystem_storages[3]) < 0 and 0 or player:getStorageValue(taskSystem_storages[3])) .. "/" .. taskSystem[task].count .. "]\nMonster To Hunt: " .. getMonsterFromList(taskSystem[task].monsters_list) .. ".\nItems for Delivery: " .. (#taskSystem[task].items > 0 and getItemsFromList(taskSystem[task].items) or "None") .. ".\n\n[->] CURRENT TASK REWARDS [<-]\n\nReward Money: " .. (taskSystem[task].money > 0 and taskSystem[task].money or 0) .. "\nReward Experience: " .. (taskSystem[task].exp > 0 and taskSystem[task].exp or 0) .. "\nReward Points: " .. taskSystem[task].points .. "\nReward Items: " .. (#taskSystem[task].reward > 0 and getItemsFromList(taskSystem[task].reward) or "No reward items") .. "."
    return player:showTextDialog(34238, taskInfo)
end

talkAction:separator(" ")
talkAction:groupType("normal")
talkAction:register()