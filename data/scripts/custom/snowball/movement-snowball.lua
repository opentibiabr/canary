local snowball = MoveEvent()
function snowball.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if item:getActionId() == 10101 then
		table.insert(CACHE_GAMEPLAYERS, player:getId())
		player:teleportTo(SnowBallConfig.Area_Configurations.Position_WaitRoom)
	elseif item:getActionId() == 10102 then
		player:teleportTo(player:getTown():getTemplePosition())
		for pos, players in ipairs(CACHE_GAMEPLAYERS) do
			if player:getId() == players then
				table.remove(CACHE_GAMEPLAYERS, pos)
				return true
			end
		end
	end
	return true
end

snowball:aid(10101, 10102)
snowball:register()
