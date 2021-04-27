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

local voices = { {text = 'Hey mate, up for a game of dice?'} }
npcHandler:addModule(VoiceModule:new(voices))

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 0 then
			npcHandler:say('Hmmm, would you like to play for {money} or for a chance to win your own {dice}?', cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 4 then
			if not player:removeMoneyNpc(100) then
				npcHandler:say('I am sorry, but you don\'t have so much money.', cid)
				npcHandler.topic[cid] = 0
				return false
			end

			Npc():getPosition():sendMagicEffect(CONST_ME_CRAPS)
			local realRoll = math.random(30)
			local roll = math.random(5)
			if realRoll < 30 then
				npcHandler:say('Ok, here we go ... '.. roll ..'! You have lost. Bad luck. One more game?', cid)
			else
				npcHandler:say('Ok, here we go ... 6! You have won a dice, congratulations. One more game?', cid)
				player:addItem(5792, 1)
			end
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'game') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say('So you care for a civilized game of dice?', cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'money') then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say('I thought so. Okay, I will roll a dice. If it shows 6, you will get five times your bet. How much do you want to bet?', cid)
			npcHandler.topic[cid] = 3
		end
	elseif msgcontains(msg, 'dice') then
		if npcHandler.topic[cid] == 2 then
			npcHandler:say('Hehe, good choice. Okay, the price for this game is 100 gold pieces. I will roll a dice. If I roll a 6, you can have my dice. Agreed?', cid)
			npcHandler.topic[cid] = 4
		end
	elseif tonumber(msg) then
		local amount = tonumber(msg)
		if amount < 1 or amount > 99 then
			npcHandler:say('I am sorry, but I accept only bets between 1 and 99 gold. I don\'t want to ruin you after all. How much do you want to bet?', cid)
			npcHandler.topic[cid] = 3
			return false
		end

		if not player:removeMoneyNpc(amount) then
			npcHandler:say('I am sorry, but you don\'t have so much money.', cid)
			npcHandler.topic[cid] = 0
			return false
		end

		Npc():getPosition():sendMagicEffect(CONST_ME_CRAPS)
		local roll = math.random(6)
		if roll < 6 then
			npcHandler:say('Ok, here we go ... '.. roll ..'! You have lost. Bad luck. One more game?', cid)
		else
			npcHandler:say('Ok, here we go ... 6! You have won '.. amount * 5 ..', congratulations. One more game?', cid)
			player:addMoney(amount * 5)
		end
		npcHandler.topic[cid] = 0
	elseif msgcontains(msg, 'no') then
		npcHandler:say('Oh come on, don\'t be a child.', cid)
		npcHandler.topic[cid] = 1
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Greetings, high roller. So you care for a game, |PLAYERNAME|?')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Hey, you can\'t leave. Luck is smiling on you. I can feel it!')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Hey, you can\'t leave, |PLAYERNAME|. Luck is smiling on you. I can feel it!')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
