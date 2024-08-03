local bosses = {
	["goshnar's malice"] = { storage = Storage.Quest.U12_40.SoulWar.GoshnarMaliceKilled },
	["goshnar's hatred"] = { storage = Storage.Quest.U12_40.SoulWar.GoshnarHatredKilled },
	["goshnar's spite"] = { storage = Storage.Quest.U12_40.SoulWar.GoshnarSpiteKilled },
	["goshnar's cruelty"] = { storage = Storage.Quest.U12_40.SoulWar.GoshnarCrueltyKilled },
	["goshnar's greed"] = { storage = Storage.Quest.U12_40.SoulWar.GoshnarGreedKilled },
	["goshnar's megalomania"] = { storage = Storage.Quest.U12_40.SoulWar.GoshnarMegalomaniaKilled },
}

local bossesSoulWar = CreatureEvent("SoulwarsBossDeath")
function bossesSoulWar.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		if bossConfig.storage then
			player:setStorageValue(bossConfig.storage, 1)
		end
	end)
	return true
end

bossesSoulWar:register()
