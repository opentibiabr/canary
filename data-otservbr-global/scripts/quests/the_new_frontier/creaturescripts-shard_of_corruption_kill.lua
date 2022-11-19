local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier

local shardOfCorruptionKill = CreatureEvent("ShardOfCorruptionKill")

function shardOfCorruptionKill.onKill(creature, target)
	local targetMonster = target:getMonster()
	if not targetMonster then
		return true
	end

	if targetMonster:getName():lower() ~= 'shard of corruption' then
		return true
	end

	local player = creature:getPlayer()
	if player:getStorageValue(TheNewFrontier.Questline) == 11 then
		player:setStorageValue(TheNewFrontier.Questline, 12)
	end
	return true
end

shardOfCorruptionKill:register()
