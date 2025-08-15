local monsters = {
	[1] = { pos = Position(32810, 32664, 14) },
	[2] = { pos = Position(32815, 32664, 14) },
}

local function functionBack(pos, oldPos)
	local position = Position(pos)
	if not position then
		return
	end

	local tile = Tile(position)
	if not tile then
		return
	end

	local guardian = tile:getTopCreature()
	if not guardian then
		return
	end

	local haveGuardianMonster = false
	local spectator1 = nil

	local spectators1 = Game.getSpectators(Position(32813, 32664, 14), false, false, 15, 15, 15, 15)
	for index = 1, #spectators1 do
		spectator1 = spectators1[index]
		if spectator1 then
			if spectator1:isMonster() and spectator1:getName():lower() == "the blazing time guardian" or spectator1:getName():lower() == "the freezing time guardian" then
				oldPos = spectator1:getPosition()
				haveGuardianMonster = true
			end
		end
	end

	if not haveGuardianMonster then
		guardian:remove()
		return true
	end

	local diference = 0
	local spectator = nil

	local spectators2, spectator2 = Game.getSpectators(Position(32813, 32664, 14), false, false, 15, 15, 15, 15)
	for i = 1, #spectators2 do
		spectator2 = spectators2[i]
		if spectator2 then
			if spectator2:isMonster() and spectator2:getName():lower() == "the blazing time guardian" or spectator2:getName():lower() == "the freezing time guardian" then
				spectator2:teleportTo(position)
				diference = guardian:getHealth() - spectator2:getHealth()
			end
		end
	end

	if diference > 0 then
		guardian:addHealth(-diference)
	end

	guardian:teleportTo(oldPos)
end

local spell = Spell("instant")

function spell.onCastSpell(creature, var)
	local monsterPos = creature:getPosition()
	if monsterPos.z ~= 14 then
		return true
	end

	local index = math.random(1, 2)
	local position = monsters[index].pos
	if position then
		local tile = Tile(position)
		if not tile then
			return true
		end

		local form = tile:getTopCreature()
		if not form then
			return true
		end

		creature:teleportTo(position)

		local diference = form:getHealth() - creature:getHealth()
		if diference and diference > 0 then
			form:addHealth(-diference)
		end

		form:teleportTo(monsterPos)
		addEvent(functionBack, 30 * 1000, position, monsterPos)
	end

	return true
end

spell:name("time guardiann")
spell:words("###441")
spell:isAggressive(true)
spell:blockWalls(true)
spell:needLearn(true)
spell:register()
