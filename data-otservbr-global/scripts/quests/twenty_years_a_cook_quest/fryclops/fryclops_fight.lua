local fryclopsZoneEvent = ZoneEvent(TwentyYearsACookQuest.Fryclops.BossZone)
function fryclopsZoneEvent.afterEnter(_zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	player:setIcon("fryclops", CreatureIconCategory_Quests, CreatureIconQuests_GreenBall, 200)
	return true
end

function fryclopsZoneEvent.afterLeave(zone, creature)
	local player = creature:getPlayer()
	if not player then
		return false
	end

	local axeCount = player:getItemCount(TwentyYearsACookQuest.Fryclops.Items.Axe)
	if axeCount and axeCount > 0 then
		player:removeItem(TwentyYearsACookQuest.Fryclops.Items.Axe, axeCount)
	end

	player:removeIcon("fryclops")

	if #zone:getPlayers() == 0 then
		TwentyYearsACookQuest.Fryclops.Catapult.UpdateCatapultItems(false)
	end

	return true
end

fryclopsZoneEvent:register()
