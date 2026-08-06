local internalNpcName = "Enpa Rudra"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1816,
	lookHead = 40,
	lookBody = 9,
	lookLegs = 63,
	lookFeet = 63,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
	profession = "banker",
}
npcConfig.speechBubble = SPEECHBUBBLE_BANKER

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
local monkQuestTotalShrines = math.max(1, configManager.getNumber(configKeys.MONK_QUEST_TOTAL_SHRINES))

local promotionNode = keywordHandler:addKeyword({ "promot" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I can promote you for 20000 gold coins. Do you want me to promote you?" })
promotionNode:addChildKeyword({ "yes" }, StdModule.promotePlayer, { npcHandler = npcHandler, monk = true, cost = 20000, level = 20, text = "Congratulations! You are now promoted." })
promotionNode:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, monk = true, onlyFocus = true, text = "Alright then, come back when you are ready.", reset = true })

local node1 = keywordHandler:addKeyword({ "greater tiger clash" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {greater tiger clash} magic spell for 6000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "greater tiger clash", vocation = { 9, 10 }, price = 6000, level = 18 })

local node2 = keywordHandler:addKeyword({ "greater flurry of blows" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {greater flurry of blows} magic spell for 11000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "greater flurry of blows", vocation = { 9, 10 }, price = 11000, level = 90 })

local node3 = keywordHandler:addKeyword({ "sweeping takedown" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {sweeping takedown} magic spell for 8000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "sweeping takedown", vocation = { 9, 10 }, price = 8000, level = 60 })

local node4 = keywordHandler:addKeyword({ "chained penance" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {chained penance} magic spell for 8000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "chained penance", vocation = { 9, 10 }, price = 8000, level = 70 })

