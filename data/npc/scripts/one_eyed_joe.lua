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
	{ text = 'Did you hear that, too?' }
}
npcHandler:addModule(VoiceModule:new(voices))
function creatureSayCallback(cid, type, msg)
local player = Player(cid)
	if not npcHandler:isFocused(cid) then
		if msg == "hi" or msg == "hello" then
			if (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) == 3) then
				if (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline) == 3)then
					player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline, 4)
				end
				player:addAchievement("Wail of the Banshee")
				player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe, 4)
				doPlayerAddItem(cid,18413,1)
				doPlayerAddItem(cid,18414,1)
				doPlayerAddItem(cid,18415,1)
				math.randomseed(os.time())
				chanceToPirate = math.random(1,4)
				if chanceToPirate == 1 then
					doPlayerAddItem(cid,5926,1)
				elseif chanceToPirate == 2 then
					doPlayerAddItem(cid,6098,1)
				elseif chanceToPirate == 3 then
					doPlayerAddItem(cid,6097,1)
				elseif chanceToPirate == 4 then
					doPlayerAddItem(cid,6126,1)
				end
				npcHandler:say("Well done! Take this reward for your efforts. But know this: The cursed crystal seems to regenerate over time. It could be necessary to come back and repeat whatever you have done down there.", cid)
			elseif (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) >= 0) and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 3) then
				npcHandler:say("Ah, the brave adventurer who sought to destroy the evil crystal down there. Have you been succesful?", cid)			
			else
				npcHandler:say("Hello there. I'm sorry, I hardly noticed you. I'm a bit nervous. The spooky {sounds} down there, you know.", cid)	
			end
			npcHandler:addFocus(cid)
		else
			return false
		end
	end
	if msgcontains(msg, "mission") and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 0) and npcHandler.topic[cid] < 1 then
		npcHandler.topic[cid] = 1 
		npcHandler:say({
"As for myself I haven't been down there. But I heard some disturbing rumours. In these caves are wonderful crystal formations. Some more poetically inclined fellows call them the crystal gardens. ...",
"At first glance it seems to be a beautiful - and precious - surrounding. But in truth, deep down in these caverns exists an old evil. Want to hear more?"
		}, cid)
	elseif msgcontains(msg, "yes") and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) > 0) and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 3) then
		npcHandler:say({"Hmm. No, i don't think so. I still feel this strange prickling in my toes."}, cid)
	elseif msgcontains(msg, "no") and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) > 0) and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 3) then
		npcHandler:say({"Too bad."}, cid)
	elseif msgcontains(msg, "protect ears") then
		npcHandler:say({"Protect your ears? Hmm ... Wasn't there some fabulous seafarer who used wax or something to plug his ears? There was a story about horrible bird-women or something ...? No, sounds like hogwash, doesn't it."}, cid)
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 1 then
		npcHandler.topic[cid] = 2
		npcHandler:say({
"The evil I mentioned is a strange crystal, imbued with some kind of unholy energy. It is very hard to destroy, no weapon is able to shatter the thing. Maybe a jarring, very loud sound could destroy it. ...",
"I heard of creatures, that are able to utter ear-splitting sounds. Don't remember the name, though. Would you go down there and try to destroy the crystal?"
		}, cid)
	elseif msgcontains(msg, "yes") and npcHandler.topic[cid] == 2 then
		npcHandler.topic[cid] = 3
		player:setStorageValue(Storage.TibiaTales.DefaultStart, 1)
		if (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline) < 0)then
			player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Questline, 0)
		end
		player:setStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe, 0)
		npcHandler:say({"Great! Good luck and be careful down there!"}, cid)
	elseif msgcontains(msg, "crystals") then
		npcHandler:say({
"In my humble opinion a pirate should win a fortune by boarding ships not by crawling through caves and tunnels. But who am I to bring into question the captain's decision. All I know is that they sell the crystals at a high price. ...",
"A certain amount of the crystals is ground to crystal dust with a special kind of mill. Don't ask me why. Some kind of magical component perhaps that they sell to mages and sorcerers."
		}, cid)
	elseif msgcontains(msg, "cursed") and (player:getStorageValue(Storage.TibiaTales.TheCursedCrystal.Oneeyedjoe) < 0) and npcHandler.topic[cid] < 1 then
		npcHandler.topic[cid] = 1 
		npcHandler:say({
"As for myself I haven't been down there. But I heard some disturbing rumours. In these caves are wonderful crystal formations. Some more poetically inclined fellows call them the crystal gardens. ...",
"At first glance it seems to be a beautiful - and precious - surrounding. But in truth, deep down in these caverns exists an old evil. Want to hear more?"
		}, cid)
	elseif msgcontains(msg, "sounds") then
		npcHandler:say({
"These caves are incredibly beautiful, {crystals} in vibrant colours grow there like exotic flowers. There are more than a few captains who send down their men in order to quarry the precious crystals. ...",
"But there are few volunteers. Often the crystal gatherers disappear and are never seen again. Other poor fellows then meet their former shipmates in the form of ghosts or skeletons. It's a {cursed} area, something evil is down there!"
		}, cid)
	elseif msgcontains(msg, "job") then
		npcHandler:say({"I'm a pirate. Normally I'm sailing the seas, boarding other ships and gathering treasures. But at the moment my captain graciously assigned me to watch this {cursed} entrance."}, cid)
	elseif msgcontains(msg, "name") then
		npcHandler:say({"I'm One-Eyed Joe. From Josephina, got that? And I regard this eye patch as a personal feature of beauty!"}, cid)
	elseif msgcontains(msg, "bye") then
		npcHandler:say("Good bye adventurer. It was nice to talk with you.", cid)	
		npcHandler:releaseFocus(cid) 
	end
     return
end
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
