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

-- Don't forget npcHandler = npcHandler in the parameters. It is required for all StdModule functions!
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "'Alice the chalice'... Hmpf, of course I won't TELL you my name, I am UNDERCOVER! Now be quiet or they will hear you."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Well, I am drinking most of the time. Er, no I mean - trying to hold my fluids... ah, wait that came out wrong: I am doing research. Let's just keep it at that."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "chalice") and player:getStorageValue(Storage.ForgottenKnowledge.Chalice) == 1 then
		npcHandler:say({
			"Finally. That's what I... oh wait, you're still talking to me - you will blow my cover! What do you want? Oh wait, did my {daughter} send you? It has been some time now, indeed."
		}, cid)
		npcHandler.topic[cid] = 1
	end

	if msgcontains(msg, "daughter") and npcHandler.topic[cid] == 1 then
		npcHandler:say({
			"Well, besides being a renowned sorcerer and scholar at the magic academy in Edron, I am also the proud father of a beautiful daughter, Ivalisse. My little endeavour here must have troubled the poor thing all the time since I left. ...",
			"Tell her I love her and that I will take care. I have to press on! My research is most valuable to the 'Edron-Zaoan Exploration Division'. You don't happen to have some water, do you? Ah nevermind. It's a long {story}."
		}, cid)
		npcHandler.topic[cid] = 2
	end

	if msgcontains(msg, "story") and npcHandler.topic[cid] == 2 then
		npcHandler:say({
			"No water then? Ah drat - er, don't worry, no problem. So, from the day I received news of the discovery of Zao, I wanted to study its inhabitants, wildlife, plants and geography. ...",
			"The academy instated the 'Edron-Zaoan Exploration Division' shortly after. I was a founding member and head of the 'Draken' research branch. ...",
			"Since my valued and practical oriented colleague and mentor Spectulus did not join us, there is only one member of the academy exploration division to actually venture out to see the place - me. ...",
			"You must know, most things in the academy happen 'inside', behind closed doors. But some of us simply refuse to let theory reign over practical experience in science. ...",
			"Well, basically Spectulus is the only one likeminded so far. In fact, he incited me to work in the field in first place. So here I am! {Disguised} as a chalice."
		}, cid)
		npcHandler.topic[cid] = 3
	end

	if msgcontains(msg, "disguised") and npcHandler.topic[cid] == 3 then
		npcHandler:say({
			"Oh yes, so since I wanted to study the Draken up close, I came up with an idea. Based on my research, and some slight bruises and a scar, the perfect hiding place is often right in the middle of subjects. ...",
			"If I could enter their lair unseen and establish a forward camp, I would be able to study the draken in peace - or so I thought. Turns out the whole place was empty. I set up my camp and waited. ...",
			"Then something happened, lizardfolk started to appear, searching the place. I had to retreat from my hiding place and advance through a safer position. ...",
			"I needed to get close and blend in. So I came up with the ultimate disguise: a chalice. I could establish foothold right in their midst, would never be identified as an intruder and could even analyse their drinks! ...",
			"I quickly dug a tunnel to get into what I assume is a throne room and waited for them to pick me up an carry me around! ...",
			"They also 'used' me a bit, you don't want to go into any details here. I am really {thirsty}."
		}, cid)
		npcHandler.topic[cid] = 4
	end

	if msgcontains(msg, "thirsty") and npcHandler.topic[cid] == 4 then
		npcHandler:say({
			"Ah did I say that? Nevermind, I'm not really thirsty. It's part of this illusion. Somehow, I've been in hiding for so long, I started to... become... a vessel. ...",
			"I don't know, I have that constant urge to drink but in this form I would not need to, there is no mouth, no stomach, no flesh and no actual need to eat, drink or sleep. ...",
			"I basically communicate by making the metal of this goblet vibrate and using its form as a body of sound. Like a real voice, don't you think?? Yes, alright I know it's creepy. ...",
			"I am still in the middle of my research and do not want to go home, so please tell my daughter to not worry about my - this will be a breakthrough! I already {learned} a lot!"
		}, cid)
		npcHandler.topic[cid] = 5
	end

	if msgcontains(msg, "learned") and npcHandler.topic[cid] == 5 then
		npcHandler:say({
			"Yes, well for instance I tried for some time to figure out how to enter the fiery portal in this complex. Most of the draken never come up here. They rather hide somewhere down there, planning and plotting. ...",
			" I already know how to enter it, you need to step in and yell 'zzubaran'. Unfortunately they never took me with them. ...",
			" I heard them say it once, when a seemingly drunk guard yelled it in front of a wall mounted torch, hitting his head against it afterwards. He spilt all my contents on the floor, hmpf."
		}, cid)
		player:setStorageValue(Storage.ForgottenKnowledge.AccessLavaTeleport, 1)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
