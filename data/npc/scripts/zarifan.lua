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
	{ text = '<sigh> lost... word...' },
	{ text = '<sigh> ohhhh.... memories...' },
	{ text = 'The secrets... too many... sleep...' },
	{ text = 'Loneliness...' }
}

local function creatureSayCallback(cid, type, msg)
if not npcHandler:isFocused(cid) then
		return false
	end

local player = Player(cid)
	if msgcontains(msg, "magic") and player:getStorageValue(12902) < 1 then
	npcHandler:say("...Tell me...the first... magic word.", cid)
	player:setStorageValue(12902, 1)
	else npcHandler:say("...continue with your mission...", cid)
	end

	end
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = '..what about {magic}..'})
keywordHandler:addKeyword({'friendship'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes... YES... friendship... now... second word?'})
keywordHandler:addKeyword({'lives'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes... YES... friendship... lives... now third word?'})
keywordHandler:addKeyword({'forever'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes... YES... friendship... lives... FOREVER ... And say hello... to... my old friend... Omrabas. '})


npcHandler:addModule(VoiceModule:new(voices))
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
