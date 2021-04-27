local essenceOfMalice = CreatureEvent("EssenceOfMalice")
function essenceOfMalice.onKill(creature, target)
	if not creature:isMonster() or creature:getMaster() then
		return false
	end

	local boss = {"eshtaba the conjurer", "mezlon the defiler", "eliz the unyielding", "malkhar deathbringer", "dorokoll the mystic"}
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
						if isInArray(boss, monster:getName():lower()) then
							newBoss = newBoss + 1
						end
					end
				end
			end
		end
	end
	if newBoss == 1 then
		Game.createMonster("Essence Of Malice", Position(33098, 31920, 15))
	end
	return true
end

essenceOfMalice:register()
