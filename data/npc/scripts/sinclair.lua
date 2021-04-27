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
	{ text = 'Indeed, there has to be some other way.' },
	{ text = 'Mmh, interesting.' },
	{ text = 'Yes indeed, all of the equipment should be checked and calibrated regularly.' },
	{ text = 'No, we have to give this another go.' }
}

local function releasePlayer(cid)
	if not Player(cid) then
		return
	end

	npcHandler:releaseFocus(cid)
	npcHandler:resetNpc(cid)
end

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	end
	local player = Player(cid)

	if msgcontains(msg, 'mission') then
		local qStorage = player:getStorageValue(Storage.SpiritHunters.Mission01)
		if qStorage == 3 then
			npcHandler:say("So, did you find anything worth examining? Did you actually catch a ghost?",cid)
			npcHandler.topic[cid] = 3
		elseif qStorage == 2 then
			npcHandler:say({"So you have passed Spectulus' acceptance test. Well, I'm sure you will live up to that. ...",
							"We are trying to get this business up and running and need any help we can get. Did he tell you about the spirit cage?"
							}, cid)
			npcHandler.topic[cid] = 1
		elseif qStorage > 2 then
			npcHandler:say("You already done this quest.",cid)
			npcHandler.topic[cid] = 0
		elseif qStorage < 2 then
			npcHandler:say("Talk research with spectulus to take some mission.",cid)
			npcHandler.topic[cid] = 0
		end
	elseif msgcontains(msg, 'yes') then
		if npcHandler.topic[cid] == 1 then
			npcHandler:say({"Excellent. Now we need to concentrate on testing that thing. The spirit cage has been calibrated based on some tests we made - as well as your recent findings over at the graveyard. ...",
						"Using the device on the remains of a ghost right after its defeat should capture it inside this trap. We could then transfer it into our spirit chamber which is in fact a magical barrier. ..",
						"At first, however, we need you to find a specimen and bring it here for us to test the capacity of the device. Are you ready for this?"
						}, cid)
			npcHandler.topic[cid] = 2
		elseif npcHandler.topic[cid] == 2 then
			npcHandler:say("Good, now all you need to do is find a ghost, defeat it and catch its very essence with the cage. Once you have it, return to me and Spectulus and I will move it into our chamber device. Good luck, return to me as soon as you are prepared.", cid)
			player:setStorageValue(Storage.SpiritHunters.Mission01, 3)
			player:addItem(12671, 1)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 3 then
			if player:getStorageValue(Storage.SpiritHunters.CharmUse) == 1 then
				npcHandler:say({"Fascinating, let me see. ...",
								"Amazing! I will transfer this to our spirit chamber right about - now! ...",
								"Alright, the device is holding it. The magical barrier should be able to contain nearly 20 times the current load. That's a complete success! Spectulus, are you seeing this? We did it! ...",
								"Well, you did! You really helped us pulling this off. Thank you Lord Stalks! ...",
								"I doubt we will have much time to hunt for new specimens ourselves in the near future. If you like, you can continue helping us by finding and capturing more and different ghosts. Just talk to me to receive a new task."
								}, cid)
				player:setStorageValue(Storage.SpiritHunters.Mission01, 4)
				player:addExperience(500, true)
				addEvent(releasePlayer, 1000, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("Go and use the machine in a dead ghost!", cid)
				npcHandler.topic[cid] = 0
			end
		elseif npcHandler.topic[cid] == 4 then
			npcHandler:say({"Magnificent! Alright, we will at least need 5 caught ghosts. We will pay some more if you can catch 5 nightstalkers. Of course you will earn some more if you bring us 5 souleaters. ...",
							"I heard they dwell somewhere in that new continent - Zao? Well anyway, if you feel you've got enough, just return with what you've got and we will see. Good luck! ...",
							"Keep in mind that the specimens are only of any worth to us if the exact amount of 5 per specimen is reached. ...",
							"Furhtermore, to successfully bind Nightstalkers to the cage, you will need to have caught at least 5 Ghosts. To bind Souleaters, you will need at least 5 Ghosts and 5 Nightstalkers. ...",
							"The higher the amount of spirit energy in the cage, the higher its effective capacity. Oh and always come back and tell me if you lose your spirit cage."
							}, cid)
			player:setStorageValue(Storage.SpiritHunters.Mission01, 5)
			npcHandler.topic[cid] = 0
		elseif npcHandler.topic[cid] == 5 then
			npcHandler:say("Good, of course you will also receive an additional monetary reward for your troubles. Are you fine with that?", cid)
			npcHandler.topic[cid] = 6
		elseif npcHandler.topic[cid] == 6 then
			local nightstalkers, souleaters, ghost = player:getStorageValue(Storage.SpiritHunters.NightstalkerUse), player:getStorageValue(Storage.SpiritHunters.SouleaterUse), player:getStorageValue(Storage.SpiritHunters.GhostUse)
			if nightstalkers >= 4 and souleaters >= 4 and ghost >= 4 then
				npcHandler:say("Alright, let us see how many ghosts you caught!", cid)
				player:setStorageValue(Storage.SpiritHunters.Mission01, 6)
				player:addExperience(8000, true)
				player:addItem(2152, 60)
				addEvent(releasePlayer, 1000, cid)
				npcHandler.topic[cid] = 0
			else
				npcHandler:say("You didnt catch the ghost pieces.", cid)
				npcHandler.topic[cid] = 0
			end
		end
	elseif msgcontains(msg, 'research') then
		local qStorage = player:getStorageValue(Storage.SpiritHunters.Mission01)
		if qStorage == 4 then
			npcHandler:say({"We are still in need of more research concerning environmental as well as psychic ecto-magical influences. Besides more common ghosts we also need some of the harder to come by nightstalkers and - if you're really hardboiled - souleaters. ...",
						"We will of course pay for every ghost you catch. You will receive more if you hunt for some of the tougher fellows - but don't overdue it. What do you say?"
						}, cid)
			npcHandler.topic[cid] = 4
		elseif qStorage == 5 then
			npcHandler:say(" Alright you found something! Are you really finished hunting out there?", cid)
			npcHandler.topic[cid] = 5
		end
	end

	return true
end

npcHandler:addModule(VoiceModule:new(voices))

npcHandler:setMessage(MESSAGE_GREET, "Greetings |PLAYERNAME|. I have - very - little time, please make it as short as possible. I may be able to help you if you are here to help us with any of our tasks or missions.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Goodbye and good luck |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Goodbye and good luck |PLAYERNAME|.")

npcHandler:addModule(FocusModule:new())

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
