	local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)


function onCreatureAppear(cid)
	npcHandler:onCreatureAppear(cid)
end
function onCreatureDisappear(cid)
	npcHandler:onCreatureDisappear(cid)
end
function onCreatureSay(cid, type, msg)
	npcHandler:onCreatureSay(cid, type, msg)
end
function onThink()
	npcHandler:onThink()
end

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end

	local player = Player(cid)

	if(msgcontains(msg, "flou")) then
		if(getPlayerStorageValue(cid, Storage.Navigator) < 1) then
			npcHandler:say("Lhnjei gouthn naumpi! I know why you are here. I can {explain} everything.", cid)
			npcHandler.topic[cid] = 1
		end
	elseif(msgcontains(msg, "explain")) then
		if(npcHandler.topic[cid] == 1) then
			npcHandler:say("By entering this place, you have earned the right to learn what this is all about. This is a long story. Are you sure you want to hear this, {yes}?", cid)
			npcHandler.topic[cid] = 2
		end
	elseif(msgcontains(msg, "helmet")) then
		if(npcHandler.topic[cid] == 7) then
			selfSay("NAAAAARGH. If you promise to leave me alone and NOT TO TELL MY SECRET to anyone - you can have one. ...", cid)
			selfSay("NO! Not the one I'm wearing. I am BOUND to this device. This suit has granted me a longer life. However, once you have spent a certain time with this - there is no turning back if you know what I mean. ...", cid)
			selfSay("The armor will merge with your very body. Holding you captive, holding your life in its hands like a ransom. ...", cid)
			npcHandler:say("Using Deepling craft and various components from down here, I created several spare helmets - just in case this one gets damaged. If you return that small golden anchor to me, you can have one. Will you?", cid)
			npcHandler.topic[cid] = 8
		end
	elseif(msgcontains(msg, "no")) then
		if(npcHandler.topic[cid] == 3) then
			selfSay("When none of my men returned, I forced myself to make a decision. Either dying on this dead ship or plunging into the liquid black beneath. ...", cid)
			selfSay("In my desperation my thoughts fell onto a strange armor - a gift from a trader we dealt with just before the storm. Strange ornaments and fish-like elements decorated this armor. We thought it would fit just perfectly into the captain's cabin. ...", cid)
			selfSay("He said something like a 'blessed breath' and 'to subdue the drift'. We thought he wanted to sell us worthless decoration and make it look interesting. If I had only listened to what he said. ...", cid)
			selfSay("I figured that this thing would have something to do with diving or at least protect me from the icy water. I put it on, grabbed a shimmer glower from our storage to light my path and jumped in. ...", cid)
			npcHandler:say("Do you want me to go on?", cid)
			npcHandler.topic[cid] = 4
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 2) then
			selfSay("I was once captain of a ship, the Skyflare. We were traders for King Tibianus and on our way home when we got into a storm. We fought hard to escape the cold grip of the sea. ...", cid)
			selfSay("I myself did what I could to navigate the Skyflare out of this mess. They depended on me. Me, the navigator. And I succeeded. ...", cid)
			selfSay("However, when the sea calmed down and the rain was finally gone, we recognised that our ship wouldn't move. It wasn't my fault. ...", cid)
			selfSay("There was a strong gale and we could already see this island on the horizon. There were seagulls all around the Skyflare to lead us to dry land. But the ship did not move a single inch. It was NOT my fault. ...", cid)
			selfSay("We dived under the bow and saw that it was stuck right on the tip of a sharp rock. The world below us was treacherous, we could see large underwater mountains and a labyrinthine system of caves and holes. ...", cid)
			selfSay("Some of my men panicked and hijacked the dinghies to reach the island, others tried to swim. I remained on the ship. It was not my FAULT. It was not. ...", cid)
			npcHandler:say("Do you have enough, can I stop?", cid)
			npcHandler.topic[cid] = 3
		elseif(npcHandler.topic[cid] == 4) then
			selfSay("Hmpf. The armor was working. After some time I was surrounded by darkness and could only see as far as my shimmer glower would me allow to. But I didn't feel the cold - I could even breathe through that helmet. ...", cid)
			selfSay("I dived into the deep black. Across rugged mountains, vast fields of kelp, swarms of strange fish. ...", cid)
			selfSay("And then I laid my eyes on a creature I have never seen before. I now know that they call themselves Njey. You would call them the 'Creatures of the Deep' or 'Deeplings'. ...", cid)
			npcHandler:say("I am now convinced that when they first saw me descending in that suit with the light of the shimmer glower encompassing me, they took me for their God King Qjell. And that's when it all started to make sense. Don't you agree?", cid)
			npcHandler.topic[cid] = 5
		elseif(npcHandler.topic[cid] == 5) then
			selfSay("Of course you do. And they did, too. They obeyed me. They adored me. They followed me. ...", cid)
			selfSay("I learnt everything about their culture, their life, their goals and their problems. I found out about vile insect-like creatures inhabiting the surface of the island. And their waiting for the return of Qjell. ...", cid)
			selfSay("I practically rewrote their history. I WAS THE SECOND COMING. I WAS QJELL. I, THE NAVIGATOR. ...", cid)
			npcHandler:say("And I navigated them out of their miserable lives. Away from their petty interests. I led them to a greater purpose - to form chaos out of order, to bring back the storm to the seas and to make THINGS MOVE. Do you want to hear the rest as well?", cid)
			npcHandler.topic[cid] = 6
		elseif(npcHandler.topic[cid] == 6) then
			selfSay("I control EVERYTHING from this room, navigating the fate of this land for more than a century now. Can you see all these funnels? My voice travels through them and throughout everything down here! ...", cid)
			selfSay("The stones on the beach? The trader up there? That was ME ALL THE TIME! I lured YOU into creating all this chaos up there and down here! ...", cid)
			npcHandler:say("You thought you could choose sides? Think again! I nearly led you into the destruction of two species! ME, THE NAVIGATOR! I CONTROL YOU, I OWN YOU! QJELL AFAR GOU JEY!", cid)
			npcHandler.topic[cid] = 7
		elseif(npcHandler.topic[cid] == 8) then
			npcHandler:say("Then take this one. And remember: DO NOT TELL ANYONE ABOUT ME OR ANYTHING YOU HAVE HEARD HERE TODAY.", cid)
			player:addOutfitAddon(464, 2)
			player:addOutfitAddon(463, 2)
			setPlayerStorageValue(cid, Storage.Navigator, 4)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
