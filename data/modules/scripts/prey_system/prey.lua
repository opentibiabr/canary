dofile('data/modules/scripts/prey_system/assets.lua')

Prey = {
	Credits = "System remake: Westwol ~ Packet logic: Cjaker ~  Formulas: slavidodo ~  Revision: Rick, Sameshima, RodrigoSilva93",
	Version = "6.4",
	LastUpdate = "12/02/2021",
}

Prey.Difficulty = {
	HARMLESS = 0,
	TRIVIAL = 1,
	EASY = 2,
	MEDIUM = 3,
	HARD = 4,
	CHALLEGING = 5
}

CONST_PREY_SLOT_FIRST = 0
CONST_PREY_SLOT_SECOND = 1
CONST_PREY_SLOT_THIRD = 2

CONST_BONUS_DAMAGE_BOOST = 0
CONST_BONUS_DAMAGE_REDUCTION = 1
CONST_BONUS_XP_BONUS = 2
CONST_BONUS_IMPROVED_LOOT = 3

Prey.Config = {
	PreyTime = 7200, -- Seconds
	StoreSlotStorage = 63253,
	ListRerollPrice = 150,
	BonusRerollPrice = 1,
	SelectWithWildCardPrice = 5,
}

Prey.S_Packets = {
	ShowDialog = 0xED,
	PreyRerollPrice = 0xE9,
	PreyData = 0xE8,
	PreyTimeLeft = 0xE7
}

Prey.StateTypes = {
	LOCKED = 0,
	INACTIVE = 1,
	ACTIVE = 2,
	SELECTION = 3,
	SELECTION_CHANGE_MONSTER = 4,
	SELECTION_WITH_WILDCARD = 6
}

Prey.UnlockTypes = {
	PREMIUM_OR_STORE = 0,
	STORE = 1,
	NONE = 2
}

Prey.Actions = {
	NEW_LIST = 0,
	NEW_BONUS = 1,
	SELECT = 2,
	LIST_ALL_MONSTERS = 3,
	SELECT_ALL_MONSTERS = 4,
	TICK_LOCK = 5
}

Prey.C_Packets = {
	RequestData = 0xED,
	PreyAction = 0xEB
}

Prey.Bonuses = {
	[CONST_BONUS_DAMAGE_BOOST] = {7, 9, 11, 13, 15, 17, 19, 21, 23, 25},
	[CONST_BONUS_DAMAGE_REDUCTION] = {12, 14, 16, 18, 20, 22, 24, 26, 28, 30},
	[CONST_BONUS_XP_BONUS] = {13, 16, 19, 22, 25, 28, 31, 34, 37, 40},
	[CONST_BONUS_IMPROVED_LOOT] = {13, 16, 19, 22, 25, 28, 31, 34, 37, 40}
}

