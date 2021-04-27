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
  {text = "What a beautiful palace. The Kilmareshians are highly skilful architects."},
  {text = "The new treaty of amity and commerce with Kilmaresh is of utmost importance."},
  {text = "The pending freight from the saffron coasts is overdue."}
}

keywordHandler:addKeyword(
	{"present"}, StdModule.say, { npcHandler = npcHandler,
	text = "This is a very beautiful ring. Thank you for this generous present!"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Third.Recovering) == 2 and player:getItemById(36098, true) end,
	function (player) 
		player:removeItem(36098, 1)
		player:setStorageValue(Storage.Kilmaresh.Fourth.Moe, 1)
		player:setStorageValue(Storage.Kilmaresh.Third.Recovering, 3)
	end
)

keywordHandler:addKeyword(
	{"present"}, StdModule.say, { npcHandler = npcHandler,
	text = "Didn't you bring my gift?"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Third.Recovering) == 2 end
)


npcHandler:setMessage(MESSAGE_GREET, "Greetings, friend.")
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
