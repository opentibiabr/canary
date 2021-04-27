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

function creatureSayCallback(cid, type, msg)
	if(not npcHandler:isFocused(cid)) then
		return false
	end


	if(msgcontains(msg, "mission") or msgcontains(msg, "task")) then
		if(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) < 1) and getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Time) <= os.time() then
			npcHandler:say("Oh, you want some work? You can help us, alright. Did you know that the people of the city think those rabbit feet are actually lucky charms?", cid)
			npcHandler.topic[cid] = 1
		elseif(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 1) then
			npcHandler:say("Good to see you back. Now, did you bring us the lucky charms?", cid)
			npcHandler.topic[cid] = 3


			elseif getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Time) > os.time() then
			npcHandler:say("You need wait some hours to take other mission again or you are still on a mission.", cid)

	------------------------ FINISH MISSION 01 ------------------------
		elseif(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 2) then
			selfSay("Of course, of course, there is indeed something you can help us with. Remember that we also have some tasks for you. So, are you ready for another quest to help the men of the forest?", cid)
			selfSay("There is a problem with one of our deer stands. Right. Well, there are two problems, our deer stands - and some of the walls of the buildings in the camp are broken. ...", cid)
			selfSay("You know, the guys built all of that themselves. Sure, at first it didn't quite work out as we planned and in the end we had to tear down half the forest - but - it was worth it. ...", cid)
			selfSay("Still, most of the camp is kind of... broken now. And someone with a good hammer and a steady hand needs to fix that. Or I am afraid we will have to freeze... during the cold evenings... well you know, hard times. ...", cid)
			npcHandler:say("So what do you say, in for this one?", cid)
			npcHandler.topic[cid] = 4
		elseif(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 3) and getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.RottinStart) > 4 then
			npcHandler:say("Ah there you are. So, did you repair all the broken structures?", cid)
			npcHandler.topic[cid] = 5
	------------------------ FINISH MISSION 02 ------------------------
		elseif(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 4) then
			selfSay("Oh my good friend, good to see you! Today you will help us with a very important task. Very important indeed. ...", cid)
			selfSay("You know, a large group of merchants is travelling from Thais to Venore and they are crossing the forest to shorten their way - can you believe it? ...", cid)
			npcHandler:say("They will enter the forest near our camp which is where you come in - uhm I mean you do want to help us with this, right?", cid)
			npcHandler.topic[cid] = 6
		elseif(getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03) == 5) and getPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Corpse) == 4 then
			npcHandler:say("You did it!! And I assume you took only what you needed? Heh. No, I know it. Because my men took the rest. Thanks for helping us, you did a very good job. In fact I have a little 'extra' for you here, thanks again.", cid)
				------------------ RESET STORAGE --------------------
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03, - 1) -- reset storage
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.RottinStart, - 1) -- reset storage
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Trap, - 1) -- reset storage
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Corpse, - 1) -- reset storage
				-----------------------------------------------------
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Time, os.time() + 20 * 60 * 60) -- set time to start mission again
				setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Questline, 2) -- quest log
			------------------- ITEM RANDOM --------------------
			items = {
				[0] = {id = 2152, count = 3, chance = 100},
				[1] = {id = 2169, count = 1, chance = 80},
				[2] = {id = 13247, count = 1, chance = 25},
			}
			for i = 0, #items do
			if (items[i].chance > math.random(1, 100)) then
			doPlayerAddItem(cid, items[i].id, items[i].count)
			----------------------------------------------------
			npcHandler.topic[cid] = 0
			end
		end
	end
	------------------------ FINISH MISSION 03 ------------------------
	elseif(msgcontains(msg, "yes")) then
		if(npcHandler.topic[cid] == 1) then
			npcHandler:say("Good, because that is exactly what you will help us with - getting more 'lucky charms'. If we won't get our hands on new charms in time, we will surely have to starve... during the autumn. That would be a hard time for all of us. So... you in?", cid)
			npcHandler.topic[cid] = 2
		elseif(npcHandler.topic[cid] == 2) then
			selfSay("Fine, now hurry into the woods and find some rabbits. Find them and kill them that is. Use a sharp, thin knife to get the rabbit foot and be careful not to destroy it - no one would buy it in a bad condition after all. ...", cid)
			selfSay("Once you gathered some rabbit feet, put one of our - handcrafted by the guys - ribbons on each of them. That will make two lucky charms per rabbit. ...", cid)
			selfSay("We will need at least seven. And seven is a lucky number, don't you think? Heh. ...", cid)
			npcHandler:say("If you need some more ribbons just come back to me and ask.", cid)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03, 1)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Questline, 1) -- quest log
			doPlayerAddItem(cid, 13158, 7)
			npcHandler.topic[cid] = 0
		elseif(npcHandler.topic[cid] == 3) and getPlayerItemCount(cid, 13160) >= 7 then
			npcHandler:say("Good hunt. That will be enough to help us uhm... get through the winter yes. Now if you want to help us getting even more lucky charms, you can always ask.", cid)
			doPlayerRemoveItem(cid, 13160, 7)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03, 2)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Questline, 4) -- quest log
			npcHandler.topic[cid] = 0

			elseif(npcHandler.topic[cid] == 3) and getPlayerItemCount(cid, 13160) <= 6 then
			npcHandler:say("You do not have sufficient rabbit's foot.", cid)

		------------------------ FINISH MISSION 01 ------------------------
		elseif(npcHandler.topic[cid] == 4) then
			npcHandler:say("Good, good. Do you remember the old saying? If it ain't broken, it was not made by us. Now, off you go!", cid)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03, 3)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Questline, 3) -- quest log
			npcHandler.topic[cid] = 0
		elseif(npcHandler.topic[cid] == 5) then
			selfSay("Mmmmh, I have to say - good workmanship. No doubt. Yes, the person who made that tool you used to fix all this was a pure professional. Something I can't say about your work, though. ...", cid)
			npcHandler:say("The walls look as if they will come off in a matter of hours. Oh well, you can always come back and repair this mess, ask me for a task if you want to. Yeah, yeah and here's your reward for today.", cid)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03, 4)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Questline, 6) -- quest log
			doPlayerAddItem(cid, 2152, 5)
			npcHandler.topic[cid] = 0
		------------------------ FINISH MISSION 02 ------------------------
		elseif(npcHandler.topic[cid] == 6) then
			selfSay("Right, now before the merchants enter the woods, you will install several traps - nothing too dangerous, just nets and ropes. ...", cid)
			selfSay("When they enter said area which is located close to our hidden camp, they will be trapped and you can... lighten their heavy burden of valuable goods. ...", cid)
			selfSay("There is but a tiny little catch - we cannot help you laying these traps. You know, some of the guys became sick recently, we talk about several broken legs here, one almost lost his arm ...", cid)
			npcHandler:say("So... it's entirely up to you, will you do this or not?", cid)
			npcHandler.topic[cid] = 7
		elseif(npcHandler.topic[cid] == 7) then
			selfSay("Alright very good. Now the only thing you need to do is taking these traps and moving out to the area I have marked on your map where you need to place them. ...", cid)
			selfSay("Once you did that go to the large high seat near the camp and watch for the travelling merchants. ...", cid)
			selfSay("Once all of them are trapped in the nets, you can go down and gather anything of value you can find. But only take what we... you really need - around 100 gold should be enough for any man to take. ...", cid)
			selfSay("We have manners after all, haven't we. ...", cid)
			selfSay("My men will take their share of course and... help you relieve the merchants of any valuables. ...", cid)
			selfSay("You're done if you get at least... let's say 5 of these fools. Return to me and you will be rewarded. ...", cid)
			npcHandler:say("Off you go and - good hunt, heh.", cid)
			doPlayerAddItem(cid, 13173, 5)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Mission03, 5)
			setPlayerStorageValue(cid, Storage.RottinWoodAndMaried.Questline, 5) -- quest log
			npcHandler.topic[cid] = 0
		------------------------ FINISH MISSION 03 ------------------------
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
