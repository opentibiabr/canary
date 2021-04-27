local function outExplode()
	local upConer = {x = 32223, y = 31273, z = 14}       -- upLeftCorner
	local downConer = {x = 32246, y = 31297, z = 14}     -- downRightCorner

	for i=upConer.x, downConer.x do
		for j=upConer.y, downConer.y do
        	for k= upConer.z, downConer.z do
		        local room = {x=i, y=j, z=k}
				local tile = Tile(room)
				if tile then
					local creatures = tile:getCreatures()
					if creatures and #creatures > 0 then
						for _, c in pairs(creatures) do
							if isPlayer(c) then
								c:teleportTo({x = 32234, y = 31280, z = 14})
							elseif isMonster(c) and c:getName() == "Charging Outburst" then
								c:teleportTo({x = 32234, y = 31279, z = 14})
							end
						end
					end
				end
			end
		end
	end
end

local combat = Combat()
combat:setParameter(COMBAT_PARAM_TYPE, COMBAT_ENERGYDAMAGE)
combat:setParameter(COMBAT_PARAM_EFFECT, CONST_ME_PURPLEENERGY)

arr = {
	{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{1, 1, 1, 1, 1, 1, 3, 1, 1, 1, 1, 1, 1},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0},
	{0, 0, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0},
	{0, 0, 0, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0},
	{0, 0, 0, 0, 1, 1, 1, 1, 1, 0, 0, 0, 0},
	{0, 0, 0, 0, 0, 0, 1, 0, 0, 0, 0, 0, 0},
}

local area = createCombatArea(arr)
combat:setArea(area)

local function delayedCastSpell(creature, var)
	if not creature then
		return
	end
	return combat:execute(creature, positionToVariant(creature:getPosition()))
end

function removeOutburst(cid)
	local creature = Creature(cid)
	if not isCreature(creature) then return false end
	creature:remove()
end

function onCastSpell(creature, var)
	local from = creature:getId()

	outExplode()
	delayedCastSpell(creature, var)
	chargingOutKilled = true
	addEvent(removeOutburst, 1000, creature.uid)

	local monster = Game.createMonster("Outburst", {x = 32234, y = 31284, z = 14}, false, true)
	monster:addHealth(-monster:getHealth() + outburstHealth, COMBAT_PHYSICALDAMAGE)
	transferBossPoints(from, monster:getId())
	return true
end
