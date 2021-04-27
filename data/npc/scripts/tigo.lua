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

	if player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) < 2 then
		npcHandler:setMessage(MESSAGE_GREET, "There, there initiate. You will now become one of us, as so many before you. One of the {Barkless}. Walk with us and you will walk tall my friend.")
		playerTopic[cid] = 1
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

	-- Começou a quest
	if msgcontains(msg, "barkless") and npcHandler.topic[cid] == 1 then
			npcHandler:say({"You are now one of us. Learn to endure this world's suffering in every facet and take delight in the soothing eternity that waits for the {purest} of us on the other side."}, cid)
			npcHandler.topic[cid] = 2
			playerTopic[cid] = 2
			if player:getStorageValue(Storage.CultsOfTibia.Questline) < 1 then
			   player:setStorageValue(Storage.CultsOfTibia.Questline, 1)
			end
			if player:getStorageValue(Storage.CultsOfTibia.Barkless.Mission) < 1 then
			   player:setStorageValue(Storage.CultsOfTibia.Barkless.Mission, 1)
			   player:setStorageValue(Storage.CultsOfTibia.Barkless.TrialAccessDoor, 1)
			end
	elseif msgcontains(msg, "purest") and npcHandler.topic[cid] == 2 then
			npcHandler:say({"Purification is but one of the difficult steps on your way to the other side. The {trial} of tar, sulphur and ice."}, cid)
			npcHandler.topic[cid] = 2
			playerTopic[cid] = 2
	elseif msgcontains(msg, "trial") and npcHandler.topic[cid] == 3 then
			npcHandler:say({"The trial consists of three steps. The trial of tar, where you will suffer unbearable heat and embrace the stigma of misfortune. ...",
							"The trial of sulphur, where you will bathe in burning sulphur and embrace the stigma of vanity. Then, there is the trial of purification. The truest of us will be purified to face judgement from the {Penitent}.",
							"To purge your soul, your body will have to be near absolute zero, the point where life becomes impossible. ...",
							"Something about you is different.  I know that you will find a way to return even if you should die during the purification. And if you do... Leiden will become aware of you and retreat. ...",
							"If he does, follow him into his own chambers. Barkless are neither allowed to go near the throne room, aside from being judged, nor can we actually enter it.",
							"He should be easy to defeat with his back to the wall, find him - and delvier us from whatever became of the Penitent."}, cid)
							npcHandler.topic[cid] = 0
							playerTopic[cid] = 0
		end
	return true
end



npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
