local internalNpcName = "Wyrdin"
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
	lookHead = 76,
	lookBody = 77,
	lookLegs = 79,
	lookFeet = 115,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{
		text = "<mumbles> So where was I again?"
	},
	{
		text = "<mumbles> Typical - you can never find a hero when you need one!"
	},
	{
		text = "<mumbles> Could the bonelord language be the invention of some madman?"
	},
	{
		text = "<mumbles> The curse algorithm of triplex shadowing has to be two times higher than an overcharged nanoquorx on the peripheral..."
	}
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.TheWayToYalahar.QuestLine) < 1 and
		player:getStorageValue(Storage.ExplorerSociety.JoiningTheExplorers) >= 4 and
		player:getStorageValue(Storage.ExplorerSociety.QuestLine) >= 4 then
			npcHandler:say(
			{"There is indeed something that needs our attention. In the far north, a new city named Yalahar was discovered. It seems to be incredibly huge. ...",
				"According to travelers, it's a city of glory and wonders. We need to learn as much as we can about this city and its inhabitants. ...",
				"Gladly the explorer's society already sent a representative there. Still, we need someone to bring us the information he was able to gather until now. ...",
				"Please look for the explorer's society's captain Maximilian in Liberty Bay. Ask him for a passage to Yalahar. There visit Timothy of the explorer's society and get his research notes. ...",
			"It might be a good idea to explore the city a bit on your own before you deliver the notes here, but please make sure you don't lose them."},
			npc, creature)
			player:setStorageValue(Storage.TheWayToYalahar.QuestLine, 1)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.TheWayToYalahar.QuestLine) == 2 then
			npcHandler:say("Did you bring the papers I asked you for?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if player:removeItem(9171, 1) then
				player:setStorageValue(Storage.TheWayToYalahar.QuestLine, 3)
				npcHandler:say(
				"Oh marvellous, please excuse me. I need to read this text immediately. Here, take this small reward of 500 gold pieces for your efforts.",
				npc, creature)
				player:addMoney(500)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 3 then
			if player:getStorageValue(TheNewFrontier.Mission05.Wyrdin) == 2 and player:removeItem(10025, 1) then
				npcHandler:say(
				{"By Uman! That's one of the rare almanacs of Origus! I had no idea that you are a scholar yourself! And a generous one on top of it! ...",
					"This book must be worth some thousand crystal coins on the free market. Look at the signature here, it's Origus' very own! ...",
				"Of course we should talk again about your request. What do you say makes Farmine important?"},
				npc, creature)
				player:setStorageValue(TheNewFrontier.Mission05.Wyrdin, 1)
				npcHandler:setTopic(playerId, 2)
			end
		end
		-- The New Frontier
	elseif MsgContains(message, "farmine") then
		if player:getStorageValue(TheNewFrontier.Questline) == 14 then
			if player:getStorageValue(TheNewFrontier.Mission05.Wyrdin) == 1 then
				npcHandler:say(
				"I've heard some odd rumours about this new dwarven outpost. But tell me, what has the Edron academy to do with Farmine?",
				npc, creature)
				npcHandler:setTopic(playerId, 2)
			else
				npcHandler:say(
				"I'm not sure if I'm in the mood to talk about that matter again. Or do you have anything that might change my mind?",
				npc, creature)
				npcHandler:setTopic(playerId, 3)
			end
		end
	elseif MsgContains(message, "plea") and player:getStorageValue(TheNewFrontier.Mission05.WyrdinKeyword) == 1 and
	player:getStorageValue(TheNewFrontier.Mission05.Wyrdin) == 1 then
		if npcHandler:getTopic(playerId) == 2 then
			local chance = math.random(1, 3)
			if chance == 1 then
				npcHandler:say(
				"Hm, you are right, we are at the forefront of knowledge and innovation. Our dwarven friends could learn much from one of our representatives.",
				npc, creature)
			elseif chance == 2 then
				npcHandler:say(
				"<sighs> Okay, sending some trader there won't hurt. I hope it will be worth the effort, though.",
				npc, creature)
			else
				npcHandler:say(
				{"Well, it can't be wrong to be there when new discoveries are made. Also, all those soldiers of fortune that might travel there could turn out to be a good source of income for a magic shop. ...",
				"I think we'll send a representative. At least, for some time."}, npc, creature)
			end
			player:setStorageValue(TheNewFrontier.Mission05.Wyrdin, 3)
		end
	elseif MsgContains(message, "bluff") and player:getStorageValue(TheNewFrontier.Mission05.WyrdinKeyword) == 2 and
	player:getStorageValue(TheNewFrontier.Mission05.Wyrdin) == 1 then
		npcHandler:say(
		"What do you mean the druids of Carlin could provide the service as well? They are incompetent imposters! I will not allow them to ruin our reputation! I'll send some trader with supplies right away!",
		npc, creature)
		player:setStorageValue(TheNewFrontier.Mission05.Wyrdin, 3)
	elseif MsgContains(message, "flatter") and player:getStorageValue(TheNewFrontier.Mission05.WyrdinKeyword) == 3 and
	player:getStorageValue(TheNewFrontier.Mission05.Wyrdin) == 1 then
		npcHandler:say(
		"Hm, you are right, we are at the forefront of knowledge and innovation. Our dwarven friends could learn much from one of our representatives.",
		npc, creature)
		player:setStorageValue(TheNewFrontier.Mission05.Wyrdin, 3)
	else
		if player:getStorageValue(TheNewFrontier.Questline) == 14 and
		player:getStorageValue(TheNewFrontier.Mission05.Wyrdin) == 1 then
			npcHandler:say("Wrong Word.", npc, creature)
			player:setStorageValue(TheNewFrontier.Mission05.Wyrdin, 2)
		end
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello, what brings you here?")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
