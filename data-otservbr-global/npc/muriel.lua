local internalNpcName = "Muriel"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 115,
	lookBody = 94,
	lookLegs = 97,
	lookFeet = 76,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getLevel() < 35 then
			npcHandler:say("Indeed there is something to be done, but I need someone more experienced. Come back later if you want to.", npc, creature)
			return true
		end

		if player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) == -1 then
			npcHandler:say({
				"Indeed, there is something you can do for me. You must know I am researching for a new spell against the undead. ...",
				"To achieve that I need a desecrated bone. There is a cursed bone pit somewhere in the dungeons north of Thais where the dead never rest. ...",
				"Find that pit, dig for a well-preserved human skeleton and conserve a sample in a special container which you receive from me. Are you going to help me?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) == 1 then
			npcHandler:say({
				"The rotworms dug deep into the soil north of Thais. Rumours say that you can access a place of endless moaning from there. ...",
				"No one knows how old that common grave is but the people who died there are cursed and never come to rest. A bone from that pit would be perfect for my studies.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit) == 2 then
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit, 3)
			if player:removeItem(131, 1) then
				player:addItem(6299, 1)
				npcHandler:say("Excellent! Now I can try to put my theoretical thoughts into practice and find a cure for the symptoms of undead. Here, take this for your efforts.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({
					"I am so glad you are still alive. Benjamin found the container with the bone sample inside. Fortunately, I inscribe everything with my name, so he knew it was mine. ...",
					"I thought you have been haunted and killed by the undead. I'm glad that this is not the case. Thank you for your help.",
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		else
			npcHandler:say("I am very glad you helped me, but I am very busy at the moment.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "addons") then
		local hasMasks = player:getItemCount(25088) >= 3
		local hasFeathers = player:getItemCount(25089) >= 50
		if player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers) == 2 and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1) == 1 and hasMasks then
			npcHandler:say("I see you have the porcelain masks. Are you ready to exchange them for the first addon?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers) == 2 and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2) == 1 and hasFeathers then
			npcHandler:say("I see you have the colourful feathers. Are you ready to exchange them for the second addon?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		else
			npcHandler:say("You need the outfit and 3 porcelain masks or 50 colored feathers to get the festive costume accessories.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "mask") and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1) == 1 then
		if player:removeItem(25088, 3) then
			player:addOutfit(929, 1)
			player:addOutfit(931, 1)
			npcHandler:say("Very good! You gained the first addon to the festive outfit.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Oh, sorry but you don't have enough porcelain masks!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "feather") and player:getStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2) == 1 then
		if player:removeItem(25089, 50) then
			player:addOutfit(929, 2)
			player:addOutfit(931, 2)
			npcHandler:say("Very good! You gained the second addon to the festive outfit.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2, 2)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("Oh, sorry but you don't have enough colourful feathers!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Great! Here is the container for the bone. Once, I used it to collect ectoplasma of ghosts, but it will work here as well. ...",
				"If you lose it, you can buy a new one from the explorer's society in North Port or Port Hope. Ask me about the mission when you come back.",
			}, npc, creature)
			player:addItem(4852, 1)
			player:setStorageValue(Storage.Quest.U8_1.TibiaTales.IntoTheBonePit, 1)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I provide two addons. For the first one I need you to bring me three porcelain masks. For the second addon you need fifty colourful ostrich feathers. Do you want one of these addons?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("What do you have for me: the porcelain masks or the colourful feathers?", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon1, 1)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say("I provide two addons. For the first one I need you to bring me three porcelain masks. For the second addon you need fifty colourful ostrich feathers. Do you want one of these addons?", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.FestiveOutfits.Addon2, 1)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("Ohh, then I need to find another adventurer who wants to earn a great reward. Bye!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

local node1 = keywordHandler:addKeyword({ "apprentice's strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {apprentice's strike} magic spell for free?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "apprentice's strike", vocation = { 1, 2, 5, 6 }, price = 0, level = 8 })

local node2 = keywordHandler:addKeyword({ "creature illusion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {creature illusion} magic spell for 1000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "creature illusion", vocation = { 1, 2, 5, 6 }, price = 1000, level = 23 })

local node3 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 700, level = 17 })

local node4 = keywordHandler:addKeyword({ "great energy beam" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great energy beam} magic spell for 1800 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great energy beam", vocation = { 1, 5 }, price = 1800, level = 29 })

local node5 = keywordHandler:addKeyword({ "energy wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Wall} Rune spell for 2500 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wall rune", vocation = { 1, 2, 5, 6 }, price = 2500, level = 41 })

local node6 = keywordHandler:addKeyword({ "energy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Energy Field} Rune spell for 700 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy field rune", vocation = { 1, 2, 5, 6 }, price = 700, level = 18 })

local node7 = keywordHandler:addKeyword({ "energy wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy wave} magic spell for 2500 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy wave", vocation = { 1, 5 }, price = 2500, level = 38 })

local node8 = keywordHandler:addKeyword({ "energy beam" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {energy beam} magic spell for 1000 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "energy beam", vocation = { 1, 5 }, price = 1000, level = 23 })

local node9 = keywordHandler:addKeyword({ "explosion" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {explosion} magic spell for 1800 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "Explosion Rune", vocation = { 1, 2, 5, 6 }, price = 1800, level = 31 })

local node10 = keywordHandler:addKeyword({ "fire bomb" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Bomb} Rune spell for 1500 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire bomb rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 27 })

local node11 = keywordHandler:addKeyword({ "fire wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Wall} Rune spell for 2000 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wall rune", vocation = { 1, 2, 5, 6 }, price = 2000, level = 33 })

local node12 = keywordHandler:addKeyword({ "fire field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Fire Field} Rune spell for 500 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire field rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node13 = keywordHandler:addKeyword({ "fire wave" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {fire wave} magic spell for 850 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fire wave", vocation = { 1, 5 }, price = 850, level = 18 })

local node14 = keywordHandler:addKeyword({ "great fireball" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Great Fireball} Rune spell for 1200 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great fireball rune", vocation = { 1, 5 }, price = 1200, level = 30 })

local node15 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 500, level = 13 })

local node16 = keywordHandler:addKeyword({ "heavy magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Heavy Magic Missile} Rune spell for 1500 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "heavy magic missile rune", vocation = { 1, 2, 5, 6 }, price = 1500, level = 25 })

local node17 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 350, level = 20 })

local node18 = keywordHandler:addKeyword({ "invisibility" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {invisibility} magic spell for 2000 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "invisibility", vocation = { 1, 2, 5, 6 }, price = 2000, level = 35 })

local node19 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 1, 2, 3, 5, 6, 7, 9, 10 }, price = 0, level = 8 })

local node20 = keywordHandler:addKeyword({ "light magic missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Light Magic Missile} Rune spell for 500 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light magic missile rune", vocation = { 1, 2, 5, 6 }, price = 500, level = 15 })

local node21 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 0, level = 8 })

local node22 = keywordHandler:addKeyword({ "magic shield" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic shield} magic spell for 450 gold?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic shield", vocation = { 1, 2, 5, 6 }, price = 450, level = 14 })

local node23 = keywordHandler:addKeyword({ "poison wall" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Wall} Rune spell for 1600 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison wall rune", vocation = { 1, 2, 5, 6 }, price = 1600, level = 29 })

local node24 = keywordHandler:addKeyword({ "poison field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Poison Field} Rune spell for 300 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "poison field rune", vocation = { 1, 2, 5, 6 }, price = 300, level = 14 })

local node25 = keywordHandler:addKeyword({ "stalagmite" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Stalagmite} Rune spell for 1400 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "stalagmite rune", vocation = { 1, 2, 5, 6 }, price = 1400, level = 24 })

local node26 = keywordHandler:addKeyword({ "sudden death" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Sudden Death} Rune spell for 3000 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "sudden death rune", vocation = { 1, 5 }, price = 3000, level = 45 })

local node27 = keywordHandler:addKeyword({ "summon creature" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon creature} magic spell for 2000 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon creature", vocation = { 1, 2, 5, 6 }, price = 2000, level = 25 })

local node28 = keywordHandler:addKeyword({ "ultimate healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ultimate healing} magic spell for 1000 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ultimate healing", vocation = { 1, 2, 5, 6 }, price = 1000, level = 30 })

local node29 = keywordHandler:addKeyword({ "buzz" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {buzz} magic spell for free?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "buzz", vocation = { 1, 5 }, price = 0, level = 1 })

local node30 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 150, level = 10 })

local node31 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 1000, level = 25 })

local node32 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 1, 2, 3, 4, 5, 6, 7, 8, 9, 10 }, price = 80, level = 8 })

