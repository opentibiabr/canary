local internalNpcName = "Navigator"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 463,
	lookHead = 94,
	lookBody = 123,
	lookLegs = 116,
	lookFeet = 123,
	lookAddons = 2
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)


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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if(MsgContains(message, "flou")) then
		if(getPlayerStorageValue(creature, Storage.Navigator) < 1) then
			npcHandler:say("Lhnjei gouthn naumpi! I know why you are here. I can {explain} everything.", npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif(MsgContains(message, "explain")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("By entering this place, you have earned the right to learn what this is all about. This is a long story. Are you sure you want to hear this, {yes}?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif(MsgContains(message, "helmet")) then
		if(npcHandler:getTopic(playerId) == 7) then
			npcHandler:say(
				{
					"NAAAAARGH. If you promise to leave me alone and NOT TO TELL MY SECRET to anyone - you can have one. ...",
					"NO! Not the one I'm wearing. I am BOUND to this device. This suit has granted me a longer life. However, once you have spent a certain time with this - there is no turning back if you know what I mean. ...",
					"The armor will merge with your very body. Holding you captive, holding your life in its hands like a ransom. ...",
					"Using Deepling craft and various components from down here, I created several spare helmets - just in case this one gets damaged. If you return that small golden anchor to me, you can have one. Will you?",
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 8)
		end
	elseif(MsgContains(message, "no")) then
		if(npcHandler:getTopic(playerId) == 3) then
			npcHandler:say(
				{
					"When none of my men returned, I forced myself to make a decision. Either dying on this dead ship or plunging into the liquid black beneath. ...",
					"In my desperation my thoughts fell onto a strange armor - a gift from a trader we dealt with just before the storm. Strange ornaments and fish-like elements decorated this armor. We thought it would fit just perfectly into the captain's cabin. ...",
					"He said something like a 'blessed breath' and 'to subdue the drift'. We thought he wanted to sell us worthless decoration and make it look interesting. If I had only listened to what he said. ...",
					"I figured that this thing would have something to do with diving or at least protect me from the icy water. I put it on, grabbed a shimmer glower from our storage to light my path and jumped in. ...",
					"Do you want me to go on?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 4)
		end
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 2) then
			npcHandler:say(
				{
					"I was once captain of a ship, the Skyflare. We were traders for King Tibianus and on our way home when we got into a storm. We fought hard to escape the cold grip of the sea. ...",
					"I myself did what I could to navigate the Skyflare out of this mess. They depended on me. Me, the navigator. And I succeeded. ...",
					"However, when the sea calmed down and the rain was finally gone, we recognised that our ship wouldn't move. It wasn't my fault. ...",
					"There was a strong gale and we could already see this island on the horizon. There were seagulls all around the Skyflare to lead us to dry land. But the ship did not move a single inch. It was NOT my fault. ...",
					"We dived under the bow and saw that it was stuck right on the tip of a sharp rock. The world below us was treacherous, we could see large underwater mountains and a labyrinthine system of caves and holes. ...",
					"Some of my men panicked and hijacked the dinghies to reach the island, others tried to swim. I remained on the ship. It was not my FAULT. It was not. ..."
				},
				npc,
				creature
			)
			npcHandler:say("Do you have enough, can I stop?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif(npcHandler:getTopic(playerId) == 4) then
			npcHandler:say(
				{
					"Hmpf. The armor was working. After some time I was surrounded by darkness and could only see as far as my shimmer glower would me allow to. But I didn't feel the cold - I could even breathe through that helmet. ...",
					"I dived into the deep black. Across rugged mountains, vast fields of kelp, swarms of strange fish. ...",
					"And then I laid my eyes on a creature I have never seen before. I now know that they call themselves Njey. You would call them the 'Creatures of the Deep' or 'Deeplings'. ...",
					"I am now convinced that when they first saw me descending in that suit with the light of the shimmer glower encompassing me, they took me for their God King Qjell. And that's when it all started to make sense. Don't you agree?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 5)
		elseif(npcHandler:getTopic(playerId) == 5) then
			npcHandler:say(
				{
					"Of course you do. And they did, too. They obeyed me. They adored me. They followed me. ...",
					"I learnt everything about their culture, their life, their goals and their problems. I found out about vile insect-like creatures inhabiting the surface of the island. And their waiting for the return of Qjell. ...",
					"I practically rewrote their history. I WAS THE SECOND COMING. I WAS QJELL. I, THE NAVIGATOR. ...",
					"And I navigated them out of their miserable lives. Away from their petty interests. I led them to a greater purpose - to form chaos out of order, to bring back the storm to the seas and to make THINGS MOVE. Do you want to hear the rest as well?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 6)
		elseif(npcHandler:getTopic(playerId) == 6) then
			npcHandler:say(
				{
					"I control EVERYTHING from this room, navigating the fate of this land for more than a century now. Can you see all these funnels? My voice travels through them and throughout everything down here! ...",
					"The stones on the beach? The trader up there? That was ME ALL THE TIME! I lured YOU into creating all this chaos up there and down here! ...",
					"You thought you could choose sides? Think again! I nearly led you into the destruction of two species! ME, THE NAVIGATOR! I CONTROL YOU, I OWN YOU! QJELL AFAR GOU JEY!"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 7)
		elseif(npcHandler:getTopic(playerId) == 8) then
			npcHandler:say("Then take this one. And remember: DO NOT TELL ANYONE ABOUT ME OR ANYTHING YOU HAVE HEARD HERE TODAY.", npc, creature)
			player:addOutfitAddon(464, 2)
			player:addOutfitAddon(463, 2)
			setPlayerStorageValue(creature, Storage.Navigator, 4)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
