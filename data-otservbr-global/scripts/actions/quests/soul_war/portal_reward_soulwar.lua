local portalReward = MoveEvent()
function portalReward.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarMegalomaniaKilled) < 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only warriors who defeated Goshnar's Megalomania can access this area.")
		player:teleportTo(fromPosition, true)
		return false
	else
		return true
	end
end

portalReward:type("stepin")
portalReward:position({x = 33621, y = 31416, z = 10})
portalReward:register()