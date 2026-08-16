local internalNpcName = "Albinius"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 634,
	lookHead = 0,
	lookBody = 19,
	lookLegs = 86,
	lookFeet = 60,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

npcConfig.shop = {
	{ itemName = "heavy old tome", clientId = 23986, sell = 30 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

local talkState = {}
npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local runes = {
	{ runeid = 24954 },
	{ runeid = 24955 },
	{ runeid = 24956 },
	{ runeid = 24957 },
	{ runeid = 24958 },
	{ runeid = 24959 },
}

local function getTable()
	local itemsList = {
		{ name = "heavy old tome", id = 23986, sell = 30 },
	}
	return itemsList
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "shapers") then
		npcHandler:say({
			"The {Shapers} were an advanced civilisation, well versed in art, construction, language and exploration of our world in their time. ...",
			"The foundations of this {temple} are testament to their genius and advanced understanding of complex problems. They were master craftsmen and excelled in magic.",
		}, npc, creature)
	end

	if MsgContains(message, "temple") then
		npcHandler:say("The temple has been restored to its former glory, yet we strife to live and praise in the {Shaper} ways. Do you still need me to take some old {tomes} from you my child?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	end
	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say("You already offered enough tomes for us to study and rebuild this temple. Thank you, my child.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		else
			if player:getItemCount(23986) >= 5 then
				player:removeItem(23986, 5)
				npcHandler:say("Thank you very much for your contribution, child. Your first step in the ways of the {Shapers} has been taken.", npc, creature)
				player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes, 1)
			else
				npcHandler:say("You need 5 heavy old tome.", npc, creature)
			end
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("I understand. Return to me if you change your mind, my child.", npc, creature)
		npcHandler:removeInteraction(npc, creature)
	end

	if MsgContains(message, "tomes") and player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) < 1 then
		npcHandler:say("If you have some old shaper tomes I would {buy} them.", npc, creature)
		npcHandler:setTopic(playerId, 7)
	end

	if MsgContains(message, "buy") then
		npcHandler:say("I'm sorry, I don't buy anything. My main concern right now is the bulding of this temple.", npc, creature)
		npc:openShopWindow(creature)
	end

	--- ##Astral Shaper Rune##
	if MsgContains(message, "astral shaper rune") then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.LastLoreKilled) >= 1 then
			npcHandler:say("Do you wish to merge your rune parts into an astral shaper rune?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		else
			npcHandler:say("I'm sorry but you lack the needed rune parts.", npc, creature)
		end
	end

	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 8 then
		local haveParts = false
		for k = 1, #runes do
			if player:removeItem(runes[k].runeid, 1) then
				haveParts = true
			end
		end
		if haveParts then
			npcHandler:say("As you wish.", npc, creature)
			player:addItem(24960, 1)
			npcHandler:removeInteraction(npc, creature)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 8 then
		npcHandler:say("ok.", npc, creature)
		npcHandler:removeInteraction(npc, creature)
	end

	--- ####PORTALS###
	-- Ice Portal
	if MsgContains(message, "ice portal") then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) == 1 and player:getStorageValue(Storage.Quest.U8_0.TheIceIslands.FormorgarMinesDoor) == 1 then
			npcHandler:say("You may pass this portal if you have 50 fish as offering. Do you have the fish with you?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say("Sorry, you first need to bring my Heavy Old Tomes or do the quest before continuing.", npc, creature)
		end
	end

	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 2 then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessIce) < 1 and player:getItemCount(3578) >= 50 then
			player:removeItem(3578, 50)
			npcHandler:say("Thank you for your offering. You may pass the Portal to the Powers of Ice now.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessIce, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough fish. Return if you can offer fifty of them.", npc, creature)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 2 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", npc, creature)
	end

	-- Holy Portal
	if MsgContains(message, "holy portal") then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say("You may pass this portal if you have 50 incantation notes as offering. Do you have the incantation notes with you?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		else
			npcHandler:say("Sorry, first you need to bring my Heavy Old Tomes.", npc, creature)
		end
	end

	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 3 then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessGolden) < 1 and player:getItemCount(18929) >= 50 then
			player:removeItem(18929, 50)
			npcHandler:say("Thank you for your offering. You may pass the Portal to the Powers of Holy now.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessGolden, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough incantation notes. Return if you can offer fifty of them.", npc, creature)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", npc, creature)
	end

	-- Energy Portal
	if MsgContains(message, "energy portal") then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say("You may pass this portal if you have 50 marsh stalker feathers as offering. Do you have the marsh stalker feathers with you?", npc, creature)
			npcHandler:setTopic(playerId, 4)
		else
			npcHandler:say("Sorry, first you need to bring my Heavy Old Tomes.", npc, creature)
		end
	end

	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 4 then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessViolet) < 1 and player:getItemCount(17462) >= 50 then
			player:removeItem(17462, 50)
			npcHandler:say("Thank you for your offering. You may pass the Portal to the Powers of Energy now.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessViolet, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough marsh stalker feathers. Return if you can offer fifty of them.", npc, creature)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 4 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", npc, creature)
	end

	-- Earth Portal
	if MsgContains(message, "earth portal") then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say("You may pass this portal if you have 50 acorns as offering. Do you have the acorns with you?", npc, creature)
			npcHandler:setTopic(playerId, 5)
		else
			npcHandler:say("Sorry, first you need to bring my Heavy Old Tomes.", npc, creature)
		end
	end

	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 5 then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessEarth) < 1 and player:getItemCount(10296) >= 50 then
			player:removeItem(10296, 50)
			npcHandler:say("Thank you for your offering. You may pass the Portal to the Powers of Earth now.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessEarth, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough acorns. Return if you can offer fifty of them.", npc, creature)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", npc, creature)
	end

	-- Death Portal
	if MsgContains(message, "death portal") then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.Tomes) == 1 then
			npcHandler:say("You may pass this portal if you have 50 pelvis bones as offering. Do you have the pelvis bones with you?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:say("Sorry, first you need to bring my Heavy Old Tomes.", npc, creature)
		end
	end

	if MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 6 then
		if player:getStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessDeath) < 1 and player:getItemCount(11481) >= 50 then
			player:removeItem(11481, 50)
			npcHandler:say("Thank you for your offering. You may pass the Portal to the Powers of Death now.", npc, creature)
			player:setStorageValue(Storage.Quest.U11_02.ForgottenKnowledge.AccessDeath, 1)
		else
			npcHandler:say("I'm sorry, you don't have enough pelvis bones. Return if you can offer fifty of them.", npc, creature)
		end
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 6 then
		npcHandler:say("In this case I'm sorry, you may not pass this portal.", npc, creature)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings, pilgrim. Welcome to the halls of hope. We are the keepers of this {temple} and welcome everyone willing to contribute.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh... farewell, child.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I am Albinius, a worshipper of the {Astral Shapers}." })
