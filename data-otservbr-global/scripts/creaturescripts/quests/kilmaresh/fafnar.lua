local monster = {
	["burning gladiator"] = Storage.Kilmaresh.Thirteen.Fafnar,
	["priestess of the wild sun"] = Storage.Kilmaresh.Thirteen.Fafnar,
}

local fafnar = CreatureEvent("FafnarMissionsDeath")

function fafnar.onDeath(creature, _corpse, _lastHitKiller, mostDamageKiller)
	local storage = monster[creature:getName():lower()]
	if not storage then
		return false
	end

	onDeathForParty(creature, mostDamageKiller, function(creature, player)
		local kills = player:getStorageValue(storage)
		if kills == 300 then
			player:say("You slayed " .. creature:getName() .. ".", TALKTYPE_MONSTER_SAY)
			player:setStorageValue(storage, 301)
		elseif kills < 300 then
			kills = kills + 1
			player:setStorageValue(storage, kills)
		end
	end)

	return true
end

fafnar:register()
