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

keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "My name is Marlene."})
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I'm Bruno's wife. Besides: Have you already heard the latest news about the seamonster, Aneus, or the rumours in this area?"})
keywordHandler:addKeyword({'bruno'}, StdModule.say, {npcHandler = npcHandler, text = "Bruno is a wonderful husband. But he is seldom at home. *looks a little bit sad*"})
keywordHandler:addKeyword({'graubart'}, StdModule.say, {npcHandler = npcHandler, text = "Ah, old Graubart. A very nice person. But he is strange. He always is busy when I want to talk to him. *lost in thoughts*"})
keywordHandler:addKeyword({'thank you'}, StdModule.say, {npcHandler = npcHandler, text = "My pleasure, I always enjoy sharing interesting stories."})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "seamonster") then
		npcHandler:say({
			'Only some days ago I was at the docks late in the night and was looking for my husband\'s ship when suddenly a known noise appeared near the docks. ...',
			'I know this noise very well because it is the noise of a ship sailing very fast. I searched the horizon in hope to see my husbands ship. ...',
			'But instead of a ship I saw a huge shape far away. It was like a big snake swimming in the sea. ...',
			'I couldn\'t see it clearly because of the fog but I think I saw two lava-red eyes glowing in the nightly fog. ...',
			'I ran into the house and hoped that my husband would arrive safely from fishing. And after one hour he finally arrived. ...',
			'I told him about what I saw but he didn\'t believe me because he never saw anything like that in all the years before. But you believe me right? Go and convince yourself. ...',
			'Just go to the docks at exactly midnight and be very quiet. Look at the horizon and maybe you will hear and see it, too!'
		}, cid)
	elseif msgcontains(msg, "aneus") then
		npcHandler:say({
			'A very nice person. He has a great story to tell with big fights and much magic. Just ask him for his story. ...',
			'I heard that he came from far, far away. He must have seen soooo many countries, cities, different races. ...',
			'He must have collected so much wisdom. *sigh* I wish I could also travel around the world. ...',
			'I would try to visit as many cities and meet as many beings as possible. Who knows what strange races I will meet? ...',
			'Maybe I can also find a lovely new dress for me. I have been looking for one for months now but never found a good one. Maybe... *keeps on babbling*'
		}, cid)
	elseif msgcontains(msg, "rumours") then
		npcHandler:say({
			'Well, I heard about evil beings living in a dungeon below us. So once I tried to find them and went down the hole far to the southwest. ...',
			'I\'m pretty curious, you know. *smiles* So I took the coat of invisibility from my husband and went down there. At first I only found some spiders, snakes, and wolves. ...',
			'But after some time I found a ladder to a deeper level of the dungeon but I didn\'t dare to go down there because I heard many voices. ...',
			'The voices were very strange and I ran back to my house because they were very loud and very angry. I hope they will never get the idea to attack the surface beings. ...',
			'I heard they are almighty and have incredible powers! I already packed our stuff for an emergency escape. You never know. Maybe they plan to conquer the whole world. ...',
			'I bet that they look very ugly. Most mighty monsters look very ugly. Hmm, you seem to be very strong. Maybe you can go deeper and explore the area. But be careful, please. ...',
			'I heard that they can kill humans with only one hit! And that they have magic abilities twenty times stronger than the mightiest sorcerer in our world.'
		}, cid)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:setMessage(MESSAGE_GREET, "Ahhh, welcome |PLAYERNAME|! Say, have you already heard the latest news about the {seamonster}, {Aneus}, or the {rumours} in this area?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and come again for another small talk! *waves*")
npcHandler:addModule(FocusModule:new())
