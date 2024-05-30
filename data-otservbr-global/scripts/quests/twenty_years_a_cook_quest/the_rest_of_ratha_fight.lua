local theRestOfRathaZoneEvent = ZoneEvent(TwentyYearsACookQuest.TheRestOfRatha.BossZone)
function theRestOfRathaZoneEvent.afterEnter(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:setIcon("the-rest-of-ratha", CreatureIconCategory_Quests, CreatureIconQuests_Dove, 3)
	return true
end

function theRestOfRathaZoneEvent.afterLeave(zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	if not zone:getPlayers() then
		TwentyYearsACookQuest.TheRestOfRatha.SpiritContainerPoints = 0
	end

	player:removeIcon("the-rest-of-ratha")
	return true
end

theRestOfRathaZoneEvent:register()