Prey.MonsterList = {
	"Azure Frog", "Coral Frog", "Crimson Frog", "Filth Toad", "Infernal Frog", "Orchid Frog", "Salamander", "Toad",
	"Abyssal Calamary", "Blood Crab", "Crab", "Deathling Scout", "Deathling Spellsinger", "Deepling Brawler",
	"Deepling Elite", "Deepling Guard", "Deepling Master Librarian", "Deepling Scout", "Deepling Spellsinger",
	"Deepling Tyrant", "Deepling Warrior", "Deepling Worker", "Deepsea Blood Crab", "Manta Ray", "Quara Constrictor",
	"Quara Constrictor Scout", "Quara Hydromancer", "Quara Hydromancer Scout", "Quara Mantassin", "Quara Mantassin Scout",
	"Quara Pincher", "Quara Pincher Scout", "Quara Predator", "Quara Predator Scout", "Shark", "Berserker Chicken",
	"Demon Parrot", "Marsh Stalker", "Penguin", "Terror Bird", "Biting Book", "Clay Guardian", "Damaged Worker Golem",
	"Diamond Servant", "Enraged Crystal Golem",	"Eternal Guardian", "Glooth Golem", "Golden Servant", "Ice Golem",
	"Infected Weeper", "Iron Servant", "Lava Golem","Metal Gargoyle", "Orewalker", "Rotten Golem", "Rustheap Golem",
	"Sandstone Scorpion", "Stone Devourer",	"Stone Golem", "Walker", "War Golem", "Weeper", "Worker Golem", "Askarak Demon",
	"Askarak Lord", "Askarak Prince", "Brachiodemon", "Dark Torturer", "Dawnfire Asura", "Demon", "Demon Outcast",
	"Destroyer", "Diabolic Imp", "Fire Devil", "Floating Savant", "Frost Flower Asura", "Fury", "Gozzler", "Grimeleech",
	"Hellfire Fighter", "Hellflayer", "Hellhound", "Hellspawn", "Infernal Demon", "Juggernaut", "Many Faces",
	"Midnight Asura", "Nightfiend", "Plaguesmith", "Shaburak Demon", "Shaburak Lord", "Shaburak Prince",
	"True Dawnfire Asura", "True Frost Flower Asura", "True Midnight Asura", "Vexclaw", "Dragon", "Dragon Hatchling",
	"Dragon Lord", "Dragon Lord Hatchling", "Draken Abomination", "Draken Elite", "Draken Spellweaver", "Draken Warmaster",
	"Elder Wyrm", "Frost Dragon", "Frost Dragon Hatchling", "Ghastly Dragon", "Hydra", "Wyrm", "Cliff Strider",
	"Earth Elemental", "Energy Elemental", "Fire Elemental", "High Voltage Elemental", "Ironblight",
	"Knowledge Elemental", "Lava Lurker", "Massive Earth Elemental", "Massive Fire Elemental", "Massive Water Elemental",
	"Ravenous Lava Lurker", "Turbulent Elemental", "Water Elemental", "Breach Brood", "Courage Leech", "Dread Intruder",
	"Instable Breach Brood", "Instable Sparkion", "Reality Reaver", "Sparkion", "Stabilizing Dread Intruder",
	"Stabilizing Reality Reaver", "Yielothax", "Arctic Faun", "Boogy", "Dark Faun", "Dryad", "Faun", "Nymph", "Percht",
	"Pixie", "Pooka", "Schiach", "Swan Maiden", "Twisted Pooka", "Behemoth", "Cyclops", "Cyclops Drone",
	"Cyclops Smith", "Frost Giant", "Frost Giantess", "Ogre Brute", "Ogre Rowdy", "Ogre Ruffian", "Ogre Sage",
	"Ogre Savage", "Ogre Shaman", "Orclops Doomhauler", "Orclops Ravager", "Acolyte of the Cult", "Adept of the Cult",
	"Adventurer", "Amazon", "Assassin", "Bandit", "Barbarian Bloodwalker", "Barbarian Brutetamer", "Barbarian Headsplitter",
	"Barbarian Skullhunter", "Black Sphinx Acolyte", "Blood Hand", "Blood Priest", "Burning Gladiator", "Cobra Assassin",
	"Cobra Scout", "Cobra Vizier", "Crazed Beggar", "Crypt Defiler", "Cult Believer", "Cult Enforcer", "Cult Scholar",
	"Dark Apprentice", "Dark Magician", "Dark Monk", "Enlightened of the Cult", "Feverish Citizen", "Gang Member",
	"Gladiator", "Glooth Bandit", "Glooth Brigand", "Goldhanded Cultist", "Grave Robber",
	"Hero", "Hunter", "Ice Witch", "Infernalist", "Mad Scientist", "Misguided Thief", "Monk",
	"Mutated Human", "Necromancer", "Nomad", "Nomad Female", "Novice of the Cult", "Pirate Buccaneer", "Pirate Corsair",
	"Pirate Cutthroat", "Pirate Marauder", "Poacher", "Priestess", "Priestess of the Wild Sun", "Renegade Knight",
	"Shadow Pupil", "Smuggler", "Stalker", "Valkyrie", "Vicious Squire", "Vile Grandmaster", "Warlock", "Wild Warrior",
	"Witch", "Barkless Devotee", "Barkless Fanatic", "Broken Shaper", "Chakoya Toolshaper", "Chakoya Tribewarden",
	"Chakoya Windcaller", "Corym Charlatan", "Corym Skirmisher", "Corym Vanguard", "Crazed Summer Rearguard",
	"Crazed Summer Vanguard", "Crazed Winter Rearguard", "Crazed Winter Vanguard", "Dwarf", "Dwarf Geomancer",
	"Dwarf Guard", "Dwarf Soldier", "Dworc Fleshhunter", "Dworc Venomsniper", "Dworc Voodoomaster", "Elf",
	"Elf Arcanist", "Elf Scout", "Enslaved Dwarf", "Execowtioner", "Firestarter", "Frost Troll", "Furious Troll",
	"Goblin", "Goblin Assassin", "Goblin Leader", "Goblin Scavenger", "Insane Siren", "Island Troll",
	"Little Corym Charlatan", "Lost Basher", "Lost Berserker", "Lost Exile", "Lost Husher", "Lost Thrower", "Minotaur",
	"Minotaur Amazon", "Minotaur Archer", "Minotaur Cult Follower", "Minotaur Cult Prophet", "Minotaur Cult Zealot",
	"Minotaur Guard", "Minotaur Hunter", "Minotaur Invader", "Minotaur Mage", "Mooh'Tah Warrior", "Moohtant", "Orc",
	"Orc Berserker", "Orc Cult Fanatic", "Orc Cult Inquisitor", "Orc Cult Minion", "Orc Cult Priest", "Orc Cultist",
	"Orc Leader", "Orc Marauder", "Orc Rider", "Orc Shaman", "Orc Spearman", "Orc Warlord", "Orc Warrior",
	"Pirat Cutthroat", "Pirat Scoundrel", "Shaper Matriarch", "Soul-Broken Harbinger", "Swamp Troll", "Troll",
	"Troll Champion", "Troll Guard", "Troll", "Troll Legionnaire", "Twisted Shaper", "Worm Priestess", "Werebadger",
	"Werebear", "Wereboar", "Werefox", "Werehyaena", "Werehyaena Shaman", "Werelion", "Werelioness", "Werewolf",
	"Animated Feather", "Arachnophobica", "Armadile", "Blue Djinn", "Bog Raider", "Bonelord", "Brain Squid",
	"Choking Fear", "Crypt Warden", "Crystal Spider", "Crystal Wolf", "Crystalcrusher", "Cursed Book", "Efreet",
	"Elder Bonelord", "Energetic Book", "Energuardian of Tales", "Enfeebled Silencer",
	"Feral Sphinx", "Feversleep", "Flying Book", "Forest Fury", "Frazzlemaw", "Gargoyle", "Gazer", "Gryphon",
	"Guardian of Tales", "Guzzlemaw", "Icecold Book", "Lamassu", "Lumbering Carnivor", "Manticore", "Marid", "Medusa",
	"Menacing Carnivor", "Midnight Panther", "Nightmare", "Nightmare Scion", "Nightstalker", "Phantasm", "Rage Squid",
	"Retching Horror", "Rorc", "Shock Head", "Sight of Surrender", "Silencer", "Sphinx", "Spiky Carnivor",
	"Squid Warden", "Terrorsleep", "Thanatursus", "Thornfire Wolf", "Weakened Frazzlemaw", "Badger", "Bat", "Bear",
	"Boar", "Cave Rat", "Clomp", "Doom Deer", "Elephant", "Evil Sheep", "Evil Sheep Lord", "Exotic Bat", "Fox",
	"Gloom Wolf", "Gnarlhound", "Hot Dog", "Killer Rabbit", "Kongra", "Lion", "Mammoth", "Merlkin", "Mole",
	"Mutated Bat", "Mutated Rat", "Mutated Tiger", "Noble Lion", "Panda", "Polar Bear", "Rat", "Roaring Lion",
	"Sibang", "Skunk", "Starving Wolf", "Stone Rhino", "Tiger", "Vulcongra", "War Wolf", "Water Buffalo",
	"White Lion", "Winter Wolf", "Wolf", "Branchy Crawler", "Carniphila", "Cloak Of Terror", "Glooth Anemone",
	"Haunted Treeling", "Hideous Fungus", "Humongous Fungus", "Leaf Golem", "Omnivora", "Spit Nettle", "Swampling",
	"Wilting Leaf Golem", "Adult Goanna", "Cobra", "Crocodile", "Killer Caiman", "Lizard Chosen",
	"Lizard Dragon Priest", "Lizard High Guard", "Lizard Legionnaire", "Lizard Magistratus", "Lizard Noble",
	"Lizard Sentinel", "Lizard Snakecharmer", "Lizard Templar", "Lizard Zaogun", "Sea Serpent", "Seacrest Serpent",
	"Serpent Spawn", "Snake", "Stampor", "Stonerefiner", "Thornback Tortoise", "Tortoise", "Wyvern", "Young Goanna",
	"Young Sea Serpent", "Acid Blob", "Death Blob", "Defiler", "Devourer", "Glooth Blob", "Ink Blob", "Mercury Blob",
	"Midnight Spawn", "Slime", "Son of Verminor", "Squidgy Slime", "Banshee", "Betrayed Wraith", "Blightwalker",
	"Blood Beast", "Bonebeast", "Bony Sea Devil", "Braindeath", "Burster Spectre", "Capricious Phantom",
	"Crypt Shambler", "Cursed Prospector", "Death Priest", "Demon Skeleton", "Distorted Phantom",
	"Druid's Apparition", "Elder Mummy", "Evil Prospector", "Falcon Knight", "Falcon Paladin", "Flimsy Lost Soul",
	"Freakish Lost Soul", "Gazer Spectre", "Ghost", "Ghost Wolf", "Ghoul", "Ghoulish Hyaena", "Grave Guard",
	"Gravedigger", "Grim Reaper", "Hand of Cursed Fate", "Honour Guard", "Infernal Phantom", "Knight's Apparition",
	"Lich", "Lost Soul", "Mean Lost Soul", "Mould Phantom", "Mummy", "Paladin's Apparition", "Pirate Ghost",
	"Pirate Skeleton", "Putrid Mummy", "Ripper Spectre", "Rot Elemental", "Skeleton", "Skeleton Elite Warrior",
	"Skeleton Warrior", "Sorcerer's Apparition", "Souleater", "Spectre", "Tarnished Spirit", "Tomb Servant",
	"Undead Dragon", "Undead Elite Gladiator", "Undead Gladiator", "Vampire", "Vampire Bride", "Vampire Pig",
	"Vampire Viscount", "Vibrant Phantom", "Vicious Manbat", "White Shade", "Zombie", "Ancient Scarab",
	"Brimstone Bug", "Bug", "Carrion Worm", "Cave Devourer", "Centipede", "Crawler", "Deepworm", "Diremaw",
	"Drillworm", "Emerald Damselfly", "Exotic Cave Spider", "Giant Spider", "Hibernal Moth", "Hive Overseer",
	"Insect Swarm", "Insectoid Scout", "Insectoid Worker", "Kollos", "Lacewing Moth", "Ladybug", "Lancer Beetle",
	"Larva", "Poison Spider", "Rotworm", "Sacred Spider", "Sandcrawler", "Scarab", "Scorpion", "Spider", "Spidris",
	"Spidris Elite", "Spitter", "Swarmer", "Tarantula", "Terramite", "Tunnel Tyrant", "Wailing Widow", "Wasp",
	"Waspoid", "Wiggler", "Terrified Elephant"
}

