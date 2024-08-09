local teleports = {
	[3189] = {
		destination = Position(33041, 31086, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Fury,
	},
	[3190] = {
		destination = Position(33091, 31083, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Wrath,
	},
	[3191] = {
		destination = Position(33094, 31118, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Scorn,
	},
	[3192] = {
		destination = Position(33038, 31119, 15),
		storage = Storage.Quest.U8_6.WrathOfTheEmperor.Bosses.Spite,
	},
}

local bossTeleport = MoveEvent()

function bossTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = teleports[item.uid]
	if not teleport then
		return true
	end

	if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Wote10) == 1 then
		player:teleportTo(teleport.destination)
		teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.BossStatus) == 5 then
		local destination = Position(33072, 31151, 15)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:teleportTo(destination)
		destination:sendMagicEffect(CONST_ME_TELEPORT)
		return true
	end

	local expectedStatus = item.uid - 3188

	if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.BossStatus) ~= expectedStatus then
		player:teleportTo(fromPosition, true)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Go to another Teleport or take mission with Zizzle.")
		return true
	end

	if Game.getStorageValue(teleport.storage) ~= 1 then
		player:teleportTo(teleport.destination)
		teleport.destination:sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(teleport.destination)
	end

	return true
end

bossTeleport:type("stepin")

for index, value in pairs(teleports) do
	bossTeleport:uid(index)
end

bossTeleport:register()
