local spell = Spell("instant")

local smokeArray = {
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 1, 3, 1, 0, 0 },
	{ 0, 0, 0, 1, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0 },
	{ 0, 0, 0, 0, 0, 0, 0 },
}

local smokeCombat = Combat()
smokeCombat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_GREENSMOKE)
smokeCombat:setArea(createCombatArea(smokeArray))

function spell.onCastSpell(creature, var)
	local pos = creature:getPosition()

	local target = Creature(var:getNumber())
	local tarPos = target:getPosition()
	local direction = target:getDirection()
	local pos1
	local pos2
	local pos3
	if direction == 0 then
		pos1 = Position(tarPos.x, tarPos.y + 1, tarPos.z)
		pos2 = Position(tarPos.x + 1, tarPos.y + 1, tarPos.z)
		pos3 = Position(tarPos.x - 1, tarPos.y + 1, tarPos.z)
	elseif direction == 1 then
		pos1 = Position(tarPos.x - 1, tarPos.y, tarPos.z)
		pos2 = Position(tarPos.x - 1, tarPos.y + 1, tarPos.z)
		pos3 = Position(tarPos.x - 1, tarPos.y - 1, tarPos.z)
	elseif direction == 2 then
		pos1 = Position(tarPos.x, tarPos.y - 1, tarPos.z)
		pos2 = Position(tarPos.x - 1, tarPos.y - 1, tarPos.z)
		pos3 = Position(tarPos.x + 1, tarPos.y - 1, tarPos.z)
	elseif direction == 3 then
		pos1 = Position(tarPos.x + 1, tarPos.y, tarPos.z)
		pos2 = Position(tarPos.x + 1, tarPos.y - 1, tarPos.z)
		pos3 = Position(tarPos.x + 1, tarPos.y + 1, tarPos.z)
	end

	if Tile(pos1) and Tile(pos1):isWalkable(true, true, true, true) then
		smokeCombat:execute(creature, Variant(pos))
		creature:teleportTo(pos1)
	elseif Tile(pos2) and Tile(pos2):isWalkable(true, true, true, true) then
		smokeCombat:execute(creature, Variant(pos))
		creature:teleportTo(pos2)
	elseif Tile(pos3) and Tile(pos3):isWalkable(true, true, true, true) then
		smokeCombat:execute(creature, Variant(pos))
		creature:teleportTo(pos3)
	end

	return
end

spell:name("teleport strike")
spell:words("###6048")
spell:needLearn(true)
spell:cooldown("2000")
spell:isSelfTarget(false)
spell:needTarget(true)
spell:register()