-- Communication functions
function Player.sendResource(self, resourceType, value)
	local typeByte = 0
	if resourceType == "bank" then
		typeByte = 0x00
	elseif resourceType == "inventory" then
		typeByte = 0x01
	elseif resourceType == "prey" then
		typeByte = 0x0A
	end
	local msg = NetworkMessage()
	msg:addByte(0xEE)
	msg:addByte(typeByte)
	msg:addU64(value)
	msg:sendToPlayer(self)
end

function Player.sendErrorDialog(self, error)
	local msg = NetworkMessage()
	msg:addByte(Prey.S_Packets.ShowDialog)
	msg:addByte(0x15)
	msg:addString(error)
	msg:sendToPlayer(self)
end

-- Core functions
function Player.setRandomBonusValue(self, slot, bonus, typeChange)
	local type = self:getPreyBonusType(slot)
	local bonusValue = math.random(1, 10)
	local starUP = math.random(1, 3)
	local value = Prey.Bonuses[type][bonusValue]
	local bonusGrade = self:getPreyBonusGrade(slot)
	
	if bonus then
		if typeChange then
			self:setPreyBonusGrade(slot, bonusValue)
			self:setPreyBonusValue(slot, value)
		else
			local upgradeStar = bonusGrade + starUP
			if upgradeStar >= 10 then
				upgradeStar = 10
			end
			local newBonus = Prey.Bonuses[type][upgradeStar]
			self:setPreyBonusGrade(slot, upgradeStar)
			self:setPreyBonusValue(slot, newBonus)
		end
	end
