local internalNpcName = "Todd"
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
	lookHead = 115,
	lookBody = 0,
	lookLegs = 67,
	lookFeet = 114,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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

	if MsgContains(message, "interesting") then
		npcHandler:say({
			"I'd really like to rebuild my reputation someday and maybe find a nice girl. If you come across scrolls of heroic deeds or addresses of lovely maidens... let me know! ...",
			"Oh no, it doesn't matter what name is on the scrolls. I'm, uhm... flexible! And money - yes, I can pay. My, erm... uncle died recently and left me a pretty sum. Yes."
		}, npc, creature)
	end
end

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am... a traveler. Just leave me alone if you have nothing {interesting} to talk about."})
keywordHandler:addKeyword({'want'}, StdModule.say, {npcHandler = npcHandler, text = "I am... a traveler. Just leave me alone if you have nothing {interesting} to talk about."})
keywordHandler:addKeyword({'head'}, StdModule.say, {npcHandler = npcHandler, text = "Uhhh ohhhh one of the beers yesterday must have been bad."})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My Name? I am To... ahm... hum... My name is {Hugo}."})
keywordHandler:addKeyword({'hugo'}, StdModule.say, {npcHandler = npcHandler, text = "Yes, that's my name of course."})
keywordHandler:addKeyword({'todd'}, StdModule.say, {npcHandler = npcHandler, text = "Uh .. I... I met a Todd on the road. He told me he was traveling to Venore, look there for your Todd."})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "I love that city."})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = "I never was there. Now leave me alone."})
keywordHandler:addKeyword({'resistance'}, StdModule.say, {npcHandler = npcHandler, text = "Resistance is futile... uhm... I wonder where I picked that saying up. Oh my head..."})
keywordHandler:addKeyword({'money'}, StdModule.say, {npcHandler = npcHandler, text = "I don't know anything about money, missing or not."})
keywordHandler:addKeyword({'eclesius'}, StdModule.say, {npcHandler = npcHandler, text = "He often comes here. But his constant confusion gives me a worse headache than Frodo's beer. I rather avoid him."})
keywordHandler:addKeyword({'karl'}, StdModule.say, {npcHandler = npcHandler, text = "Uhm, never heard about him... and you can't prove otherwise."})
keywordHandler:addKeyword({'william'}, StdModule.say, {npcHandler = npcHandler, text = "Thats a common name, perhaps I met a William, not sure about that."})

npcHandler:setMessage(MESSAGE_GREET, "Uhm oh hello |PLAYERNAME|... not so loud please... my {head}... What ... do you {want}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yes, goodbye |PLAYERNAME|, just leave me alone.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Silence at last.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "scroll of heroic deeds", clientId = 11510, sell = 230 },
	{ itemName = "small notebook", clientId = 11450, sell = 480 }
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

npcType:register(npcConfig)
