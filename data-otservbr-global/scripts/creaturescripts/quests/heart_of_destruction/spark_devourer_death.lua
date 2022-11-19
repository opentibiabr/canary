local sparkDevourerDeath = CreatureEvent("SparkDevourerDeath")
function sparkDevourerDeath.onDeath(creature)
	sparkSpawnCount = sparkSpawnCount + 1
	return true
end

sparkDevourerDeath:register()
