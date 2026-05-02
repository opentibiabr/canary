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
	{ text = "In Ankrahmun's desert, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!", storage = GlobalStorage.WorldBoard.NightmareIsle.AnkhramunNorth },
	{ text = "Near Darashia's coast, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!", storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaNorth },
	{ text = "Near Drefia's mountains, a storm has revealed the entry to a nightmare that can't be sealed. Horrible creatures there spell instant death to all young adventurers who dare take a breath!", storage = GlobalStorage.WorldBoard.NightmareIsle.DarashiaWest },
	{ text = "Hear ye! Hear ye! What a lucky and beautiful day! Visit Carlin, Ankrahmun, or Liberty Bay. Yasir, the oriental trader might be there. Gather your creature products, for this chance is rare.", storage = GlobalStorage.Yasir },
	{ text = "Hear ye! Hear ye! A fiery gate has opened, threatening a city! Guard the people frightened, their death would be a pity!", storage = GlobalStorage.FuryGates },
	{ text = "Hear ye! Hear ye! The witch Wyda seems to be bored. Pay her a visit but sharpen your sword. She might come up with a terrible surprise, are you brave enough to believe your eyes?", kv = KV.scoped("worldchanges"):scoped("bored"), kvKey = "active" },
}

local function isWorldChangeActive(entry)
	if entry.storage ~= nil then
		return Game.getStorageValue(entry.storage) > 0
	end

	if entry.kv ~= nil then
		local kvValue = entry.kv:get(entry.kvKey or "value")
		return kvValue == true or kvValue == 1
	end

	return false
end

for i = 1, #worldChanges do
	if isWorldChangeActive(worldChanges[i]) then
		table.insert(npcConfig.voices, { text = worldChanges[i].text })
	end
end

npcType:register(npcConfig)
