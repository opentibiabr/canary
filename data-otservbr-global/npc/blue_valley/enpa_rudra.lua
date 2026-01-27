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
}

npcConfig.voices = {
	interval = 15000,
	chance = 0,
	{
		text = "",
	},
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local promotionNode = keywordHandler:addKeyword({ "promot" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "I can promote you for 20000 gold coins. Do you want me to promote you?" })
promotionNode:addChildKeyword({ "yes" }, StdModule.promotePlayer, { npcHandler = npcHandler, monk = true, cost = 20000, level = 20, text = "Congratulations! You are now promoted." })
promotionNode:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, monk = true, onlyFocus = true, text = "Alright then, come back when you are ready.", reset = true })

keywordHandler:addSpellKeyword({ "destroy field rune" }, {
	npcHandler = npcHandler,
	spellName = "Destroy Field Rune",
	price = 700,
	level = 17,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "disintegrate rune" }, {
	npcHandler = npcHandler,
	spellName = "Disintegrate Rune",
	price = 900,
	level = 21,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "magic patch" }, {
	npcHandler = npcHandler,
	spellName = "Magic Patch",
	price = 0,
	level = 8,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "light healing" }, {
	npcHandler = npcHandler,
	spellName = "Light Healing",
	price = 0,
	level = 8,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "intense healing" }, {
	npcHandler = npcHandler,
	spellName = "Intense Healing",
	price = 350,
	level = 20,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "cure poison" }, {
	npcHandler = npcHandler,
	spellName = "Cure Poison",
	price = 150,
	level = 10,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "restore balance" }, {
	npcHandler = npcHandler,
	spellName = "Restore Balance",
	price = 800,
	level = 18,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "spirit mend" }, {
	npcHandler = npcHandler,
	spellName = "Spirit Mend",
	price = 9000,
	level = 80,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "mass spirit mend" }, {
	npcHandler = npcHandler,
	spellName = "Mass Spirit Mend",
	price = 20000,
	level = 150,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "tiger clash" }, {
	npcHandler = npcHandler,
	spellName = "Tiger Clash",
	price = 0,
	level = 8,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "swift jab" }, {
	npcHandler = npcHandler,
	spellName = "Swift Jab",
	price = 0,
	level = 8,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "double jab" }, {
	npcHandler = npcHandler,
	spellName = "Double Jab",
	price = 1000,
	level = 14,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "greater tiger clash" }, {
	npcHandler = npcHandler,
	spellName = "Greater Tiger Clash",
	price = 6000,
	level = 18,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "chained penance" }, {
	npcHandler = npcHandler,
	spellName = "Chained Penance",
	price = 8000,
	level = 70,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "sweeping takedown" }, {
	npcHandler = npcHandler,
	spellName = "Sweeping Takedown",
	price = 8000,
	level = 60,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "flurry of blows" }, {
	npcHandler = npcHandler,
	spellName = "Flurry of Blows",
	price = 1500,
	level = 35,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "greater flurry of blows" }, {
	npcHandler = npcHandler,
	spellName = "Greater Flurry of Blows",
	price = 11000,
	level = 90,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "devastating knockout" }, {
	npcHandler = npcHandler,
	spellName = "Devastating Knockout",
	price = 20000,
	level = 125,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "magic rope" }, {
	npcHandler = npcHandler,
	spellName = "Magic Rope",
	price = 200,
	level = 9,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "levitate" }, {
	npcHandler = npcHandler,
	spellName = "Levitate",
	price = 500,
	level = 12,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "haste" }, {
	npcHandler = npcHandler,
	spellName = "Haste",
	price = 600,
	level = 14,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "strong haste" }, {
	npcHandler = npcHandler,
	spellName = "Strong Haste",
	price = 1300,
	level = 20,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "find person" }, {
	npcHandler = npcHandler,
	spellName = "Find Person",
	price = 80,
	level = 8,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "find fiend" }, {
	npcHandler = npcHandler,
	spellName = "Find Fiend",
	price = 1000,
	level = 25,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "light" }, {
	npcHandler = npcHandler,
	spellName = "Light",
	price = 0,
	level = 8,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "great light" }, {
	npcHandler = npcHandler,
	spellName = "Great Light",
	price = 500,
	level = 13,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "balanced brawl" }, {
	npcHandler = npcHandler,
	spellName = "Balanced Brawl",
	price = 250000,
	level = 175,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "focus serenity" }, {
	npcHandler = npcHandler,
	spellName = "Focus Serenity",
	price = 125000,
	level = 150,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "enlighten party" }, {
	npcHandler = npcHandler,
	spellName = "Enlighten Party",
	price = 4000,
	level = 32,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "summon monk familiar" }, {
	npcHandler = npcHandler,
	spellName = "Monk Familiar",
	price = 50000,
	level = 200,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addSpellKeyword({ "mentor other" }, {
	npcHandler = npcHandler,
	spellName = "Mentor Other",
	price = 175000,
	level = 150,
	vocation = VOCATION.BASE_ID.MONK,
})

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {rune spells} and {instant spells}. What kind of spell do you wish to learn? You can also tell me for which level you would like to learn a spell, if you prefer that.",
})

keywordHandler:addKeyword({ "instant spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I sell {healing spells}, {attack spells} and {support spells}. Which of these interests you most?",
})

