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
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell musical instruments of many kinds.'})
keywordHandler:addKeyword({'instruments'}, StdModule.say, {npcHandler = npcHandler, text = 'I sell lyres, lutes, drums, and simple fanfares.'})
keywordHandler:addKeyword({'music'}, StdModule.say, {npcHandler = npcHandler, text = 'Music is an attempt to condensate emotions in harmonies and save them for the times to come.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'Time has its own song. Close your eyes and listen to the symphony of the seasons.'})
keywordHandler:addKeyword({'song'}, StdModule.say, {npcHandler = npcHandler, text = 'Everything is a song. Life, death, history ... everything. To listen to the song of something is the first step to understand it.'})
keywordHandler:addKeyword({'melody'}, StdModule.say, {npcHandler = npcHandler, text = 'Everything is a song. Life, death, history ... everything. To listen to the song of something is the first step to understand it.'})
keywordHandler:addKeyword({'elf'}, StdModule.say, {npcHandler = npcHandler, text = 'We are the most graceful of all races. We feel the music of the universe in our hearts and souls.'})
keywordHandler:addKeyword({'kuridai'}, StdModule.say, {npcHandler = npcHandler, text = 'They could dig some halls for a big musical event, but they won\'t listen to me about that matter.'})
keywordHandler:addKeyword({'teshial'}, StdModule.say, {npcHandler = npcHandler, text = 'I bet they were great musicians.'})
keywordHandler:addKeyword({'crunor'}, StdModule.say, {npcHandler = npcHandler, text = 'That is some god the humans worship. Our pople are not interested in this gods anymore.'})
keywordHandler:addKeyword({'human'}, StdModule.say, {npcHandler = npcHandler, text = 'They are too loud and don\'t even understand the concept of a melody.'})
keywordHandler:addKeyword({'deraisim'}, StdModule.say, {npcHandler = npcHandler, text = 'The other deraisim are too much concerned with mastering the nature so they don\'t listen to its music anymore.'})
keywordHandler:addKeyword({'cenath'}, StdModule.say, {npcHandler = npcHandler, text = 'The Cenath think they know the \'art\' but the only true art is the music.'})
keywordHandler:addKeyword({'troll'}, StdModule.say, {npcHandler = npcHandler, text = 'I went down to the mines and tried to lighten up their spirit, the foolish creatures did not listen to my songs, though.'})
keywordHandler:addKeyword({'magic'}, StdModule.say, {npcHandler = npcHandler, text = 'Sorry, I don\'t feel like teaching magic today.'})
keywordHandler:addKeyword({'hellgate'}, StdModule.say, {npcHandler = npcHandler, text = 'For the worst of crimes, criminals are cast into hellgate. It is said no one can return from there. Since it is not actually forbidden to enter hellgate, you might convince Elathriel to grant you entrance.'})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	if msgcontains(msg, 'songs of the forest') then
		npcHandler:say({
			'The last issue I had was bought by Randor Swiftfinger. He was banished through the hellgate and probably took the book with him ...',
			'I would not recommend seeking him or the book there, but of course it is possible.'
		}, cid)
	elseif msgcontains(msg, 'love poem') then
		npcHandler:say('Do you want to buy a poem scroll for 200 gold?', cid)
		npcHandler.topic[cid] = 1
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler.topic[cid] = 0
			local player = Player(cid)
			if not player:removeMoneyNpc(200) then
				npcHandler:say('You don\'t have enough money.', cid)
				return true
			end

			player:addItem(8189, 1)
			npcHandler:say('Here it is.', cid)
		end
	end
	return true
end

-- Greeting message
keywordHandler:addGreetKeyword({"ashari"}, {npcHandler = npcHandler, text = "Ashari, |PLAYERNAME|."})
--Farewell message
keywordHandler:addFarewellKeyword({"asgha thrazi"}, {npcHandler = npcHandler, text = "Asha Thrazi, |PLAYERNAME|."})

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, 'Ashari |PLAYERNAME|.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Asha Thrazi, |PLAYERNAME|!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Asha Thrazi, |PLAYERNAME|!')

npcHandler:addModule(FocusModule:new())
