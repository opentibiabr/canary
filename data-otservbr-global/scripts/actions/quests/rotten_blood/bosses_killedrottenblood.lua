local bosses = {
	["murcion"] = { storage = Storage.Quest.U12_40.SoulWar.MurcionKilled },
	["vemiath"] = { storage = Storage.Quest.U12_40.SoulWar.VemiathKilled },
	["chagorz"] = { storage = Storage.Quest.U12_40.SoulWar.ChagorzKilled },
	["ichgahal"] = { storage = Storage.Quest.U12_40.SoulWar.IchgahalKilled },
	["bakragore"] = { storage = Storage.Quest.U12_40.SoulWar.BakragoreKilled },

}

local bossesRottenBlood = CreatureEvent("RottenbloodBossDeath")
function bossesRottenBlood.onDeath(creature)
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

bossesRottenBlood:register()
