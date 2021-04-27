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
	{ text = 'I am a MAN! Get me out you drunken fools!' },
	{ text = 'GET ME OUT OF HERE!' },
	{ text = 'Get me out! It was all part of the plan, you fools!' },
	{ text = 'If I ever get out of here, I\'ll kill you all! All of you!' },
	{ text = 'I am NOT Princess Lumelia, you fools!' },
	{ text = 'Get a locksmith and free me or you will regret it, you foolish pirates!' },
	{ text = 'I am not a princess, I am an actor!' }
}

npcHandler:addModule(VoiceModule:new(voices))

keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = "I am a great and famous actor! Not a princess, at all. I was only PRETENDING to be a princess. But try explaining that to those stupid pirates."})
keywordHandler:addKeyword({'actor'}, StdModule.say, {npcHandler = npcHandler, text = "Stage acting was a waste of my immense talent. Not only am I a born leader, my talent is more profitable when it is used for conning people."})
keywordHandler:addKeyword({'stage'}, StdModule.say, {npcHandler = npcHandler, text = "Stage acting was a waste of my immense talent. Not only am I a born leader, my talent is more profitable when it is used for conning people."})
keywordHandler:addKeyword({'kid'}, StdModule.say, {npcHandler = npcHandler, text = "He was always a fool with a heart too soft to become a feared pirate."})
keywordHandler:addKeyword({'princess'}, StdModule.say, {npcHandler = npcHandler, text = "Me playing a princess was just part of a cunning plan we had."})
keywordHandler:addKeyword({'cell'}, StdModule.say, {npcHandler = npcHandler, text = "If you find some way to release me I might even let you live as reward! So you'd better do your best or I'll kill you!"})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = "How dare you? I left to rot in this dirty cell and you have nothing better to do than chit chat?"})
keywordHandler:addKeyword({'rot'}, StdModule.say, {npcHandler = npcHandler, text = "YOU .. YOU .. You are as good as dead! I will get you! Do you hear me? I will have your head! On a platter!"})
keywordHandler:addKeyword({'pirate'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'In a just world, I would be captain of a grand ship, ...',
		'Those pirates out there would now be my minions, and we would brave the seas and become the terror of the coastal towns! ...',
		'If only our plan had worked!'
	}}
)
keywordHandler:addKeyword({'ship'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Captain Kid sold his ship to buy pointless things like those insanely expensive locks for the cell doors. ...',
		'He said the canoes would do for a while. ...',
		'I got the impression he was not overly sad to part with the ship because he was known to suffer a lot from seasickness.'
	}}
)
keywordHandler:addKeyword({'captain'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'I\'d have been a much better captain then Kid was. I played several captains on stage and I was good! ...',
		'Where Kid longed for the appreciation of his men, I would rule by fear and with an iron fist!'
	}}
)
keywordHandler:addKeyword({'plan'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'It was all captain Kid\'s idea. You see, he hated his name and planned to become known by the name captain Kidnap. ...',
		'All he needed was someone famous to kidnap. ...',
		'Given his men\'s dismal lack of talent and intelligence that would have been quite a feat. ...',
		'We knew each other from a few scams we did together in the past, so he contacted me. ...',
		'I was to impersonate the famous Princess Lumelia. You know, the one everyone was looking for. ...',
		'That would show his men and the other pirates what a great kidnapper he was. ...',
		'He promised me that I would become his second in command and lead a wonderful life of plundering, robbing and pillaging. ...',
		'So I agreed to impersonate the Princess for a while and it worked fine at first. ...',
		'He returned with me dressed as the Princess from a raid on his own and was instantaneously the hero of the day for his men. ...',
		'Things went bad when they decided to have a victory party. ...',
		'As far as I could make out from the mumblings of the pirates, Kid lost the key to my cell while relieving himself in the underground river. ...',
		'The fool decided to dive after it .. never to be seen again. ...',
		'When I found out about Kid\'s demise I tried to convince the pirates it was a hoax, but they just won\'t believe me!'
	}}
)
keywordHandler:addKeyword({'kidnap'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Ah kidnapping is so much fun. That is, if you\'re not on the receiving end. ...',
		'It\'s easy money and you have a chance to frighten and torture someone who can\'t fight back!'
	}}
)
keywordHandler:addKeyword({'scams'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'The more stupid the people are, the easier it is to con them. ...',
		'And the poorer they are the less means they have to get revenge. Har Har! ...',
		'So I make sure I ruin those I scam. Then they have other things to worry about than getting revenge on me.'
	}}
)
keywordHandler:addKeyword({'key'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'The key was lost in the underground river and has probably washed into the seven seas by now! ...',
		'If that stupid Kid hadn\'t been so obsessed with kidnapping he\'d not have sold his ship to buy the most expensive and complicated locks for his cells!'
	}}
)
keywordHandler:addKeyword({'plundering'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'As long as we stick to undefended coastal towns we can make an easy fortune. Har Har! ...',
		'As soon as I get out of here I\'ll finally become a pirate captain on my own. I don\'t need Captain Kid!'
	}}
)

npcHandler:setMessage(MESSAGE_GREET, "GET ME OUT OF HERE! NOW!")

npcHandler:addModule(FocusModule:new())
