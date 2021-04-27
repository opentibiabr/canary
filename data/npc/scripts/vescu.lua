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

local message = {}

local config = {
	['30 bonelord eyes'] = {storageValue = 1, text = {'Have you really managed to bring me 30 bonelord eyes? <hicks>', 'Do bonelord eyes continue blinking when they are seperated from the bonelord? That is a scary thought.', 'Aw-awsome! <hicks> Squishy! Now, please bring me 10 {red dragon scales}.'}, itemId = 5898, count = 30},
	['bonelord eyes'] = {storageValue = 1, text = {'Have you really managed to bring me 30 bonelord eyes? <hicks>', 'Do bonelord eyes continue blinking when they are seperated from the bonelord? That is a scary thought.', 'Aw-awsome! <hicks> Squishy! Now, please bring me 10 {red dragon scales}.'}, itemId = 5898, count = 30},
	['bonelord eye'] = {storageValue = 1, text = {'Have you really managed to bring me 30 bonelord eyes? <hicks>', 'Do bonelord eyes continue blinking when they are seperated from the bonelord? That is a scary thought.', 'Aw-awsome! <hicks> Squishy! Now, please bring me 10 {red dragon scales}.'}, itemId = 5898, count = 30},
	['10 red dragon scales'] = {storageValue = 2, text = {'D-did you get all of the 10 red dragon scales? <hicks>', 'Have you ever wondered if a red dragon means \'stop\' whereas a green dragon means \'go\'?', 'G-good work, ... wha-what\'s your name again? <hicks> Anyway... come back with 30 {lizard scales}.'}, itemId = 5882, count = 10},
	['red dragon scales'] = {storageValue = 2, text = {'D-did you get all of the 10 red dragon scales? <hicks>', 'Have you ever wondered if a red dragon means \'stop\' whereas a green dragon means \'go\'?', 'G-good work, ... wha-what\'s your name again? <hicks> Anyway... come back with 30 {lizard scales}.'}, itemId = 5882, count = 10},
	['red dragon scale'] = {storageValue = 2, text = {'D-did you get all of the 10 red dragon scales? <hicks>', 'Have you ever wondered if a red dragon means \'stop\' whereas a green dragon means \'go\'?', 'G-good work, ... wha-what\'s your name again? <hicks> Anyway... come back with 30 {lizard scales}.'}, itemId = 5882, count = 10},
	['30 lizard scales'] = {storageValue = 3, text = {'Ah, are those - <hicks> - the 30 lizard scales?', 'I once had a girlfriend c-called L-lizzie. She had s-scales too.', 'This potion will become p-pretty scaly. I\'m not sure yet if I want to d-drink that. I think the 20 {fish fins} which come next won\'t really improve it. <hicks>'}, itemId = 5881, count = 30},
	['lizard scales'] = {storageValue = 3, text = {'Ah, are those - <hicks> - the 30 lizard scales?', 'I once had a girlfriend c-called L-lizzie. She had s-scales too.', 'This potion will become p-pretty scaly. I\'m not sure yet if I want to d-drink that. I think the 20 {fish fins} which come next won\'t really improve it. <hicks>'}, itemId = 5881, count = 30},
	['lizard scale'] = {storageValue = 3, text = {'Ah, are those - <hicks> - the 30 lizard scales?', 'I once had a girlfriend c-called L-lizzie. She had s-scales too.', 'This potion will become p-pretty scaly. I\'m not sure yet if I want to d-drink that. I think the 20 {fish fins} which come next won\'t really improve it. <hicks>'}, itemId = 5881, count = 30},
	['20 fish fins'] = {storageValue = 4, text = {'Eww, is that disgusting smell coming from the 20 fish fins? <burps>', 'Not normal fish fins of course. We need <hicks> Quara fish fins. If you haven\'t h-heard about them, ask the - <hicks> - plorer society.', 'Alrrrrrrright! Thanks for the f-fish. Get me the 20 ounces of {vampire dust} now. I\'ll have another b-beer.'}, itemId = 5895, count = 20},
	['fish fins'] = {storageValue = 4, text = {'Eww, is that disgusting smell coming from the 20 fish fins? <burps>', 'Not normal fish fins of course. We need <hicks> Quara fish fins. If you haven\'t h-heard about them, ask the - <hicks> - plorer society.', 'Alrrrrrrright! Thanks for the f-fish. Get me the 20 ounces of {vampire dust} now. I\'ll have another b-beer.'}, itemId = 5895, count = 20},
	['fish fin'] = {storageValue = 4, text = {'Eww, is that disgusting smell coming from the 20 fish fins? <burps>', 'Not normal fish fins of course. We need <hicks> Quara fish fins. If you haven\'t h-heard about them, ask the - <hicks> - plorer society.', 'Alrrrrrrright! Thanks for the f-fish. Get me the 20 ounces of {vampire dust} now. I\'ll have another b-beer.'}, itemId = 5895, count = 20},
	['20 vampire dust'] = {storageValue = 5, text = {'Have you collected 20 ounces of vampire d-dust? <hicks>', 'Don\'t you think vampires have something - <hicks> - romantic about them? I think you need a b-blessed steak though to turn them into d-dust.', 'Tha-thank you. Trolls are good for something a-after all. Bring me the 10 ounces of {demon dust} now. <hicks>'}, itemId = 5905, count = 20},
	['vampire dust'] = {storageValue = 5, text = {'Have you collected 20 ounces of vampire d-dust? <hicks>', 'Don\'t you think vampires have something - <hicks> - romantic about them? I think you need a b-blessed steak though to turn them into d-dust.', 'Tha-thank you. Trolls are good for something a-after all. Bring me the 10 ounces of {demon dust} now. <hicks>'}, itemId = 5905, count = 20},
	['10 demon dust'] = {storageValue = 6, text = {'Have you slain enough d-demons to gather 10 ounces of demon dust? <hicks>', 'I like d-demons. They are just as pretty as flamingos. But you need a blessed stake or something to get demon dust. <hicks>', 'G-great. You\'re a reeeal k-killer like me, eh? I think I\'ll g-give you something fun when the potion is complete. But first, b-bring me {warrior\'s sweat}.'}, itemId = 5906, count = 10},
	['demon dust'] = {storageValue = 6, text = {'Have you slain enough d-demons to gather 10 ounces of demon dust? <hicks>', 'I like d-demons. They are just as pretty as flamingos. But you need a blessed stake or something to get demon dust. <hicks>', 'G-great. You\'re a reeeal k-killer like me, eh? I think I\'ll g-give you something fun when the potion is complete. But first, b-bring me {warrior\'s sweat}.'}, itemId = 5906, count = 10},
	['warrior\'s sweat'] = {storageValue = 7, text = {'This s-smells even worse than the fish fins. Is that warrior\'s sweat?', 'If you can\'t sweat enough yourself, go ask a Djinn. They do - <hicks> magical <hicks> - tractions. Err, extractions.', 'Yahaha! Here we g-go. I\'ll just take a small sip - <gulp>. Okay, this is disgusting, but it seems to work. I\'ll teach you something fun, remind me to tell you a {secret} sometime.'}, itemId = 5885},
}

