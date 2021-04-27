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

keywordHandler:addKeyword({'soldiers'}, StdModule.say, {npcHandler = npcHandler, text = "It was the elite of the whole army. They were called the Red Legion (also known as the bloody legion)."})
keywordHandler:addKeyword({'orcs'}, StdModule.say, {npcHandler = npcHandler, text = "The orcs attacked the workers from time to time and so they disturbed the WORKS on the city."})
keywordHandler:addKeyword({'cruelty'}, StdModule.say, {npcHandler = npcHandler, text = "The soldiers treated the workers like slaves."})
keywordHandler:addKeyword({'island'}, StdModule.say, {npcHandler = npcHandler, text = "The General of the Red Legion became very angry about these attacks and after some months he STROKE back!"})

local function creatureSayCallback(cid, type, msg)
	if not npcHandler:isFocused(cid) then
		return false
	elseif msgcontains(msg, "story") then
		npcHandler:say({
			'Ok, sit down and listen. Back in the early days, one of the ancestors ... <press m for more>',
			'... of our king Tibianus III wanted to build the best CITY in whole of Tibia.'
		}, cid)
	elseif msgcontains(msg, "city") then
		npcHandler:say({
			'The works on this new city began and the king sent his best ... <m>',
			'... SOLDIERS to protect the workers from ORCS and to make them WORK HARDER.'
		}, cid)
	elseif msgcontains(msg, "works") then
		npcHandler:say({
			'The development of the city was fine. Also a giant castle was build ... <m>',
			'... northeast of the city. But more and more workers started to REBEL because of the bad conditions.'
		}, cid)
	elseif msgcontains(msg, "rebel") then
		npcHandler:say({
			'All rebels were brought to the giant castle. Guarded by the Red Legion, ... <m>',
			'... they had to work and live in even worser conditions. Also some FRIENDS of the king\'s sister were brought there.'
		}, cid)
	elseif msgcontains(msg, "friends") then
		npcHandler:say({
			'The king\'s sister was pretty upset about the situation there but her brother ... <m>',
			'... didn\'t want to do anything about this matter. So she made a PLAN to destroy the Red Legion for their CRUELTY forever.'
		}, cid)
	elseif msgcontains(msg, "plan") then
		npcHandler:say({
			'She ordered her loyal druids and hunters to disguise themselves ... <m>',
			'... as orcs from the near ISLAND and to ATTACK the Red Legion by night over and over again.'
		}, cid)
	elseif msgcontains(msg, "stroke") then
		npcHandler:say({
			'Most of the Red Legion went to the island by night. The orcs ... <m>',
			'... were not prepared and the Red Legion killed hundreds of orcs ... <m>',
			'... with nearly no loss. After they were satisfied they WALKED BACK to the castle.'
		}, cid)
	elseif msgcontains(msg, "walked back") then
		npcHandler:say({
			'It is said that the orcish shamans cursed the Red Legion. <m>',
			'Nobody knows. But one third of the soldiers died by a disease on the way back. <m>',
			'And the orcs wanted to take revenge, and after some days they stroke back! <m>',
			'The orcs and many allied cyclopses and minotaurs from all ...<m>',
			'... over Tibia came to avenge their friends, and they killed nearly all ... <m>',
			'... workers and soldiers in the castle. The HELP of the king\'s sister came too late.'
		}, cid)
	elseif msgcontains(msg, "help") then
		npcHandler:say({
			'She tried to rescue the workers but it was too late. The orcs ... <m>',
			'... started immediately to attack her troops, too. Her royal troops ... <m>',
			'... went back to the city. A TRICK saved the city from DESTRUCTION.'
		}, cid)
	elseif msgcontains(msg, "destruction") then
		npcHandler:say({
			'They used the same trick as against the Red Legion and the orcs ... <m>',
			'... started to fight their non-orcish-allies. After a bloody long fight ... <m>',
			'... the orcs went back to their cities. The city of Carlin was rescued. <m>',
			'Since then, a woman has always been ruling over Carlin and this statue ... <m>',
			'... was made to remind us of their great tactics against the orcs ... <m>',
			'... and the Red Legion. So that was the story of Carlin and these Fields of Glory. I hope you liked it. *He smiles*'
		}, cid)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings adventurer |PLAYERNAME|. What leads you to me?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and take care of you!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new())
