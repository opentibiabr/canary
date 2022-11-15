local config = {
	[4226] = {premium = true, destination = Position(32243, 32598, 8)},
	[4227] = {destination = Position(32624, 31855, 11)},
	[4228] = {level = 80, destination = Position(32228, 32596, 8)},
	[4229] = {destination = Position(32237, 32605, 8)},
	[4230] = {level = 80, destination = Position(32243, 32619, 9)},
	[4231] = {destination = Position(32237, 32605, 9)},
	[4232] = {level = 80, destination = Position(32240, 32620, 10)},
	[4233] = {destination = Position(32237, 32605, 10)},
	[4234] = {level = 80, destination = Position(32227, 32598, 11)},
	[4235] = {destination = Position(32237, 32605, 11)},
	[4236] = {level = 80, destination = Position(32238, 32622, 12)},
	[4237] = {destination = Position(32237, 32605, 12)},
	[4238] = {level = 80, destination = Position(32244, 32619, 13)},
	[4239] = {destination = Position(32237, 32605, 13)},
	[4240] = {level = 80, destination = Position(32244, 32588, 14)},
	[4241] = {destination = Position(32237, 32605, 14)},
	[4242] = {level = 80, destination = Position(32224, 32606, 15)},
	[4243] = {destination = Position(32237, 32605, 15)}
}

local spikeTeleport = MoveEvent()

function spikeTeleport.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetPortal = config[item.actionid]
	if not targetPortal then
		return true
	end

	if targetPortal.premium then
		if not player:isPremium() then
			local toPosition = Position(32624, 31855, 11)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Only premium accounts can use this teleporter.")
			player:teleportTo(toPosition)
			position:sendMagicEffect(CONST_ME_TELEPORT)
			toPosition:sendMagicEffect(CONST_ME_TELEPORT)
			return true
		end
	end

	player:teleportTo(targetPortal.destination)
	position:sendMagicEffect(CONST_ME_TELEPORT)
	targetPortal.destination:sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

spikeTeleport:type("stepin")

for index, value in pairs(config) do
	spikeTeleport:aid(index)
end

spikeTeleport:register()