local function greetCallback(cid)
	if Player(cid):getCondition(CONDITION_DRUNK) then
		npcHandler:setMessage(MESSAGE_GREET, 'Hey t-there, you look like someone who enjoys a good {booze}.')
	else
		npcHandler:say('Oh, two t-trolls. Hellooo, wittle twolls. <hicks>', cid)
		return false
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)

	if msgcontains(msg, 'potion') then
		if player:getStorageValue(Storage.OutfitQuest.AssassinBaseOutfit) < 1 then
			npcHandler:say('It\'s so hard to know the exact time when to stop drinking. <hicks> C-could you help me to brew such a potion?', cid)
			npcHandler.topic[cid] = 1
		end
	elseif config[msg] and npcHandler.topic[cid] == 0 then
		if player:getStorageValue(Storage.OutfitQuest.AssassinBaseOutfit) == config[msg].storageValue then
			npcHandler:say(config[msg].text[1], cid)
			npcHandler.topic[cid] = 3
			message[cid] = msg
		else
			npcHandler:say(config[msg].text[2], cid)
		end
	elseif msgcontains(msg, 'secret') then
		if player:getStorageValue(Storage.OutfitQuest.AssassinBaseOutfit) == 8 then
			npcHandler:say('Right. <hicks> Since you helped me to b-brew that potion and thus ensured the high quality of my work <hicks>, I\'ll give you my old assassin costume. It lacks the head part, but it\'s almost like new. Don\'t pretend to be me though, \'kay? <hicks>', cid)
			player:addOutfit(156)
			player:addOutfit(152)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
			player:setStorageValue(Storage.OutfitQuest.AssassinBaseOutfit, 9)
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({
				'You\'re a true buddy. I promise I will t-try to avoid killing you even if someone asks me to. <hicks> ...',
				'Listen, I have this old formula from my grandma. <hicks> It says... 30 {bonelord eyes}... 10 {red dragon scales}. ...',
				'Then 30 {lizard scales}... 20 {fish fins} - ew, this sounds disgusting, I wonder if this is really a potion or rather a cleaning agent. ...',
				'Add 20 ounces of {vampire dust}, 10 ounces of {demon dust} and mix well with one flask of {warrior\'s sweat}. <hicks> ...',
				'Okayyy, this is a lot... we\'ll take this step by step. <hicks> Will you help me gathering 30 {bonelord eyes}?'
			}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			if player:getStorageValue(Storage.OutfitQuest.DefaultStart) ~= 1 then
				player:setStorageValue(Storage.OutfitQuest.DefaultStart, 1)
			end
			player:setStorageValue(Storage.OutfitQuest.AssassinBaseOutfit, 1)
			npcHandler:say('G-good. Go get them, I\'ll have a beer in the meantime.', cid)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			local targetMessage = config[message[cid]]
			local count = targetMessage.count or 1
			if not player:removeItem(targetMessage.itemId, count) then
				npcHandler:say('Next time you lie to me I\'ll k-kill you. <hicks> Don\'t think I can\'t aim well just because I\'m d-drunk.', cid)
				npcHandler.topic[cid] = 0
				return true
			end

			player:setStorageValue(Storage.OutfitQuest.AssassinBaseOutfit, player:getStorageValue(Storage.OutfitQuest.AssassinBaseOutfit) + 1)
			npcHandler:say(targetMessage.text[3], cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'no') then
		if npcHandler.topic[cid] ~= 3 then
			npcHandler:say('Then not <hicks>.', cid)
		elseif npcHandler.topic[cid] == 3 then
			npcHandler:say('H-hurry up! <hicks> I have to start working soon.', cid)
		end
		npcHandler.topic[cid] = 0
	end
	return true
end

local function onReleaseFocus(cid)
	message[cid] = nil
end

keywordHandler:addKeyword({'addon'}, StdModule.say, {npcHandler = npcHandler, text = 'I can give you a <hicks> scar as an addon. Nyahahah.'})
keywordHandler:addKeyword({'booze'}, StdModule.say, {npcHandler = npcHandler, text = 'Did I say booze? I meant, {flamingo}. <hicks> Pink birds are kinda cool, don\'t you think? Especially on a painting.'})
keywordHandler:addKeyword({'flamingo'}, StdModule.say, {npcHandler = npcHandler, text = 'You have to enjoy the word. Like, {flayyyminnngoooo}. Say it with me. <hicks>'})
keywordHandler:addKeyword({'flayyyminnngoooo'}, StdModule.say, {npcHandler = npcHandler, text = 'Yes, you got it! Hahaha, we understand each other. Good {job}. <hicks>'})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a killer! Yeshindeed! A masterful assassin. I prefer that too \'Peekay\'. <hicks>'})
keywordHandler:addKeyword({'outfit'}, StdModule.say, {npcHandler = npcHandler, text = 'O-outfit? You already have a t-troll outfit. That\'s good enough for you. <hicks>'})
keywordHandler:addKeyword({'sober'}, StdModule.say, {npcHandler = npcHandler, text = 'I wish there was like a {potion} which makes you sober in an instant. Dwarven rings wear off so fast. <hicks>'})

npcHandler:setMessage(MESSAGE_FAREWELL, 'T-time for another b-beer. <hicks>')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Oh, two t-trolls. Hellooo, wittle twolls. <hicks>')

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)
npcHandler:addModule(FocusModule:new())