end

function Player.createMonsterList(self)
	-- Do not allow repeated monsters
	local repeatedList = {}
	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		if (self:getPreyCurrentMonster(slot) ~= '') then
			repeatedList[#repeatedList + 1] = self:getPreyCurrentMonster(slot)
		end
		if (self:getPreyMonsterList(slot) ~= '') then
			local currentList = self:getPreyMonsterList(slot):split(";")
			for i = 1, #currentList do
				repeatedList[#repeatedList + 1] = currentList[i]
			end
		end
	end
	-- Generating monsterList
	local monsters = {}
	local counters = {
		Trivial = 0,
		Easy = 0,
		Medium = 0,
		Hard = 0,
		Challeging = 0
	}
	while (#monsters ~= 9) do
		local randomMonster = Prey.MonsterList[math.random(#Prey.MonsterList)]
		local difficulty = getMonsterDifficulty(randomMonster)
		-- Verify that monster actually exists
		if MonsterType(randomMonster) and not table.contains(monsters, randomMonster)
			and not table.contains(repeatedList, randomMonster) then
				if difficulty == Prey.Difficulty.TRIVIAL and counters.Trivial < getMaxMonster(self, Prey.Difficulty.TRIVIAL) then
					monsters[#monsters + 1] = randomMonster
					counters.Trivial = counters.Trivial + 1
				elseif difficulty == Prey.Difficulty.EASY and counters.Easy < getMaxMonster(self, Prey.Difficulty.EASY) then
					monsters[#monsters + 1] = randomMonster
					counters.Easy = counters.Easy + 1
				elseif difficulty == Prey.Difficulty.MEDIUM and counters.Medium < getMaxMonster(self, Prey.Difficulty.MEDIUM) then
					monsters[#monsters + 1] = randomMonster
					counters.Medium = counters.Medium + 1
				elseif difficulty == Prey.Difficulty.HARD and counters.Hard < getMaxMonster(self, Prey.Difficulty.HARD) then
					monsters[#monsters + 1] = randomMonster
					counters.Hard = counters.Hard + 1
				elseif difficulty == Prey.Difficulty.CHALLEGING and counters.Challeging < getMaxMonster(self, Prey.Difficulty.CHALLEGING) then
					monsters[#monsters + 1] = randomMonster
					counters.Challeging = counters.Challeging + 1
				end
		end
	end
	return table.concat(monsters, ";")
end

function Player.resetPreySlot(self, slot, from)
	self:setPreyMonsterList(slot, self:createMonsterList())
	self:setPreyCurrentMonster(slot, "")
	self:setPreyState(slot, from)
	return self:sendPreyData(slot)
end

function Player.getMinutesUntilFreeReroll(self, slot)
	local currentTime = os.time()
	if (self:getPreyNextUse(slot) <= currentTime) then
		return 0
	end

	return math.floor((self:getPreyNextUse(slot) - currentTime))
end

function Player.getRerollPrice(self)
	return (self:getLevel() * Prey.Config.ListRerollPrice)
end

function getNameByRace(race)
	local mtype = MonsterType(race)
	if mtype then
		return mtype:getName()
	end
end

function Player.getMonsterList(self)
	local repeatedList = {}
    local sortList = {}
	local monsterList = {}

	for slot = CONST_PREY_SLOT_FIRST, CONST_PREY_SLOT_THIRD do
		if (self:getPreyCurrentMonster(slot) ~= '') then
			repeatedList[#repeatedList + 1] = self:getPreyCurrentMonster(slot)
		end
		if (self:getPreyMonsterList(slot) ~= '') then
			local currentList = self:getPreyMonsterList(slot):split(";")
			for i = 1, #currentList do
				repeatedList[#repeatedList + 1] = currentList[i]
			end
		end
	end
	
	-- Insert the monstersId
	for i = 1, #preyRaceIds do
		table.insert(sortList, preyRaceIds[i])
	end

    -- Do not allow repeated monsters
	for k, v in pairs(sortList) do
		if not table.contains(repeatedList, getNameByRace(tonumber(v))) then
			table.insert(monsterList, v)
		end
	end
	
	return monsterList
end

function Player.setAutomaticBonus(self, slot)
	local monster = self:getPreyCurrentMonster(slot)

	-- Automatic Bonus Reroll
	if self:getPreyTick(slot) == 1 and self:getPreyBonusRerolls() >= 1 then
		self:setPreyBonusType(slot, self:getDiffBonus(slot))
		self:setRandomBonusValue(slot, true, true)
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 1)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s's prey bonus was automatically rolled.", monster:lower()))
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)
	
	-- Lock Prey
	elseif self:getPreyTick(slot) == 2 and self:getPreyBonusRerolls() >= 5 then
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 5)
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s's prey time was automatically renewed.", monster:lower()))
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)
	else
		self:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Your %s's prey has expired because you don't have enough prey wildcards.", monster:lower()))
		self:setPreyCurrentMonster(slot, "")
		self:setPreyTick(slot, 0)
	end	
end	

function onRecvbyte(player, msg, byte)
	if (byte == Prey.C_Packets.RequestData) then
		player:sendPreyData(CONST_PREY_SLOT_FIRST)
		player:sendPreyData(CONST_PREY_SLOT_SECOND)
		player:sendPreyData(CONST_PREY_SLOT_THIRD)
	elseif (byte == Prey.C_Packets.PreyAction) then
		player:preyAction(msg)
	end
end

function Player.preyAction(self, msg)

	local slot = msg:getByte()
	local action = msg:getByte()

	if not slot then
		return self:sendErrorDialog("Sorry, there was an issue, please relog-in.")
	end

	-- Verify whether the slot is unlocked
	if (self:getPreyUnlocked(slot) ~= 2) then
		return self:sendErrorDialog("Sorry, you don't have this slot unlocked yet.")
	end

	-- Listreroll
	if (action == Prey.Actions.NEW_LIST) then

		-- Verifying state
		if (self:getPreyState(slot) ~= Prey.StateTypes.ACTIVE and self:getPreyState(slot) ~= Prey.StateTypes.SELECTION
		and self:getPreyState(slot) ~= Prey.StateTypes.SELECTION_CHANGE_MONSTER)
		and self:getPreyState(slot) ~= Prey.StateTypes.INACTIVE then
			return self:sendErrorDialog("This is slot is not even active.")
		end

		-- If free reroll is available
		if (self:getMinutesUntilFreeReroll(slot) == 0) then
			self:setPreyNextUse(slot, os.time() + 20 * 60 * 60)
		elseif (not self:removeMoneyNpc(self:getRerollPrice())) then
			return self:sendErrorDialog("You do not have enough money to perform this action.")
		end

		self:setPreyCurrentMonster(slot, "")
		self:setPreyMonsterList(slot, self:createMonsterList())
		self:setPreyState(slot, Prey.StateTypes.SELECTION_CHANGE_MONSTER)

	-- Listreroll with wildcards
	elseif (action == Prey.Actions.LIST_ALL_MONSTERS) then

		-- Removing bonus rerolls
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 5)

		self:setPreyCurrentMonster(slot, "")
		self:setPreyMonsterList(slot, "")
		self:setPreyState(slot, Prey.StateTypes.SELECTION_WITH_WILDCARD)

	-- Select monster from the list
	elseif (action == Prey.Actions.SELECT_ALL_MONSTERS) then
		local race = msg:getU16()
		local race = getNameByRace(race)
	
		-- Converts RaceID to String
		self:setPreyCurrentMonster(slot, race)

		self:setPreyState(slot, Prey.StateTypes.ACTIVE)
		self:setPreyMonsterList(slot, "")
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)

	-- Bonus reroll
	elseif (action == Prey.Actions.NEW_BONUS) then

		-- Verifying state
		if (self:getPreyState(slot) ~= Prey.StateTypes.ACTIVE) then
			return self:sendErrorDialog("This is slot is not even active.")
		end

		if (self:getPreyBonusRerolls() < 1) then
			return self:sendErrorDialog("You don't have any bonus rerolls.")
		end

		-- Removing bonus rerolls
		self:setPreyBonusRerolls(self:getPreyBonusRerolls() - 1)

		-- Calculating new bonus
		local oldType = self:getPreyBonusType(slot)
		self:setPreyBonusType(slot, math.random(CONST_BONUS_DAMAGE_BOOST, CONST_BONUS_IMPROVED_LOOT))
		self:setRandomBonusValue(slot, true, false)
		self:setPreyTimeLeft(slot, Prey.Config.PreyTime)

	-- Select monster from list
	elseif (action == Prey.Actions.SELECT) then

		local selectedMonster = msg:getByte()
		local monsterList = self:getPreyMonsterList(slot):split(";")

		-- Verify if the monster exists.
		local monster = MonsterType(monsterList[selectedMonster + 1])
		if not monster then
			return self:sendPreyData(slot)
		end

		-- Verifying slot state
		if (self:getPreyState(slot) ~= Prey.StateTypes.SELECTION
		and self:getPreyState(slot) ~= Prey.StateTypes.SELECTION_CHANGE_MONSTER) then
			return self:sendErrorDialog("This slot can't select monsters.")
		end

		-- Proceeding to prey monster selection
		self:selectPreyMonster(slot, monsterList[selectedMonster + 1])

	-- Automatic Reroll/Lock
	elseif (action == Prey.Actions.TICK_LOCK) then
	
		local button = msg:getByte()
		if button == 1 then
			self:setPreyTick(slot, 1)
		elseif button == 2 then
			self:setPreyTick(slot, 2)
		else
			self:setPreyTick(slot, 0)
		end
	end

	-- Perfom slot update
	return self:sendPreyData(slot)
end

function Player.selectPreyMonster(self, slot, monster)

	-- Verify if the monster exists.
	local monster = MonsterType(monster)
	if not monster then
		return self:sendPreyData(slot)
	end

	local msg = NetworkMessage()

	-- Only first/expired selection list gets new prey bonus
	if (self:getPreyState(slot) == Prey.StateTypes.SELECTION) then
		-- Generating random prey type
		self:setPreyBonusType(slot, math.random(CONST_BONUS_DAMAGE_BOOST, CONST_BONUS_IMPROVED_LOOT))
		-- Generating random bonus stats
		self:setRandomBonusValue(slot, true, true)
	elseif (self:getPreyBonusGrade(slot) == 0) then
		-- Generating random prey type
		self:setPreyBonusType(slot, math.random(CONST_BONUS_DAMAGE_BOOST, CONST_BONUS_IMPROVED_LOOT))
		-- Generating random bonus stats
		self:setRandomBonusValue(slot, true, true)
	end

	-- Setting current monster
	self:setPreyCurrentMonster(slot, monster:getName())
	-- Setting preySlot state
	self:setPreyState(slot, Prey.StateTypes.ACTIVE)
	-- Cleaning up monsterList
	self:setPreyMonsterList(slot, "")
	-- Time left
	self:setPreyTimeLeft(slot, Prey.Config.PreyTime)
end

function Player.sendPreyData(self, slot)
	-- Unlock First Slot
	if self:getPreyState(CONST_PREY_SLOT_FIRST) == 0 then
		self:setPreyUnlocked(CONST_PREY_SLOT_FIRST, 2)
		self:setPreyState(CONST_PREY_SLOT_FIRST, 1)
	end

	-- Unlock/lock second slot (premium status)
	if self:isPremium() then
		if self:getPreyState(CONST_PREY_SLOT_SECOND) == 0 then
			self:setPreyUnlocked(CONST_PREY_SLOT_SECOND, 2)
			self:setPreyState(CONST_PREY_SLOT_SECOND, 1)
		end
	else
		self:setPreyUnlocked(CONST_PREY_SLOT_SECOND, 0)
		self:setPreyState(CONST_PREY_SLOT_SECOND, 0)
	end

	-- Unlock store slot
	if self:getPreyState(CONST_PREY_SLOT_THIRD) == 0 then
		if self:getStorageValue(Prey.Config.StoreSlotStorage) == 1	then
			self:setPreyUnlocked(CONST_PREY_SLOT_THIRD, 2)
			self:setPreyState(CONST_PREY_SLOT_THIRD, 1)
		else
			self:setPreyUnlocked(CONST_PREY_SLOT_THIRD, 1)
			self:setPreyState(CONST_PREY_SLOT_THIRD, 0)
		end
	end

	local slotState = self:getPreyState(slot)
	local tickState = self:getPreyTick(slot)

	local msg = NetworkMessage()
	msg:addByte(Prey.S_Packets.PreyData) -- packet header

	if slotState == Prey.StateTypes.SELECTION_CHANGE_MONSTER then
		msg:addByte(slot) -- slot number
		msg:addByte(slotState)
		msg:addByte(self:getPreyBonusType(slot))
		msg:addU16(self:getPreyBonusValue(slot))
		msg:addByte(self:getPreyBonusGrade(slot))

		local monsterList = self:getPreyMonsterList(slot):split(";")
		msg:addByte(#monsterList)
		for i = 1, #monsterList do
			local monster = MonsterType(monsterList[i])
			if monster then
				msg:addString(monster:getName())
				msg:addU16(monster:getOutfit().lookType or 21)
				msg:addByte(monster:getOutfit().lookHead or 0x00)
				msg:addByte(monster:getOutfit().lookBody or 0x00)
				msg:addByte(monster:getOutfit().lookLegs or 0x00)
				msg:addByte(monster:getOutfit().lookFeet or 0x00)
				msg:addByte(monster:getOutfit().lookAddons or 0x00)
			else
				return self:resetPreySlot(slot, Prey.StateTypes.SELECTION_CHANGE_MONSTER)
			end
		end

	elseif slotState == Prey.StateTypes.SELECTION then
		msg:addByte(slot)
		msg:addByte(slotState)

		local preyMonsterList = self:getPreyMonsterList(slot)
		if preyMonsterList == '' then
			self:setPreyMonsterList(slot, self:createMonsterList())
			return self:sendPreyData(slot)
		end

		local monsterList = preyMonsterList:split(";")
		msg:addByte(#monsterList)
		for i = 1, #monsterList do
			local monster = MonsterType(monsterList[i])
			if monster then
				msg:addString(monster:getName())
				msg:addU16(monster:getOutfit().lookType or 21)
				msg:addByte(monster:getOutfit().lookHead or 0x00)
				msg:addByte(monster:getOutfit().lookBody or 0x00)
				msg:addByte(monster:getOutfit().lookLegs or 0x00)
				msg:addByte(monster:getOutfit().lookFeet or 0x00)
				msg:addByte(monster:getOutfit().lookAddons or 0x00)
			else
				return self:resetPreySlot(slot, Prey.StateTypes.SELECTION)
			end
		end

	elseif slotState == Prey.StateTypes.ACTIVE then
		msg:addByte(slot)
		msg:addByte(slotState)
		local monster = MonsterType(self:getPreyCurrentMonster(slot))
		if monster and self:getPreyTimeLeft(slot) > 0 then
			msg:addString(monster:getName())
			msg:addU16(monster:getOutfit().lookType or 21)
			msg:addByte(monster:getOutfit().lookHead or 0x00)
			msg:addByte(monster:getOutfit().lookBody or 0x00)
			msg:addByte(monster:getOutfit().lookLegs or 0x00)
			msg:addByte(monster:getOutfit().lookFeet or 0x00)
			msg:addByte(monster:getOutfit().lookAddons or 0x00)
			msg:addByte(self:getPreyBonusType(slot))
			msg:addU16(self:getPreyBonusValue(slot))
			msg:addByte(self:getPreyBonusGrade(slot))
			msg:addU16(self:getPreyTimeLeft(slot))
		else
			return self:resetPreySlot(slot, Prey.StateTypes.SELECTION)
		end

	elseif slotState == Prey.StateTypes.INACTIVE then
		msg:addByte(slot) -- slot number
		msg:addByte(slotState) -- slot state
		self:setRandomBonusValue(slot, true, true)

	elseif slotState == Prey.StateTypes.LOCKED then
		msg:addByte(slot)
		msg:addByte(slotState)
		msg:addByte(self:getPreyUnlocked(slot))

	elseif slotState == Prey.StateTypes.SELECTION_WITH_WILDCARD then
		local raceList = self:getMonsterList()

		msg:addByte(slot) -- slot number
		msg:addByte(slotState) -- slot state
		
		-- Check if has any bonus
		if self:getPreyTimeLeft(slot) <= 0 then
			self:setRandomBonusValue(slot, true, true)
		end
		
		msg:addByte(self:getPreyBonusType(slot)) -- bonus type
		msg:addU16(self:getPreyBonusValue(slot)) -- bonus value
		msg:addByte(self:getPreyBonusGrade(slot)) -- bonus grade
		msg:addU16(#raceList) -- monsters count
		
		for i = 1, #raceList do
			msg:addU16(raceList[i]) -- raceID
		end
	end

	-- Next free reroll
	msg:addU32(self:getMinutesUntilFreeReroll(slot))

	-- Automatic Reroll/Lock Prey
	msg:addByte(tickState)

	-- send prey message
	msg:sendToPlayer(self)

	-- close emb window
	self:closeImbuementWindow()

	-- Send resources
	self:sendResource("prey", self:getPreyBonusRerolls())
	self:sendResource("bank", self:getBankBalance())
	self:sendResource("inventory", self:getMoney())

	-- Send reroll price
	self:sendPreyRerollPrice()

end

function Player:sendPreyRerollPrice()
	local msg = NetworkMessage()
	
	msg:addByte(Prey.S_Packets.PreyRerollPrice)
	msg:addU32(self:getRerollPrice())
	msg:addByte(Prey.Config.BonusRerollPrice) -- wildcards
	msg:addByte(Prey.Config.SelectWithWildCardPrice) -- select directly

	-- Feature unavailable
	msg:addU32(0)
	msg:addU32(0)
	msg:addByte(0)
	msg:addByte(0)

	msg:sendToPlayer(self)
end

function getMonsterDifficulty(monster)
	local stars
	if MonsterType(monster) == nil or MonsterType(monster):experience() == 0 then
		return 0
	else
		stars = MonsterType(monster):BestiaryStars()
	end
	return stars
end

function getMaxMonster(self, tier)
	local level = self:getLevel()

	if(tier == Prey.Difficulty.HARMLESS) then return 0 end

	if level >=8 and level <= 100 then
		if tier == Prey.Difficulty.TRIVIAL then return 1
		elseif tier == Prey.Difficulty.EASY then return 4
		elseif tier == Prey.Difficulty.MEDIUM then return 4
		elseif tier == Prey.Difficulty.HARD then return 4
		elseif tier == Prey.Difficulty.CHALLEGING then return 1 end
	elseif level >= 101 and level <= 250 then
		if tier == Prey.Difficulty.TRIVIAL then return 1
		elseif tier == Prey.Difficulty.EASY then return 3
		elseif tier == Prey.Difficulty.MEDIUM then return 5
		elseif tier == Prey.Difficulty.HARD then return 4
		elseif tier == Prey.Difficulty.CHALLEGING then return 1 end
	else
		if tier == Prey.Difficulty.TRIVIAL then return 1
		elseif tier == Prey.Difficulty.EASY then return 3
		elseif tier == Prey.Difficulty.MEDIUM then return 4
		elseif tier == Prey.Difficulty.HARD then return 5
		elseif tier == Prey.Difficulty.CHALLEGING then return 1 end
	end
end
