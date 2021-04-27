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

local function greetCallback(cid)
	local player = Player(cid)

	if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 7 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"You!! What have you told my family? They are mad at me and I don't even know why! \z
			They think I lied to them about working in Edron in secrecy! Why should I even do that!"
		)
	elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 8 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			{
				"What did you do to my SCULPTURE? You simply DESTROYED it? Why? You... you ruined everything... \z
					my house, my hobby, my life. My family even refuses to talk to me anymore. ...",
				"Alright, alright you win. I am done for. You... you must be right, yes. Yes, I was working as an \z
				intern... in the academy in Edron... yes... Just... tell this Spectulus guy I want to see him. \z
				I have nothing left. I am ready."
			}
		)
		player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 9)
	elseif player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 10 then
		npcHandler:setMessage(
			MESSAGE_GREET,
			"So, you've returned to Spectulus? What did he say, is anything wrong? You have this strange expression \z
			on your face - is there anything wrong? You DID tell me the truth here, didn't you?"
		)
	else
		npcHandler:setMessage(MESSAGE_GREET, "Yes? What can I do for you? I hope this won't take long, though.")
	end

	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if msgcontains(msg, "spectulus") then
		if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 1) then
			npcHandler:say("Gesundheit! Are you alright? Did you... want to tell me something by that?", cid)
			npcHandler.topic[cid] = 1
		elseif (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 3) then
			if npcHandler.topic[cid] == 3 then
				npcHandler:say(
					{
						"So it's that name again. You are really determined, aren't you. ...",
						"So if he thinks I'm someone he knew who is now 'lost' and needs to come back or whatever - \z
						tell him he is WRONG. I always lived here with my mother and sister, I'm happy here and I \z
						certainly don't want to go to that academy of yours."
					},
					cid
				)
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 4)
			end
		end
	elseif msgcontains(msg, "furniture") then
		if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 3) then
			if
				(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Furniture01) == 1) and
					(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Furniture02) == 1) and
					(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Furniture03) == 1) and
					(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Furniture04) == 1) and
					(player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Furniture05) == 1)
			 then
				npcHandler:say(
					"What have you done? What are all these pieces of furniture doing here? Those are ugly at \z
					best and - hey! Stop! Leave the wallpaper alone! Alright, alright! Just tell me, why are you \z
					doing this? Who's behind all this?",
					cid
				)
				npcHandler.topic[cid] = 3
			end
		end
	elseif msgcontains(msg, "no") then
		if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 10 then
			if (npcHandler.topic[cid] == 0) then
				npcHandler:say("WHAT?? No way, I ask you again - you DID tell me the TRUTH here... right?", cid)
				npcHandler.topic[cid] = 5
			elseif (npcHandler.topic[cid] == 5) then
				npcHandler:say(
					{
						"So... so this wasn't EVEN REAL? You brought all this ugly furniture here, you destroyed \z
						my sculpture... and on top of that you actually CONVINCED mother and my sister!? How can \z
						I possibly explain all that? ...",
						"I... I... Well, at least you told me the truth. I don't know if I can accept this as an \z
						excuse but it's a start. Now let me return to my work, I need to fix this statue and then \z
							the rest of this... mess."
					},
					cid
				)
				player:addAchievement("Truth Be Told")
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 11)
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.LastMissionState, 1)
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, "yes") then
		if (npcHandler.topic[cid] == 1) then
			npcHandler:say(
				{
					"Oh hm, I've got a handkerchief here somewhere - ah, oh no it's already used, I'm sorry. \z
					So, you say that's a real person? Spectulus? I mean - what kind of weirdo thinks \z
					of a name like that anyway. ...",
					"And he does what? Hm. Here in Edron? I see. And I was - what? No way. Where? What! \z
					Why? And you say you are telling the truth?"
				},
				cid
			)
			npcHandler.topic[cid] = 2
		elseif (npcHandler.topic[cid] == 2) then
			npcHandler:say(
				{
					"I see. Well for starters, I think you're crazy. If I would have 'travelled' in some \z
					kind of - device? - that thing should be around here somewhere, or not? ...",
					"What? 'Dimensional fold?' Well, thanks for the information and please close the door \z
					behind you when you leave my house. Now."
				},
				cid
			)
			npcHandler.topic[cid] = 0
			player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 2)
		end

		if player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 10 then
			if (npcHandler.topic[cid] == 0) then
				npcHandler:say("So that's it? Really?", cid)
				npcHandler.topic[cid] = 6
			elseif (npcHandler.topic[cid] == 6) then
				npcHandler:say(
					"Yeah, yeah... so what are you still doing here? I guess I... will have to seek out this \z
					Spectulus now, see what he has to say. There is nothing left for me in this place.",
					cid
				)
				player:addAchievement("You Don't Know Jack")
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine, 11)
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.LastMissionState, 2)
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, "hobbies") or msgcontains(msg, "hobby") then
		if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 7) then
			if (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.Statue) < 1) then
				npcHandler:say(
					{
						"Ah, also a keen lover of arts I assume? You might have already caught a glimpse of that \z
						humble masterpiece over there in the corner - I sculpt sulky sculptures! ...",
						"Sculpting sculptures was my passion since childhood... ...and it was there at my first \z
						sandcastle when... ...and it formed... ...and it developed into... ...years of enduring \z
						sculpting... ...carved of something like... ...sulky... ...",
						"And that's what I like to do to this very day - hey, hey will you wake up? Were you even \z
							listening to me?"
					},
					cid,
					false,
					true,
					200
				)
				player:setStorageValue(Storage.TibiaTales.JackFutureQuest.Statue, 1)
				npcHandler.topic[cid] = 0
			end
		elseif (player:getStorageValue(Storage.TibiaTales.JackFutureQuest.QuestLine) == 8) then
			npcHandler:say(
				"I... was... sculpting sulky sculptures. For all my life. Until you came in here and DESTROYED \z
				MY MASTERPIECE. Go away. I don't like you.",
				cid
			)
			npcHandler.topic[cid] = 0
		end
	end
	return true
end

local voices = {
	{text = "Now I need to clean up everything again."},
	{text = "So much to do, so little time, they say..."},
	{text = "Could it be...? No. No way."},
	{text = "Mh..."}
}

npcHandler:addModule(VoiceModule:new(voices))
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:addModule(FocusModule:new())
