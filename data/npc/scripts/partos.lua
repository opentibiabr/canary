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

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'supplies') then
		if player:getStorageValue(Storage.DjinnWar.EfreetFaction.Mission01) == 1 then
			npcHandler:say({
				'What!? I bet, Baa\'leal sent you! ...',
				'I won\'t tell you anything! Shove off!'
			}, cid)
			player:setStorageValue(Storage.DjinnWar.EfreetFaction.Mission01, 2)
		else
			npcHandler:say('I won\'t talk about that.', cid)
		end

	elseif msgcontains(msg, 'ankrahmun') then
		npcHandler:say({
			'Yes, I\'ve lived in Ankrahmun for quite some time. Ahh, good old times! ...',
			'Unfortunately I had to relocate. <sigh> ...',
			'Business reasons - you know.'
		}, cid)
	end
	return true
end

keywordHandler:addKeyword({'prison'}, StdModule.say, {npcHandler = npcHandler, text = 'You mean that\'s a JAIL? They told me it\'s the finest hotel in town! THAT explains the lousy roomservice!'})
keywordHandler:addKeyword({'jail'}, StdModule.say, {npcHandler = npcHandler, text = 'You mean that\'s a JAIL? They told me it\'s the finest hotel in town! THAT explains the lousy roomservice!'})
keywordHandler:addKeyword({'cell'}, StdModule.say, {npcHandler = npcHandler, text = 'You mean that\'s a JAIL? They told me it\'s the finest hotel in town! THAT explains the lousy roomservice!'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome to my little kingdom, |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye, visit me again. I will be here, promised.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye, visit me again. I will be here, promised.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
