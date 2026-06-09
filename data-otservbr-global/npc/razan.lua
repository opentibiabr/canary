local internalNpcName = "Razan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 19,
	lookBody = 19,
	lookLegs = 9,
	lookFeet = 58,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

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

local topic = {}

local config = {
	["ape fur"] = {
		itemId = 5883,
		count = 100,
		storageValue = 1,
		text = {
			"Have you really managed to fulfil the task and brought me 100 pieces of ape fur?",
			"Only ape fur is good enough to touch the feet of our Caliph.",
			"Ahhh, this softness! I'm impressed, |PLAYERNAME|. You're on the best way to earn that turban. Now, please retrieve 100 fish fins.",
		},
	},
	["fish fins"] = {
		itemId = 5895,
		count = 100,
		storageValue = 2,
		text = {
			"Were you able to discover the undersea race and retrieved 100 fish fins?",
			"I really wonder what the explorer society is up to. Actually I have no idea how they managed to dive unterwater.",
			"I never thought you'd make it, |PLAYERNAME|. Now we only need two enchanted chicken wings to start our waterwalking test!",
		},
	},
	["enchanted chicken wings"] = {
		itemId = 5891,
		count = 2,
		storageValue = 3,
		text = {
			"Were you able to get hold of two enchanted chicken wings?",
			"Enchanted chicken wings are actually used to make boots of haste, so they could be magically extracted again. Djinns are said to be good at that.",
			"Great, thank you very much. Just bring me 100 pieces of blue cloth now and I will happily show you how to make a turban.",
		},
	},
	["blue cloth"] = {
		itemId = 5912,
		count = 100,
		storageValue = 4,
		text = {
			"Ah, have you brought the 100 pieces of blue cloth?",
			"It's a great material for turbans.",
			"Ah! Congratulations - even if you are not a true weaponmaster, you surely deserve to wear this turban. Here, I'll tie it for you.",
		},
	},
}

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if player:getSex() == PLAYERSEX_MALE and MsgContains(message, "outfit") then
		npcHandler:say("My turban? Eh no, you can't have it. Only oriental weapon masters may wear it after having completed a difficult task.", npc, creature)
	elseif player:getSex() == PLAYERSEX_MALE and MsgContains(message, "task") then
		if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) < 1 then
			npcHandler:say("You mean, you would like to prove that you deserve to wear such a turban?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif config[message] and npcHandler:getTopic(playerId) == 0 then
		if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) == config[message].storageValue then
			npcHandler:say(config[message].text[1], npc, creature)
			npcHandler:setTopic(playerId, 3)
			topic[playerId] = message
		else
			npcHandler:say(config[message].text[2], npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Alright, then listen to the following requirements. We are currently in dire need of ape fur since the Caliph has requested a new bathroom carpet. ...",
				"Thus, please bring me 100 pieces of ape fur. Secondly, it came to our ears that the explorer society has discovered a new undersea race of fishmen. ...",
				"Their fins are said to allow humans to walk on water! Please bring us 100 of these fish fin. ...",
				"Third, if the plan of walking on water should fail, we need enchanted chicken wings to prevent the testers from drowning. Please bring me two. ...",
				"Last but not least, just drop by with 100 pieces of blue cloth and I will happily show you how to make a turban. ...",
				"Did you understand everything I told you and are willing to handle this task?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon, 1)
			npcHandler:say("Excellent! Come back to me once you have collected 100 pieces of ape fur.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			local targetMessage = config[topic[playerId]]
			if not player:removeItem(targetMessage.itemId, targetMessage.count) then
				npcHandler:say("That is a shameless lie.", npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon, player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) + 1)
			if player:getStorageValue(Storage.Quest.U7_8.OrientalOutfits.SecondOrientalAddon) == 5 then
				player:addOutfitAddon(146, 2) -- male addon
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			end
			npcHandler:say(targetMessage.text[3], npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) ~= 0 then
		npcHandler:say("What a pity.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

local function onReleaseFocus(npc, creature)
	local playerId = creature:getId()
	topic[playerId] = nil
end

local node1 = keywordHandler:addKeyword({ "summon knight familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon knight familiar} magic spell for 50000 gold?" })
node1:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon knight familiar", vocation = { 4, 8 }, price = 50000, level = 200 })

local node2 = keywordHandler:addKeyword({ "summon paladin familiar" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {summon paladin familiar} magic spell for 50000 gold?" })
node2:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "summon paladin familiar", vocation = { 3, 7 }, price = 50000, level = 200 })

local node3 = keywordHandler:addKeyword({ "strong ethereal spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {strong ethereal spear} magic spell for 10000 gold?" })
node3:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "strong ethereal spear", vocation = { 3, 7 }, price = 10000, level = 90 })

