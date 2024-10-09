local creaturescripts_necromancer_servant = CreatureEvent("NecromancerServantDeath")

function creaturescripts_necromancer_servant.onDeath(creature)
	onDeathForDamagingPlayers(creature, function(creature, player)
		if player:getStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission57) < 1 then
			player:setStorageValue(Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission57, 1)
		end
	end)
	return true
end

creaturescripts_necromancer_servant:register()
