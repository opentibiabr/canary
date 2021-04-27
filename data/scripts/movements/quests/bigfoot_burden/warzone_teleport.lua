local destinations = {
	[3140] = {teleportPosition = Position(32996, 31922, 10), storage = Storage.BigfootBurden.Warzone1Access, value = 1},
	[3141] = {teleportPosition = Position(33011, 31943, 11), storage = Storage.BigfootBurden.Warzone2Access, value = 2},
	[3142] = {teleportPosition = Position(32989, 31909, 12), storage = Storage.BigfootBurden.Warzone3Access, value = 3},
}

local warzoneTeleport = MoveEvent()

function warzoneTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local destination = destinations[item.uid]
	if not destination then
		return true
	end

	if player:getStorageValue(Storage.BigfootBurden.QuestLine) < 30 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You are not permitted to enter.")
		player:teleportTo(fromPosition)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(Storage.BigfootBurden.WarzoneStatus) < 1 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You finally have enough renown among the gnomes, \z
		ask Gnomission for a mission to fight on the warzones.")
		player:teleportTo(fromPosition)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(destination.storage) < 1 and not player:removeItem(18509, 1) then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You need a mission crystal or a job done with Gnomission to enter.")
		player:teleportTo(fromPosition)
		position:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	player:teleportTo(destination.teleportPosition)
	destination.teleportPosition:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

warzoneTeleport:type("stepin")

for index, value in pairs(destinations) do
	warzoneTeleport:uid(index)
end

warzoneTeleport:register()
