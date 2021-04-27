local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)
NpcSystem.parseParameters(npcHandler)

local Price = {}

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

local voices = { {text = 'Praised be Suon, the Benevolent King!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function greetCallback(cid)
	if Player(cid):getSex() == PLAYERSEX_FEMALE then
		npcHandler:setMessage(MESSAGE_GREET, "Suon's and Bastesh's blessings! Welcome to {Issavi}, traveller.")
		npcHandler.topic[cid] = 1
	else
		npcHandler:setMessage(MESSAGE_GREET, "Suon's and Bastesh's blessings! Welcome to {Issavi}, traveller.")
		npcHandler.topic[cid] = nil
	end
	Price[cid] = nil
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	local Sex = player:getSex()
	if npcHandler.topic[cid] == 1 then
		npcHandler:say("I would never have guessed that.", cid)
		npcHandler.topic[cid] = nil
	elseif npcHandler.topic[cid] == 2 then
		if player:removeMoneyNpc(Price[cid]) then
			npcHandler:say("Oh, sorry, I was distracted, what did you say?", cid)
		else
			npcHandler:say("Oh, I just remember I have some work to do, sorry. Bye!", cid)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
		npcHandler.topic[cid] = nil
		Price[cid] = nil
	elseif npcHandler.topic[cid] == 3 and player:removeItem(2036, 1) then
		npcHandler:say("Take some time to talk to me!", cid)
		npcHandler.topic[cid] = nil
	elseif npcHandler.topic[cid] == 4 and (msgcontains(msg, "spouse") or msgcontains(msg, "girlfriend")) then
		npcHandler:say("Well ... I have met him for a little while .. but this was nothing serious.", cid)
		npcHandler.topic[cid] = 5
	elseif npcHandler.topic[cid] == 5 and msgcontains(msg, "fruit") then
		npcHandler:say("I remember that grapes were his favourites. He was almost addicted to them.", cid)
		npcHandler.topic[cid] = nil
	elseif msgcontains(msg, "how") and msgcontains(msg, "are") and msgcontains(msg, "you") then
		npcHandler:say("Thank you very much. How kind of you to care about me. I am fine, thank you.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "sell") then
		npcHandler:say("This is the continent you are currently visiting. You will find vast, dry steppes here as well as high mountains, the river Nykri and the big city {Issavi}.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "job") or msgcontains(msg, "issavi") then
		npcHandler:say("Issavi is the capital of {Kilmaresh}, also called the Golden City. This city has a motto: An open gate for those of peace. This means, anyone is welcome here as long as they respect our laws, be it humans, elves, minotaurs or even a medusa.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "name") then
		if Sex == PLAYERSEX_FEMALE then
			npcHandler:say("I am Aruda.", cid)
		else
			npcHandler:say("I am a little sad, that you seem to have forgotten me, handsome. I am Aruda.", cid)
		end
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "aruda") then
		if Sex == PLAYERSEX_FEMALE then
			npcHandler:say("Yes, that's me!", cid)
		else
			npcHandler:say("Oh, I like it, how you say my name.", cid)
		end
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "time") then
		npcHandler:say("Please don't be so rude to look for the time if you are talking to me.", cid)
		npcHandler.topic[cid] = 3
	elseif msgcontains(msg, "help") then
		npcHandler:say("I am deeply sorry, I can't help you.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "monster") or msgcontains(msg, "dungeon") then
		npcHandler:say("UH! What a terrifying topic. Please let us speak about something more pleasant, I am a weak and small woman after all.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "sewer") then
		npcHandler:say("What gives you the impression, I am the kind of women, you find in sewers?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "god") then
		npcHandler:say("You should ask about that in one of the temples.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "king") then
		npcHandler:say("The king, that lives in this fascinating castle? I think he does look kind of cute in his luxurious robes, doesn't he?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 10
	elseif msgcontains(msg, "sam") then
		if Sex == PLAYERSEX_FEMALE then
			npcHandler:say("He is soooo strong! What muscles! What a body! Did you ask him for a date?", cid)
		else
			npcHandler:say("He is soooo strong! What muscles! What a body! On the other hand, compared to you he looks quite puny.", cid)
		end
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "benjamin") then
		npcHandler:say("He is a little simple minded but always nice and well dressed.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "gorn") then
		npcHandler:say("He should really sell some stylish gowns or something like that. We Tibians never get some clothing of the latest fashion. It's a shame.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "quentin") then
		npcHandler:say("I don't understand this lonely monks. I love company too much to become one. Hehehe!", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "bozo") then
		npcHandler:say("Oh, isn't he funny? I could listen to him the whole day.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "oswald") then
		npcHandler:say("As far as I know, he is working in the castle.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "rumour") or msgcontains(msg, "rumor") or msgcontains(msg, "gossip") then
		npcHandler:say("I am a little shy and so don't hear many rumors.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "kiss") and Sex == PLAYERSEX_MALE then
		npcHandler:say("Oh, you little devil, stop talking like that! <blush>", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 20
	elseif msgcontains(msg, "weapon") then
		npcHandler:say("I know only little about weapons. Can you tell me something about them, please?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "magic") then
		npcHandler:say("I believe that love is stronger than magic, don't you agree?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "thief") or msgcontains(msg, "theft") then
		npcHandler:say("Oh, sorry, I have to hurry, bye!", cid)
		npcHandler.topic[cid] = nil
		Price[cid] = nil
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	elseif msgcontains(msg, "tibia") then
		npcHandler:say("I would like to visit the beach more often, but I guess it's too dangerous.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "castle") then
		npcHandler:say("I love this castle! It's so beautiful.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "muriel") then
		npcHandler:say("Powerful sorcerers frighten me a little.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "elane") then
		npcHandler:say("I personally think it's inappropriate for a woman to become a warrior, what do you think about that?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "marvik") then
		npcHandler:say("Druids seldom visit a town, what do you know about druids?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "gregor") then
		npcHandler:say("I like brave fighters like him.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "noodles") then
		npcHandler:say("Oh, he is sooooo cute!", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "dog") or msgcontains(msg, "poodle") then
		npcHandler:say("I like dogs, the little ones at least. Do you like dogs, too?", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 5
	elseif msgcontains(msg, "excalibug") then
		npcHandler:say("Oh, I am just a girl and know nothing about magic swords and such things.", cid)
		npcHandler.topic[cid] = 2
		Price[cid] = 10
	elseif msgcontains(msg, "partos") then
		npcHandler:say("I ... don't know someone named like that.", cid)
		npcHandler.topic[cid] = 4
		Price[cid] = nil
	elseif msgcontains(msg, "yenny") then
		npcHandler:say("Yenny? I know no Yenny, nor have I ever used that name! You have mistook me with someone else.", cid)
		npcHandler.topic[cid] = nil
		Price[cid] = nil
		npcHandler:releaseFocus(cid)
		npcHandler:resetNpc(cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "I hope to see you soon.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye, |PLAYERNAME|. I really hope we'll talk again soon.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
