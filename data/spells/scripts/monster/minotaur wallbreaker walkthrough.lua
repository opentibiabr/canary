local condition = Condition(CONDITION_REGENERATION, CONDITIONID_DEFAULT)
condition:setParameter(CONDITION_PARAM_SUBID, 88888)
condition:setParameter(CONDITION_PARAM_TICKS, 10 * 1000)
condition:setParameter(CONDITION_PARAM_HEALTHGAIN, 0.01)
condition:setParameter(CONDITION_PARAM_HEALTHTICKS, 10 * 1000)

local function changeSpeeds(cid, var)
	local creature = Creature(cid)
	if not creature then
		return
	end
	creature:changeSpeed(creature:getBaseSpeed())
end

function onCastSpell(creature, var)
    local nextPosition = creature:getPosition()
	local speed = creature:getSpeed()
	local tile = Tile(nextPosition.x - 1, nextPosition.y, nextPosition.z)
	local topCreature = tile:getTopCreature()
	if not creature:getCondition(CONDITION_REGENERATION, CONDITIONID_DEFAULT, 88888) then
		creature:addCondition(condition)
		creature:teleportTo(Position(nextPosition.x - 1, nextPosition.y, nextPosition.z), true)
		creature:changeSpeed(-speed)
		addEvent(changeSpeeds, 11 * 1000, creature:getId(), var)
		if not topCreature then
			return
		end
		if topCreature:isPlayer() then
			topCreature:teleportTo(Position(nextPosition.x - 3, nextPosition.y, nextPosition.z), true)
		else
		end
	end
    return true
end