local node4 = keywordHandler:addKeyword({ "chivalrous challenge" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {chivalrous challenge} magic spell for 250000 gold?" })
node4:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "chivalrous challenge", vocation = { 4, 8 }, price = 250000, level = 150 })

local node5 = keywordHandler:addKeyword({ "fair wound cleansing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {fair wound cleansing} magic spell for 500000 gold?" })
node5:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fair wound cleansing", vocation = { 4, 8 }, price = 500000, level = 300 })

local node6 = keywordHandler:addKeyword({ "fierce berserk" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {fierce berserk} magic spell for 7500 gold?" })
node6:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "fierce berserk", vocation = { 4, 8 }, price = 7500, level = 90 })

local node7 = keywordHandler:addKeyword({ "intense recovery" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense recovery} magic spell for 10000 gold?" })
node7:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense recovery", vocation = { 3, 4, 7, 8 }, price = 10000, level = 100 })

local node8 = keywordHandler:addKeyword({ "intense wound cleansing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense wound cleansing} magic spell for 6000 gold?" })
node8:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense wound cleansing", vocation = { 4, 8 }, price = 6000, level = 80 })

local node9 = keywordHandler:addKeyword({ "conjure explosive arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure explosive arrow} magic spell for 1000 gold?" })
node9:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure explosive arrow", vocation = { 3, 7 }, price = 1000, level = 25 })

local node10 = keywordHandler:addKeyword({ "divine caldera" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine caldera} magic spell for 3000 gold?" })
node10:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "divine caldera", vocation = { 3, 7 }, price = 3000, level = 50 })

local node11 = keywordHandler:addKeyword({ "divine healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine healing} magic spell for 3000 gold?" })
node11:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "divine healing", vocation = { 3, 7 }, price = 3000, level = 35 })

local node12 = keywordHandler:addKeyword({ "divine missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {divine missile} magic spell for 1800 gold?" })
node12:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "divine missile", vocation = { 3, 7 }, price = 1800, level = 40 })

local node13 = keywordHandler:addKeyword({ "ethereal spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {ethereal spear} magic spell for 1100 gold?" })
node13:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "ethereal spear", vocation = { 3, 7 }, price = 1100, level = 23 })

local node14 = keywordHandler:addKeyword({ "front sweep" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {front sweep} magic spell for 4000 gold?" })
node14:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "front sweep", vocation = { 4, 8 }, price = 4000, level = 70 })

local node15 = keywordHandler:addKeyword({ "groundshaker" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {groundshaker} magic spell for 1500 gold?" })
node15:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "groundshaker", vocation = { 4, 8 }, price = 1500, level = 33 })

local node16 = keywordHandler:addKeyword({ "holy flash" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {holy flash} magic spell for 7500 gold?" })
node16:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "holy flash", vocation = { 3, 7 }, price = 7500, level = 70 })

local node17 = keywordHandler:addKeyword({ "inflict wound" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {inflict wound} magic spell for 2500 gold?" })
node17:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "inflict wound", vocation = { 4, 8 }, price = 2500, level = 40 })

local node18 = keywordHandler:addKeyword({ "salvation" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {salvation} magic spell for 8000 gold?" })
node18:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "salvation", vocation = { 3, 7 }, price = 8000, level = 60 })

local node19 = keywordHandler:addKeyword({ "swift foot" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {swift foot} magic spell for 6000 gold?" })
node19:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "swift foot", vocation = { 3, 7 }, price = 6000, level = 55 })

local node20 = keywordHandler:addKeyword({ "whirlwind throw" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {whirlwind throw} magic spell for 1500 gold?" })
node20:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "whirlwind throw", vocation = { 4, 8 }, price = 1500, level = 28 })

