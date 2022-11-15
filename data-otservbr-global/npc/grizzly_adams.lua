local internalNpcName = "Grizzly Adams"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 144,
	lookHead = 116,
	lookBody = 78,
	lookLegs = 94,
	lookFeet = 78,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.shop = {
	-- HuntsMan rank
	-- Sell offers
	{clientId = 10297, sell = 50, itemName = "antlers", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 9633, sell = 100, itemName = "bloody pincers", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10272, sell = 35, itemName = "crab pincers", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 9657, sell = 55, itemName = "cyclops toe", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12316, sell = 550, itemName = "cavebear skull", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 17818, sell = 150, itemName = "cheesy figurine", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11514, sell = 110, itemName = "colourful feather", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 7398, sell = 500, itemName = "cyclops trophy", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10398, sell = 15000, itemName = "draken trophy", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12309, sell = 800, itemName = "draptor scales", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 18994, sell = 115, itemName = "elven hoof", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 9648, sell = 30, itemName = "frosty ear of a troll", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12317, sell = 950, itemName = "giant crab pincer", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11539, sell = 20, itemName = "goblin ear", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12314, sell = 400, itemName = "hollow stampor hoof", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10282, sell = 600, itemName = "hydra head", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10455, sell = 80, itemName = "lancer beetle shell", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10419, sell = 8000, itemName = "lizard trophy", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11489, sell = 280, itemName = "mantassin tail", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 17461, sell = 65, itemName = "marsh stalker beak", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 17462, sell = 50, itemName = "marsh stalker feather", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12315, sell = 250, itemName = "maxilla", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 7401, sell = 500, itemName = "minotaur trophy", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 9662, sell = 420, itemName = "mutated bat ear", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12039, sell = 750, itemName = "panther head", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12040, sell = 300, itemName = "panther paw", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11491, sell = 500, itemName = "quara bone", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11491, sell = 350, itemName = "quara eye", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11490, sell = 410, itemName = "quara pincers", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 11487, sell = 140, itemName = "quara tentacle", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12172, sell = 50, itemName = "rabbit's foot", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 18993, sell = 70, itemName = "rorc feather", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10311, sell = 400, itemName = "sabretooth", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10456, sell = 20, itemName = "sandcrawler shell", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 9631, sell = 280, itemName = "scarab pincers", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12312, sell = 280, itemName = "stampor horn", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 12313, sell = 150, itemName = "stampor talons", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10454, sell = 60, itemName = "terramite legs", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10452, sell = 170, itemName = "terramite shell", storageKey = POINTSSTORAGE, storageValue = 10},
	{clientId = 10273, sell = 95, itemName = "terrorbird beak", storageKey = POINTSSTORAGE, storageValue = 10},
	-- Buy offers
	{clientId = 5907, buy = 35000, itemName = "slingshot", storageKey = POINTSSTORAGE, storageValue = 20},

	-- BigGameHunter rank
	{clientId = 10244, sell = 6000, itemName = "bonebeast trophy", storageKey = POINTSSTORAGE, storageValue = 40},
	{clientId = 7397, sell = 3000, itemName = "deer trophy", storageKey = POINTSSTORAGE, storageValue = 40},
	{clientId = 7400, sell = 3000, itemName = "lion trophy", storageKey = POINTSSTORAGE, storageValue = 40},
	{clientId = 7395, sell = 1000, itemName = "orc trophy", storageKey = POINTSSTORAGE, storageValue = 40},
	{clientId = 7394, sell = 3000, itemName = "wolf trophy", storageKey = POINTSSTORAGE, storageValue = 40},

	-- TrophyHunter rank
	-- Sell offers
	{clientId = 7396, sell = 20000, itemName = "behemoth trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 7393, sell = 40000, itemName = "demon trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 7399, sell = 10000, itemName = "dragon lord trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 10421, sell = 3000, itemName = "disgusting trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 22101, sell = 9000, itemName = "werebadger trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 22102, sell = 10000, itemName = "wereboar trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 22103, sell = 11000, itemName = "werebear trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 27706, sell = 9000, itemName = "werefox trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	{clientId = 34219, sell = 12000, itemName = "werehyaena trophy", storageKey = POINTSSTORAGE, storageValue = 70},
	-- Buy offers
	{clientId = 9601, buy = 1000, itemName = "demon backpack", storageKey = POINTSSTORAGE, storageValue = 70}
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType)
end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry) ~= 0 then
		npcHandler:setMessage(MESSAGE_GREET, "Hi there, do you want to to {join} the 'Paw and Fur - Hunting Elite'?")
	elseif player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) < 0 and player:getStorageValue(POINTSSTORAGE) >= 10 and player:getLevel() >= 6 or		-- to Huntsman Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 0 and player:getStorageValue(POINTSSTORAGE) >= 20 and player:getLevel() >= 6 or			-- to Ranger Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 2 and player:getStorageValue(POINTSSTORAGE) >= 40 and player:getLevel() >= 50 or		-- to Big Game Hunter Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 4 and player:getStorageValue(POINTSSTORAGE) >= 70 and player:getLevel() >= 80 or		-- to Trophy Hunter Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 6 and player:getStorageValue(POINTSSTORAGE) >= 100 and player:getLevel() >= 130 then	-- to Elite Hunter Rank
		npcHandler:setMessage(MESSAGE_GREET, "Good to see you again |PLAYERNAME|. You gained " .. player:getStorageValue(POINTSSTORAGE) .. " points for our society. Ask me for {promotion} to advance your rank!")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Welcome to the 'Paw and Fur - Hunting Elite' |PLAYERNAME|. Feel free to do {tasks} for us.")
	end
	return true
