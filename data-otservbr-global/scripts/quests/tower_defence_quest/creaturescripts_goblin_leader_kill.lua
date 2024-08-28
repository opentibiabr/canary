local creaturescripts_goblin_leader_kill = CreatureEvent("GoblinLeaderDeath")

function creaturescripts_goblin_leader_kill.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) == 2 then
			player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 3)
		end
	end)

	return true
end

creaturescripts_goblin_leader_kill:register()