local node21 = keywordHandler:addKeyword({ "annihilation" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {annihilation} magic spell for 20000 gold?" })
node21:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "annihilation", vocation = { 4, 8 }, price = 20000, level = 110 })

local node22 = keywordHandler:addKeyword({ "berserk" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {berserk} magic spell for 2500 gold?" })
node22:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "berserk", vocation = { 4, 8 }, price = 2500, level = 35 })

local node23 = keywordHandler:addKeyword({ "brutal strike" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {brutal strike} magic spell for 1000 gold?" })
node23:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "brutal strike", vocation = { 4, 8 }, price = 1000, level = 16 })

local node24 = keywordHandler:addKeyword({ "cancel invisibility" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cancel invisibility} magic spell for 1600 gold?" })
node24:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cancel invisibility", vocation = { 3, 7 }, price = 1600, level = 26 })

local node25 = keywordHandler:addKeyword({ "charge" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {charge} magic spell for 1300 gold?" })
node25:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "charge", vocation = { 4, 8 }, price = 1300, level = 25 })

local node26 = keywordHandler:addKeyword({ "conjure arrow" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {conjure arrow} magic spell for 450 gold?" })
node26:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "conjure arrow", vocation = { 3, 7 }, price = 450, level = 13 })

local node27 = keywordHandler:addKeyword({ "cure bleeding" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure bleeding} magic spell for 2500 gold?" })
node27:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure bleeding", vocation = { 4, 8 }, price = 2500, level = 45 })

local node28 = keywordHandler:addKeyword({ "cure curse" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure curse} magic spell for 6000 gold?" })
node28:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure curse", vocation = { 3, 7 }, price = 6000, level = 80 })

local node29 = keywordHandler:addKeyword({ "cure poison" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {cure poison} magic spell for 150 gold?" })
node29:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "cure poison", vocation = { 3, 4, 7, 8 }, price = 150, level = 10 })

local node30 = keywordHandler:addKeyword({ "destroy field" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Destroy Field} Rune spell for 700 gold?" })
node30:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "destroy field rune", vocation = { 3, 7 }, price = 700, level = 17 })

local node31 = keywordHandler:addKeyword({ "disintegrate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Disintegrate} Rune spell for 900 gold?" })
node31:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "disintegrate rune", vocation = { 3, 7 }, price = 900, level = 21 })

local node32 = keywordHandler:addKeyword({ "enchant spear" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {enchant spear} magic spell for 2000 gold?" })
node32:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "enchant spear", vocation = { 3, 7 }, price = 2000, level = 45 })

local node33 = keywordHandler:addKeyword({ "find fiend" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find fiend} magic spell for 1000 gold?" })
node33:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find fiend", vocation = { 3, 4, 7, 8 }, price = 1000, level = 25 })

local node34 = keywordHandler:addKeyword({ "find person" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {find person} magic spell for 80 gold?" })
node34:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "find person", vocation = { 3, 4, 7, 8 }, price = 80, level = 8 })

local node35 = keywordHandler:addKeyword({ "great light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {great light} magic spell for 500 gold?" })
node35:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "great light", vocation = { 3, 4, 7, 8 }, price = 500, level = 13 })

local node36 = keywordHandler:addKeyword({ "haste" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {haste} magic spell for 600 gold?" })
node36:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "haste", vocation = { 3, 4, 7, 8 }, price = 600, level = 14 })

local node37 = keywordHandler:addKeyword({ "holy missile" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {Holy Missile} Rune spell for 1600 gold?" })
node37:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "holy missile rune", vocation = { 3, 7 }, price = 1600, level = 27 })

local node38 = keywordHandler:addKeyword({ "intense healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {intense healing} magic spell for 350 gold?" })
node38:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "intense healing", vocation = { 3, 7 }, price = 350, level = 20 })

local node39 = keywordHandler:addKeyword({ "lesser front sweep" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {lesser front sweep} magic spell for free?" })
node39:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "lesser front sweep", vocation = { 4, 8 }, price = 0, level = 1 })

