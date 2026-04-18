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

	local emptyCount = player:getItemCount(TwentyYearsACookQuest.TheRestOfRatha.Items.EmptySpiritFlask)
	local fullCount = player:getItemCount(TwentyYearsACookQuest.TheRestOfRatha.Items.FullSpiritFlask)
	if emptyCount and emptyCount > 0 then
		player:removeItem(TwentyYearsACookQuest.TheRestOfRatha.Items.EmptySpiritFlask, emptyCount)
	end
	if fullCount and fullCount > 0 then
		player:removeItem(TwentyYearsACookQuest.TheRestOfRatha.Items.FullSpiritFlask, 1)
	end

	player:removeIcon("the-rest-of-ratha")
	return true
end

theRestOfRathaZoneEvent:register()
