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

local voices = { {text = 'Any time\'s a good time to buy some furniture!'} }
npcHandler:addModule(VoiceModule:new(voices))

-- Wooden Stake
local stakeKeyword = keywordHandler:addKeyword({'stake'}, StdModule.say, {npcHandler = npcHandler, text = 'Making a stake from a chair? Are you insane??! I won\'t waste my chairs on you for free! You will have to pay for it, but since I consider your plan a blasphemy, it will cost 5000 gold pieces. Okay?'},
		function(player) return player:getStorageValue(Storage.FriendsandTraders.TheBlessedStake) ~= -1 end
	)

	stakeKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'Argh... my heart aches! Alright... a promise is a promise. Here - take this wooden stake, and now get lost.', ungreet = true},
		function(player) return player:getMoney() + player:getBankBalance() >= 5000 end,
		function(player) player:removeMoneyNpc(5000) player:addItem(5941, 1) end
	)

	stakeKeyword:addChildKeyword({'yes'}, StdModule.say, {npcHandler = npcHandler, text = 'You can\'t even pay for that.', reset = true})
	stakeKeyword:addChildKeyword({''}, StdModule.say, {npcHandler = npcHandler, text = 'Phew. No chair-killing.', reset = true})

-- Others
npcHandler:setMessage(MESSAGE_GREET, 'Nice to meet you, Mister |PLAYERNAME|! Looking for furniture? You\'ve come to the right place!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'You\'ll come back. They all do.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye.')
npcHandler:setMessage(MESSAGE_SENDTRADE, 'Have a look. Most furniture comes in handy kits. Just use them in your house to assemble the furniture. Do you want to see only a certain type of furniture?')

npcHandler:addModule(FocusModule:new())
