local taskCreature = CreatureEvent("TaskCreature")

function taskCreature.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	local targetName = target:getName():lower()
	local data = getTaskByMonsterName(targetName)
	if data ~= false and player:hasStartedTask(data.storage) then
		if player:getStorageValue(10102) >= os.time() then
		player:addTaskKill(data.storage, 2)
		else
		player:addTaskKill(data.storage, 1)
		end
	end
	return true
end

taskCreature:register()