function RegisterPrimalPackBeast(template)
	local name = template.name or template.description:gsub("an ", ""):gsub("a ", ""):titleCase()
	local primal = Game.createMonsterType(name .. " (Primal)")
	local primalMonster = table.copy(template)
	primalMonster.experience = 0
	primalMonster.loot = {}
	primalMonster.name = "Primal Pack Beast"
	primalMonster.description = "a primal pack beast"
	primalMonster.maxHealth = primalMonster.maxHealth * 0.7
	primalMonster.health = primalMonster.maxHealth
	primalMonster.raceId = nil
	primalMonster.Bestiary = nil
	primalMonster.corpse = 0
	primal:register(primalMonster)
end
