local bosses = {
	["magma bubble"] = { storage = Storage.Quest.U12_90.PrimalOrdeal.Bosses.MagmaBubbleKilled },
	["the primal menace"] = { storage = Storage.Quest.U12_90.PrimalOrdeal.Bosses.ThePrimalMenaceKilled },
}

local bossesPrimeOrdeal = CreatureEvent("ThePrimeOrdealBossDeath")
function bossesPrimeOrdeal.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig or not bossConfig.storage then
		return true
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		player:setStorageValue(bossConfig.storage, 1)
	end)
	return true
end

bossesPrimeOrdeal:register()
