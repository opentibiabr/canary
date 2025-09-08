local event = CreatureEvent("BrotherWormDeath")

function event.onDeath(creature, corpse, killer, mostDamage, unjustified, mostDamage_unjustified)
	local centerPos = creature:getPosition()
	local searchArea = {
		startPos = Position(centerPos.x - 30, centerPos.y - 30, centerPos.z),
		endPos = Position(centerPos.x + 30, centerPos.y + 30, centerPos.z),
	}

	for x = searchArea.startPos.x, searchArea.endPos.x do
		for y = searchArea.startPos.y, searchArea.endPos.y do
			local tile = Tile(Position(x, y, centerPos.z))
			if tile then
				local creatures = tile:getCreatures()
				for _, targetCreature in ipairs(creatures) do
					if targetCreature:isMonster() and targetCreature:getName():lower() == "the unwelcome" then
						targetCreature:addHealth(-targetCreature:getMaxHealth())
						targetCreature:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
						return true
					end
				end
			end
		end
	end
	return true
end

event:register()
