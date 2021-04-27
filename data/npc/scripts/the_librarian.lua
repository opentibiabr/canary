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
  {text = "I really have to find this scroll. Where did I put it?"},
  {text = "Too much dust here. I should tidy up on occasion."},
  {text = "Someone opened the Grimoire of Flames without permission. Egregious!"}
}

keywordHandler:addKeyword(
	{"ring"}, StdModule.say, { npcHandler = npcHandler,
	text = {
		"To extract memories from the ring, you have to enter a trance-like state with the help of a hallucinogen. Like this you can see all memories that are stored in the ring. Ask {Faloriel} for a respective potion. ...",
		"Drink it while wearing the ring in the Temple of {Bastesh} and say: \'Sa Katesa Tarsani na\'. If the legends are true you will be able to take memories with you in the form of memory shards."
	}},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Fourth.Moe) == 4 end,
	function (player)
		player:setStorageValue(Storage.Kilmaresh.Fifth.Memories, 1)
		player:setStorageValue(Storage.Kilmaresh.Fifth.MemoriesShards, 0)
		player:setStorageValue(Storage.Kilmaresh.Fourth.Moe, 5)
	end
)

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, dear guest. If you are interested in paperware such as books or scrolls, ask me for a trade.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
