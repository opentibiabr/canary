local internalNpcName = "Benjamin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 116,
	lookBody = 79,
	lookLegs = 117,
	lookFeet = 76,
	lookAddons = 0,
}

npcConfig.flags = {
	floorchange = false,
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Welcome to the post office!" },
	{ text = "If you need help with letters or parcels, just ask me. I can explain everything." },
	{ text = "Hey, send a letter to your friend now and then. Keep in touch, you know." },
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "measurements") then
		local player = Player(creature)
		if player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) >= 1 and player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.MeasurementsBenjamin) ~= 1 then
			npcHandler:say("Oh they don't change that much since in the old days as... <tells a boring and confusing story about a cake, a parcel, himself and two squirrels, at least he tells you his measurements in the end> ", npc, creature)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07, player:getStorageValue(Storage.Quest.U7_24.ThePostmanMissions.Mission07) + 1)
			player:setStorageValue(Storage.Quest.U7_24.ThePostmanMissions.MeasurementsBenjamin, 1)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("...", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello. How may I help you |PLAYERNAME|? Ask me for a {trade} if you want to buy something. I can also explain the {mail} system.")
npcHandler:setMessage(MESSAGE_FAREWELL, "It was a pleasure to help you.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "TO THE ARMS! MAN THE WALLS! FERUMBRAS IS NEAR!" })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "I don't remember that someone named like that is living here." })
keywordHandler:addKeyword({ "receiver" }, StdModule.say, { npcHandler = npcHandler, text = "Well, the receiver - or addressee - is the person you want to send mail to. Always make sure to enter his or her name correctly." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I know him because he always forgets to write the name of the recipient on his parcels and letters. The hardest part is to find out who he actually wanted to send it to." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, King Tibianus, our wise ruler. He has been sick for some time, hasn't he?" })
keywordHandler:addKeyword({ "letters" }, StdModule.say, { npcHandler = npcHandler, text = "If you want to buy a letter, ask me for a trade. Or do you want me to explain how letters work?" })
keywordHandler:addKeyword({ "explain" }, StdModule.say, { npcHandler = npcHandler, text = "With a letter you can send a message to another Tibian's depot. If you want to send it to 'Ben' in Thais, use the letter - so that a form opens - and write 'Ben' in the first line. Write your message below that. ... Then drag your letter on one of the blue mailboxes here to send it." })
keywordHandler:addKeyword({ "parcels" }, StdModule.say, { npcHandler = npcHandler, text = "If you want to buy a parcel, ask me for a trade. Or do you want me to explain how parcels work?" })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "TO THE ARMS! MAN THE WALLS! FERUMBRAS IS NEAR!" })
keywordHandler:addKeyword({ "harkath" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, young Harkath will be a fine warrior some day." })
keywordHandler:addKeyword({ "quentin" }, StdModule.say, { npcHandler = npcHandler, text = "Ooooh, nice man, visits me often... I think." })
keywordHandler:addKeyword({ "office" }, StdModule.say, { npcHandler = npcHandler, text = "I'm always in my office. You are welcome to visit me here at any time." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "You can send letters and parcels to Carlin." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "This naughty child, always stealing apples!" })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "Never heard of him." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "He's always talking about healing me even though I'm fine... I believe he is a bit nuts, poor man." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "This Muriel has a lot of correspondence." })
keywordHandler:addKeyword({ "sherry" }, StdModule.say, { npcHandler = npcHandler, text = "I don't drink alcohol while I'm on duty." })
keywordHandler:addKeyword({ "depot" }, StdModule.say, { npcHandler = npcHandler, text = "Each major city has at least one depot. Just step in front of one of the lockers and you can store items inside. Your mail will also arrive there. It doesn't matter which depot you stored it in - you can retrieve all your items from any depot in any city!" })
keywordHandler:addKeyword({ "label" }, StdModule.say, { npcHandler = npcHandler, text = "If you want to buy a label, ask me for a trade. Or do you want me to explain how labels work?" })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "This is the town you are currently in." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "Oh, she lives next door." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "Frodo... Frodo... ? Uhm... isn't that the guy that brings me food at lunchtime?" })
keywordHandler:addKeyword({ "kevin" }, StdModule.say, { npcHandler = npcHandler, text = "That name sounds familiar... who might that be..." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "NO! NO! NO! GO AWAY!." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "She's SO pretty!" })
keywordHandler:addKeyword({ "quero" }, StdModule.say, { npcHandler = npcHandler, text = "I love his music! He's my best friend and I visit him as often as I can." })
keywordHandler:addKeyword({ "xodet" }, StdModule.say, { npcHandler = npcHandler, text = "The young sorcerer is a good businessman." })
keywordHandler:addKeyword({ "send" }, StdModule.say, { npcHandler = npcHandler, text = "Drag and drop a letter or a parcel on the blue mailbox to send it. However, you need to include the name of the receiver. If the sending fails, you most likely made a mistake." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Benjamin." })
keywordHandler:addKeyword({ "join" }, StdModule.say, { npcHandler = npcHandler, text = "Uh... oh... Uhm... Join what?" })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "TO THE ARMS! MAN THE WALLS! FERUMBRAS IS NEAR!" })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, I don't read the letters we deliver." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He hangs around here quite often. He says that I inspire him." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He sells equipment." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "The king? Oops, I... can't remember his name..." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I'm working here at the post office. If you have questions about the Royal Tibia Mail System or the depots, ask me." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "Ham? No thanks, I already ate fish." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "label", clientId = 3507, buy = 1 },
	{ itemName = "letter", clientId = 3505, buy = 8 },
	{ itemName = "parcel", clientId = 3503, buy = 15 },
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

npcType:register(npcConfig)
