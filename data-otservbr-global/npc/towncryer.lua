local internalNpcName = "Towncryer"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 131,
	lookHead = 95,
	lookBody = 86,
	lookLegs = 10,
	lookFeet = 114,
	lookAddons = 1,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Hear me! Hear me! The mage Wyrdin in the Edron academy is looking for brave adventurers to undertake a task!" },
	{ text = "Hear me! Hear me! The postmaster's guild has open spots for aspiring postmen! Contact Kevin Postner at the post office in the plains south of Kazordoon!" },
	{ text = "Hear me! Hear me! The inquisition is looking for daring people to fight evil! Apply at the inquisition headquarters next to the Thaian jail!" },
}

local worldChanges = {
	{ text = "In Ankrahmun's desert, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!", storage = GlobalStorage.WorldBoard.NightmareIsle.ankrahmunNorth },
	{ text = "Near Darashia's coast, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!", storage = GlobalStorage.WorldBoard.NightmareIsle.darashiaNorth },
	{ text = "Near Drefia's mountains, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!", storage = GlobalStorage.WorldBoard.NightmareIsle.darashiaWest },
	{ text = "Hear ye! Hear ye! What a lucky and beautiful day! Visit Carlin, Ankrahmun, or Liberty Bay. Yasir, the oriental trader might be there. Gather your creature products, for this chance is rare.", storage = GlobalStorage.WorldBoard.Yasir },
}

for i = 1, #worldChanges do
	if Game.getStorageValue(worldChanges[i].storage) > 0 then
		table.insert(npcConfig.voices, { text = worldChanges[i].text })
	end
end

npcType:register(npcConfig)