keywordHandler:addKeyword({ "healing spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "In this category I have '{Magic Patch}', '{Light Healing}', '{Intense Healing}', '{Cure Poison}', '{Restore Balance}', '{Spirit Mend}' and '{Mass Spirit Mend}'.",
})

keywordHandler:addKeyword({ "attack spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "In this category I have '{Tiger Clash}', '{Swift Jab}', '{Double Jab}', '{Greater Tiger Clash}', '{Chained Penance}', '{Sweeping Takedown}', '{Flurry of Blows}', '{Greater Flurry of Blows}' and '{Devastating Knockout}'.",
})

keywordHandler:addKeyword({ "support spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"In this category I have '{Magic Rope}', '{Levitate}', '{Haste}', '{Strong Haste}', '{Find Person}', '{Find Fiend}', '{Light}', '{Great Light}', '{Balanced Brawl}', '{Focus Serenity}', '{Enlighten Party}' ...",
		"'{Summon Monk Familiar}' and '{Mentor Other}'.",
	},
})

keywordHandler:addKeyword({ "rune spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I sell {support rune spells}. Which of these interests you most?",
})

keywordHandler:addKeyword({ "support rune spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "In this category I have 'PDestroy Field Rune{' and '{Disintegrate Rune}'.",
})

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
	text = "All initiates have to undergo the Three-Fold path to understand the way of the Merudri and become true warrior monks. ...",
	"Many generations of monks have been chosen to travel the world of Tibia incognito to study and learn the ways of the outside world. The pilgrims are not to take part in skirmishes or settle down outside of the valley. ...",
	"Learning, documenting and training, they eventually find their way back to the valley after years of wandering. Embracing the three elements of harmony, enlightenment and power. ...",
	"These three elements of totality are to be found among the Merudri shrines which dot Tibian landscapes all over our world. ...",
	"Enpa-Deia Pema will answer all your questions concerning our sacred pilgrimage.",
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

keywordHandler:addKeyword({ "semi-enpa", "Sempi-Enpa" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"There comes a time when an Enpa reaches the utmost level of harmony, enlightenment and control. In this completely serene state, he can focus all his energy and wield tremendous power over himself - and others. ...",
		"It is possible for an Enpa to move on to a higher state and leave the physical body to become Dhar-Enpa. After this, most of the mind of an Enpa is focused on control and containment. ...",
		"Once a Dhar-Enpa decides to essentially become one with our world itself, he becomes Sempi-Enpa, eternal and powerful beyond imagination. ...",
		"Dhar-Enpa Gaan decided to leave his metaphysical state and become Sempi-Enpa to close the reality rift and seal the Yng from ever trespassing the valley again. He closed the rift but was not able to contain and control his power. ...",
		"Lost in a dimensional pocket that formed during the closing of the rift, he is lost to the Merudri and a potential threat to everything in this realm. It is for this reason, that only one other Enpa has decided to become Dhar-Enpa ever since.",
	},
})

keywordHandler:addKeyword({ "yng", "Yng" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The Yng, our nemesis, scourge of our ancestors and defining our legacy. Entering our realm through the depths of the reality rift, they terrorised the Merudri for centuries.",
})

keywordHandler:addKeyword({ "dhar-enpa", "Dhar-Enpa" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"There comes a time when an Enpa reaches the utmost level of harmony, enlightenment and control. In this completely serene state, he can focus all his energy and wield tremendous power over himself - and others. ...",
		"It is possible for an Enpa to move on to a higher state and leave the physical body to become Dhar-Enpa. After this, most of the mind of an Enpa is focused on control and containment. ...",
		"Once a Dhar-Enpa decides to essentially become one with our world itself, he becomes Sempi-Enpa, eternal and powerful beyond imagination. ...",
		"Dhar-Enpa Gaan decided to leave his metaphysical state and become Sempi-Enpa to close the reality rift and seal the Yng from ever trespassing the valley again. He closed the rift but was not able to contain and control his power. ...",
		"Lost in a dimensional pocket that formed during the closing of the rift, he is lost to the Merudri and a potential threat to everything in this realm. It is for this reason, that only one other Enpa has decided to become Dhar-Enpa ever since.",
	},
})

keywordHandler:addKeyword({ "job", "Job" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am the current Enpa of our community in this sacred valley.",
})

keywordHandler:addKeyword({ "name", "Name" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I am Enpa Ruda, welcome to the {valley}.",
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "pilgrimage") then
		local shrinesCount = player:getStorageValue(Storage.Quest.U14_15.TheWayOfTheMonk.ShrinesCount)
		if shrinesCount >= #TheWayOfTheMonkShrines then
			npcHandler:say("You are a monk of the Merudri, enlightened and beyond the Three-Fold Path. You have visited all of our ancestral shrines and embraced eternity. The Enpa will see you now.", npc, creature)
		else
			local currentShrine = TheWayOfTheMonkShrines[shrinesCount]
			local nextShrine = TheWayOfTheMonkShrines[shrinesCount + 1]
			npcHandler:say(string.format("You are an initiate of the Merudri, inducted and on the Three-Fold Path. You have visited the second of the shrines and embraced '%s'. ...", currentShrine.name), npc, creature)
			npcHandler:say(string.format("The next step, embracing '%s', will lead you to the south of Thais, away from the city.", nextShrine.name), npc, creature)
		end
	end
	return true
end

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()
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
