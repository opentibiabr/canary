local svargrondArenaPlayerDeath = CreatureEvent("SvargrondArenaPlayerDeath")

function svargrondArenaPlayerDeath.onDeath(player, corpse, killer, mostDamageKiller, unjustified, mostDamageUnjustified)
	if player:getStorageValue(Storage.Quest.U8_0.BarbarianArena.PitDoor) > 0 then
		player:setStorageValue(Storage.Quest.U8_0.BarbarianArena.PitDoor, 0)
	end
end

svargrondArenaPlayerDeath:register()
