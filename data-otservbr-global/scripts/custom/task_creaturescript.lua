local taskCreature = CreatureEvent("TaskCreature")

function taskCreature.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if not player:isPlayer() and not player:isPlayerControlled() then
			return true
		end

		local targetName = creature:getName():lower()
		local data = getTaskByMonsterName(targetName)
		if data ~= false and player:hasStartedTask(data.storage) then
			if player:getStorageValue(10102) >= os.time() then
				player:addTaskKill(data.storage, 2)
			else
				player:addTaskKill(data.storage, 1)
			end
		end
	end)
	return true
end

taskCreature:register()

local taskCreatureStartup = GlobalEvent("TaskCreatureStartup")
function taskCreatureStartup.onStartup()
	for _, tasks in pairs(taskConfiguration) do
		if tasks.races and type(tasks.races) == "table" and next(tasks.races) ~= nil then
			for _, raceList in ipairs(tasks.races) do
			local mType = MonsterType(raceList)
			if not mType then
				logger.error("[TaskCreatureStartup] boss with name {} is not a valid MonsterType", raceList)
			else
				mType:registerEvent("TaskCreature")
			end
		end
		else
			logger.error("[TaskCreatureStartup] No valid races found for task")
		end
	end	
end
taskCreatureStartup:register()