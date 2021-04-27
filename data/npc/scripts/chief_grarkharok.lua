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
	{ text = 'Grarkharok\'s bestest troll tribe! Yeee, good name!' },
	{ text = 'Grarkharok make new tribe here! Me Chief now!' },
	{ text = 'Me like to throw rocks, me also like frogs! Yumyum!' }
}

npcHandler:addModule(VoiceModule:new(voices))


local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
    if msgcontains(msg, 'cloak') then
		if (player:getStorageValue(Storage.ThreatenedDreams.TroubledMission01) == 13) then
			player:setStorageValue(Storage.ThreatenedDreams.TroubledMission01, 14)
            npcHandler:say("Hahaha! Grarkharok take cloak from pretty girl. Then ... girl is swan. Grarkharok wants eat but flies away. Grarkharok not understand. Not need cloak, too many feathers. Give cloak to To ... Ta ... Tereban in Edron. Getting shiny coins and meat.", cid)
        else
            npcHandler:say("You are not on that mission.", cid)
			npcHandler.topic[cid] = 0
        end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Me Chief Grarkharok! No do {nothing}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Grarkharok be {chief}!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Grarkharok be {chief}!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())

