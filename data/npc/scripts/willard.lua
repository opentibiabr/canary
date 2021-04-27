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

local voices = { {text = 'Selling weapons, ammunition and armor. Special offers only available here, have a look!'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)
	if msgcontains(msg, "package for rashid") then
		if player:getStorageValue(Storage.TravellingTrader.Mission02) >= 1 and player:getStorageValue(Storage.TravellingTrader.Mission02) < 3 then
			npcHandler:say({
				"Oooh, damn, I completely forgot about that. I was supposed to pick it up from the Outlaw Camp. ...",
				"I can't leave my shop here right now, please go and talk to Snake Eye about that package... I promise he won't make any trouble. ...",
				"Don't tell Rashid! I really don't want him to know that I forgot his order. Okay?"
			}, cid)
			npcHandler.topic[cid] = 1
		end
	elseif msgcontains(msg, "yes") then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say("Thank you, I appreciate it. Don't forget to mention the package to Snake.", cid)
			player:setStorageValue(Storage.TravellingTrader.Mission02, player:getStorageValue(Storage.TravellingTrader.Mission02) + 1)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings and Banor be with you, |PLAYERNAME|! May I interest you in a {trade} for weapons, ammunition or armor?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell, |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_SENDTRADE, "Of course, just browse through my wares. If you're only interested in {distance} equipment, let me know.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
