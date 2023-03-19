local portalReward = MoveEvent()
function portalReward.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return false
	end
	if player:getStorageValue(Storage.Quest.U12_40.SoulWar.GoshnarMegalomaniaKilled) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only warriors who defeated Goshnar's Megalomania can access this area.")
		player:teleportTo(fromPosition, true)
		return false
	end
	
		player:teleportTo(Position(33621, 31411, 10))
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		return true
end

portalReward:type("stepin")
portalReward:position({x = 33621, y = 31416, z = 10})
portalReward:register()
