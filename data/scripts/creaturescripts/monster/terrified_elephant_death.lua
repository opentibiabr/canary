local stampede = 283226

local terrifiedElephantDeath = CreatureEvent("TerrifiedterrifiedElephantDeath")

function terrifiedElephantDeath.onDeath(creature, corpse, killer, mostDamageKiller, lastHitUnjustified, mostDamageUnjustified)
	local player = mostDamageKiller or killer
	if not player or not player:isPlayer() then
		return true
	end

	if player:hasAchievement("Trail of the Ape God") then
		return true
	end

	local kills = player:getStorageValue(stampede)
	if kills < 0 then
		kills = 0
	end

	kills = kills + 1
	player:setStorageValue(stampede, kills)

	if kills >= 5 then
		player:addAchievement("Trail of the Ape God")
	end

	return true
end

terrifiedElephantDeath:register()