end
local choose = {}
local cancel = {}
local KillCounter = Storage.Quest.U8_5.KillingInTheNameOf.MonsterKillCount.KillCount
local messageYes = {
	[1] = "Happy hunting, friend! When you have finished hunting, return here.",
	[2] = "Happy hunting, friend! Come back to me when you are done hunting.",
	[3] = "Happy hunting, old chap! Come back to me when you are through with your task.",
	[4] = "Happy hunting, old chap! Come back to me when you are done hunting.",
	[5] = "Happy hunting, old chap! Speak to me again when you are done hunting.",
	[6] = "Happy hunting, pal! Speak to me again when you are done hunting.",
	[7] = "Good show, old chap! Speak to me again when you are done hunting.",
	[8] = "Good choice! Speak to me again when you are done hunting.",
	[9] = "Good choice, pal! Speak to me again when you are done hunting.",
	[10] = "Good choice, old chap! Speak to me again when you are done hunting.",
}
local messageTask = {
	[1]	= "Nice work, old chap. If you're up for another hunting mission, just ask me for a {task}.",
	[2]	= "Jolly good job you did there, old chap. If you're up for another hunting mission, just ask me for a {task}.",
	[3]	= "Well done! If you're up for another hunting mission, just ask me for a {task}.",
	[4]	= "That took some time, huh? Good hunting though. If you're up for another hunting mission, just ask me for a {task}."
}
local messageBoss = {
	{"Spiffing work, old chap. Now I have a special task for you. Recently several citizens of Port Hope vanished. It is rumoured that they were killed by a crocodile. The people call it 'Snapper'. Hunt down and kill that evil man-eating beast. ...",
	"Ask me about new {tasks} if you're up for a further hunting mission. Be aware that you can only have one 'Snapper' task active at the same time!"},
	"Nicely done! Now I shall assign you a special task. Rumour has it that there is an ancient and evil tarantula who preys on humans. She is called 'Hide'. Track her down and kill her! Good luck, old chap.",
	{"Well done, old chap. Now i shall assign you a special task. Rumour has it that there is an old carniphila somewhere in the jungle. Find Deathbine's hideout and kill it! Good luck, old chap ...",
	"Ask me about new {tasks} if you're up for further hunting mission. Be aware that you can only have one 'Deathbine' task active at the same time!"},
	"Jolly good job you did there, but now I have a special task for you. The citizens of Svargrond live in fear because of a frightfully bad-tempered mammoth they call 'Blood Tusk'. Go there and put an end to him. Happy hunting!",
	{"As I see it, you need more of a challenge! I have heard that there is an ice golem the hunters in Svargrond call 'Shardhead'. It is an extremely dangerous example of its kind! ...",
	"I believe you are equal to the task, |PLAYERNAME|! If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Shardhead' task active at the same time!"},
	{"Very good work, old chap. Lucky you are here - I have just been told of a task which is perfect for you. ...",
	"The Yalaharians are having a spot of bother with a huge mutated rat. They call it 'Esmeralda' and you should find her somewhere in the sewers. Good hunting!"},
	{"Very good work, old chap. Lucky you are here - I have just been told of a task which is perfect for you. ...",
	"The people of Ankrahmun are having a spot of bother with a huge ancient scarab. They call it 'Fleshcrawler' and you should find and kill it. Good hunting! ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Fleshcrawler' task active at the same time!"},
	{"Very good work, old chap. Have you heard about 'Ribstride'? It must have a hideout. Try to find it and slay the beast. ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Ribstride' task active at the same time!"},
	{"Very good work, old chap. Have you heard about 'Bloodweb'? It must have a hideout. Try to find it and slay the beast. ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Bloodweb' task active at the same time!"},
	{"Superb work. However, there is something else I want you to do. It is said that there is a quara general named 'Thul' who is responsible for the attacks on Liberty Bay. Find and kill the general and bring peace back to Liberty Bay! ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Thul' task active at the same time!"},
	"Well THAT was a hunt. Good job. Have you heard about the 'Old Widow'? It must have a hideout. Try to find it and slay the beast. You can ask about new {tasks} by the way. Be aware that you can only have one 'Old Widow' task active at the same time!",
	{"What an impressive hunt. Nicely done. By the way there is still something I want you to do for me. 'Hemming' a furious werewolf is up to mischief. Find its hideout and bring it down! ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Hemming' task active at the same time!"},
	{"Thumbs up, nice performance. Have you heard about 'Tormentor'? Find it and slay the beast. ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Tormentor' task active at the same time!"},
	"Well THAT was a hunt. Good job. Have you heard about 'Flameborn'? It must have a hideout. Try to find it and slay the beast. You can ask about new {tasks} by the way. Be aware that you can only have one 'Flameborn' task active at the same time!",
	{"What an impressive hunt. Nicely done. Have you heard about 'Fazzrah'? Try to find it and slay the beast. ...",
	"You can ask about new {tasks} by the way. Be aware that you can only have one 'Fazzrah' task active at the same time!"},
	{"Nicely done. However, there is something else I want you to do. I have heard that there is a stampor the hunters in the Muggy Plains call 'Tromphonyte'. It is an extremely dangerous example of its kind! ...",
	"I believe you are equal to the task, |PLAYERNAME|! Find and kill it and bring peace back! ...",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Tromphonyte' task active at the same time!"},
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Sulphur Scuttler' task active at the same time!",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Bruise Payne' task active at the same time!",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Many' task active at the same time!",
	{"My - you can be proud of yourself! However, you're not finished yet. There are rumours about a being called 'The Noxious Spawn' which was seen deep down in the ruins of Banuta. Try to find its hideout. ...",
	"You can ask about new {tasks} bye the way. Be aware that you can only have one 'Noxious Spawn' task active at the same time!"},
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Gorgo' task active at the same time!",
	{"Such marvellous hunting skills! Perhaps you can help me with this one. Have you heard about 'Stonecracker'? ...",
	"It's the oldest and most dangerous of all behemoths and was last seen under the Cyclopolis in Edron. What do you think? Are you hunter enough? I think you are!"},
	{"Good job, old chap! Are you up for a challenge? Have you heard of the legendary sea serpent called the 'Leviathan'? It must be somewhere near the spot you found. ...",
	"This is a true test of your hunting skills - find it and kill it. Good hunting! ...", "You can ask about new {tasks} by the way. Be aware that you can only have one 'Leviathan' task active at the same time!"},
	{"Outstanding! You do have impressive hunting skills. Have you already heard about Kerberos the oldest and most dangerous of all hellhounds? He must have a hideout somewhere. Try to find him and slay the beast. ...",
	"You can ask about new tasks by the way. Be aware that you can only have one Kerberos task active at the same time!"},
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Ethershreck' task active at the same time!",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Paiz the Pauperizer' task active at the same time!",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Bretzecutioner' task active at the same time!",
	"If you're up for another hunting mission, just ask me for a {task}. Be aware that you can only have one 'Zanakeph' task active at the same time!"
}
local messageBossStart = {
	"Okay. Go forth and kill him.", -- Snapper
	"Okay. Go forth and kill him.", -- Hide
	"Find Deathbine, the old carniphila, somewhere in the jungle. Find its hideout and kill it!",
	"Okay. Go forth and kill him.", -- Bloodtusk
	"Okay. Go forth and kill him.", -- Shardhead
	"Okay. Go forth and kill him.", -- Esmeralda
	"Okay. Go forth and kill him.", -- Fleshcrawler
	"Okay. Go forth and kill him.", -- Ribstride
	"Okay. Go forth and kill him.", -- Bloodweb
	"Okay. Go forth and kill him.", -- Thul
	"Okay. Go forth and kill him.", -- Old Widow
	"Okay. Go forth and kill him.", -- Hemming
	"Okay. Go forth and kill him.", -- Tormentor
	"Okay. Go forth and kill him.", -- Flameborn
	"Okay. Go forth and kill him.", -- Fazzrah
	"Okay. Go forth and kill him.", -- Tromphonyte
	"Okay. Go forth and kill him.", -- Sulphur Scuttler
	"Okay. Go forth and kill him.", -- Bruise Payne
	"Keep your head and focus when you confront her!",
	"Okay. Go forth and kill him.", -- Noxious Spawn
	"Okay. Happy hunting!",
	"Smash it to smithereens!",
	"Okay. Go forth and kill him.", -- Leviathan
	"Okay. Go forth and kill him.",
	"Okay. Go forth and kill him.",
	"Okay. Go forth and kill him.",
	"Okay. Go forth and kill him.",
	"Okay. Go forth and kill him."
}
local tier = {
	{allName = {"crocodiles", "badgers", "tarantulas", "carniphilas", "stone golems", "mammoths", "gnarlhounds", "terramites", "apes", "thornback tortoises", "gargoyles", "crocodile", "badger", "tarantula", "carniphila", "stone golem", "mammoth", "gnarlhound", "terramite", "ape", "thornback tortoise", "gargoyle"},
	withsName = {"crocodiles", "badgers", "tarantulas", "carniphilas", "stone golems", "mammoths", "gnarlhounds", "terramites", "apes", "thornback tortoises", "gargoyles"}},
	{allName = {"ice golems", "quara scouts", "mutated rats", "ancient scarabs", "wyverns", "lancer beetles", "wailing widows", "killer caimans", "bonebeasts", "crystal spiders", "mutated tigers", "ice golem", "quara scout", "mutated rat", "ancient scarab", "wyvern", "lancer beetle", "wailing widow", "killer caiman", "bonebeast", "crystal spider", "mutated tiger"},
	withsName = {"ice golems", "quara scouts", "mutated rats", "ancient scarabs", "wyverns", "lancer beetles", "wailing widows", "killer caimans", "bonebeasts", "crystal spiders", "mutated tigers"}},
	{allName = {"underwater quara", "giant spiders", "werewolves", "nightmares", "hellspawns", "high class lizards", "stampors", "brimstone bugs", "mutated bats", "giant spider", "werewolve", "nightmare", "hellspawn", "high class lizard", "stampor", "brimstone bug", "mutated bat"},
	withsName = {"underwater quara", "giant spiders", "werewolves", "nightmares", "hellspawns", "high class lizards", "stampors", "brimstone bugs", "mutated bats"}},
	{allName = {"hydras", "serpent spawns", "medusae", "behemoths", "sea serpents", "hellhounds", "ghastly dragons", "undead dragons", "drakens", "destroyers", "hydra", "serpent spawn", "medusa", "behemoth", "sea serpent", "hellhound", "ghastly dragon", "undead dragon", "draken", "destroyer"},
	withsName = {"hydras", "serpent spawns", "medusae", "behemoths", "sea serpents", "hellhounds", "ghastly dragons", "undead dragons", "drakens", "destroyers"}}
}
local messageStartTask = {
	["crocodiles"] = "They are a nuisance! You'll find them here in the jungle near the river. Hunt 300 crocodiles and you'll get a nice reward. Interested?",
	["badgers"] = "You'll find them in the surrounding of Svargrond. Hunt 300 badgers and you'll get a reward. Interested?",
	["tarantulas"] = "There is a veritable plague of tarantulas living in the caves north of the river to the east. Can you squish 300 tarantulas for the Hunting Elite. What do you say?",
	["stone golems"] = "They can be found all over Tibia. You'll find them in mountain caves or rocky dungeons. Hunt 200 stone golems of them and come back to me. Understood?",
	["mammoths"] = "This particular species is found in Svargrond. Impressive beasts, but you wouldn't want one in your backyard. Hunt 300 mammoths of them. Alright?",
	["gnarlhounds"] = "This particular species is found in Zao Steppe. Hunt 300 gnarlhounds of them. Understood?",
	["terramites"] = "This particular species can be found beneath Zao Steppe. Hunt 300 terramites of them. Understood?",
	["apes"] = "You'll find the apes deeper in the jungle. Hunt 300 merlkins, kongras or sibangs to complete this task. Alright?",
	["thornback tortoises"] = "You'll find them on the Laguna Islands. Hunt 300 thornback tortoises of them. Interested?",
	["gargoyles"] = "They can be found all over Tibia. Hunt 300 gargoyles of them. Interested?",
	["ice golems"] = "The ice golems on the glacier of Hrodmir are becoming a threat to the civilians in Svargrond. Travel to the Ice Islands and hunt 300 ice golems. Do you accept this task?",
	["quara scouts"] = "The {scouts} can be found on Malada, one of the Shattered Isles. Your task is to kill 400 quara scouts. I accept quara constrictor scouts, quara hydromancer scouts, quara mantassin scouts, quara pincher scouts and quara predator scouts, are you in?",
	["mutated rats"] = "Recently, I heard of a disturbing development in Yalahar - a plague of monstrous Mutated rats! If they were to spread to the rest of Tibia.. <shudders> My task for you is to contain their numbers in Yalahar. Hunt 400 mutated rats of them. What do you say?",
	["ancient scarabs"] = "They can be found in tombs beneath the desert around Ankrahmun. Hunt 250 ancient scarabs of them. Interested?",
	["wyverns"] = "They can be found all over Tibia. Hunt 300 wyverns. Interested?",
	["lancer beetles"] = "Lancer beetle populations can be found on the landmass of Zao. Hunt down 300 of this crawlers for this task. Alright?",
	["wailing widows"] = "Wailing widow populations can be found on the landmass of Zao. Hunt down 400 of them. Alright?",
	["killer caimans"] = "Killer caiman populations can be found on the landmass of Zao. Hunt down 250 of them for this task. Interested?",
	["bonebeasts"] = "In this task you must defeat 300 bonebeasts. Are you sure that you want to start this task?",
	["crystal spiders"] = "In this task you must defeat 300 crystal spiders. Are you sure that you want to start this task?",
	["mutated tigers"] = "In this task you must defeat 300 mutated tigers. Are you sure that you want to start this task?",
	["underwater quara"] = "As you wish. Seek out a quara settlement and hunt 600 underwater quara, it doesn't matter which type you hunt. Alright?",
	["giant spiders"] = "Never liked spiders. Simply too many legs. And I always find them in my bath! Those nasty creepy-crawlies are a threat to the hygiene of every living being in Tibia. Hunt 500 of them. Okay?",
	["werewolves"] = "Those nasty creatures can be found on the island of Vengoth. Hunt 300 of them. Are you in?",
	["nightmares"] = "Nightmares and nightmare scions can be found all over Tibia. For this task kill 400 of them. Interested?",
	["hellspawns"] = "Recently, I heard of a disturbing development - hellspawns. If they spread to the rest of Tibia... <shudders> My task for you is to contain their numbers. Hunt 600 of them. What do you say?",
	["high class lizards"] = "I want you to decrease the number of high class lizards on the Zaoan landmass. Hunt 800 of them. I accept lizard chosens, lizard dragon priests, lizard high guards, lizard legionnaires and lizard zaoguns. Are you interested?",
	["stampors"] = "Stampors can be found in a dungeon on the Zaoan landmass. Hunt 600 of them. Are you interested?",
	["brimstone bugs"] = "You can find them on the Zaoan landmass. Kill 500 brimstone bugs to complete this task. Are you in?",
	["mutated bats"] = "Recently, I heard of a disturbing development in Yalahar - a plague of monstrous mutated bats! If they were to spread to the rest of Tibia... <shudders> My task for you is to contain their numbers in Yalahar. Hunt 400 of them. What do you say?",
	["hydras"] = "The hydras are located in the eastern jungle of Tiquanda and there are several mountain caves that are inhabited by them. Your task is to hunt a mere 650 hydras. Are you willing to do that?",
	["serpent spawns"] = "Very dangerous, nasty and slimy creatures. They live deep in the old ruins of Banuta. I think a mere 800 serpent spawns should do the trick. What do you say?",
	["medusae"] = "They live deep in the old ruins of Banuta and they are nasty! I think a mere 500 medusae should do the trick. What do you say?",
	["behemoths"] = "Behemoths must be kept away from the settlements at all costs. You'll find them east of here in the taboo-area or under Cyclopolis in Edron. Go there and hunt a few of them - shall we say... 700? Are you up for that?",
	["sea serpents"] = {
	"The sea serpent threat increases! Captain Haba knows where to find them. ...",
	"Go to Svargrond and talk to him. 900 sea serpents, including the young ones, should be enough to reduce the threat. Got it?"},
	["hellhounds"] = "These harbingers of darkness can be found in many deep dungeons all over Tibia. Kill 250 of them. Are you in?",
	["ghastly dragons"] = "Ghastly dragons are devastating creatures which can be found in many dangerous places all over Tibia. Kill 500 of them. Are you in?",
	["undead dragons"] = "You are a thrill seeker? Undead dragons belong to one of the most powerful races that can be found in Tibia. Kill 400 of them. Are you in?",
	["drakens"] = "Go to the Zaoan landmass and reduce their number! Kill 900 drakens, I'll accept: draken abomination, draken elite, draken spellweaver and draken warmaster. Are you in?",
	["destroyers"] = "You can find those dark creatures on several places all over Tibia. For this task I want you to kill 650 destroyers. Are you in?"
}
local messageStartTaskAlt = {
	["crocodile"] = messageStartTask["crocodiles"],
	["badger"] = messageStartTask["badgers"],
	["tarantula"] = messageStartTask["tarantulas"],
	["stone golem"] = messageStartTask["stone golems"],
	["mammoth"] = messageStartTask["mammoths"],
	["gnarlhound"] = messageStartTask["gnarlhounds"],
	["terramite"] = messageStartTask["terramites"],
	["ape"] = messageStartTask["apes"],
	["thornback tortoise"] = messageStartTask["thornback tortoises"],
	["gargoyle"] = messageStartTask["gargoyles"],
	["ice golem"] = messageStartTask["ice golems"],
	["quara scout"] = messageStartTask["quara scouts"],
	["mutated rat"] = messageStartTask["mutated rats"],
	["ancient scarab"] = messageStartTask["ancient scarabs"],
	["wyvern"] = messageStartTask["wyverns"],
	["lancer beetle"] = messageStartTask["lancer beetles"],
	["wailing widow"] = messageStartTask["wailing widows"],
	["killer caiman"] = messageStartTask["killer caimans"],
	["bonebeast"] = messageStartTask["bonebeasts"],
	["crystal spider"] = messageStartTask["crystal spiders"],
	["mutated tiger"] = messageStartTask["mutated tigers"],
	["giant spider"] = messageStartTask["giant spiders"],
	["werewolve"] = messageStartTask["werewolves"],
	["nightmare"] = messageStartTask["nightmares"],
	["hellspawn"] = messageStartTask["hellspawns"],
	["high class lizard"] = messageStartTask["high class lizards"],
	["stampor"] = messageStartTask["stampors"],
	["brimstone bug"] = messageStartTask["brimstone bugs"],
	["mutated bat"] = messageStartTask["mutated bats"],
	["hydra"] = messageStartTask["hydras"],
	["serpent spawn"] = messageStartTask["serpent spawns"],
	["medusa"] = messageStartTask["medusae"],
	["behemoth"] = messageStartTask["behemoths"],
	["sea serpent"] = messageStartTask["sea serpents"],
	["hellhound"] = messageStartTask["hellhounds"],
	["ghastly dragon"] = messageStartTask["ghastly dragons"],
	["undead dragon"] = messageStartTask["undead dragons"],
	["draken"] = messageStartTask["drakens"],
	["destroyer"] = messageStartTask["destroyers"],
}
local function checkX(npc, player, d, message)
	for m = 1, #tasks.GrizzlyAdams do
		if tasks.GrizzlyAdams[m].bossName then
			if tasks.GrizzlyAdams[m].bossName:lower() == message:lower() then
				for n = 1, #tasks.GrizzlyAdams[m].rewards do
					if isInArray({REWARD_STORAGE, "storage", "stor"}, tasks.GrizzlyAdams[m].rewards[n].type:lower()) then
						if player:getStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[1]) < 0 and player:getLevel() >= d then
							npcHandler:say("You're a lucky one. You can go and kill him without spending your 'boss points'. Have fun!", npc, player)
							player:setStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[1], 1)
							player:setStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[2], 0)
						elseif player:getStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[1]) == 3 or player:getStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[1]) < 0 then
							npcHandler:say(messageBossStart[tasks.GrizzlyAdams[m].bossId], npc, player)
							player:setStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[1], 1)
							player:setStorageValue(tasks.GrizzlyAdams[m].rewards[n].value[2], 0)
							player:setStorageValue(Storage.KillingInTheNameOf.BossPoints, player:getStorageValue(Storage.KillingInTheNameOf.BossPoints) - 1)
							player:setStorageValue(Storage.KillingInTheNameOf.QuestLogEntry, player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry)) -- fake update
							return true
						else
							npcHandler:say("You have '"..tasks.GrizzlyAdams[m].bossName.."' task active.", npc, player)
						end
					end
				end
			end
		end
	end
