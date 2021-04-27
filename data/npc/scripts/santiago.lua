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
	{ text = 'Evil little beasts... I hope someone helps me fight them.' },
	{ text = 'Nasty creepy crawlies!' },
	{ text = 'Hey! You over there, could you help me with a little quest? Just say \'hi\' or \'hello\' to talk to me!' },
	{ text = 'Don\'t be shy, can\'t hurt to greet me with \'hello\' or \'hi\'!' }
}
npcHandler:addModule(VoiceModule:new(voices))

local storeTalkCid = {}
local function greetCallback(cid)
	local player = Player(cid)
	if player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) < 1 then
		player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 1)
		player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 1)
		npcHandler:setMessage(MESSAGE_GREET, "Hello |PLAYERNAME|, nice to see you on Rookgaard! I saw you walking by and wondered if you could help me. Could you? Please, say {yes}!")
		storeTalkCid[cid] = 0
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 1 then
		npcHandler:setMessage(MESSAGE_GREET, "Oh, |PLAYERNAME|, it's you again! It's probably impolite to disturb a busy adventurer like you, but I really need help. Please, say {yes}!")
		storeTalkCid[cid] = 0
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 2 then
		npcHandler:say("Oh, what's wrong? As I said, simply go to my house south of here and go upstairs. Then come back and we'll continue our chat.", cid)
		Position(32033, 32277, 6):sendMagicEffect(CONST_ME_TUTORIALARROW)
		return false
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 3 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back, |PLAYERNAME|! Ahh, you found my chest. Let me take a look at you. You put on that coat, {yes}?")
		storeTalkCid[cid] = 2
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 4 then
		npcHandler:setMessage(MESSAGE_GREET, "Hey, I want to give you a weapon for free! You should not refuse that, in fact you should say '{yes}'!")
		storeTalkCid[cid] = 2
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 5 then
		npcHandler:say("I've forgotten to tell you something. Of course I need proof that you killed cockroaches. Please bring me at least 3 of their legs. Good luck!", cid)
		return false
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 6 then
		if player:removeItem(8710, 3) then
			npcHandler:setMessage(MESSAGE_GREET, "Good job! For that, I'll grant you 100 experience points! Oh - what was that? I think you advanced a level, {right}?")
			player:addExperience(100, true)
			player:getPosition():sendMagicEffect(CONST_ME_GIFT_WRAPS)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 5)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 7)
			storeTalkCid[cid] = 4
		else
			npcHandler:say("I've forgotten to tell you something. Of course I need proof that you killed cockroaches. Please bring me at least 3 of their legs. Good luck!", cid)
			return false
		end
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 7 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! Where were we... ? Ah, right, I asked you if you saw your 'level up'! You did, {right}?")
		storeTalkCid[cid] = 4
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 8 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! Where were we... ? Ah, right, I asked you if those nasty cockroaches {hurt} you! Did they?")
		storeTalkCid[cid] = 5
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 9 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! Where were we... ? Ah, right, I asked you if I should demonstrate some damage on you. Let's do it, {okay}?")
		storeTalkCid[cid] = 6
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 10 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! Where were we... ? Ah, right, I was about to show you how you regain health, right?")
		storeTalkCid[cid] = 7
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 11 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! Where were we... ? Ah, right, I gave you a fish to eat?")
		storeTalkCid[cid] = 8
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 12 then
		npcHandler:setMessage(MESSAGE_GREET, "Welcome back! Where were we... ? Ah, right, I asked you if you saw Zirella! Did you?")
		storeTalkCid[cid] = 9
	elseif player:getStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage) == 13 then
		npcHandler:setMessage(MESSAGE_GREET, "Hello again, |PLAYERNAME|! It's great to see you. If you like, we can chat a little. Just use the highlighted {keywords} again to choose a {topic}.")
	end
	return true
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end

	local player = Player(cid)
	if isInArray({"yes", "right", "ok"}, msg) then
		if storeTalkCid[cid] == 0 then
			npcHandler:say("Great, please go to my house, just a few steps south of here. Upstairs in my room, you'll find a chest. You can keep what you find inside of it! Come back after you got it and greet me to talk to me again. {Yes}?", cid)
			Position(32033, 32277, 6):sendMagicEffect(CONST_ME_TUTORIALARROW)
			storeTalkCid[cid] = 1
		elseif storeTalkCid[cid] == 1 then
			npcHandler:say("Alright! Do you see the button called 'Quest Log'? There you can check the status of quests, like this one. {Bye} for now!", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 2)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 2)
			player:sendTutorial(3)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif storeTalkCid[cid] == 2 then
			if player:getItemCount(2651) > 0 then
				local coatSlot = player:getSlotItem(CONST_SLOT_ARMOR)
				if coatSlot then
					npcHandler:say("Ah, no need to say anything, I can see it suits you perfectly. Now we're getting to the fun part, let's get you armed! Are you ready for some {action}?", cid)
					player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 4)
					storeTalkCid[cid] = 3
				else
					npcHandler:say("Oh, you don't wear it properly yet. You need to drag and drop it from your bag to your armor slot. Here, let me show you again. Is it a little {clearer} now?", cid)
					player:sendTutorial(5)
					storeTalkCid[cid] = 2
				end
			else
				player:addItem(2651, 1)
				npcHandler:say("Oh no, did you lose my coat? Well, lucky you, I have a spare one here. Don't lose it again! Now we're getting to the fun part, let's get you armed! Are you ready for some {action}?", cid)
				storeTalkCid[cid] = 3
			end
		elseif storeTalkCid[cid] == 3 then
			npcHandler:say("I knew I could count on you. Here, take this good and sturdy weapon in your hand. Then go back to my house and down the ladder. Good luck, and {bye} for now!", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 5)
			Position(32036, 32277, 6):sendMagicEffect(CONST_ME_TUTORIALARROW)
			player:addItem(2382, 1)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		elseif storeTalkCid[cid] == 4 then
			npcHandler:say("That's just great! Now you have more health points, can carry more stuff and walk faster. Talking about health, did you get {hurt} by those cockroaches?", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 8)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 6)
			storeTalkCid[cid] = 5
		elseif storeTalkCid[cid] == 5 then
			npcHandler:say("Really? You look fine to me, must have been just a scratch. Well, there are much more dangerous monsters than cockroaches out there. Take a look at your status bar. You have 155 Health right now. I'll show you something, {yes}?", cid)
			player:sendTutorial(19)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 9)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 7)
			storeTalkCid[cid] = 6
		elseif storeTalkCid[cid] == 6 then
			npcHandler:say("This is an important lesson from me - an experienced veteran fighter. Take this! Look at your status bar again. As you can see, you've lost health. Now I'll tell you how to heal that, {yes}?", cid)
			player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			Npc():getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			player:addHealth(-20, COMBAT_PHYSICALDAMAGE)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 10)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 8)
			player:sendTutorial(19)
			storeTalkCid[cid] = 7
		elseif storeTalkCid[cid] == 7 then
			npcHandler:say({
				"Here, take this fish which I've caught myself. Find it in your inventory, then 'Use' it to eat it. This will slowly refill your health. ...",
				"By the way: If your hitpoints are below 150, you will regenerate back to 150 hitpoints after few seconds as long as you are not hungry, outside a protection zone and do not have a battle sign. {Easy}, yes?"
			}, cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 9)
			player:addItem(2667, 1)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 11)
			storeTalkCid[cid] = 8
		elseif storeTalkCid[cid] == 8 then
			npcHandler:say("I knew you'd get it right away. You can loot food from many creatures, such as deer and rabbits. You can find them in the forest nearby. By the way... have you seen {Zirella}?", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 12)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 10)
			storeTalkCid[cid] = 9
		elseif storeTalkCid[cid] == 9 then
			npcHandler:say("Really?? She was looking for someone to help her. Maybe you could go and see her. She lives just to the east and down the mountain. So, thank you again and {bye} for now!", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 13)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 11)
			player:addMapMark(Position(32045, 32270, 6), MAPMARK_GREENSOUTH, "To Zirella")
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "hurt") then
		if storeTalkCid[cid] == 6 then
			npcHandler:say("This is an important lesson from me - an experienced veteran fighter. Take this! Look at your status bar again. As you can see, you've lost health. Now I'll tell you how to heal that, {yes}?", cid)
			player:getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			Npc():getPosition():sendMagicEffect(CONST_ME_MORTAREA)
			player:addHealth(-20, COMBAT_PHYSICALDAMAGE)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 8)
			player:sendTutorial(19)
			storeTalkCid[cid] = 7
		end
	elseif msgcontains(msg, "action") then
		if storeTalkCid[cid] == 3 then
			npcHandler:say("I knew I could count on you. Here, take this good and sturdy weapon in your hand. Then go back to my house and down the ladder. Good luck, and {bye} for now!", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 4)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 5)
			Position(32036, 32277, 6):sendMagicEffect(CONST_ME_TUTORIALARROW)
			player:addItem(2382, 1)
			npcHandler:releaseFocus(cid)
			npcHandler:resetNpc(cid)
		end
	elseif msgcontains(msg, "easy") then
		if storeTalkCid[cid] == 8 then
			npcHandler:say("I knew you'd get it right away. You can loot food from many creatures, such as deer and rabbits. You can find them in the forest nearby. By the way... have you seen {Zirella}?", cid)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoNpcGreetStorage, 11)
			player:setStorageValue(Storage.RookgaardTutorialIsland.SantiagoQuestLog, 10)
			storeTalkCid[cid] = 9
		end
	end
	return true
end

local function onReleaseFocus(cid)
	storeTalkCid[cid] = nil
end

npcHandler:setCallback(CALLBACK_ONRELEASEFOCUS, onReleaseFocus)

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setMessage(MESSAGE_FAREWELL, "Take care, |PLAYERNAME|!.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye traveller, and enjoy your stay on Rookgaard.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
