-- The Rookie Guard Quest - Mission 03: A Rational Request

-- Mission Kills

local ratKill = CreatureEvent("RationalRequestRatDeath")

function ratKill.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		if player:getStorageValue(Storage.Quest.U9_1.TheRookieGuard.Mission03) == 1 then
			local counter = player:getStorageValue(Storage.Quest.U9_1.TheRookieGuard.RatKills)
			if counter < 5 then
				player:setStorageValue(Storage.Quest.U9_1.TheRookieGuard.RatKills, counter + 1)
			end
		end
	end)
	return true
end

ratKill:register()
