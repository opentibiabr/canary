local internalNpcName = "Rottin Wood"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 129,
	lookHead = 114,
	lookBody = 118,
	lookLegs = 116,
	lookFeet = 97,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

local keywordHandler = KeywordHandler:new()
local npcHandler = NpcHandler:new(keywordHandler)


npcType.onAppear = function(npc, creature)
	npcHandler:onAppear(npc, creature)
end

npcType.onDisappear = function(npc, creature)
	npcHandler:onDisappear(npc, creature)
end

npcType.onSay = function(npc, creature, type, message)
	npcHandler:onSay(npc, creature, type, message)
end

npcType.onCloseChannel = function(npc, creature)
	npcHandler:onCloseChannel(npc, creature)
end

npcType.onThink = function(npc, interval)
	npcHandler:onThink(npc, interval)
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if(MsgContains(message, "mission") or MsgContains(message, "task")) then
		if(getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03) < 1) and getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Time) <= os.time() then
			npcHandler:say("Oh, you want some work? You can help us, alright. Did you know that the people of the city think those rabbit feet are actually lucky charms?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif(getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03) == 1) then
			npcHandler:say("Good to see you back. Now, did you bring us the lucky charms?", npc, creature)
			npcHandler:setTopic(playerId, 3)
			elseif getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Time) > os.time() then
			npcHandler:say("You need wait some hours to take other mission again or you are still on a mission.", npc, creature)

	------------------------ FINISH MISSION 01 ------------------------
		elseif(getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03) == 2) then
			npcHandler:say(
				{
					"Of course, of course, there is indeed something you can help us with. Remember that we also have some tasks for you. So, are you ready for another quest to help the men of the forest?",
					"There is a problem with one of our deer stands. Right. Well, there are two problems, our deer stands - and some of the walls of the buildings in the camp are broken. ...",
					"You know, the guys built all of that themselves. Sure, at first it didn't quite work out as we planned and in the end we had to tear down half the forest - but - it was worth it. ...",
					"Still, most of the camp is kind of... broken now. And someone with a good hammer and a steady hand needs to fix that. Or I am afraid we will have to freeze... during the cold evenings... well you know, hard times. ...",
					"So what do you say, in for this one?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 4)
		elseif(getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03) == 3) and getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.RottinStart) > 4 then
			npcHandler:say("Ah there you are. So, did you repair all the broken structures?", npc, creature)
			npcHandler:setTopic(playerId, 5)
	------------------------ FINISH MISSION 02 ------------------------
		elseif(getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03) == 4) then
			npcHandler:say(
				{
					"Oh my good friend, good to see you! Today you will help us with a very important task. Very important indeed. ...",
					"You know, a large group of merchants is travelling from Thais to Venore and they are crossing the forest to shorten their way - can you believe it? ...",
					"They will enter the forest near our camp which is where you come in - uhm I mean you do want to help us with this, right?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 6)
		elseif(getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03) == 5) and getPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Corpse) == 4 then
			npcHandler:say("You did it!! And I assume you took only what you needed? Heh. No, I know it. Because my men took the rest. Thanks for helping us, you did a very good job. In fact I have a little 'extra' for you here, thanks again.", npc, creature)
				------------------ RESET STORAGE --------------------
				setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03, - 1) -- reset storage
				setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.RottinStart, - 1) -- reset storage
				setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Trap, - 1) -- reset storage
				setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Corpse, - 1) -- reset storage
				-----------------------------------------------------
				setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Time, os.time() + 20 * 60 * 60) -- set time to start mission again
				setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Questline, 2) -- quest log
			------------------- ITEM RANDOM --------------------
			local items = {
				[0] = {id = 3035, count = 3, chance = 100},
				[1] = {id = 3053, count = 1, chance = 80},
				[2] = {id = 12260, count = 1, chance = 25},
			}
			for i = 0, #items do
			if (items[i].chance > math.random(1, 100)) then
			doPlayerAddItem(creature, items[i].id, items[i].count)
			----------------------------------------------------
			npcHandler:setTopic(playerId, 0)
			end
		end
	end
	------------------------ FINISH MISSION 03 ------------------------
	elseif(MsgContains(message, "yes")) then
		if(npcHandler:getTopic(playerId) == 1) then
			npcHandler:say("Good, because that is exactly what you will help us with - getting more 'lucky charms'. If we won't get our hands on new charms in time, we will surely have to starve... during the autumn. That would be a hard time for all of us. So... you in?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif(npcHandler:getTopic(playerId) == 2) then
			npcHandler:say(
				{
					"Fine, now hurry into the woods and find some rabbits. Find them and kill them that is. Use a sharp, thin knife to get the rabbit foot and be careful not to destroy it - no one would buy it in a bad condition after all. ...",
					"Once you gathered some rabbit feet, put one of our - handcrafted by the guys - ribbons on each of them. That will make two lucky charms per rabbit. ...",
					"We will need at least seven. And seven is a lucky number, don't you think? Heh. ...",
					"If you need some more ribbons just come back to me and ask."
				},
				npc,
				creature
			)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03, 1)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Questline, 1) -- quest log
			doPlayerAddItem(creature, 12171, 7)
			npcHandler:setTopic(playerId, 0)
		elseif(npcHandler:getTopic(playerId) == 3) and getPlayerItemCount(creature, 12173) >= 7 then
			npcHandler:say("Good hunt. That will be enough to help us uhm... get through the winter yes. Now if you want to help us getting even more lucky charms, you can always ask.", npc, creature)
			doPlayerRemoveItem(creature, 12173, 7)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03, 2)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Questline, 4) -- quest log
			npcHandler:setTopic(playerId, 0)

			elseif(npcHandler:getTopic(playerId) == 3) and getPlayerItemCount(creature, 12173) <= 6 then
			npcHandler:say("You do not have sufficient rabbit's foot.", npc, creature)

		------------------------ FINISH MISSION 01 ------------------------
		elseif(npcHandler:getTopic(playerId) == 4) then
			npcHandler:say("Good, good. Do you remember the old saying? If it ain't broken, it was not made by us. Now, off you go!", npc, creature)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03, 3)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Questline, 3) -- quest log
			npcHandler:setTopic(playerId, 0)
		elseif(npcHandler:getTopic(playerId) == 5) then
			npcHandler:say(
				{
					"Mmmmh, I have to say - good workmanship. No doubt. Yes, the person who made that tool you used to fix all this was a pure professional. Something I can't say about your work, though. ...",
					"The walls look as if they will come off in a matter of hours. Oh well, you can always come back and repair this mess, ask me for a task if you want to. Yeah, yeah and here's your reward for today."
				},
				npc,
				creature
			)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03, 4)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Questline, 6) -- quest log
			doPlayerAddItem(creature, 3035, 5)
			npcHandler:setTopic(playerId, 0)
		------------------------ FINISH MISSION 02 ------------------------
		elseif(npcHandler:getTopic(playerId) == 6) then
			npcHandler:say(
				{
					"Right, now before the merchants enter the woods, you will install several traps - nothing too dangerous, just nets and ropes. ...",
					"When they enter said area which is located close to our hidden camp, they will be trapped and you can... lighten their heavy burden of valuable goods. ...",
					"There is but a tiny little catch - we cannot help you laying these traps. You know, some of the guys became sick recently, we talk about several broken legs here, one almost lost his arm ...",
					"So... it's entirely up to you, will you do this or not?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 7)
		elseif(npcHandler:getTopic(playerId) == 7) then
			npcHandler:say(
				{
					"Alright very good. Now the only thing you need to do is taking these traps and moving out to the area I have marked on your map where you need to place them. ...",
						"Once you did that go to the large high seat near the camp and watch for the travelling merchants. ...",
						"Once all of them are trapped in the nets, you can go down and gather anything of value you can find. But only take what we... you really need - around 100 gold should be enough for any man to take. ...",
						"We have manners after all, haven't we. ...",
						"My men will take their share of course and... help you relieve the merchants of any valuables. ...",
						"You're done if you get at least... let's say 5 of these fools. Return to me and you will be rewarded. ...",
						"Off you go and - good hunt, heh."
				},
				npc,
				creature
			)
			doPlayerAddItem(creature, 12186, 5)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Mission03, 5)
			setPlayerStorageValue(creature, Storage.RottinWoodAndMaried.Questline, 5) -- quest log
			npcHandler:setTopic(playerId, 0)
		------------------------ FINISH MISSION 03 ------------------------
		end
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
