local quaraLeaders = {
	["inky"] = Storage.InServiceofYalahar.QuaraInky,
	["sharptooth"] = Storage.InServiceofYalahar.QuaraSharptooth,
	["splasher"] = Storage.InServiceofYalahar.QuaraSplasher,
}

local quaraLeadersKill = CreatureEvent("QuaraLeadersDeath")
function quaraLeadersKill.onDeath(creature)
	local bossStorage = quaraLeaders[creature:getName():lower()]
	if not bossStorage then
		return true
	end

	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(bossStorage) < 1 then
			player:setStorageValue(bossStorage, 1)
			player:say("You slayed " .. creature:getName() .. ".", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(Storage.InServiceofYalahar.QuaraState, 2)
			player:setStorageValue(Storage.InServiceofYalahar.Questline, 41)
			-- StorageValue for Questlog 'Mission 07: A Fishy Mission'
			player:setStorageValue(Storage.InServiceofYalahar.Mission07, 4)
		end
	end)
	return true
end

quaraLeadersKill:register()
