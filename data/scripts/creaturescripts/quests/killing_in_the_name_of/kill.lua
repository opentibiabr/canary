local killingInTheNameOfKill = CreatureEvent("KillingInTheNameOfKill")
function killingInTheNameOfKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end

	local targetName, startedTasks, taskId = target:getName():lower(), player:getStartedTasks()
	for i = 1, #startedTasks do
		taskId = startedTasks[i]
		if isInArray(tasks[taskId].creatures, targetName) then
			local killAmount = player:getStorageValue(KILLSSTORAGE_BASE + taskId)
			if killAmount < tasks[taskId].killsRequired then
				-- Set max kills to adm
				if (player:getAccountType() >= ACCOUNT_TYPE_GOD) then
					player:setStorageValue(KILLSSTORAGE_BASE + taskId, tasks[taskId].killsRequired)
					return true
				end

				player:setStorageValue(KILLSSTORAGE_BASE + taskId, killAmount + 1)
			end
		end
	end

	if(isMonster(target)) then
		local killAmount = player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount)
		if(string.lower(getCreatureName(target)) == "necromancer") and killAmount < 4000 and player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount, killAmount + 1)

		elseif(string.lower(getCreatureName(target)) == "priestess") and killAmount < 4000 and player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount, killAmount + 1)

		elseif(string.lower(getCreatureName(target)) == "blood priest") and killAmount < 4000 and player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount, killAmount + 1)

		elseif(string.lower(getCreatureName(target)) == "blood hand") and killAmount < 4000 and player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount, killAmount + 1)

		elseif(string.lower(getCreatureName(target)) == "shadow pupil") and killAmount < 4000 and player:getStorageValue(Storage.KillingInTheNameOf.LugriNecromancers) == 1 then
			player:setStorageValue(Storage.KillingInTheNameOf.LugriNecromancerCount, killAmount + 1)
		end
	end
	return true
end

killingInTheNameOfKill:register()
