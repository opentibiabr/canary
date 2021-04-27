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
			if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Mother) < 1) then
				npcHandler:say(
					"What about him? He's downstairs as he always has been. He never went away from home \z
					any further than into the forest nearby. He rarely ever took a walk to Edron, did he?",
					cid
				)
				npcHandler.topic[cid] = 1
			end
		end
	elseif msgcontains(msg, "no") then
		if (npcHandler.topic[cid] == 2) then
			npcHandler:say(
				"Thought so. Of course he wouldn't do anything wrong. And he went where? Edron. Hm. I can \z
					see nothing wrong with that. But... he wasn't there often, was he?",
				cid
			)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, "yes") then
		if (npcHandler.topic[cid] == 1) then
			npcHandler:say("What...? But he wasn't up to something, was he?", cid)
			npcHandler.topic[cid] = 2
		elseif (npcHandler.topic[cid] == 3) then
			npcHandler:say(
				{
					"Oh my... he did what? Why was he there? Edron Academy? ...",
					"I see... this cannot be. Spectrofuss? Who? Jack! When? How? But why did he do that? Jack!! \z
						JACK!! When I find him he owes me an EXPLANATION. Thanks for telling \z
						me what he is actually doing in his FREE TIME. ...",
					"JAAAAACK!"
				},
				cid
			)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Mother, 1)
		end
	end
	return true
end

local voices = {
	{text = "JAAAAACK? EVERYTHING ALRIGHT DOWN THERE?"},
	{text = "Oh dear, I can't find anything in here!"},
	{text = "There is still some dust on the drawer over there. What where you thinking, Jane?"},
	{text = "Jane!"}
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "I demand an explanation of you entering our house without any invitation.")
npcHandler:addModule(FocusModule:new())
