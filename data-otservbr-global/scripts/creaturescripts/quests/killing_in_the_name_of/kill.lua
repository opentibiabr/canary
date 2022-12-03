local taskBoss = {
	[0] = "the snapper",
	[1] = "hide",
	[2] = "deathbine",
	[3] = "the bloodtusk",
	[4] = "shardhead",
	[5] = "esmeralda",
	[6] = "fleshcrawler",
	[7] = "ribstride",
	[8] = "the bloodweb",
	[9] = "thul",
	[10] = "the old widow",
	[11] = "hemming",
	[12] = "tormentor",
	[13] = "flameborn",
	[14] = "fazzrah",
	[15] = "tromphonyte",
	[16] = "sulphur scuttler",
	[17] = "bruise payne",
	[18] = "the many",
	[19] = "the noxious spawn",
	[20] = "gorgo",
	[21] = "stonecracker",
	[22] = "leviathan",
	[23] = "kerberos",
	[24] = "ethershreck",
	[25] = "paiz the pauperizer",
	[26] = "bretzecutioner",
	[27] = "zanakeph",
	[28] = "tiquandas revenge",
	[29] = "demodras",
	[30] = "necropharus",
	[31] = "the horned fox"
}
local function killCheck(player, targetName, taskName, taskStage, taskInfo, taskAltKillCount, taskkillCount)
	if player:getStorageValue(taskName) == taskStage then
		if isInArray(taskInfo, targetName) then
			for k = 1, #taskInfo do
				if targetName == taskInfo[k] then
					player:setStorageValue(taskAltKillCount + k - 1, player:getStorageValue(taskAltKillCount + k - 1) + 1)
				end
			end
			player:setStorageValue(taskkillCount, player:getStorageValue(taskkillCount) + 1)
			player:setStorageValue(taskName, player:getStorageValue(taskName)) -- fake update quest tracker
		end
	end
end
local killCounter = Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.KillCount
local BossKillCount = Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.SnapperCount
local killingInTheNameOfKill = CreatureEvent("KillingInTheNameOfKill")
function killingInTheNameOfKill.onKill(player, target)
	if target:isPlayer() or target:getMaster() then
		return true
	end
	local targetName, startedTasks, taskId = target:getName():lower(), player:getStartedTasks()
	for i = 1, #startedTasks do
		taskId = startedTasks[i]
		if isInArray(tasks.GrizzlyAdams[taskId].creatures, targetName) then
			if #tasks.GrizzlyAdams[taskId].creatures > 1 then
				for a = 1, #tasks.GrizzlyAdams[taskId].creatures do
					if targetName == tasks.GrizzlyAdams[taskId].creatures[a] then
						if tasks.GrizzlyAdams[taskId].raceName == "Apes" then
							local apes = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.KongraCount + a - 1
							player:setStorageValue(apes, player:getStorageValue(apes) + 1)
						elseif	tasks.GrizzlyAdams[taskId].raceName == "Quara Scouts" then
							local scouts = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraConstrictorScoutCount + a - 1
							player:setStorageValue(scouts, player:getStorageValue(scouts) + 1)
						elseif	tasks.GrizzlyAdams[taskId].raceName == "Underwater Quara" then
							local underwater = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraConstrictorCount + a - 1
							player:setStorageValue(underwater, player:getStorageValue(underwater) + 1)
						elseif	tasks.GrizzlyAdams[taskId].raceName == "Nightmares" then
							local nightmares = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NightmareCount + a - 1
							player:setStorageValue(nightmares, player:getStorageValue(nightmares) + 1)
						elseif	tasks.GrizzlyAdams[taskId].raceName == "High Class Lizards" then
							local lizards = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardChosenCount + a - 1
							player:setStorageValue(lizards, player:getStorageValue(lizards) + 1)
						elseif	tasks.GrizzlyAdams[taskId].raceName == "Sea Serpents" then
							local serpents = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.SeaSerpentCount + a - 1
							player:setStorageValue(serpents, player:getStorageValue(serpents) + 1)
						elseif	tasks.GrizzlyAdams[taskId].raceName == "Drakens" then
							local drakens = Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenAbominationCount + a - 1
							player:setStorageValue(drakens, player:getStorageValue(drakens) + 1)
						end
					end
				end
			end
			local killAmount = player:getStorageValue(killCounter + taskId)
			player:setStorageValue(killCounter + taskId, killAmount + 1)
			player:setStorageValue(KILLSSTORAGE_BASE + taskId, player:getStorageValue(KILLSSTORAGE_BASE + taskId)) -- fake update quest tracker
		end
	end
	for j = 0, #taskBoss do
		if targetName == taskBoss[j] then
			if player:getStorageValue(BossKillCount + j) == 0 then
				player:setStorageValue(BossKillCount + j, 1)
			end
		end
	end
-- Minotaurs
	killCheck(player, targetName, Storage.KillingInTheNameOf.BudrikMinos, 0, tasks.Budrik[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MinotaurCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.MinotaurCount)
-- Necromancers and Priestesses
	killCheck(player, targetName, Storage.KillingInTheNameOf.LugriNecromancers, 0, tasks.Lugri[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NecromancerCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount)
	killCheck(player, targetName, Storage.KillingInTheNameOf.LugriNecromancers, 3, tasks.Lugri[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NecromancerCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.NecromancerCount)
-- Green Djinns or Efreets
	killCheck(player, targetName, Storage.KillingInTheNameOf.GreenDjinnTask, 0, tasks.Gabel[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GreenDjinnCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GreenDjinnCount)
-- Blue Djinns or Marids
	killCheck(player, targetName, Storage.KillingInTheNameOf.BlueDjinnTask, 0, tasks.Malor[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.BlueDjinnCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.BlueDjinnCount)
-- Pirates
	killCheck(player, targetName, Storage.KillingInTheNameOf.PirateTask, 0, tasks.RaymondStriker[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.PirateMarauderCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.PirateCount)
-- Trolls
	killCheck(player, targetName, Storage.KillingInTheNameOf.TrollTask, 0, tasks.DanielSteelsoul[1].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.TrollCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.TrollCount)
-- Goblins
	killCheck(player, targetName, Storage.KillingInTheNameOf.GoblinTask, 0, tasks.DanielSteelsoul[2].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.GoblinCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.GoblinCount)
-- Rotworms
	killCheck(player, targetName, Storage.KillingInTheNameOf.RotwormTask, 0, tasks.DanielSteelsoul[3].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.RotwormCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.RotwormCount)
-- Cyclops
	killCheck(player, targetName, Storage.KillingInTheNameOf.CyclopsTask, 0, tasks.DanielSteelsoul[4].creatures, Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.CyclopsCount, Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.CyclopsCount)
	return true
end

killingInTheNameOfKill:register()