local node40 = keywordHandler:addKeyword({ "levitate" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {levitate} magic spell for 500 gold?" })
node40:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "levitate", vocation = { 3, 4, 7, 8 }, price = 500, level = 12 })

local node41 = keywordHandler:addKeyword({ "light healing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light healing} magic spell for free?" })
node41:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light healing", vocation = { 3, 7 }, price = 0, level = 8 })

local node42 = keywordHandler:addKeyword({ "light" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {light} magic spell for free?" })
node42:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "light", vocation = { 3, 4, 7, 8 }, price = 0, level = 8 })

local node43 = keywordHandler:addKeyword({ "magic patch" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic patch} magic spell for free?" })
node43:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic patch", vocation = { 3, 7 }, price = 0, level = 1 })

local node44 = keywordHandler:addKeyword({ "magic rope" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {magic rope} magic spell for 200 gold?" })
node44:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "magic rope", vocation = { 3, 4, 7, 8 }, price = 200, level = 9 })

local node45 = keywordHandler:addKeyword({ "recovery" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {recovery} magic spell for 4000 gold?" })
node45:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "recovery", vocation = { 3, 4, 7, 8 }, price = 4000, level = 50 })

local node46 = keywordHandler:addKeyword({ "wound cleansing" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {wound cleansing} magic spell for free?" })
node46:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "wound cleansing", vocation = { 4, 8 }, price = 0, level = 8 })

local node47 = keywordHandler:addKeyword({ "arrow call" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {arrow call} magic spell for free?" })
node47:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "arrow call", vocation = { 3, 7 }, price = 0, level = 1 })

local node48 = keywordHandler:addKeyword({ "bruise bane" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "Would you like to learn {bruise bane} magic spell for free?" })
node48:addChildKeyword({ "yes" }, StdModule.learnSpell, { npcHandler = npcHandler, premium = false, spellName = "bruise bane", vocation = { 4, 8 }, price = 0, level = 1 })

keywordHandler:addKeyword({ "spells" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "I can teach you {attack} spells, {healing} spells and {support} spells. What kind of spell do you wish to learn? I can also tell you which spells are available at your {level}.",
})

keywordHandler:addKeyword({ "attack" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My attack spells are: {Annihilation}, {Berserk}, {Brutal Strike}, {Chivalrous Challenge}, {Divine Caldera}, {Divine Missile}, {Ethereal Spear}, {Fierce Berserk}, {Front Sweep}, {Groundshaker}, {Holy Flash}, {Inflict Wound}, {Lesser Front Sweep}, {Strong Ethereal Spear} and {Whirlwind Throw}.",
})

keywordHandler:addKeyword({ "healing" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My healing spells are: {Bruise Bane}, {Cure Bleeding}, {Cure Curse}, {Cure Poison}, {Divine Healing}, {Fair Wound Cleansing}, {Intense Healing}, {Intense Recovery}, {Intense Wound Cleansing}, {Light Healing}, {Magic Patch}, {Recovery}, {Salvation} and {Wound Cleansing}.",
})

keywordHandler:addKeyword({ "support" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My support spells are: {Arrow Call}, {Cancel Invisibility}, {Charge}, {Conjure Arrow}, {Conjure Explosive Arrow}, {Enchant Spear}, {Find Fiend}, {Find Person}, {Great Light}, {Haste}, {Levitate}, {Light}, {Magic Rope}, {Summon Knight Familiar}, {Summon Paladin Familiar} and {Swift Foot}.",
})

keywordHandler:addKeyword({ "runes" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "My rune spells are: {Destroy Field} Rune, {Disintegrate} Rune and {Holy Missile} Rune.",
})

local nodeLevels = keywordHandler:addKeyword({ "level" }, StdModule.say, {
	npcHandler = npcHandler,
	onlyFocus = true,
	text = "I have spells for level {1}, {8}, {9}, {10}, {12}, {13}, {14}, {16}, {17}, {20}, {21}, {23}, {25}, {26}, {27}, {28}, {33}, {35}, {40}, {45}, {50}, {55}, {60}, {70}, {80}, {90}, {100}, {110}, {150}, {200} and {300}.",
})

nodeLevels:addChildKeyword({ "300" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 300 I have {Fair Wound Cleansing} for 500000 gold." })
nodeLevels:addChildKeyword({ "200" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 200 I have {Summon Knight Familiar} for 50000 gold and {Summon Paladin Familiar} for 50000 gold." })
nodeLevels:addChildKeyword({ "150" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 150 I have {Chivalrous Challenge} for 250000 gold." })
nodeLevels:addChildKeyword({ "110" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 110 I have {Annihilation} for 20000 gold." })
nodeLevels:addChildKeyword({ "100" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 100 I have {Intense Recovery} for 10000 gold." })
nodeLevels:addChildKeyword({ "90" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 90 I have {Fierce Berserk} for 7500 gold and {Strong Ethereal Spear} for 10000 gold." })
nodeLevels:addChildKeyword({ "80" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 80 I have {Cure Curse} for 6000 gold and {Intense Wound Cleansing} for 6000 gold." })
nodeLevels:addChildKeyword({ "70" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 70 I have {Front Sweep} for 4000 gold and {Holy Flash} for 7500 gold." })
nodeLevels:addChildKeyword({ "60" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 60 I have {Salvation} for 8000 gold." })
nodeLevels:addChildKeyword({ "55" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 55 I have {Swift Foot} for 6000 gold." })
nodeLevels:addChildKeyword({ "50" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 50 I have {Divine Caldera} for 3000 gold and {Recovery} for 4000 gold." })
nodeLevels:addChildKeyword({ "45" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 45 I have {Cure Bleeding} for 2500 gold and {Enchant Spear} for 2000 gold." })
nodeLevels:addChildKeyword({ "40" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 40 I have {Divine Missile} for 1800 gold and {Inflict Wound} for 2500 gold." })
nodeLevels:addChildKeyword({ "35" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 35 I have {Berserk} for 2500 gold and {Divine Healing} for 3000 gold." })
nodeLevels:addChildKeyword({ "33" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 33 I have {Groundshaker} for 1500 gold." })
nodeLevels:addChildKeyword({ "28" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 28 I have {Whirlwind Throw} for 1500 gold." })
nodeLevels:addChildKeyword({ "27" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 27 I have {Holy Missile} Rune for 1600 gold." })
nodeLevels:addChildKeyword({ "26" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 26 I have {Cancel Invisibility} for 1600 gold." })
nodeLevels:addChildKeyword({ "25" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 25 I have {Charge} for 1300 gold, {Conjure Explosive Arrow} for 1000 gold and {Find Fiend} for 1000 gold." })
nodeLevels:addChildKeyword({ "23" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 23 I have {Ethereal Spear} for 1100 gold." })
nodeLevels:addChildKeyword({ "21" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 21 I have {Disintegrate} Rune for 900 gold." })
nodeLevels:addChildKeyword({ "20" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 20 I have {Intense Healing} for 350 gold." })
nodeLevels:addChildKeyword({ "17" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 17 I have {Destroy Field} Rune for 700 gold." })
nodeLevels:addChildKeyword({ "16" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 16 I have {Brutal Strike} for 1000 gold." })
nodeLevels:addChildKeyword({ "14" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 14 I have {Haste} for 600 gold." })
nodeLevels:addChildKeyword({ "13" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 13 I have {Conjure Arrow} for 450 gold and {Great Light} for 500 gold." })
nodeLevels:addChildKeyword({ "12" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 12 I have {Levitate} for 500 gold." })
nodeLevels:addChildKeyword({ "10" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 10 I have {Cure Poison} for 150 gold." })
nodeLevels:addChildKeyword({ "9" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 9 I have {Magic Rope} for 200 gold." })
nodeLevels:addChildKeyword({ "8" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 8 I have {Find Person} for 80 gold, {Light} for free, {Light Healing} for free and {Wound Cleansing} for free." })
nodeLevels:addChildKeyword({ "1" }, StdModule.say, { npcHandler = npcHandler, onlyFocus = true, text = "For level 1 I have {Arrow Call} for free, {Bruise Bane} for free, {Lesser Front Sweep} for free and {Magic Patch} for free." })

npcHandler:setMessage(MESSAGE_GREET, "Greetings |PLAYERNAME|. What leads you to me?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Daraman's blessings.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
