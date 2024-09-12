local bosses = {
	["sir baeloc"] = { storage = Storage.Quest.U12_20.GraveDanger.Bosses.BaelocNictrosKilled },
	["count vlarkorth"] = { storage = Storage.Quest.U12_20.GraveDanger.Bosses.CountVlarkorthKilled },
	["duke krule"] = { storage = Storage.Quest.U12_20.GraveDanger.Bosses.DukeKruleKilled },
	["earl osam"] = { storage = Storage.Quest.U12_20.GraveDanger.Bosses.EarlOsamKilled },
	["lord azaram"] = { storage = Storage.Quest.U12_20.GraveDanger.Bosses.LordAzaramKilled },
	["king zelos"] = { storage = Storage.Quest.U12_20.GraveDanger.Bosses.KingZelosKilled },
}

local bossesGraveDanger = CreatureEvent("GraveDangerBossDeath")
function bossesGraveDanger.onDeath(creature)
	local bossConfig = bosses[creature:getName():lower()]
	if not bossConfig then
		return true
	end
	onDeathForDamagingPlayers(creature, function(creature, player)
		if bossConfig.storage then
			player:setStorageValue(bossConfig.storage, 1)
		end
		local bossesKilled = 0
		for value in pairs(bosses) do
			if player:getStorageValue(bosses[value].storage) > 0 then
				bossesKilled = bossesKilled + 1
			end
		end
		if bossesKilled >= 5 then -- number of mini bosses
			player:setStorageValue(Storage.Quest.U12_20.GraveDanger.Bosses.KingZelosDoor, 1)
		end
	end)
	return true
end

bossesGraveDanger:register()
