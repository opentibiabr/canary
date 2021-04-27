local setting = {
	[12382] = {
		storage = Storage.WrathoftheEmperor.Questline,
		toPosition = {Position(33078, 31219, 8), Position(33216, 31069, 9)}
	},
	[12383] = {
		storage = Storage.WrathoftheEmperor.Questline,
		toPosition = {Position(33216, 31069, 9), Position(33078, 31219, 8)}
	}
}

local teleportRebelToZlak = MoveEvent()

function teleportRebelToZlak.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetTile = setting[item.actionid]
	if not targetTile then
		return true
	end

	local hasStorageValue = player:getStorageValue(targetTile.storage) >= 23
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:teleportTo(targetTile.toPosition[hasStorageValue and 1 or 2])
	player:teleportTo(targetTile.toPosition[1])
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)

	if not hasStorageValue then
		player:say("This portal is not activated", TALKTYPE_MONSTER_SAY)
	end
	return true
end

teleportRebelToZlak:type("stepin")

for index, value in pairs(setting) do
	teleportRebelToZlak:aid(index)
end

teleportRebelToZlak:register()
