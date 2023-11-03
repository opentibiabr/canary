local bosses = {
	["jaul"] = { status = 2, storage = Storage.DeeplingBosses.Jaul },
	["tanjis"] = { status = 3, storage = Storage.DeeplingBosses.Tanjis },
	["obujos"] = { status = 4, storage = Storage.DeeplingBosses.Obujos },
}

local deeplingBosses = CreatureEvent("DeeplingBossDeath")
function deeplingBosses.onDeath(player, creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.DeeplingBosses.DeeplingStatus) < bossConfig.status then
			player:setStorageValue(Storage.DeeplingBosses.DeeplingStatus, bossConfig.status)
		end
		player:setStorageValue(bossConfig.storage, 1)
	end)
end

deeplingBosses:register()
