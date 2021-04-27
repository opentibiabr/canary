local spawnBoss = CreatureEvent("SpawnBoss")
function spawnBoss.onDeath(creature, target)
	if not creature or not creature:isMonster() then
		return true
	end

	if creature:getName():lower() == "leiden" then
		local monster = Game.createMonster("ravennous hunger", creature:getPosition())
	elseif creature:getName():lower() == "the sinister hermit" then
		local monster = Game.createMonster("the souldespoiler", creature:getPosition())
	end
	return true
end

spawnBoss:register()