end
local function checkY(npc, player, message)
	for a = 1, #tasks.GrizzlyAdams do
		if message:lower() == tasks.GrizzlyAdams[a].raceName:lower() then
			if player:getStorageValue(REPEATSTORAGE_BASE + a) == 3 then
				npcHandler:say("You have already complete this task "..player:getStorageValue(REPEATSTORAGE_BASE + a).." times.", npc, player)
				return true
			end
		end
	end
end
local function checkZ(npc, player, message)
	for k = 1, #tasks.GrizzlyAdams do
		for o = 1, #tasks.GrizzlyAdams[k].rewards do
			if isInArray({REWARD_ACHIEVEMENT, "achievement", "ach"}, tasks.GrizzlyAdams[k].rewards[o].type:lower()) then
				if player:getStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[1]) == 2 and player:getStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[2]) == 0 then
					player:setStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[1], 1)
				end
				if player:getStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[1]) == 2 and player:getStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[2]) == 1 then
					player:setStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[1], 3)
					player:setStorageValue(tasks.GrizzlyAdams[k].rewards[o + 1].value[2], 0)
					player:addAchievement(tasks.GrizzlyAdams[k].rewards[o].value[1])
					npcHandler:say("You've killed " .. tasks.GrizzlyAdams[k].bossName .. "! Let's continue with your normal {tasks}.", npc, player)
					return true
				end
			end
		end
	end
