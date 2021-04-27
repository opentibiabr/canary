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

local playerTopic = {}
local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.Kilmaresh.First.Access) < 1 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		playerTopic[cid] = 1
	elseif (player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) >= 0 and player:getStorageValue(Storage.Kilmaresh.First.JamesfrancisTask) <= 50)
	and player:getStorageValue(Storage.Kilmaresh.First.Mission) < 3 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		playerTopic[cid] = 15
	elseif player:getStorageValue(Storage.Kilmaresh.First.Mission) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "How could I help you?") -- It needs to be revised, it's not the same as the global
		player:setStorageValue(Storage.Kilmaresh.First.Mission, 5)
		playerTopic[cid] = 20
	end
	npcHandler:addFocus(cid)
	return true
end

local function creatureSayCallback(cid, type, msg)
if not npcHandler:isFocused(cid) then
	return false
end
npcHandler.topic[cid] = playerTopic[cid]
local player = Player(cid)

if msgcontains(msg, "report") and player:getStorageValue(Storage.TheSecretLibrary.PinkTel) == 1 then
	npcHandler:say({"Talk to Captain Charles in Port Hope. He told me that he once ran ashore on a small island where he discovered a small ruin. The architecture was like nothing he had seen before."}, cid)
	player:setStorageValue(Storage.TheSecretLibrary.PinkTel, 2)
	npcHandler.topic[cid] = 1
	playerTopic[cid] = 1
end

if msgcontains(msg, "check") and player:getStorageValue(Storage.TheSecretLibrary.HighDry) == 5 then
	npcHandler:say({"Marvellous! With this information combined we have all that's needed! ...",
					"So let me see. ...",
					"Hmm, interesting. And we shouldn't forget about the chant! Yes, excellent! ...",
					"So listen: To enter the veiled library, travel to the white raven monastery on the Isle of Kings and enter its main altar room. ...",
					"There, use an ordinary scythe on the right of the two monuments, while concentrating on this glyph here and chant the words: Chamek Athra Thull Zathroth ...",
					"Oh, and one other thing. For your efforts I want to reward you with one of my old outfits, back from my adventuring days. May it suit you well! ...",
					"Hurry now my friend. Time is of essence!"}, cid)
	player:setStorageValue(Storage.TheSecretLibrary.HighDry, 6)
	npcHandler.topic[cid] = 1
	playerTopic[cid] = 1
end



return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')
npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
