local pillar = {
	[1] = "pillar of summoning",
	[2] = "pillar of death",
	[3] = "pillar of protection",
	[4] = "pillar of healing",
	[5] = "pillar of draining",
}

local destroyedPillar = CreatureEvent("DestroyedPillar")
function destroyedPillar.onDeath(creature)
	local monsterName = creature:getName():lower()
	local summoning = "summoning"
	local death = "death"
	local healing = "healing"
	local protection = "protection"
	local draining = "draining"
	for i = 1, #pillar do
		local position = creature:getPosition()
		local pilar = ""
		local newpos = {}
		pilar = pillar[i]
		if monsterName == pilar:lower() then
			if monsterName:find(summoning) then
				newpos = { x = position.x + 1, y = position.y, z = position.z }
				local boss = Tile(Position(newpos)):getTopCreature()
				if boss then
					boss:remove()
				end
				Game.createMonster("Destroyed Pillar", position, true, true)
				Game.createMonster("Eshtaba The Conjurer", newpos, true, true)
			elseif monsterName:find(death) then
				newpos = { x = position.x, y = position.y + 1, z = position.z }
				local boss = Tile(Position(newpos)):getTopCreature()
				if boss then
					boss:remove()
				end
				Game.createMonster("Destroyed Pillar", position, true, true)
				Game.createMonster("Malkhar Deathbringer", newpos, true, true)
			elseif monsterName:find(healing) then
				newpos = { x = position.x, y = position.y - 1, z = position.z }
				local boss = Tile(Position(newpos)):getTopCreature()
				if boss then
					boss:remove()
				end
				Game.createMonster("Destroyed Pillar", position, true, true)
				Game.createMonster("Mezlon The Defiler", newpos, true, true)
			elseif monsterName:find(protection) then
				newpos = { x = position.x - 1, y = position.y, z = position.z }
				local boss = Tile(Position(newpos)):getTopCreature()
				if boss then
					boss:remove()
				end
				Game.createMonster("Destroyed Pillar", position, true, true)
				Game.createMonster("Eliz The Unyielding", newpos, true, true)
			elseif monsterName:find(draining) then
				newpos = { x = position.x, y = position.y - 1, z = position.z }
				local boss = Tile(Position(newpos)):getTopCreature()
				if boss then
					boss:remove()
				end
				Game.createMonster("Destroyed Pillar", position, true, true)
				Game.createMonster("Dorokoll The Mystic", newpos, true, true)
			end
		end
	end
	return true
end

destroyedPillar:register()
