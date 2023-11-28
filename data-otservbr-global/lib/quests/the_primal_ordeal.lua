function RegisterPrimalPackBeast(template)
	local name = template.name or template.description:gsub("an ", ""):gsub("a ", ""):titleCase()
	local primal = Game.createMonsterType(name .. " (Primal)")
	local primalMonster = table.copy(template)
	primalMonster.experience = 0
	primalMonster.loot = {}
	primalMonster.name = "Primal Pack Beast"
	primalMonster.description = "a primal pack beast"

	primalMonster.raceId = nil
	primalMonster.Bestiary = nil

	primal:register(primalMonster)
end