local node33 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node33:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 1, 2, 3, 5, 6, 7 }, price = 0, level = 1 })

local node34 = keywordHandler:addKeyword({ "scorch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {scorch} magic spell for free?" })
node34:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "scorch", vocation = { 1, 5 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells, {support} spells and spells for {runes}. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Apprentice's Strike}, {Buzz}, {Creature Illusion}, {Energy Beam}, {Energy Wave}, {Explosion}, {Fire Wave}, {Great Energy Beam}, {Invisibility}, {Scorch} and {Summon Creature}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Cure Poison}, {Intense Healing}, {Light Healing}, {Magic Patch} and {Ultimate Healing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Find Fiend}, {Find Person}, {Great Light}, {Light}, {Magic Shield}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Destroy Field} Rune, {Energy Field} Rune, {Energy Wall} Rune, {Fire Bomb} Rune, {Fire Field} Rune, {Fire Wall} Rune, {Great Fireball} Rune, {Heavy Magic Missile} Rune, {Light Magic Missile} Rune, {Poison Field} Rune, {Poison Wall} Rune, {Stalagmite} Rune and {Sudden Death} Rune.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {10}, {13}, {14}, {15}, {17}, {18}, {20}, {23}, {24}, {25}, {27}, {29}, {30}, {31}, {33}, {35}, {38}, {41} and {45}.",
})

