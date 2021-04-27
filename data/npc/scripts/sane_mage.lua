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
	{ text = 'Hm? What is the meaning of all this?' },
	{ text = 'What have I become? What is slime if it\'s not for everyone?' },
	{ text = 'Slime! Everywhere! SLIME TIME! Or... not?' }
}

npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "I AM THE... I mean... I am - what is a mage, if he is not {mad}? If he isn't... raging? I am... I am just sane. A sane mage."})
keywordHandler:addKeyword({'mad'}, StdModule.say, {npcHandler = npcHandler, text = "I am not mad... I- YES, that's the whole problem, isn't it? What's going on, what's happening to me? I don't even know anymore."})
keywordHandler:addKeyword({'vacation'}, StdModule.say, {npcHandler = npcHandler, text = "Yes, well... I'm taking a break. It will take some time. I don't know how long I just... I want to get away from all this for some time, that's it."})
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = "Slime is my mission. Is there anything more important? There isn't. To me. Right now at least."})
keywordHandler:addKeyword({'quest'}, StdModule.say, {npcHandler = npcHandler, text = "Slime is my mission. Is there anything more important? There isn't. To me. Right now at least."})
keywordHandler:addKeyword({'help'}, StdModule.say, {npcHandler = npcHandler, text = "You want to help me? HELP me? You? Who... who are you anyway? Ah nevermind."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	if msgcontains(msg, "job") then
		npcHandler:say({
			'Well I conduct experiments. Viscosity, consistency and overall elegance of {SLIME}. Fungus, I am currently working on a formula for the perfect {slime fungus}.',
			'Not... right now, though. I am currently... on {vacation}. {Vacation}, yes. All my experiments went wrong. WRONG. Everything. I tried everything but still.',
			'It\'s always the same, the {fungus} grows, I am EXCITED and... well... WHAAAAAM! It just EXPLODES! It spreads, covers everything.',
			'At least I have my trusty {servants} helping me to clean up. They do ALL the work. Removing ALL the slime. At least they\'re working as intended. I designed them, you know.',
			'However, sometimes people come and just... DESTROY them! Destroy my work!! Why? Do those people help me removing the slime instead? NO! Not at all.',
			'All they do is ruining my experiments, my perfect testing conditions. It makes me just FURIOUS! And boy do I get FURIOUS, I tell you.'
		}, cid)
	elseif isInArray({"slime", "fungus"}, msg) then
		npcHandler:say({
			'My experiments, my work - not at the moment, however. I\'m on vacation. Trying to get away from it... it\'s all not right. Why... why am I doing this anyway.',
			'NO! I should not talk like that, I just... I shouldn\'t. That\'s not even ME. I... I used to be MAD. A MAD SCIENTIST! THE BEST! THE... the... WORST! A SUPERLATIVE! Ah, nevermind.'
		}, cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "...er... hello? Yes...? Well, if... if you have any questions - I am not even here.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yes... then, goodbye.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes... then, goodbye.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
