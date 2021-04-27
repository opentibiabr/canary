local setting = {
	-- west entrance
	[4244] = {
		sacrificePosition = Position(32859, 31056, 9),
		pushPosition = Position(32856, 31054, 9),
		destination = Position(32860, 31061, 9)
	},
	--east entrance
	[4245] = {
		sacrificePosition = Position(32894, 31044, 9),
		pushPosition = Position(32895, 31046, 9),
		destination = Position(32888, 31044, 9)
	}
}

local yalaharDemon = MoveEvent()

function yalaharDemon.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local flame = setting[item.actionid]
	if not flame then
		return true
	end

	local sacrificeId, sacrifice = Tile(flame.sacrificePosition):getThing(1).itemid, true
	if not isInArray({8298, 8299, 8302, 8303}, sacrificeId) then
		sacrifice = false
	end

	if not sacrifice then
		player:teleportTo(flame.pushPosition)
		position:sendMagicEffect(CONST_ME_ENERGYHIT)
		flame.pushPosition:sendMagicEffect(CONST_ME_ENERGYHIT)
		return true
	end

	local soilItem = Tile(flame.sacrificePosition):getItemById(sacrificeId)
	if soilItem then
		soilItem:remove()
	end

	player:teleportTo(flame.destination)
	position:sendMagicEffect(CONST_ME_HITBYFIRE)
	flame.sacrificePosition:sendMagicEffect(CONST_ME_HITBYFIRE)
	flame.destination:sendMagicEffect(CONST_ME_HITBYFIRE)
	return true
end

yalaharDemon:type("stepin")

for index, value in pairs(setting) do
	yalaharDemon:aid(index)
end

yalaharDemon:register()
