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

local voices = {
	{ text = '<hums a dark tune>' },
	{ text = '<chants> Re Ha, Omrah, Tan Ra...' },
	{ text = 'The rats... the rats in the walls...' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if(msgcontains(msg, 'scroll') or msgcontains(msg, 'mission')) and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission61) < 1 then
		npcHandler:say("Hello, brother. You come with a question to me, I believe?", cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'yes') and npcHandler.topic[cid] == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 then
		npcHandler:say("And what is it you want? Do you bring news from the undead, or do you seek a dark {artefact}?", cid)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission45, 1)
		npcHandler.topic[cid] = 2
	elseif(msgcontains(msg, 'artefact') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 2 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission61) < 1 then
		npcHandler:say({
			"The scroll piece there? The symbols look promising, but it is incomplete. ...",
			"It is of little use to us. But it seems to be of interest to you ...",
			"In exchange for the scroll piece, you must assist me with something. {Agreed}?"
		}, cid)
		npcHandler.topic[cid] = 3
	elseif(msgcontains(msg, 'agreed') or msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 3 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission60) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission61) < 1 then
		npcHandler:say({
			"I would have to sing to the Dark Shrines, but I cannot. ...",
			"I... cannot bear Urgith's breed. Everywhere, I hear them - scrabbling, squeaking ...",
			"Take this bone flute and play it in front of the five Dark Shrines so that they answer with song in return. You will find them in the Gardens of Night. ...",
			"If you have done that, you may have the scroll piece. Now go."
		}, cid)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission61, 1)
		player:addItem(21249, 1)
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'mission') and player:getStorageValue(Storage.GravediggerOfDrefia.Mission66) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission67) < 1 then
		npcHandler:say("Hello, brother. You have finished the dance?", cid)
		npcHandler.topic[cid] = 4
	elseif(msgcontains(msg, 'yes')) and npcHandler.topic[cid] == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission66) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission67) < 1 then
		npcHandler:say({
			"You have indeed. The shrines have sung back to you. Well done, brother. Not many men take such an interest in our art. ...",
			"I will take the flute back. Our bargain stands. You may take the scroll."
		}, cid)
		player:removeItem(21249, 1)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission67, 1)
		npcHandler.topic[cid] = 0
		else npcHandler:say({"Time is money, hurry."}, cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "A shadow preceded you. You wish a {scroll} or a {mission}?")
npcHandler:addModule(FocusModule:new())
