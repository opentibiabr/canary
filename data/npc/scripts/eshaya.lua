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
  {text = "Praised be Suon and Bastesh."},
  {text = "I should talk to Kallimae soon."},
  {text = "Issavi\'s safety is my first concern."}
}

-- First

local firstMission = keywordHandler:addKeyword(
	{"mission"}, StdModule.say, { npcHandler = npcHandler,
	text = "I\'m willing to admit that I need help. And the help of someone who is not from {Issavi} at that. But the task could be dangerous and you would become embroiled in the politics and court intrigues of {Kilmaresh}. Will you help me anyhow?"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Second.Investigating) == -1 end,
	function (player) player:setStorageValue(Storage.Kilmaresh.First.Title, 1) end
)

	firstMission:addChildKeyword(
		{"yes"}, StdModule.say, { npcHandler = npcHandler,
		text = {
			"You are a noble soul! So listen: for many decades, over a century actually, the city of {Rathleton} had an Ambassador here in {Issavi}. ...",
			"Kilmaresh and Oramond maintain important commercial relations, and for this reason Rathleton has an envoy here. In the past, the relations were good but now ...",
			"I hate to admit it but I heavily suspect that the current Ambassador is a traitor and consorts with the forbidden cult of Fafnar. I have several hints and Kallimae saw it in one of her visions ...",
			"But the vision of a Kilmareshian seer is no proof they will ever accept in Rathleton. And without proof we can\'t banish the Ambassador, this would cause major diplomatic fallout or even a war. I can\'t risk that. ...",
			"I need unequivocal evidence that the Ambassador conspires with the Fafnar cultists. Please go to his residence in the eastern part of the city and search for letters, journals ... anything that could prove him guilty."
		}},
		nil,
		function (player) player:setStorageValue(Storage.Kilmaresh.Second.Investigating, 1) end
	)

-- Second

keywordHandler:addKeyword(
	{"mission"}, StdModule.say, { npcHandler = npcHandler,
	text = {
		"It seems that he destroyed every visible evidence of his treason. That\'s very unfortunate and I see only one remaining possibility: You need to see the {Ambassador}\'s memories. ...",
		"But there is only one way to achieve this: You have to find a Ring of {Secret Thoughts}. Legend has it that a monstrous being called {Urmahlullu} has such a ring. If the myths are true you can find this creature in a subterranean tomb south of Issavi."
	}},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Second.Investigating) == 5 end,
	function (player) 
		player:setStorageValue(Storage.Kilmaresh.Second.Investigating, 6)
		player:setStorageValue(Storage.Kilmaresh.Third.Recovering, 1)
	end
)

keywordHandler:addKeyword(
	{"mission"}, StdModule.say, { npcHandler = npcHandler,
	text = "You haven\'t investigated all the evidence." },
	function (player) 
		return player:getStorageValue(Storage.Kilmaresh.Second.Investigating) >= 0 and
			player:getStorageValue(Storage.Kilmaresh.Second.Investigating) < 5  
	end
)

-- Third

keywordHandler:addKeyword(
	{"ring"}, StdModule.say, { npcHandler = npcHandler,
	text = "You found the Ring of {Secret Thoughts}! Well done! Now give it to the {Ambassador} as a present. He\'s a peacock and will accept such a precious gift for sure. As soon as he wears it, his memories will be stored in the ring."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Third.Recovering) == 1 and player:getItemById(36098, true) end,
	function (player) player:setStorageValue(Storage.Kilmaresh.Third.Recovering, 2) end
)

keywordHandler:addKeyword(
	{"ring"}, StdModule.say, { npcHandler = npcHandler,
	text = "You don't have the ring I need."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Third.Recovering) == 1 end
)

-- Fifth

keywordHandler:addKeyword(
	{"mission"}, StdModule.say, { npcHandler = npcHandler, 
	text = "This is the proof we need! Very well done! You have to report this to our {Empress}. She will grant you an audience now."},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Fifth.Memories) == 4 end,
	function (player) player:setStorageValue(Storage.Kilmaresh.Fifth.Memories, 5) end
)

npcHandler:setMessage(MESSAGE_GREET, "Suon\'s and Bastesh\'s blessing, dear guest!")
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_ONADDFOCUS, onAddFocus)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(VoiceModule:new(voices))
npcHandler:addModule(FocusModule:new())
