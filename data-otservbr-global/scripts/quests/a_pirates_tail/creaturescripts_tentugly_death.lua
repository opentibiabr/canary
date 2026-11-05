local tentuglysHeadDeath = CreatureEvent("TentuglysHeadDeath")

local function rewardPlayer(player)
	player:setStorageValue(Storage.Quest.U12_60.APiratesTail.TentuglyKilled, 1) -- Access to wreckoning
	player:addAchievement("Release the Kraken")
	if not player:hasMount(175) then
		player:addMount(175)
	end
end

function tentuglysHeadDeath.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	if not creature or not creature:getMonster() then
		return
	end

	local participantIds = {}
	if TentuglyFight and TentuglyFight.collectParticipants then
		for playerId, _ in pairs(TentuglyFight.collectParticipants(creature)) do
			participantIds[playerId] = true
		end
	else
		for playerId, _ in pairs(creature:getMonster():getDamageMap()) do
			participantIds[playerId] = true
		end
	end

	for playerId, _ in pairs(participantIds) do
		local player = Player(playerId)
		if player then
			rewardPlayer(player)
		end
	end
end

tentuglysHeadDeath:register()
