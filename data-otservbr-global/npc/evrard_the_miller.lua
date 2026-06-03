local internalNpcName = "Evrard the Miller"
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
	lookHead = 21,
	lookBody = 19,
	lookLegs = 21,
	lookFeet = 95,
	lookAddons = 0,
}

npcConfig.respawnType = {
	period = RESPAWNPERIOD_DAY,
	underground = false,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {}

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

	if message:lower() == "yes" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard) < 1 then
		if npcHandler:getTopic(playerId) == 0 then
			npcHandler:say({
				"Alright, look. You already know that camp to the east, with the bad guys roaming around, right? Great. ...",
				"They have a ledger and a map there, and I want that. Both these items. The ledger is in a warehouse at the harbour. ...",
				"I don't know where that map is, though but I am sure they have one where they've marked all the locations they've been at. ...",
				"And most importantly: BE QUIET! Try not to be seen. Be a shadow. Got that?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif npcHandler:getTopic(playerId) == 1 then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard, 1)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessEasternSide, 1)
			npcHandler:say("Good, now go. Remember: be like a light summer breeze - quick, almost unnoticeable and most importantly QUIET!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif message:lower() == "news" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard) == 1 then
		npcHandler:say("What about the small errand I mentioned? Did you get the stuff?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif message:lower() == "yes" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard) == 1 then
		if npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Parchment) >= 1 and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.MapStorage) >= 1 and player:removeItem(635, 1) and player:removeItem(2822, 1) then
				player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard, 2)
				npcHandler:say({
					"You did it! Let me just take a peek... ...",
					"What? No, no - keep them. I uhm, don't want to have anything to do with this. Just wanted to... take a quick look, you know. ...",
					"Have you been quiet as I asked you?",
				}, npc, creature)
				npcHandler:setTopic(playerId, 3)
			else
				npcHandler:say("You haven't brought both items yet. I need the ledger AND the map from that camp.", npc, creature)
			end
		end
	elseif message:lower() == "yes" and player:getStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard) == 2 then
		if npcHandler:getTopic(playerId) == 3 then
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.Evrard, 3)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.AccessSouthernSide, 1)
			player:setStorageValue(Storage.Quest.U12_40.TheOrderOfTheLion.BounacTrust, 0)
			npcHandler:say({
				"Oh you have? Why did I hear screams of battle, fear and loathing from over there about the time you were gone? ...",
				"And I really hope yours were the screams of battle and not those of fear. ...",
				"Anyway, you did it and that's very good. I am thankful for that and I'll open up an underground route I sometimes use when I want to enter the city quickly. ...",
				"This way you can get past any guards and find out more about the situation. And one more thing: ...",
				"There's a passphrase: YSELDA. Remember that. Now go and the best of luck to you, traveller!",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings. Can I help you, traveller?")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcType:register(npcConfig)
