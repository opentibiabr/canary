local config = {
	[31077] = {requireSoil = false, toPosition = Position(32908, 31081, 7), effect = CONST_ME_ENERGYHIT},
	[31080] = {requireSoil = true, pushbackPosition = Position(32908, 31081, 7), toPosition = Position(32908, 31076, 7), effect = CONST_ME_ENERGYHIT},
	[31081] = {requireSoil = true, pushbackPosition = Position(32906, 31080, 7), toPosition = Position(32908, 31085, 7), effect = CONST_ME_HITBYFIRE},
	[31084] = {requireSoil = false, toPosition = Position(32906, 31080, 7), effect = CONST_ME_HITBYFIRE}
}

local magicianQuarter = MoveEvent()

function magicianQuarter.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local targetWall = config[fromPosition.y]
	if not targetWall then
		return true
	end

	if targetWall.requireSoil then
		if not (player:removeItem(8298, 1) or player:removeItem(8299, 1) or player:removeItem(8302, 1) or player:removeItem(8303, 1)) then
			player:teleportTo(targetWall.pushbackPosition)
			player:say('You may not enter without a sacrifice of elemental soil.', TALKTYPE_MONSTER_SAY)
			targetWall.pushbackPosition:sendMagicEffect(targetWall.effect)
			return true
		end
	end

	player:teleportTo(targetWall.toPosition)
	targetWall.toPosition:sendMagicEffect(targetWall.effect)
	return true
end

magicianQuarter:type("stepin")
magicianQuarter:aid(7813)
magicianQuarter:register()
