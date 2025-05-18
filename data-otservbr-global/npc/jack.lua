local internalNpcName = "Jack"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 115,
	lookBody = 96,
	lookLegs = 115,
	lookFeet = 114,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Now I need to clean up everything again." },
	{ text = "So much to do, so little time, they say..." },
	{ text = "Could it be...? No. No way." },
	{ text = "Mh..." },
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onMove = function(npc, creature, fromPosition, toPosition)
	npcHandler:onMove(npc, creature, fromPosition, toPosition)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

local function greetCallback(npc, creature, message)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 7 then
		npcHandler:setMessage(MESSAGE_GREET, "You!! What have you told my family? They are mad at me and I don't even know why! They think I lied to them about working in Edron in secrecy! Why should I even do that!")
	elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 8 then
		npcHandler:setMessage(MESSAGE_GREET, {
			"What did you do to my SCULPTURE? You simply DESTROYED it? Why? You... you ruined everything... my house, my hobby, my life. My family even refuses to talk to me anymore. ...",
			"Alright, alright you win. I am done for. You... you must be right, yes. Yes, I was working as an intern... in the academy in Edron... yes... Just... tell this Spectulus guy I want to see him. I have nothing left. I am ready.",
		})
		player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 9)
	elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 10 then
		npcHandler:setMessage(MESSAGE_GREET, "So, you've returned to Spectulus? What did he say, is anything wrong? You have this strange expression on your face - is there anything wrong? You DID tell me the truth here, didn't you?")
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What can I do for you? I hope this won't take long, though.")
	end

	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "spectulus") then
		if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 1 then
			npcHandler:say("Gesundheit! Are you alright? Did you... want to tell me something by that?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 3 then
			if npcHandler:getTopic(playerId) == 3 then
				npcHandler:say({
					"So it's that name again. You are really determined, aren't you. ...",
					"So if he thinks I'm someone he knew who is now 'lost' and needs to come back or whatever - tell him he is WRONG. I always lived here with my mother and sister, I'm happy here and I certainly don't want to go to that academy of yours.",
				}, npc, creature, 1000)
				player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 4)
			end
		end
	elseif MsgContains(message, "furniture") then
		if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 3 then
			npcHandler:say("What have you done? What are all these pieces of furniture doing here? Those are ugly at best and - hey! Stop! Leave the wallpaper alone! Alright, alright! Just tell me, why are you doing this? Who's behind all this?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "no") then
		if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 10 then
			if npcHandler:getTopic(playerId) == 0 then
				npcHandler:say("WHAT?? No way, I ask you again - you DID tell me the TRUTH here... right?", npc, creature)
				npcHandler:setTopic(playerId, 5)
			elseif npcHandler:getTopic(playerId) == 5 then
				npcHandler:say({
					"So... so this wasn't EVEN REAL? You brought all this ugly furniture here, you destroyed my sculpture... and on top of that you actually CONVINCED mother and my sister!? How can I possibly explain all that? ...",
					"I... I... Well, at least you told me the truth. I don't know if I can accept this as an excuse but it's a start. Now let me return to my work, I need to fix this statue and then the rest of this... mess.",
				}, npc, creature)
				player:addAchievement("Truth Be Told")
				player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 11)
				player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.LastMissionState, 1)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Oh hm, I've got a handkerchief here somewhere - ah, oh no it's already used, I'm sorry. So, you say that's a real person? Spectulus? I mean - what kind of weirdo thinks of a name like that anyway. ...",
				"And he does what? Hm. Here in Edron? I see. And I was - what? No way. Where? What! Why? And you say you are telling the truth?",
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"I see. Well for starters, I think you're crazy. If I would have 'travelled' in some kind of - device? - that thing should be around here somewhere, or not? ...",
				"What? 'Dimensional fold?' Well, thanks for the information and please close the door behind you when you leave my house. Now.",
			}, npc, creature)
			npcHandler:setTopic(playerId, 0)
			player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 2)
		end

		if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 10 then
			if npcHandler:getTopic(playerId) == 0 then
				npcHandler:say("So that's it? Really?", npc, creature)
				npcHandler:setTopic(playerId, 6)
			elseif npcHandler:getTopic(playerId) == 6 then
				npcHandler:say("Yeah, yeah... so what are you still doing here? I guess I... will have to seek out this Spectulus now, see what he has to say. There is nothing left for me in this place.", npc, creature)
				player:addAchievement("You Don't Know Jack")
				player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine, 11)
				player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.LastMissionState, 2)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "hobbies") or MsgContains(message, "hobby") then
		if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 7 then
			if player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.Statue) < 0 then
				npcHandler:say({
					"Ah, also a keen lover of arts I assume? You might have already caught a glimpse of that humble masterpiece over there in the corner - I sculpt sulky sculptures! ...",
					"Sculpting sculptures was my passion since childhood... ...and it was there at my first sandcastle when... ...and it formed... ...and it developed into... ...years of enduring sculpting... ...carved of something like... ...sulky... ...",
					"And that's what I like to do to this very day - hey, hey will you wake up? Were you even listening to me?",
				}, npc, creature)
				player:setStorageValue(Storage.Quest.U8_7.JackFutureQuest.Statue, 1)
				npcHandler:setTopic(playerId, 0)
			end
		elseif player:getStorageValue(Storage.Quest.U8_7.JackFutureQuest.QuestLine) == 8 then
			npcHandler:say("I... was... sculpting sulky sculptures. For all my life. Until you came in here and DESTROYED MY MASTERPIECE. Go away. I don't like you.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
