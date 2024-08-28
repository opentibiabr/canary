local boss = { "eshtaba the conjurer", "mezlon the defiler", "eliz the unyielding", "malkhar deathbringer", "dorokoll the mystic" }

local essenceOfMalice = CreatureEvent("EssenceOfMaliceSpawnsDeath")
function essenceOfMalice.onDeath(creature)
	local newBoss = 0
	local fromPos = Position(33087, 31909, 15)
	local toPos = Position(33112, 31932, 15)
	for _x = fromPos.x, toPos.x, 1 do
		for _y = fromPos.y, toPos.y, 1 do
			for _z = fromPos.z, toPos.z, 1 do
				local tile = Tile(Position(_x, _y, _z))
				if tile then
					local monster = Monster(tile:getTopCreature())
					if monster then
						if table.contains(boss, monster:getName():lower()) then
							newBoss = newBoss + 1
						end
					end
				end
			end
		end
	end
	if table.contains(boss, creature:getName():lower()) and newBoss == 1 then
		Game.createMonster("Essence Of Malice", Position(33098, 31920, 15))
	end
	return true
end

essenceOfMalice:register()