local node5 = keywordHandler:addKeyword({ "mass spirit mend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {mass spirit mend} magic spell for 20000 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "mass spirit mend", vocation = { 9, 10 }, price = 20000, level = 150 })

local node6 = keywordHandler:addKeyword({ "flurry of blows" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {flurry of blows} magic spell for 1500 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "flurry of blows", vocation = { 9, 10 }, price = 1500, level = 35 })

local node7 = keywordHandler:addKeyword({ "devastating knockout" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {devastating knockout} magic spell for 20000 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "devastating knockout", vocation = { 9, 10 }, price = 20000, level = 125 })

local node8 = keywordHandler:addKeyword({ "spirit mend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {spirit mend} magic spell for 9000 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "spirit mend", vocation = { 9, 10 }, price = 9000, level = 80 })

local node9 = keywordHandler:addKeyword({ "focus serenity" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {focus serenity} magic spell for 125000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "focus serenity", vocation = { 9, 10 }, price = 125000, level = 150 })

local node10 = keywordHandler:addKeyword({ "mentor other" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {mentor other} magic spell for 175000 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "mentor other", vocation = { 9, 10 }, price = 175000, level = 150 })

local node11 = keywordHandler:addKeyword({ "balanced brawl" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {balanced brawl} magic spell for 250000 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "balanced brawl", vocation = { 9, 10 }, price = 250000, level = 175 })

local node12 = keywordHandler:addKeyword({ "monk familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn Summon {Monk Familiar} magic spell for 50000 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "monk familiar", vocation = { 9, 10 }, price = 50000, level = 200 })

local node13 = keywordHandler:addKeyword({ "restore balance" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {restore balance} magic spell for 800 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "restore balance", vocation = { 9, 10 }, price = 800, level = 18 })

local node14 = keywordHandler:addKeyword({ "enlighten party" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {enlighten party} magic spell for 4000 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "enlighten party", vocation = { 9, 10 }, price = 4000, level = 32 })

local node15 = keywordHandler:addKeyword({ "double jab" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {double jab} magic spell for 1000 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "double jab", vocation = { 9, 10 }, price = 1000, level = 14 })

local node16 = keywordHandler:addKeyword({ "strong haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong haste} magic spell for 1300 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "strong haste", vocation = { 1, 2, 5, 6, 9, 10 }, price = 1300, level = 20 })

local node17 = keywordHandler:addKeyword({ "tiger clash" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {tiger clash} magic spell for free?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "tiger clash", vocation = { 9, 10 }, price = 0, level = 1 })

local node18 = keywordHandler:addKeyword({ "swift jab" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {swift jab} magic spell for free?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "swift jab", vocation = { 9, 10 }, price = 0, level = 1 })

local node19 = keywordHandler:addKeyword({ "virtue of harmony" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {virtue of harmony} magic spell for free?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "virtue of harmony", vocation = { 10 }, price = 0, level = 20 })

local node20 = keywordHandler:addKeyword({ "virtue of justice" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {virtue of justice} magic spell for free?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "virtue of justice", vocation = { 10 }, price = 0, level = 20 })

local node21 = keywordHandler:addKeyword({ "virtue of sustain" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {virtue of sustain} magic spell for free?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "virtue of sustain", vocation = { 10 }, price = 0, level = 20 })

local node22 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node23 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node24 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node25 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 1 })

local node26 = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic rope} magic spell for 200 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic rope", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 200, level = 9 })

local node27 = keywordHandler:addKeyword({ "levitate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {levitate} magic spell for 500 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "levitate", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 12 })

local node28 = keywordHandler:addKeyword({ "haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {haste} magic spell for 600 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "haste", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 600, level = 14 })

local node29 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node30 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node31 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node32 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells and {support} spells. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Chained Penance}, {Devastating Knockout}, {Double Jab}, {Flurry of Blows}, {Greater Flurry of Blows}, {Greater Tiger Clash}, {Sweeping Takedown}, {Swift Jab} and {Tiger Clash}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Poison}, {Intense Healing}, {Light Healing}, {Magic Patch}, {Mass Spirit Mend}, {Restore Balance}, and {Spirit Mend}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Balanced Brawl}, {Enlighten Party}, {Find Fiend}, {Find Person}, {Focus Serenity}, {Great Light}, {Haste}, {Levitate}, {Light}, {Magic Rope}, {Mentor Other}, {Strong Haste} and Summon {Monk Familiar}, {Virtue of Harmony}, {Virtue of Justice} and {Virtue of Sustain}.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {9}, {10}, {12}, {13}, {14}, {18}, {20}, {25}, {32}, {35}, {60}, {70}, {80}, {90}, {125}, {150}, {175} and {200}.",
})

nodeLevels:addChildKeyword({ "200" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 200 I have Summon {Monk Familiar} for 50000 gold." })
nodeLevels:addChildKeyword({ "175" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 175 I have {Balanced Brawl} for 250000 gold." })
nodeLevels:addChildKeyword({ "150" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 150 I have {Focus Serenity} for 125000 gold, {Mass Spirit Mend} for 20000 gold and {Mentor Other} for 175000 gold." })
nodeLevels:addChildKeyword({ "125" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 125 I have {Devastating Knockout} for 20000 gold." })
nodeLevels:addChildKeyword({ "90" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 90 I have {Greater Flurry of Blows} for 11000 gold." })
nodeLevels:addChildKeyword({ "80" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 80 I have {Spirit Mend} for 9000 gold." })
nodeLevels:addChildKeyword({ "70" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 70 I have {Chained Penance} for 8000 gold." })
nodeLevels:addChildKeyword({ "60" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 60 I have {Sweeping Takedown} for 8000 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Flurry of Blows} for 1500 gold." })
nodeLevels:addChildKeyword({ "32" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 32 I have {Enlighten Party} for 4000 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold, {Strong Haste} for 1300 gold, {Virtue of Harmony} for free, {Virtue of Justice} for free and {Virtue of Sustain} for free." })
nodeLevels:addChildKeyword({ "18" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 18 I have {Greater Tiger Clash} for 6000 gold and {Restore Balance} for 800 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Double Jab} for 1000 gold and {Haste} for 600 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "12" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 12 I have {Levitate} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "9" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 9 I have {Magic Rope} for 200 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Magic Patch} for free, {Swift Jab} for free and {Tiger Clash} for free." })

keywordHandler:addKeyword({ "seek", "Seek" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Since Manop brought you here, you must be strong at heart, firm of will and eager to learn. ...",
		"He did not choose you, he merely decided not to stand in the path of the choice you already made and helped it manifest in the form of your arrival upon us in our valley. ...",
		"You will learn, you will fight, you will follow the {Three-Fold Path}.",
	},
})

keywordHandler:addKeyword({ "three-fold path", "Three-Fold Path" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"All initiates have to undergo the Three-Fold path to understand the way of the Merudri and become true warrior monks. ...",
		"Many generations of monks have been chosen to travel the world of Tibia incognito to study and learn the ways of the outside world. The pilgrims are not to take part in skirmishes or settle down outside of the valley. ...",
		"Learning, documenting and training, they eventually find their way back to the valley after years of wandering. Embracing the three elements of harmony, enlightenment and power. ...",
		"These three elements of totality are to be found among the Merudri shrines which dot Tibian landscapes all over our world. ...",
		"Enpa-Deia Pema will answer all your questions concerning our sacred pilgrimage.",
	},
})

keywordHandler:addKeyword({ "king", "King" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Monks are no subjects and there is no king without subjects. Our community is bound by tradition and harmony. Our {hierarchies} are shaped by our legacy.",
})

keywordHandler:addKeyword({ "hierarchies", "Hierarchies" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Our hierarchies are based around the concept of the Enpa, spiritual leader and guide to all Merudri, equal, however in rights and power. The Enpa is selected among Merudri and destined to become a warrior monk. ...",
		"Enpa-Jiva, confidants of the Enpa, are trusted to take on specific tasks, the Enpa needs help with. There is always a successor to the Enpa, which we call {Enpa-Deia}, there will be only one. ...",
		"An Enpa can reach a higher state and leave the physical form that binds us to our worldly existence to become {Dhar-Enpa}. ...",
		"Attaining the highest state of consciousness, {Sempi-Enpa}, requires absolute control and perfect balance. For generations, due to our legacy, no Dhar-Enpa has attempted to reach this state. ...",
		"When a successor has been found and is prepared to take on its designated role, the current Enpa will decide if it is time to leave the physical shell.",
	},
})

keywordHandler:addKeyword({ "legacy", "Legacy" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The Merudri, our ancestors, were once separated from their homeland and cut-off from the rest of their civilisation by the creation of a reality rift. ...",
		"Broken away from their home continent and floating through time and space, the Merudri found ways to manipulate the rift, which connected worlds to travel there, looking for a way home. ...",
		"During these times, our ancestors had to fight the Yng, a relentless foe, emerging through the rift and bound on consuming the rest of civilisation. ...",
		"When Sempi-Enpa Gaan closed the rift, the Yng threat was gone, but the cost was immeasurably high. The Sempi-Enpa lost control and got stuck in a dimensional pocket. ...",
		"Losing every last ounce of humanity he once possessed, this metaphysical being now roams another dimension either insane or, even more likely, absolutely determined and with ill intent. ...",
		"You can learn more of our legacy by tapping into our vast collected knowledge in the form of various books, written by monks here in our sanctuary.",
	},
})

keywordHandler:addKeyword({ "enpa-deia", "Enpa-Deia" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The successor to the Enpa is selected at a young age. Once chosen, an {Enpa-Deia} will follow a strict regiment of learning and training to adjust to the future role of the Enpa. ...",
		"Our Enpa-Deia is Pema. She can help you on your path with equipment and spells.",
	},
})

keywordHandler:addKeyword({ "sempi-enpa", "Sempi-Enpa" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Sempi-Enpa is the highest state of existence a Dhar-Enpa can achieve - transcending the metaphysical form to become one with the world itself. Eternal, omnipresent, and wielding power beyond mortal comprehension. ...",
		"A Sempi-Enpa exists everywhere and nowhere, their consciousness merged with the very fabric of reality. They can shape the world, seal dimensional rifts, and protect entire realms from otherworldly threats. ...",
		"However, this transcendence comes at a terrible cost. The Sempi-Enpa loses all connection to their former self, their humanity consumed by the vastness of their new existence. ...",
		"Dhar-Enpa Gaan achieved this state to seal the reality rift and banish the Yng forever. But the power overwhelmed him - he lost control and became trapped in a dimensional pocket of his own creation. ...",
		"Now he exists as a mad god, neither fully in our world nor completely beyond it. A cautionary tale of ultimate power and ultimate sacrifice. This is why no Dhar-Enpa has dared attempt transcendence since.",
	},
})

keywordHandler:addKeyword({ "yng", "Yng" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The Yng, our nemesis, scourge of our ancestors and defining our legacy. Entering our realm through the depths of the reality rift, they terrorised the Merudri for centuries.",
})

keywordHandler:addKeyword({ "dhar-enpa", "Dhar-Enpa" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"When an Enpa reaches perfect harmony, enlightenment and control, they may choose to transcend their physical form and become Dhar-Enpa - a metaphysical being of pure consciousness and will. ...",
		"In this state, the Dhar-Enpa exists between worlds, no longer bound by flesh but not yet merged with reality itself. Their entire focus shifts to control and containment of their immense power. ...",
		"A Dhar-Enpa can influence the physical world through sheer force of will, but they must constantly maintain perfect balance. One moment of lost control could have catastrophic consequences. ...",
		"Dhar-Enpa Gaan was the first to achieve this state. He used his metaphysical power to help seal the reality rift and protect the valley from the Yng. But he knew containment alone would not be enough. ...",
		"That is why he made the ultimate choice - to transcend even further and become Sempi-Enpa, risking everything to permanently seal the rift. Since his tragic fate, only one other Enpa has dared become Dhar-Enpa.",
	},
})

keywordHandler:addKeyword({ "job", "Job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am the current Enpa of our community in this sacred valley.",
})

keywordHandler:addKeyword({ "name", "Name" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am Enpa Rudra, welcome to the {valley}.",
})

keywordHandler:addKeyword({ "valley", "Valley" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "BLUE VALLEY",
})

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

local function creatureSayCallback(npc, creature, msgType, message)
	local player = Player(creature)

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "pilgrimage") then
		local shrinesCount = player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.ShrinesCount)
		-- Normalize shrinesCount: if nil, not a number, or negative, set to 0
		if not shrinesCount or type(shrinesCount) ~= "number" or shrinesCount < 0 then
			shrinesCount = 0
		end
		if shrinesCount >= monkQuestTotalShrines then
			npcHandler:say("You are a monk of the Merudri, enlightened and beyond the Three-Fold Path. You have visited all of our ancestral shrines and embraced eternity. The Enpa will see you now.", npc, creature)
		elseif shrinesCount > 0 and shrinesCount < monkQuestTotalShrines then
			local currentShrine = TheWayOfTheMonkShrines[shrinesCount]
			local nextShrine = TheWayOfTheMonkShrines[shrinesCount + 1]
			local ordinals = { "first", "second", "third", "fourth", "fifth", "sixth", "seventh", "eighth", "ninth", "tenth" }
			local ordinal = ordinals[shrinesCount] or tostring(shrinesCount)
			local currentShrineName = currentShrine and currentShrine.name or "the current shrine"
			local nextShrineName = nextShrine and nextShrine.name or "the next step"
			npcHandler:say(string.format("You are an initiate of the Merudri, inducted and on the Three-Fold Path. You have visited the %s of the shrines and embraced '%s'. ...", ordinal, currentShrineName), npc, creature)
			npcHandler:say(string.format("The next step, embracing '%s', will lead you to the south of Thais, away from the city.", nextShrineName), npc, creature)
		else
			-- shrinesCount is 0, player hasn't started yet
			local firstShrine = TheWayOfTheMonkShrines[1]
			if firstShrine then
				npcHandler:say(string.format("You are an initiate of the Merudri, ready to begin the Three-Fold Path. Your first step is to embrace '%s'.", firstShrine.name), npc, creature)
			end
		end
	end
	return true
end

local function greetCallback(npc, creature)
	npcHandler:setMessage(MESSAGE_GREET, "I welcome you, monk. Now that you have been brought here, tell me what you seek in this most sacred place. I can also teach you {spells} or {promote} you.")
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)

npcHandler:setMessage(MESSAGE_FAREWELL, "Focus on truth and balance and you will stay on the path.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Harmony. Enlightenment. Power.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
