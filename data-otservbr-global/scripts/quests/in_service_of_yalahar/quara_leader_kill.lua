local quaraLeaders = {
	["inky"] = Storage.Quest.U8_4.InServiceOfYalahar.QuaraInky,
	["sharptooth"] = Storage.Quest.U8_4.InServiceOfYalahar.QuaraSharptooth,
	["splasher"] = Storage.Quest.U8_4.InServiceOfYalahar.QuaraSplasher,
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
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.QuaraState, 2)
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Questline, 41)
			-- StorageValue for Questlog 'Mission 07: A Fishy Mission'
			player:setStorageValue(Storage.Quest.U8_4.InServiceOfYalahar.Mission07, 4)
		end
	end)
	return true
end

quaraLeadersKill:register()
