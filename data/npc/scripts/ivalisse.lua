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
keywordHandler:addKeyword({'silus'}, StdModule.say, {npcHandler = npcHandler, text = "My {father}, can you tell me if he's alright?"})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = "Alright then, you are very welcome to explore the temple!"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Ivalisse."})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = "There is always time to make a change."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "Besides my various {duties} in the temple, I also take care of visitors. Well, I would but right now I can't get my mind of how my {father}'s doing. I am sorry."})
keywordHandler:addKeyword({'duties'}, StdModule.say, {npcHandler = npcHandler, text = " I help linking the portals of this temple to other ancient sites of the {Astral Shapers}."})
keywordHandler:addKeyword({'duties'}, StdModule.say, {npcHandler = npcHandler, text = " I help linking the portals of this temple to other ancient sites of the {Astral Shapers}."})
keywordHandler:addKeyword({'mission'}, StdModule.say, {npcHandler = npcHandler, text = "Besides my various {duties} in the temple, I also take care of visitors. Well, I would but right now I can't get my mind of how my {father}'s doing. I am sorry."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "temple") then
		npcHandler:say({
			"Well, I hope you like it here. We tried to rebuild in the {Shaper}'s will. I am a bit preoccupied at the moment because of the absence of my {father}. I may not be the best of help currently, sorry."
		}, cid)
		npcHandler.topic[cid] = 1
	end

	if msgcontains(msg, "imbuing") or msgcontains(msg, "imbuements") then
		npcHandler:say({
			"The astral Shapers had many ways to shape and refine weapons and equipment. They built shrines dedicated to this world's energies, focussing it and utilising it like a tool to enhance objects. ...",
			"They called this process imbuing and perfected it throughout time. Remains of these shrines are scattered all over Tibia. ...",
			"If you truly want to master this art, you will need to visit the various ancient sites related to the original Shaper imbuements. There is one for each element and we know of at least one other besides these. ...",
			"The discovery of the foundations of this very temple we are standing in, was the key to access their legacy. It is now the center of all our efforts in getting closer to the astral predecessors. ...",
			"They found ways to connect various sites with a system of gates, all concentrating energy to allow travel to far away places. The more we learn, the more we can restore of these ancient gateways. ...",
			"We see the gates as an invitation, use them to your advantage and follow the ways of the Shapers. Access to one of these ancient shrines is the only way to learn additional imbuements. ...",
			"But beware, as far as we know, some of them have been claimed by other ancient beings and there is now way for us to prepare you what lies beyond any of those gates."
		}, cid)
	end

	if msgcontains(msg, "father") and npcHandler.topic[cid] == 1 then
		npcHandler:say({
			"Papa- my father has recently started an adventure on his own. His name is Silus, he is a member of the Edron academy. ...",
			"Ever since he has joined what he called a 'special research division', he went on and on about Zao and how venturing there would help him get ahead. ...",
			"You must know he lives for science, especially concerning far-away lands and cultures. He talked about the importance of practical field studies but, frankly, he isn't particularly cut out for that. ...",
			"I know he has to focus to get his research done right now and I simply cannot leave my duties in the temple. You seem like a person who travels a lot, would you be willing to help me?",
		}, cid)
		npcHandler.topic[cid] = 2
	elseif msgcontains(msg, "father") and npcHandler.topic[cid] == 1 and player:getStorageValue(Storage.ForgottenKnowledge.Ivalisse) == 1 or player:getStorageValue(Storage.ForgottenKnowledge.Chalice) == 1 then
		npcHandler:say({
			"Well, I hope you like it here. We tried to rebuild in the Shaper's will. I am a bit preoccupied at the moment because of the absence of my father. I may not be the best of help currently, sorry.",
		}, cid)
	elseif msgcontains(msg, "father") and npcHandler.topic[cid] == 1 and player:getStorageValue(Storage.ForgottenKnowledge.DragonkingKilled) == 1 then
		npcHandler:say({
			"What? You're telling me you found father? How is he, what did papa say? A chalice? As a disguise? The whole time? ...",
			"Well, I am not as much surprised as I am happy to hear that he's alright. You know, after the incident with the duck and the umbrella - it doesn't get to me that easily anymore. ...",
			"Thank you very much for doing all this for me, I will be forever grateful. I have nothing to repay you with but you are already blessed to have been able to lay eyes on the sacred shaper ruins."
		}, cid)
		player:setStorageValue(Storage.ForgottenKnowledge.Ivalisse, 1)
	end

	if msgcontains(msg, "yes") and npcHandler.topic[cid] == 2 then
		npcHandler:say({
			"Thank you! He told me the other researchers in his team discovered a bridge leading to a cave with a dragon sculpture somewhere in a muggy, grassy area. ...",
			"The cave is said to lead to a temple complex underground which is ued as a gathering place for a race called 'draken'. He left right away and tried to enter Zao on his own. ...",
			"I was even more worried when he explained the route he chose. he wanted to head straight through a giant steppe and through a massive mountainous ridge to reach the grassy plains of lower Zao. ...",
			"If you're interested: I know that the Shapers where active in all corners of Tibia. If you happen to find Shaper ruins there, you may even be able to gather some of their lost knowledge. ...",
			"I may have been a bit stubborn and angry the day he left, I even refused to say farewell. And now I worry if he is safe. ...",
			"I can not do much to help you but I can open a portal to get you quite close to his last known location in Zao. What do you say, will you help me find my father?",
		}, cid)
		npcHandler.topic[cid] = 3
	elseif msgcontains(msg, "no") and npcHandler.topic[cid] == 2 then
		npcHandler:say({
			"Oh nevermind, I am sorry I asked you for this.",
		}, cid)
	end

	if msgcontains(msg, "yes") and npcHandler.topic[cid] == 3 then
		npcHandler:say({
			"You would? That's great! Thank you! If you can find my father, tell him I understand and that I really miss him!",
		}, cid)
		player:setStorageValue(Storage.ForgottenKnowledge.AccessFire, 1)
		player:setStorageValue(Storage.ForgottenKnowledge.Chalice, 1)
	elseif msgcontains(msg, "no") and npcHandler.topic[cid] == 3 then
		npcHandler:say({
			"Oh nevermind, I am sorry I asked you for this.",
		}, cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_WALKAWAY, "Oh... farewell, child.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
