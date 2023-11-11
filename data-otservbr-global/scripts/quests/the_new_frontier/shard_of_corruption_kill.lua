local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local shardOfCorruptionKill = CreatureEvent("ShardOfCorruptionDeath")

function shardOfCorruptionKill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(TheNewFrontier.Questline) == 11 then
			player:setStorageValue(TheNewFrontier.Questline, 12)
		end
	end)
	return true
end

shardOfCorruptionKill:register()