nodeLevels:addChildKeyword({ "45" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 45 I have {Sudden Death} Rune for 3000 gold." })
nodeLevels:addChildKeyword({ "41" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 41 I have {Energy Wall} Rune for 2500 gold." })
nodeLevels:addChildKeyword({ "38" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 38 I have {Energy Wave} for 2500 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Invisibility} for 2000 gold." })
nodeLevels:addChildKeyword({ "33" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 33 I have {Fire Wall} Rune for 2000 gold." })
nodeLevels:addChildKeyword({ "31" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 31 I have {Explosion} for 1800 gold." })
nodeLevels:addChildKeyword({ "30" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 30 I have {Great Fireball} Rune for 1200 gold and {Ultimate Healing} for 1000 gold." })
nodeLevels:addChildKeyword({ "29" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 29 I have {Great Energy Beam} for 1800 gold and {Poison Wall} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Fire Bomb} Rune for 1500 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Find Fiend} for 1000 gold, {Heavy Magic Missile} Rune for 1500 gold and {Summon Creature} for 2000 gold." })
nodeLevels:addChildKeyword({ "24" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 24 I have {Stalagmite} Rune for 1400 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Creature Illusion} for 1000 gold and {Energy Beam} for 1000 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold." })
nodeLevels:addChildKeyword({ "18" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 18 I have {Energy Field} Rune for 700 gold and {Fire Wave} for 850 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "15" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 15 I have {Fire Field} Rune for 500 gold and {Light Magic Missile} Rune for 500 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Magic Shield} for 450 gold and {Poison Field} Rune for 300 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Apprentice's Strike} for free, {Find Person} for 80 gold, {Light} for free and {Light Healing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Buzz} for free, {Magic Patch} for free and {Scorch} for free." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings, |PLAYERNAME|! Looking for wisdom and power, eh?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "You may call me Muriel." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "I don't like jokes about my name!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the second sorcerer. I am selling spellbooks and spells." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Time is unimportant." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Our guild is working on a new spell, but I won't give away any details yet." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "The king is a patron of the arcane arts." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "The king is a patron of the arcane arts." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "We supply the army with some sorcerer recruits now and then." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "We supply the army with some sorcerer recruits now and then." })
keywordHandler:addKeyword({ "wisdom" }, StdModule.say, { npcHandler = npcHandler, text = "The wisdom of spellcasting is the source of power." })
keywordHandler:addKeyword({ "ancestor" }, StdModule.say, { npcHandler = npcHandler, text = "There have been many generations of sorcerers in the past. Today, a lot of people want to join us." })
keywordHandler:addKeyword({ "sorcerer" }, StdModule.say, { npcHandler = npcHandler, text = "A sorcerer spends his lifetime studying spells to gain power." })
keywordHandler:addKeyword({ "power" }, StdModule.say, { npcHandler = npcHandler, text = "Of course, power is the most important thing in the universe." })
keywordHandler:addKeyword({ "vocation" }, StdModule.say, { npcHandler = npcHandler, text = "Your vocation is your profession. There are four vocations in Tibia: Sorcerers, paladins, knights, and druids." })
keywordHandler:addKeyword({ "rune" }, StdModule.say, { npcHandler = npcHandler, text = "Each spell that starts with 'Ad' needs a rune. You have to have a blank rune with you when you cast it. You can buy runes at the magic shop." })
keywordHandler:addKeyword({ "arcian" }, StdModule.say, { npcHandler = npcHandler, text = "Arcian was a childhood friend of mine. We studied the art of sorcery together but later, our ways parted ... Whereas I stayed here to instruct young new sorcerers, he devoted his life to his own studies ... Since his experiments tended to become a bit dangerous and he wanted to further explore a magic phenomenon he discovered in the Plains of Havoc anyway, he moved there and took his wife and his two assistants with him ... We stayed in contact for a while and he maintained a one-way teleporter to the academy. As I was missing any message from him for some time, I travelled to the plains to learn what might have happened ... I found the house overrun by ghouls, and no living soul. I have to assume that those ghouls have killed them and dragged everyone in their lairs. I left as soon as I could ... I wouldn't have wanted to see what they've done to my old friend. It's a sad story indeed." })
keywordHandler:addKeyword({ "laira" }, StdModule.say, { npcHandler = npcHandler, text = "Laira was the wife of my childhood friend Arcian. She was a warm and caring person. I hope she had not to suffer for long as ... she was killed by the undead. Sorry, I don't want to speak about that matter anymore." })
keywordHandler:addKeyword({ "porgol" }, StdModule.say, { npcHandler = npcHandler, text = "Porgol was a quite bright student, although a bit overambitious. I was surprised when he agreed to accompany my friend Arcian to the Plains of Havoc to support him in his studies ... I was quite sure he'd rather study at the Edron academy instead. But sometimes people surprise one in a positive way. All the more it is tragic he found his death in this assault of undead on Arcian's house." })
keywordHandler:addKeyword({ "flaming pits" }, StdModule.say, { npcHandler = npcHandler, text = "These pits you refer to might be the legendary 'Pits of Inferno', also known as the 'Nightmare Pits'." })
keywordHandler:addKeyword({ "nightmare pits" }, StdModule.say, { npcHandler = npcHandler, text = "They are rumoured to be hidden somewhere in the Plains of Havoc, far to the east." })
keywordHandler:addKeyword({ "pits of inferno" }, StdModule.say, { npcHandler = npcHandler, text = "They are rumoured to be hidden somewhere in the Plains of Havoc, far to the east." })
keywordHandler:addKeyword({ "explorer society" }, StdModule.say, { npcHandler = npcHandler, text = "I heard that a member of the Explorer Society was in fact searching for the First Dragon. What a foolish endeavour - please excuse this comment. A romantic idea and a brave venture but seriously: the First Dragon. It is just a myth! ... However the explorer found an ancient inscription underneath the city of Thais. Reportedly he discovered it in the small cave where the first time ever a dragon was sighted on Tibia." })
keywordHandler:addKeyword({ "inscription" }, StdModule.say, { npcHandler = npcHandler, text = "I heard that a member of the Explorer Society was in fact searching for the First Dragon. What a foolish endeavour - please excuse this comment. A romantic idea and a brave venture but seriously: the First Dragon. It is just a myth! ... However the explorer found an ancient inscription underneath the city of Thais. Reportedly he discovered it in the small cave where the first time ever a dragon was sighted on Tibia." })
keywordHandler:addKeyword({ "cave" }, StdModule.say, { npcHandler = npcHandler, text = "I don't know exactly where it is. Someone told me you have to pass some tunnels full of orcs, somewhere underneath the king's castle. But that might be just gossip." })
keywordHandler:addKeyword({ "first dragon" }, StdModule.say, { npcHandler = npcHandler, text = "The dragon was ancient beyond compare. Eventually even he had to succumb to old age and flew to the dragon cemetery to die there. Or so it is told." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "I wonder how he actually got these awesome powers." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "The enchantments on this weapon must be awesome." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He's not a jester but a poor joke himself." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "She is quite proud of her puny magic tricks." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "A bar is no place that suits a scholar like me." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Knights! Childs with swords. Not worth of any attention." })
keywordHandler:addKeyword({ "lungelen" }, StdModule.say, { npcHandler = npcHandler, text = "She keeps the whole wisdom of our ancestors and leads our guild." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "Pretty and compentent." })
keywordHandler:addKeyword({ "mcronald" }, StdModule.say, { npcHandler = npcHandler, text = "Simple farmers." })
keywordHandler:addKeyword({ "ronald" }, StdModule.say, { npcHandler = npcHandler, text = "Simple farmers." })
keywordHandler:addKeyword({ "sherry" }, StdModule.say, { npcHandler = npcHandler, text = "Simple farmers." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "I don't know him." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "He has some minor magic powers." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "Marvik and his sorcerers lack spells with real power." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "A simple smith." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "Only his boss keeps him from being burnt to ashes." })
keywordHandler:addKeyword({ "xodet" }, StdModule.say, { npcHandler = npcHandler, text = "He has our permission to sell mana fluids." })
keywordHandler:addKeyword({ "harkath bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "He's not as dumb as the average fighter but a warrior nonetheless." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "He is rumoured to possess some secrets our guild might find ... interesting." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I don't think he's any competition. I rarely see him anyway and I don't deem his skills noteworthy." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
