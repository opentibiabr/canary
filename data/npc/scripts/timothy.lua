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
	if(not npcHandler:isFocused(cid)) then
		return false
	end
	local player = Player(cid)
	if(msgcontains(msg, "research notes")) then
		if player:getStorageValue(Storage.TheWayToYalahar.QuestLine) == 1 then
			npcHandler:say({
				"Oh, you are the contact person of the academy? Here are the notes that contain everything I have found out so far. ...",
				"This city is absolutely fascinating, I tell you! If there hadn't been all this trouble and chaos in the past, this city would certainly be the greatest centre of knowledge in the world. ...",
				"Oh, by the way, speaking about all the trouble here reminds me of Palimuth, a friend of mine. He is a native who was quite helpful in gathering all these information. ...",
				"I'd like to pay him back for his kindness by sending him some experienced helper that assists him in his effort to restore some order in this city. Maybe you are interested in this job?"
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) then
			player:setStorageValue(Storage.TheWayToYalahar.QuestLine, 2)
			npcHandler:say("Excellent! You will find Palimuth near the entrance of the city centre. Just ask him if you can assist him in a few missions.", cid)
			player:addItem(10090, 1)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
