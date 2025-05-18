local setting = {
	[4530] = {
		firstStorage = Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission05,
		secondStorage = Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission06,
		firstDestination = Position(32987, 32401, 9),
		secondDestination = Position(32988, 32397, 9),
	},
	[4532] = {
		firstStorage = Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission08,
		secondStorage = Storage.Quest.U10_10.TheGravediggerOfDrefia.Mission09,
		firstDestination = Position(33022, 32334, 10),
		secondDestination = Position(33022, 32338, 10),
	},
}

local event = MoveEvent()

function event.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local teleport = setting[item.actionid]
	if teleport and player:getStorageValue(teleport.firstStorage) == 1 and player:getStorageValue(teleport.secondStorage) < 1 then
		player:teleportTo(teleport.firstDestination)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:teleportTo(teleport.secondDestination)
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
	end
	return true
end

event:type("stepin")

for index, value in pairs(setting) do
	event:aid(index)
end

event:register()
