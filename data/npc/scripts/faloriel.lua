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
  {text = "Health potions! Mana potions! Buy them here!"},
  {text = "All kinds of potions available here!"}
}

local potionTalk = keywordHandler:addKeyword(
	{"ring"}, StdModule.say, { npcHandler = npcHandler,
	text = "So, the Librarian sent you. Well, yes, I have a vial of the hallucinogen you need. I'll give it to you for 1000 gold. Do you agree?"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Fifth.Memories) == 1 end
)

	potionTalk:addChildKeyword(
		{"yes"}, StdModule.say, { npcHandler = npcHandler,
		text = "Great. Here, take it."},
		function (player) return player:getMoney() + player:getBankBalance() >= 1000 end,
		function (player)
			player:removeMoneyNpc(1000)
			player:addItem(36185, 1) -- flask of hallucinogen
		end
	)

	potionTalk:addChildKeyword(
		{"yes"}, StdModule.say, { npcHandler = npcHandler,
		text = "You do not have enough money."},
		function (player) return player:getMoney() + player:getBankBalance() < 1000 end
	)

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, dear guest and welcome to my {potion} shop.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
