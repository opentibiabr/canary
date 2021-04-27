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
	if msgcontains(msg, "jack") then
		if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 5) then
			if
				(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Mother == 1) and
					(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Sister)) < 1)
			 then
				npcHandler:say("Why are you asking, he didn't get himself into something again did he?", cid)
				npcHandler.topic[cid] = 1
			end
		end
	elseif msgcontains(msg, "spectulus") then
		if (npcHandler.topic[cid] == 3) then
			npcHandler:say(
				"Spelltolust?! That sounds awfully nasty! What was he doing there - are you telling \z
				me he lived an alternate life and he didn't even tell {mother}?",
				cid
			)
			npcHandler.topic[cid] = 4
		end
	elseif msgcontains(msg, "yes") then
		if (npcHandler.topic[cid] == 1) then
			npcHandler:say(
				{
					"I knew it! He likes taking extended walks outside, leaving all the cleaning to me - \z
					especially when he is working on this sculpture, this... 'thing' he tries to create. ...",
					"What did he do? Since you look like a guy from the city, I bet he went to Edron in \z
						secrecy or something like that, didn't he? And you are here because of that?"
				},
				cid
			)
			npcHandler.topic[cid] = 2
		elseif (npcHandler.topic[cid] == 2) then
			npcHandler:say("What?! And what did he do there? Who did he visit there?", cid)
			npcHandler.topic[cid] = 3
		elseif (npcHandler.topic[cid] == 4) then
			npcHandler:say(
				{
					"Yesss! So this time he will get it for a change! And he lived there...? He helped whom? \z
					Ha! He won't get away this time! What did he do there? I see... interesting! ...",
					"Wait till mother hears that! Oh he will be in for a surprise, I can tell you that. Ma!! Maaaaa!!"
				},
				cid
			)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Sister, 1)
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 6)
		end
	end
	return true
end

local voices = {
	{text = "Where did I put my broom? Mother?"},
	{text = "Mother?! Oh no, now I have to do this all over again"},
	{text = "Mhmhmhmhm."},
	{text = "Lalala..."}
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Mh hello there. What can I do for you?")
npcHandler:addModule(FocusModule:new())