end
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	message = message:gsub("(%l)(%w*)", function(a,b) return string.upper(a)..b end)

	if MsgContains("join", message) or MsgContains("yes", message) and npcHandler:getTopic(playerId) == 0 and player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry) ~= 0 then
		player:setStorageValue(JOIN_STOR, 1)
		player:setStorageValue(Storage.KillingInTheNameOf.BossPoints, 0)
		player:setStorageValue(Storage.KillingInTheNameOf.QuestLogEntry, 0)
		player:setStorageValue(POINTSSTORAGE, 0)
		npcHandler:say("Great! A warm welcome to our newest member: |PLAYERNAME|! Ask me for a {task} if you want to go on a hunt.", npc, creature)
	elseif isInArray({"report", "reports"}, message:lower()) then
		if checkZ(npc, player, message) == true then
			return true
		else
			npcHandler:say("You have nothing to report.", npc, creature)
		end
	elseif isInArray({"tasks", "task", "mission"}, message:lower()) then
		if player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry) ~= 0 then
			return npcHandler:say("You'll have to {join}, to get any {tasks}.", npc, creature)
		end
		if checkZ(npc, player, message) == true then
			return true
		end
		if player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) < 0 and player:getStorageValue(POINTSSTORAGE) >= 10 and player:getLevel() >= 6 or		-- to Huntsman Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 0 and player:getStorageValue(POINTSSTORAGE) >= 20 and player:getLevel() >= 6 or			-- to Ranger Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 2 and player:getStorageValue(POINTSSTORAGE) >= 40 and player:getLevel() >= 50 or		-- to Big Game Hunter Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 4 and player:getStorageValue(POINTSSTORAGE) >= 70 and player:getLevel() >= 80 or		-- to Trophy Hunter Rank
		player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 6 and player:getStorageValue(POINTSSTORAGE) >= 100 and player:getLevel() >= 130 then	-- to Elite Hunter Rank
			npcHandler:say("You are ready to advance one rank in our society |PLAYERNAME|. Ask me for a {promotion} first.", npc, creature)
			return true
		end
		local messageAlt, messageAltPoints, messageAltExtra, messageAltExtraPoints = false
		local extraValue = 0
		local messageAltId = 1
		local started = player:getStartedTasks()
		local finished = 0
		if started and #started > 0 then
			local id, reward
			for i = 1, #started do
				id = started[i]
				if player:getStorageValue(KillCounter + id) >= tasks.GrizzlyAdams[id].killsRequired then
					finished = finished + 1
					for j = 1, #tasks.GrizzlyAdams[id].rewards do
						reward = tasks.GrizzlyAdams[id].rewards[j]
						local deny = false
						if reward.storage then
							if player:getStorageValue(reward.storage[1]) >= reward.storage[2] then
								deny = true
							end
						end
						if isInArray({REWARD_MONEY, "money"}, reward.type:lower()) and not deny then
							player:addMoney(reward.value[1])
						elseif isInArray({REWARD_EXP, "exp", "experience"}, reward.type:lower()) and not deny then
							player:addExperience(reward.value[1], true)
						elseif isInArray({REWARD_STORAGE, "storage", "stor"}, reward.type:lower()) and not deny then
							if #reward.value == 2 then
								player:setStorageValue(reward.value[1], reward.value[2])
								if tasks.GrizzlyAdams[id].raceName:lower() == "demons" then
									messageAltExtra = true
								end
							elseif isInArray({1, 2}, player:getStorageValue(reward.value[1])) then
								player:setStorageValue(Storage.KillingInTheNameOf.BossPoints, player:getStorageValue(Storage.KillingInTheNameOf.BossPoints) + 1)
							else
								player:setStorageValue(reward.value[1], reward.value[3])
								player:setStorageValue(reward.value[2], reward.value[4])
								messageAlt = true
								messageAltId = tasks.GrizzlyAdams[id].bossId
							end
						elseif isInArray({REWARD_POINT, "points", "point"}, reward.type:lower()) and not deny then
							if player:getStorageValue(POINTSSTORAGE) >= 40 and player:getLevel() < 50 or
							player:getStorageValue(POINTSSTORAGE) >= 70 and player:getLevel() < 80 or
							player:getStorageValue(POINTSSTORAGE) >= 100 and player:getLevel() < 130 then
								messageAltPoints = true
							elseif player:getLevel() >= 130 and player:getStorageValue(POINTSSTORAGE) <= 20 then
								player:setStorageValue(POINTSSTORAGE, getPlayerTasksPoints(creature) + reward.value[1] + 3)
								messageAltExtraPoints = true
								extraValue = 3
								player:setStorageValue(Storage.KillingInTheNameOf.QuestLogEntry, player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry)) -- fake update
							elseif player:getLevel() >= 130 and player:getStorageValue(POINTSSTORAGE) <= 40 then
								player:setStorageValue(POINTSSTORAGE, getPlayerTasksPoints(creature) + reward.value[1] + 2)
								messageAltExtraPoints = true
								extraValue = 2
								player:setStorageValue(Storage.KillingInTheNameOf.QuestLogEntry, player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry)) -- fake update
							elseif player:getLevel() >= 130 and player:getStorageValue(POINTSSTORAGE) <= 70 then
								player:setStorageValue(POINTSSTORAGE, getPlayerTasksPoints(creature) + reward.value[1] + 1)
								messageAltExtraPoints = true
								extraValue = 1
								player:setStorageValue(Storage.KillingInTheNameOf.QuestLogEntry, player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry)) -- fake update
							else
								player:setStorageValue(POINTSSTORAGE, getPlayerTasksPoints(creature) + reward.value[1])
								player:setStorageValue(Storage.KillingInTheNameOf.QuestLogEntry, player:getStorageValue(Storage.KillingInTheNameOf.QuestLogEntry)) -- fake update
							end
						elseif isInArray({REWARD_ITEM, "item", "items", "object"}, reward.type:lower()) and not deny then
							player:addItem(reward.value[1], reward.value[2])
						end

						if reward.storage then
							player:setStorageValue(reward.storage[1], reward.storage[2])
						end
					end

					player:setStorageValue(QUESTSTORAGE_BASE + id, (tasks.GrizzlyAdams[id].norepeatable and 2 or 0))
					if tasks.GrizzlyAdams[id].repeatable then
						player:setStorageValue(REPEATSTORAGE_BASE + id, math.max(player:getStorageValue(REPEATSTORAGE_BASE + id), 0))
					else
						player:setStorageValue(REPEATSTORAGE_BASE + id, math.max(player:getStorageValue(REPEATSTORAGE_BASE + id), 0))
						player:setStorageValue(REPEATSTORAGE_BASE + id, player:getStorageValue(REPEATSTORAGE_BASE + id) + 1)
					end
					if player:getStorageValue(REPEATSTORAGE_BASE + id) == 3 then
						player:setStorageValue(KILLSSTORAGE_BASE + id, 2)
					else
						player:setStorageValue(KILLSSTORAGE_BASE + id, player:getStorageValue(KILLSSTORAGE_BASE + id) + 1)
					end
					player:setStorageValue(KillCounter, 0)
				end
			end
		end
		if messageAltExtra == true then
			npcHandler:say({
			"Such brave deed deserves a special reward! Take this holy icon. It neutralises great evil and gives you access to areas which are protected by those forces. But remember ...",
			"This is a one-time opportunity! You won't get the holy icon twice."}, npc, creature)
			return true
		end
		if finished > 0 then
			local chanceY = math.random(4)
			if finished == 1 then
				if messageAlt == false then
					if messageAltPoints == true then
						npcHandler:say({
						"Ah, okay. This time you'll just get an experience reward, no points for our society as you already gained enough points for your level range. Ask me for a {boss} and the choice is yours. ...",
						"Level up and new tasks and thus points will be available."}, npc, creature)
					elseif messageAltExtraPoints == true then
						npcHandler:say("You're lucky today. This time you'll get an experience reward and "..extraValue.." extra points for our societ.", npc, creature)
					else
						npcHandler:say(messageTask[chanceY], npc, creature)
					end
				else
					npcHandler:say(messageBoss[messageAltId], npc, creature)
				end
			else
				npcHandler:say(messageTask[chanceY], npc, creature)
			end
			return true
		end
		if #player:getStartedTasks() >= tasksByPlayer then
			npcHandler:say("You've three unfinished tasks running old chap. If you want to accept a new one, you have to delete one of your old ones. Do you want to delete a task?", npc, creature)
			npcHandler:setTopic(playerId, 10)
			return true
		end
		if player:getLevel() < 50 then
			if player:getStorageValue(POINTSSTORAGE) >= 40 then
				npcHandler:say({
				"You may not advance in your rank anymore until you've levelled up. But you can accept tasks without getting Paw & Fur points, just for an experience reward and the possibility to fight a boss from the range lower than level 50. ...",
				"You can try {crocodiles}, {badgers}, {tarantulas}, {carniphilas}, {stone golems}, {mammoths}, {gnarlhounds}, ...",
				"as well as {terramites}, {apes}, {thornback tortoises} and {gargoyles}."}, npc, creature)
			else
				npcHandler:say("Alright, what would you like to hunt? {Crocodiles}, {badgers}, {tarantulas}, {carniphilas}, {stone golems}, {mammoths}, {gnarlhounds}, {terramites}, {apes}, {thornback tortoises} or {gargoyles}.", npc, creature)
			end
		elseif player:getLevel() >= 50 and player:getLevel() < 80 then
			if player:getStorageValue(POINTSSTORAGE) >= 70 then
				npcHandler:say({
				"You may not advance in your rank anymore until you've levelled up. But you can accept tasks without getting Paw & Fur points, just for an experience reward and the possibility to fight a boss from the range lower than level 80. ...",
				"You can try {ice golems}, {quara scouts}, {mutated rats}, {ancient scarabs}, {wyverns}, {lancer beetles}, {wailing widows}, ...",
				"as well as {killer caimans}, {bonebeasts}, {crystal spiders} and {mutated tigers}."}, npc, creature)
			else
				npcHandler:say({
				"Alright, what would you like to hunt? {Ice golems}, {quara scouts}, {mutated rats}, {ancient scarabs}, {wyverns}, {lancer beetles}, ...",
				"or {wailing widows}, {killer caimans}, {bonebeasts}, {crystal spiders} or {mutated tigers}."}, npc, creature)
			end
		elseif player:getLevel() >= 80 and player:getLevel() < 130 then
			if player:getStorageValue(POINTSSTORAGE) >= 100 then
				npcHandler:say({
				"You may not advance in your rank anymore until you've levelled up. But you can accept tasks without getting Paw & Fur points, just for an experience reward and the possibility to fight a boss from the range lower than level 130. ...",
				"You can try {underwater quara}, {giant spiders}, {werewolves}, {nightmares}, {hellspawns}, {high class lizards}, {stampors}, ...",
				"as well as {brimstone bugs} and {mutated bats}."}, npc, creature)
			else
				npcHandler:say({
				"Alright, what would you like to hunt? {Underwater quara}, {giant spiders}, {werewolves}, {nightmares}, {hellspawns}, ...",
				"as well as {high class lizards}, {stampors}, {brimstone bugs}, {mutated bats}."}, npc, creature)
			end
		elseif player:getLevel() >= 130 and player:getStorageValue(POINTSSTORAGE) < 100 then
			npcHandler:say({
			"Alright, what would you like to hunt? You can try {hydras}, {serpent spawns}, {medusae}, {behemoths}, {sea serpents}, ...",
			"as well as {hellhounds}, {ghastly dragons}, {undead dragons}, {draken} and {destroyers}."}, npc, creature)
		else
			npcHandler:say({
			"Alright, what would you like to hunt? Be aware you won't gain any paw and fur points as you already achieved the highest rank, but you'll get an experience reward and can face bosses. ...",
			"You can try {hydras}, {serpent spawns}, {medusae}, {behemoths}, {sea serpents}, ...",
			"as well as {hellhounds}, {ghastly dragons}, {undead dragons}, {draken} and {destroyers} or maybe {demons}."}, npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif message ~= "" and player:canStartTask(message) then
		if #player:getStartedTasks() >= tasksByPlayer then
			npcHandler:say("You've three unfinished tasks running old chap. If you want to accept a new one, you have to delete one of your old ones. Do you want to delete a task?", npc, creature)
			npcHandler:setTopic(playerId, 10)
			return true
		end
		local task = getTaskByName(message)
		if task and player:getStorageValue(QUESTSTORAGE_BASE + task) > 0 then
			return false
		end
		local messageElse = "You already achieved the maximum rank for your level range. If you accept this task, you won't gain points for our society. Hunt "..tasks.GrizzlyAdams[task].killsRequired.." "..tasks.GrizzlyAdams[task].raceName.." and you'll be rewarded with experience and the possibility to choose a {boss}. Are you in, old chap?"
		if isInArray(tier[1].allName, message:lower()) then
			if player:getStorageValue(POINTSSTORAGE) >= 40 and player:getLevel() < 50 then
				npcHandler:say(messageElse, npc, creature)
			elseif isInArray({"carniphilas", "carniphila"}, message:lower()) then
				local chanceX = math.random(2)
				local messageCarniphilas = {
					[1] = "Interesting kind and not so easy to find. The fun begins when you want to hunt {Tiquanda's Revenge}. It's strong and smart like no other carniphila.",
					[2] = "Damn walking weed-thingies! You'll find them deeper in the jungle. Weed out 150 carniphilas for our society. Alright?"
				}
				npcHandler:say(messageCarniphilas[chanceX], npc, creature)
			elseif isInArray(tier[1].withsName, message:lower()) then
				npcHandler:say(messageStartTask[message:lower()], npc, creature)
			else
				npcHandler:say(messageStartTaskAlt[message:lower()], npc, creature)
			end
		elseif isInArray(tier[2].allName, message:lower()) then
			if player:getStorageValue(POINTSSTORAGE) >= 70 and player:getLevel() < 80 then
				npcHandler:say(messageElse, npc, creature)
			elseif isInArray(tier[2].withsName, message:lower()) then
				npcHandler:say(messageStartTask[message:lower()], npc, creature)
			else
				npcHandler:say(messageStartTaskAlt[message:lower()], npc, creature)
			end
		elseif isInArray(tier[3].allName, message:lower()) then
			if player:getStorageValue(POINTSSTORAGE) >= 100 and player:getLevel() < 130 then
				npcHandler:say(messageElse, npc, creature)
			elseif isInArray(tier[3].withsName, message:lower()) then
				npcHandler:say(messageStartTask[message:lower()], npc, creature)
			else
				npcHandler:say(messageStartTaskAlt[message:lower()], npc, creature)
			end
		elseif isInArray(tier[4].allName, message:lower()) then
			if isInArray(tier[4].withsName, message:lower()) then
				npcHandler:say(messageStartTask[message:lower()], npc, creature)
			else
				npcHandler:say(messageStartTaskAlt[message:lower()], npc, creature)
			end
		elseif isInArray({"demons", "demon"}, message:lower()) and player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 7 then
			npcHandler:say("The spawn of pure evil must be erased from Tibia. You'll find demons lurking in the northern ruins of Edron as well as in some other deeper dungeons of Tibia. Slay 6666 demons for the greater good! Do you think you can handle this task?", npc, creature)
		else
			npcHandler:say("In this task you must defeat "..tasks.GrizzlyAdams[task].killsRequired.." "..tasks.GrizzlyAdams[task].raceName..". Are you sure that you want to start this task?", npc, creature)
		end
		choose[playerId] = task
		npcHandler:setTopic(playerId, 1)
	elseif isInArray(tier[1].allName, message:lower()) and player:getLevel() < 50 and npcHandler:getTopic(playerId) < 2 then
		checkY(npc, player, message)
	elseif isInArray(tier[2].allName, message:lower()) and player:getLevel() < 80 and npcHandler:getTopic(playerId) < 2 then
		checkY(npc, player, message)
	elseif isInArray(tier[3].allName, message:lower()) and player:getLevel() < 130 and npcHandler:getTopic(playerId) < 2 then
		checkY(npc, player, message)
	elseif message:lower() == "yes" and npcHandler:getTopic(playerId) == 1 then
		player:setStorageValue(QUESTSTORAGE_BASE + choose[playerId], 1)
		player:setStorageValue(KillCounter + choose[playerId], 0)
		if #tasks.GrizzlyAdams[choose[playerId]].creatures > 1 then
			if tasks.GrizzlyAdams[choose[playerId]].raceName == "Apes" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.KongraCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.MerlkinCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.SibangCount, 0)
			elseif	tasks.GrizzlyAdams[choose[playerId]].raceName == "Quara Scouts" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraConstrictorScoutCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraHydromancerScoutCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaramMntassinScoutCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPincherScoutCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPredatorScoutCount, 0)
			elseif	tasks.GrizzlyAdams[choose[playerId]].raceName == "Underwater Quara" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraConstrictorCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraHydromancerCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraMantassinCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPincherCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.QuaraPredatorCount, 0)
			elseif	tasks.GrizzlyAdams[choose[playerId]].raceName == "Nightmares" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NightmareCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.NightmareScionCount, 0)
			elseif	tasks.GrizzlyAdams[choose[playerId]].raceName == "High Class Lizards" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardChosenCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardDragonPriestCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardHighGuardCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardLegionnaireCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.LizardZaogunCount, 0)
			elseif	tasks.GrizzlyAdams[choose[playerId]].raceName == "Sea Serpents" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.SeaSerpentCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.YoungSeaSerpentCount, 0)
			elseif	tasks.GrizzlyAdams[choose[playerId]].raceName == "Drakens" then
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenAbominationCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenEliteCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenSpellweaverCount, 0)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.AltKillCount.DrakenWarmasterCount, 0)
			end
		end
		if player:getStorageValue(KILLSSTORAGE_BASE + choose[playerId]) == 1 then
			player:setStorageValue(KILLSSTORAGE_BASE + choose[playerId], player:getStorageValue(KILLSSTORAGE_BASE + choose[playerId]) - 1)
		else
			player:setStorageValue(KILLSSTORAGE_BASE + choose[playerId], player:getStorageValue(KILLSSTORAGE_BASE + choose[playerId]) + 1)
		end
		local chance = math.random(10)
		npcHandler:say(messageYes[chance], npc, creature)
		choose[playerId] = nil
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains("status", message) then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ""
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				text = text .. "Task name: " .. tasks.GrizzlyAdams[id].raceName .. ". "..
					"Current kills: " .. player:getStorageValue(KillCounter + id) .. ".\n"
			end
			npcHandler:say({"The status of your current tasks is:\n" .. text}, npc, creature)
		else
			npcHandler:say("You haven't started any task yet.", npc, creature)
		end
	elseif isInArray({"promotion", "promotions"}, message:lower()) then
		if player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) < 0 and player:getStorageValue(POINTSSTORAGE) >= 10 and player:getLevel() >= 6 then -- to Huntsman Rank
			npcHandler:say({
			"You gained 10 points! Let me promote you to the first rank: 'Huntsman'. Congratulations! ...",
			"If you find any trophies - either monster heads or other parts of monsters that you don't need - feel free to ask me for a trade."}, npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.PawAndFurRank, 0)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 0 and player:getStorageValue(POINTSSTORAGE) >= 20 and player:getLevel() >= 6 then -- to Ranger Rank
			npcHandler:say({
			"You gained 20 points. It's time for a promotion. You advance to the rank of a 'Ranger'. Congratulations! ...",
			"Oh, I made a deal with Lorek. He ships Rangers from our society - and higher ranks of course - to Banuta, Chor or near the mountain pass to Darama. Just ask him for a passage."}, npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.PawAndFurRank, 2)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 2 and player:getStorageValue(POINTSSTORAGE) >= 40 and player:getLevel() >= 50 then -- to Big Game Hunter Rank
			npcHandler:say({
			"Good show! You gained 40 points for the 'Paw and Fur - Hunting Elite'. You have earned the right to join the ranks of those known as 'Big game hunter'. Congratulations! ...",
			"From now on I'll buy more trophies from you!"}, npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.PawAndFurRank, 4)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 4 and player:getStorageValue(POINTSSTORAGE) >= 70 and player:getLevel() >= 80 then -- to Trophy Hunter Rank
			npcHandler:say({
			"Spiffing! You gained 70 hunting points! From now on you can call yourself a 'Trophy hunter'. As a reward I have this special backpack for you and in addition, you can sell some more rare trophies to me. ...",
			"Ask me for {special} tasks from time to time."}, npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.PawAndFurRank, 6)
		elseif player:getStorageValue(Storage.KillingInTheNameOf.PawAndFurRank) == 6 and player:getStorageValue(POINTSSTORAGE) >= 100 and player:getLevel() >= 130 then -- to Elite Hunter Rank
			npcHandler:say("Congratulations, |PLAYERNAME|! You have gained the highest rank: 'Elite hunter'. If you haven't done yet, ask me for the {special} task.", npc, creature)
			player:setStorageValue(Storage.KillingInTheNameOf.PawAndFurRank, 7)
		else
			npcHandler:say("You have not enough points for promotion.", npc, creature)
		end
	elseif isInArray({"boss", "bosses"}, message:lower()) then
		if checkZ(npc, player, message) == true then
			return true
		end
		if player:getStorageValue(Storage.KillingInTheNameOf.BossPoints) > 0 then
			if player:getLevel() < 50 then
				npcHandler:say("You can choose between the {Snapper}, {Hide}, {Deathbine} and the {Bloodtusk}.", npc, creature)
				npcHandler:setTopic(playerId, 4)
			elseif player:getLevel() >= 50 and player:getLevel() < 80 then
				npcHandler:say({
				"You can choose between the {Snapper}, {Hide}, {Deathbine}, the {Bloodtusk}, {Shardhead}, {Fleshcrawler}, {Ribstride}, {Bloodweb} and {Esmeralda}"}, npc, creature)
				npcHandler:setTopic(playerId, 5)
			elseif player:getLevel() >= 80 and player:getLevel() < 130 then
				npcHandler:say({
				"You can choose between the {Snapper}, {Hide}, {Deathbine}, the {Bloodtusk}, {Shardhead}, {Fleshcrawler}, {Ribstride}, {Bloodweb}, {Esmeralda}, ...",
				"{Thul}, {Flameborn}, {Sulphur Scuttler}, the {Old Widow}, {Hemming}, {Tormentor}, {Fazzrah}, {Tromphonyte} and {Bruise Payne}."}, npc, creature)
				npcHandler:setTopic(playerId, 6)
			else
				npcHandler:say({
				"You can choose between the {Snapper}, {Hide}, {Deathbine}, the {Bloodtusk}, {Shardhead}, {Fleshcrawler}, {Ribstride}, {Bloodweb}, {Esmeralda}, ...",
				"{Thul}, {Flameborn}, {Sulphur Scuttler}, the {Old Widow}, {Hemming}, {Tormentor}, {Fazzrah}, {Tromphonyte}, {Bruise Payne}, ...",
				"the {Many}, the {Noxious Spawn}, {Stonecracker}, {Gorgo}, {Kerberos}, {Ethershreck}, {Zanakeph}, {Paiz the Pauperizer}, {Bretzecutioner} and {Leviathan}."}, npc, creature)
				npcHandler:setTopic(playerId, 7)
			end
		else
			npcHandler:say("You have "..player:getStorageValue(Storage.KillingInTheNameOf.BossPoints).." boss points.", npc, creature)
		end
	elseif isInArray({"snapper", "hide", "deathbine", "bloodtusk"}, message:lower()) and npcHandler:getTopic(playerId) >= 4 and npcHandler:getTopic(playerId) <= 7 then
		checkX(npc, player, 50, message)
	elseif isInArray({"shardhead", "fleshcrawler", "ribstride", "bloodweb", "esmeralda"}, message:lower()) and npcHandler:getTopic(playerId) >= 5 and npcHandler:getTopic(playerId) <= 7 then
		checkX(npc, player, 80, message)
	elseif isInArray({"thul", "flameborn", "sulphur scuttler", "old widow", "hemming", "tormentor", "fazzrah", "tromphonyte", "bruise payne"}, message:lower()) and npcHandler:getTopic(playerId) >= 6 and npcHandler:getTopic(playerId) <= 7 then
		checkX(npc, player, 130, message)
	elseif isInArray({"many", "noxious spawn", "stonecracker", "gorgo", "kerberos", "ethershreck", "zanakeph", "paiz the pauperizer", "bretzecutioner", "leviathan"}, message:lower()) and npcHandler:getTopic(playerId) == 7 then
		for w = 1, #tasks.GrizzlyAdams do
			if tasks.GrizzlyAdams[w].bossName then
				if tasks.GrizzlyAdams[w].bossName:lower() == message:lower() then
					for y = 1, #tasks.GrizzlyAdams[w].rewards do
						if isInArray({REWARD_STORAGE, "storage", "stor"}, tasks.GrizzlyAdams[w].rewards[y].type:lower()) then
							if player:getStorageValue(tasks.GrizzlyAdams[w].rewards[y].value[1]) == 3 or player:getStorageValue(tasks.GrizzlyAdams[w].rewards[y].value[1]) < 0 then
								npcHandler:say(messageBossStart[tasks.GrizzlyAdams[w].bossId], npc, creature)
								player:setStorageValue(tasks.GrizzlyAdams[w].rewards[y].value[1], 1)
								player:setStorageValue(tasks.GrizzlyAdams[w].rewards[y].value[2], 0)
								player:setStorageValue(Storage.KillingInTheNameOf.BossPoints, player:getStorageValue(Storage.KillingInTheNameOf.BossPoints) - 1)
								return true
							else
								npcHandler:say("You have '"..tasks.GrizzlyAdams[w].bossName.."' task active.", npc, creature)
							end
						end
					end
				end
			end
		end
	elseif message:lower() == "started" then
		local started = player:getStartedTasks()
		if started and #started > 0 then
			local text = ""
			local sep = ", "
			table.sort(started, (function(a, b) return (a < b) end))
			local t = 0
			local id
			for i = 1, #started do
				id = started[i]
				t = t + 1
				if t == #started - 1 then
					sep = " and "
				elseif t == #started then
					sep = "."
				end
				text = text .. "{" .. (tasks.GrizzlyAdams[id].name or tasks.GrizzlyAdams[id].raceName) .. "}" .. sep
			end

			npcHandler:say("The current task" .. (#started > 1 and "s" or "") .. " that you started" ..
				" " .. (#started > 1 and "are" or "is") .. " " .. text, npc, creature)
		else
			npcHandler:say("You haven't started any task yet.", npc, creature)
		end
	elseif message:lower() == "cancel" or message:lower() == "yes" and npcHandler:getTopic(playerId) == 10 then
		local started = player:getStartedTasks()
		local text = ""
		local sep = ", "
		table.sort(started, (function(a, b) return (a < b) end))
		local t = 0
		local id
		for i = 1, #started do
			id = started[i]
			t = t + 1
			if t == #started - 1 then
				sep = " or "
			elseif t == #started then
				sep = "?"
			end
			text = text .. "{" .. (tasks.GrizzlyAdams[id].name or tasks.GrizzlyAdams[id].raceName) .. "}" .. sep
		end
		if started and #started > 0 then
			npcHandler:say("Canceling a task will make the counter restart. " ..
						"Which of these tasks you want cancel?" .. (#started > 1 and "" or "") .. " " .. text, npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say("You haven't started any task yet.", npc, creature)
		end
	elseif ((getTaskByName(message)) and
			(npcHandler:getTopic(playerId) == 2) and
			(isInArray(getPlayerStartedTasks(creature), getTaskByName(message)))) then
		local task = getTaskByName(message)
		if player:getStorageValue(KillCounter + task) > 0 then
			npcHandler:say("You currently killed " .. player:getStorageValue(KillCounter + task) .. "/" ..
						tasks.GrizzlyAdams[task].killsRequired .. " " .. tasks.GrizzlyAdams[task].raceName .. "."..
						" ".."Canceling this task will restart the count."..
						" ".."Are you sure you want to cancel this task?", npc, creature)
		else
			npcHandler:say("Are you sure you want to cancel this task?", npc, creature)
		end
		npcHandler:setTopic(playerId, 3)
		cancel[playerId] = task
	elseif ((getTaskByName(message)) and
			(npcHandler:getTopic(playerId) == 1) and
			(isInArray(getPlayerStartedTasks(creature), getTaskByName(message)))) then
		local task = getTaskByName(message)
		if player:getStorageValue(KillCounter + task) > 0 then
			npcHandler:say("You currently killed " ..
						player:getStorageValue(KillCounter + task) .. "/" ..
						tasks.GrizzlyAdams[task].killsRequired .. " " ..
						tasks.GrizzlyAdams[task].raceName .. ".", npc, creature)
		else
			npcHandler:say("You currently killed 0/" .. tasks.GrizzlyAdams[task].killsRequired .. " " .. tasks.GrizzlyAdams[task].raceName .. ".", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif message:lower() == "yes" and npcHandler:getTopic(playerId) == 3 then
		player:setStorageValue(QUESTSTORAGE_BASE + cancel[playerId], -1)
		player:setStorageValue(KILLSSTORAGE_BASE + cancel[playerId], player:getStorageValue(KILLSSTORAGE_BASE + cancel[playerId]) - 1)
		player:setStorageValue(KillCounter + cancel[playerId], 0)
		npcHandler:say("You have canceled the task " ..
					(tasks.GrizzlyAdams[cancel[playerId]].name or tasks.GrizzlyAdams[cancel[playerId]].raceName) .. ".", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif isInArray({"points", "rank"}, message:lower()) then
		npcHandler:say("At this time, you have " .. player:getPawAndFurPoints() .. " Paw & Fur points. You " ..
					(player:getPawAndFurRank() == 6 and "are an Elite Hunter" or
					player:getPawAndFurRank() == 5 and "are a Trophy Hunter" or
					player:getPawAndFurRank() == 4 and "are a Big Game Hunter" or
					player:getPawAndFurRank() == 3 and "are a Ranger" or
					player:getPawAndFurRank() == 2 and "are a Huntsman" or
					player:getPawAndFurRank() == 1 and "are a Member"  or
					"haven't been ranked yet") .. ".", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif message:lower() == "no" and npcHandler:getTopic(playerId) == 10 then
		npcHandler:say("Speak to me again when you are done hunting", npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif isInArray({"special", "special task"}, message:lower()) then
		if player:getPawAndFurPoints() >= 70 and player:getLevel() >= 80 then
			if player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) < 1 then
				npcHandler:say({
				"Have you heard about {Tiquanda's Revenge}? It is said that the jungle itself is alive and takes revenge for all the bad things people have done to it. ...",
				"I myself believe that there is some truth in this clap-trap. Something 'real' which must have a hideout somewhere. Go find it and take revenge yourself! Ask me about the {special} task when you're done."}, npc, creature)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.TiquandasCount, 0)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge, 1)
			elseif player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) <= 2 and player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.TiquandasCount) == 0 then
				npcHandler:say("You have already started the task. Go find Tiquandas Revenge and take revenge yourself!", npc, creature)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge, 1) -- for death scenario
			elseif player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 2 and player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.TiquandasCount) == 1 then
				npcHandler:say("Great achievement, old chap! You are an outstanding hunter, no doubt about it!", npc, creature)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge, 3)
			elseif player:getStorageValue(Storage.KillingInTheNameOf.MissionDemodras) < 1 then
				npcHandler:say("This task is a very dangerous one. I want you to look for {Demodras'} hideout. It might be somewhere under the {Plains of Havoc}. Good luck, old chap, come back in one piece and ask me about the special task when you're done.", npc, creature)
				player:setStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.DemodrasCount, 0)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionDemodras, 1)
			elseif player:getStorageValue(Storage.KillingInTheNameOf.MissionDemodras) <= 2 and player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.DemodrasCount) == 0 then
				npcHandler:say("You have already started the special task. Find Demodras and kill it.", npc, creature)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionDemodras, 1) -- for death scenario
			elseif player:getStorageValue(Storage.KillingInTheNameOf.MissionDemodras) == 2 and player:getStorageValue(Storage.Quest.U8_5.KillingInTheNameOf.BossKillCount.DemodrasCount) == 1 then
				npcHandler:say("Jolly good show! You can cross swords with any creature in this world! I bow to you.", npc, creature)
				player:setStorageValue(Storage.KillingInTheNameOf.MissionDemodras, 3)
			elseif player:getStorageValue(Storage.KillingInTheNameOf.MissionDemodras) == 3 and player:getStorageValue(Storage.KillingInTheNameOf.MissionTiquandasRevenge) == 3 then
				npcHandler:say("You have already finished all special tasks.", npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_FAREWELL, "Happy hunting, old chap!")
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
