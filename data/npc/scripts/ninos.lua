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
	{ text = 'Welcome to the post office!' },
	{ text = 'If you need help with letters or parcels, just ask me. I can explain everything.' },
	{ text = 'Hey, send a letter to your friend now and then. Keep in touch, you know.' }
}

npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "measurements") then
		local player = Player(cid)
		if player:getStorageValue(Storage.Postman.Mission07) >= 1 and	player:getStorageValue(Storage.Postman.MeasurementsBenjamin) ~= 1 then
			npcHandler:say("Oh they don't change that much since in the old days as... <tells a boring and confusing story about a cake, a parcel, himself and two squirrels, at least he tells you his measurements in the end> ", cid)
			player:setStorageValue(Storage.Postman.Mission07, player:getStorageValue(Storage.Postman.Mission07) + 1)
			player:setStorageValue(Storage.Postman.MeasurementsBenjamin, 1)
			npcHandler.topic[cid] = 0
	else
			npcHandler:say("...", cid)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello. How may I help you |PLAYERNAME|? Ask me for a {trade} if you want to buy something. I can also explain the {mail} system.")
npcHandler:setMessage(MESSAGE_FAREWELL, "It was a pleasure to help you, |PLAYERNAME|.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
