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

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	local storage = Storage.Quest.TheParadoxTower
	if msgcontains(msg, "test") then
			npcHandler:say("Death awaits those who fail the test of the three seals! Do you really want me to test you?", cid)
			npcHandler.topic[cid] = 1
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		npcHandler:say("FOOL! Now you're doomed! But well ... \z
			So be it! Let's start out with the Seal of Knowledge and the first question: \z
			What name did the necromant king choose for himself?", cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, "goshnar") and npcHandler.topic[cid] == 2 then
		npcHandler:say("HOHO! You have learned your lesson well. \z
			Question number two then: Who or what is the feared Hugo?", cid)
		npcHandler.topic[cid] = 3
	elseif msgcontains(msg, "demonbunny") and npcHandler.topic[cid] == 3 then
		if player:getStorageValue(storage.TheFearedHugo) == 4 then
			npcHandler:say("HOHO! Right again. All right. The final question of the first seal: Who was the first warrior to follow the path of the Mooh'Tah?", cid)
			npcHandler.topic[cid] = 4
		else
			npcHandler:say("Hmmm, so you think cheating will get you through that test? Then your final question of the first seal is: What is the meaning of life?", cid)
			npcHandler.topic[cid] = 5
		end
	elseif msgcontains(msg, "tha'kull") and npcHandler.topic[cid] == 4 then
		npcHandler:say("HOHO! Lucky you. You have passed the first seal! So ... would you like to continue with the Seal of the Mind?", cid)
		npcHandler.topic[cid] = 6
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 6 then
		npcHandler:say("As you wish, foolish one! Here is my first question: It's lighter then a feather but no living creature can hold it for ten minutes?", cid)
		npcHandler.topic[cid] = 7
	elseif msgcontains(msg, "breath") and npcHandler.topic[cid] == 7 then
		npcHandler:say("That was an easy one. Let's try the second: If you name it, you break it.", cid)
		npcHandler.topic[cid] = 8
	elseif msgcontains(msg, "silence") and npcHandler.topic[cid] == 8 then
		npcHandler:say("Hm. I bet you think you're smart. All right. \z
			How about this: What does everybody want to become but nobody to be?", cid)
		npcHandler.topic[cid] = 9
	elseif msgcontains(msg, "old") and npcHandler.topic[cid] == 9 then
		npcHandler:say("ARGH! You did it again! Well all right. Do you wish to break the Seal of Madness?", cid)
		npcHandler.topic[cid] = 10
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 10 then
		npcHandler:say("GOOD! So I will get you at last. Answer this: What is your favourite colour?", cid)
		npcHandler.topic[cid] = 11
	elseif msgcontains(msg, "green") and npcHandler.topic[cid] == 11 then
		if player:getStorageValue(storage.FavoriteColour) < 1 then
			player:setStorageValue(storage.FavoriteColour, 1)
		end
		npcHandler:say("UHM UH OH ... How could you guess that? Are you mad??? All right. \z
			Penultimate question: What is the opposite?", cid)
		npcHandler.topic[cid] = 12
	elseif msgcontains(msg, "none") and npcHandler.topic[cid] == 12 then
		npcHandler:say("NO! NO! NO! That can't be true. You're not only mad, you are a complete idiot! \z
			Ah well. Here is the last question: What is 1 plus 1?", cid)
		npcHandler.topic[cid] = 13
	elseif msgcontains(msg, "1") then
		if npcHandler.topic[cid] == 13 then
			if player:getStorageValue(storage.Mathemagics) >= 1 then
				-- Complete mission mathemagics
				if player:getStorageValue(storage.Mathemagics) == 1 then
					player:setStorageValue(storage.Mathemagics, 2)
				end
				-- Complete mission favorite colour
				if player:getStorageValue(storage.FavoriteColour) == 1 then
					player:setStorageValue(storage.FavoriteColour, 2)
				end

				player:teleportTo({x = 32478, y = 31905, z = 1})
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
				npcHandler:say("DAMN YOUUUUUUUUUUUUUUUUUUUUUU!", cid)
			else
				npcHandler:say("WRONG!", cid)
				player:teleportTo({x = 32725, y = 31589, z = 12})
				player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			end
		end
	elseif npcHandler.topic[cid] == 5 then
		npcHandler:say("WRONG! Next time get your own answers. To hell with thee, cheater Sischfried!", cid)
		player:teleportTo({x = 32725, y = 31589, z = 12})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		npcHandler:say("WRONG!", cid)
		player:teleportTo({x = 32725, y = 31589, z = 12})
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	end
	return true
end

keywordHandler:addKeyword({"paradox"}, StdModule.say, {npcHandler = npcHandler, text = "This tower, of course, silly one. It holds my {master'}s {treasure}."})
keywordHandler:addAliasKeyword({"tower"})

keywordHandler:addKeyword({"master"}, StdModule.say, {npcHandler = npcHandler, text = "His name is none of your business"})
keywordHandler:addKeyword({"treasure"}, StdModule.say, {npcHandler = npcHandler, text = "I am guarding the treasures of the tower. Only those who pass the {test} of the three sigils may pass."})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "I am known as the riddler. That is all you need to know."})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "I am the guardian of the paradox tower."})
keywordHandler:addKeyword({"key"}, StdModule.say, {npcHandler = npcHandler, text = "The key of this tower! You will never find it! A malicious plant spirit is guarding it!."})
keywordHandler:addAliasKeyword({"door"})

npcHandler:setMessage(MESSAGE_GREET, "|PLAYERNAME| HEHEHEHE! Another fool visits the {tower}! Excellent!")
npcHandler:setMessage(MESSAGE_FAREWELL, "HEHEHE! I knew you don't have the stomach.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "COWARD! CHICKEN! HEHEHEHE!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new())
