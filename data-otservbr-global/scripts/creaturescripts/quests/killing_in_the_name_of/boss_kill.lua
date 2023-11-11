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
	[31] = "the horned fox",
}

local bossKillCount = Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.SnapperCount

local deathEvent = CreatureEvent("KillingInTheNameOfBossDeath")
function deathEvent.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local targetName = creature:getName():lower()

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		for i, bossName in ipairs(taskBoss) do
			if targetName == bossName then
				if player:getStorageValue(bossKillCount + i) == 0 then
					player:setStorageValue(bossKillCount + i, 1)
				end
				return true
			end
		end
	end)
	return true
end

deathEvent:register()

local serverstartup = GlobalEvent("KillingInTheNameOfBossDeathStartup")
function serverstartup.onStartup()
	for _, bossName in pairs(taskBoss) do
		local mType = MonsterType(bossName)
		if not mType then
			logger.error("[KillingInTheNameOfBossDeathStartup] boss with name {} is not a valid MonsterType", bossName)
		else
			mType:registerEvent("KillingInTheNameOfBossDeath")
		end
	end
end
serverstartup:register()