keywordHandler:addKeyword({ "time" }, StdModule.say, { npcHandler = npcHandler, text = "Precisely time." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I find ways to unveil the secrets of the stars. Judging by this question, I doubt you follow my weekly publications concerning this research." })

npcConfig.shop = {
	{ itemName = "blank imbuement scroll", clientId = 51442, buy = 25000 },
	{ itemName = "etcher", clientId = 51443, buy = 30000 },
}

npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end

npcType.onCheckItem = function(npc, player, clientId, subType) end

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "messengers" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "We were created to communicate the will of the gods to you inhabitants of the world of matter. The gods send us visions and insights which - in turn - we announce to you. ... Sometimes though the gods might decide to grant those visions directly to a recipient. The way how a message is delivered is of no importance. All what matters is the content of a message.",
})
keywordHandler:addKeyword({ "tibiasula" }, StdModule.say, { npcHandler = npcHandler, text = "Fardos and Uman either created or awakened a new godess from her sleep: Tibiasula. She helped Fardos, Uman and Zathroth create the mighty column of Time. ... But then Zathroth killed Tibiasula and Fardos and Uman bonded her body to the column of Time, creating the elements: earth, water, fire and air." })
keywordHandler:addKeyword({ "insights" }, StdModule.say, { npcHandler = npcHandler, text = "In these dire times the gods guide their followers and chosen ones with the help of many means. Sometimes their guidance is subtle, sometimes they send visions of different kinds. Even we messengers do not directly communicate with the gods." })
keywordHandler:addKeyword({ "variphor" }, StdModule.say, { npcHandler = npcHandler, text = "The fiend from beyond. Do not speak or think its name as it might draw its attention on you." })
keywordHandler:addKeyword({ "zathroth" }, StdModule.say, { npcHandler = npcHandler, text = "There is no Zathroth but Uman-Zathroth. They are the unfathomable god of knowledge and magic." })
keywordHandler:addKeyword({ "created" }, StdModule.say, { npcHandler = npcHandler, text = "Some of us used to be beings like you. However, this was a long time ago and we hardly remember it. Others were created by the gods for a specific purpose. ... Even though some of us might look similar to you, each of us is a very specific individual with unique traits that you cannot perceive." })
keywordHandler:addKeyword({ "promise" }, StdModule.say, { npcHandler = npcHandler, text = "Not all is lost. The gods are rallying their forces to be prepared for the war to come. You will not fight alone. What is happening here is only the first step to prepare you." })
keywordHandler:addKeyword({ "prepare" }, StdModule.say, { npcHandler = npcHandler, text = "The gods guide us through visions and dreams. They have shown us an ancient, forgotten power that will help to prepare you for the things to come." })
keywordHandler:addKeyword({ "summary" }, StdModule.say, { npcHandler = npcHandler, text = "The race of the Astral Shapers had a vast knowledge on how to imbue items with magical power. Although most of their art has been forgotten, the knowledge might be recovered by finding Shaper records which include small fractions of their weapons." })
keywordHandler:addKeyword({ "bastesh" }, StdModule.say, { npcHandler = npcHandler, text = "Even the sea will rise to defend the land and the land will shield the sea." })
keywordHandler:addKeyword({ "fiends" }, StdModule.say, { npcHandler = npcHandler, text = "It is not yet time to name them. Even thinking about them may taint you. So watch your thoughts and take care because the enemy is powerful and devious." })
keywordHandler:addKeyword({ "crunor" }, StdModule.say, { npcHandler = npcHandler, text = "Be it man or be it beast, nature must rise to face the coming onslaught." })
keywordHandler:addKeyword({ "fardos" }, StdModule.say, { npcHandler = npcHandler, text = "Fardos the Creator is one of the elder gods, together with Uman Zathroth. Fardos always was driven by the need to create and give life, overflowing with creative power." })
keywordHandler:addKeyword({ "fafnar" }, StdModule.say, { npcHandler = npcHandler, text = "The suns will always shine on Tibia." })
keywordHandler:addKeyword({ "nornur" }, StdModule.say, { npcHandler = npcHandler, text = "Nornur is the god of fate. He is a child of Fardos and the element Air." })
keywordHandler:addKeyword({ "urgith" }, StdModule.say, { npcHandler = npcHandler, text = "Even his endless legions will not be enough to stop the threat. But they might turn the tides of battle." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "The first paladin has visited us many time. Her insights have proven as very useful." })
keywordHandler:addKeyword({ "kirok" }, StdModule.say, { npcHandler = npcHandler, text = "Kirok was created in a attempt to separate Uman and Zathroth." })
keywordHandler:addKeyword({ "banor" }, StdModule.say, { npcHandler = npcHandler, text = "Banor will recruit our forces against the fiends of beyond and you will be his vanguard!" })
keywordHandler:addKeyword({ "hope" }, StdModule.say, { npcHandler = npcHandler, text = "The gods promise new hope in the fight against the fiends from beyond." })
keywordHandler:addKeyword({ "know" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "The ancient race of the Astral Shapers were highly talented in charging items with magical energy. They used mighty forges and charging stations to add special and useful properties to items. ... They were wiped out and their cities destroyed but some of their legacy survived. At certain places of power their charging stations have endured the ravages of time. ... Even though their knowledge was shattered, some of it still exists. The so-called Shaper records is a text collection which was written down in ancient times. ... It will be our duty to the gods to unearth this knowledge, find the lost forges and use them to prepare for the battles to come.",
})
keywordHandler:addKeyword({ "gods" }, StdModule.say, { npcHandler = npcHandler, text = "Fear not. The gods are with us. In these days this is even recognisable by the most ignorant." })
keywordHandler:addKeyword({ "uman" }, StdModule.say, { npcHandler = npcHandler, text = "There is no Uman but Uman-Zathroth. They are the unfathomable god of knowledge and magic." })
keywordHandler:addKeyword({ "blog" }, StdModule.say, { npcHandler = npcHandler, text = "May his rage strike down the enemies of creation." })
keywordHandler:addKeyword({ "brog" }, StdModule.say, { npcHandler = npcHandler, text = "Brog is the son of Zathroth and Fafnar is a malovent god. He tried to conquer the realms long ago." })
keywordHandler:addKeyword({ "suon" }, StdModule.say, { npcHandler = npcHandler, text = "The suns will always shine on Tibia." })
keywordHandler:addKeyword({ "toth" }, StdModule.say, { npcHandler = npcHandler, text = "He's the guardian of the dead. He was created by Fardos when it when he saw that Urgith wouldn't keep the dead at their rest but using them as an army of undeath. Therefore Toth is called the Warden of Souls." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
