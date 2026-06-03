local drumeKill = CreatureEvent("DrumeKill")

local areaMin = Position(32358, 32465, 2)
local areaMax = Position(32398, 32485, 2)

function drumeKill.onDeath(creature, corpse, lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission) == 4 then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.KesarMission, 5)
		end
	end)
	return true
end

drumeKill:register()
