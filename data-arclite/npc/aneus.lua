local internalNpcName = "Aneus"
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
	lookHead = 38,
	lookBody = 50,
	lookLegs = 58,
	lookFeet = 116,
	lookAddons = 0
}

npcConfig.flags = {
	floorchange = false
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

keywordHandler:addKeyword({'soldiers'}, StdModule.say, {npcHandler = npcHandler, text = "It was the elite of the whole army. They were called the Red Legion (also known as the bloody legion)."})
keywordHandler:addKeyword({'orcs'}, StdModule.say, {npcHandler = npcHandler, text = "The orcs attacked the workers from time to time and so they disturbed the WORKS on the city."})
keywordHandler:addKeyword({'cruelty'}, StdModule.say, {npcHandler = npcHandler, text = "The soldiers treated the workers like slaves."})
keywordHandler:addKeyword({'island'}, StdModule.say, {npcHandler = npcHandler, text = "The General of the Red Legion became very angry about these attacks and after some months he STROKE back!"})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "story") then
		npcHandler:say({
			'Ok, sit down and listen. Back in the early days, one of the ancestors ... <press m for more>',
			'... of our king Tibianus III wanted to build the best CITY in whole of Tibia.'
		}, npc, creature)
	elseif MsgContains(message, "city") then
		npcHandler:say({
			'The works on this new city began and the king sent his best ... <m>',
			'... SOLDIERS to protect the workers from ORCS and to make them WORK HARDER.'
		}, npc, creature)
	elseif MsgContains(message, "works") then
		npcHandler:say({
			'The development of the city was fine. Also a giant castle was build ... <m>',
			'... northeast of the city. But more and more workers started to REBEL because of the bad conditions.'
		}, npc, creature)
	elseif MsgContains(message, "rebel") then
		npcHandler:say({
			'All rebels were brought to the giant castle. Guarded by the Red Legion, ... <m>',
			'... they had to work and live in even worser conditions. Also some FRIENDS of the king\'s sister were brought there.'
		}, npc, creature)
	elseif MsgContains(message, "friends") then
		npcHandler:say({
			'The king\'s sister was pretty upset about the situation there but her brother ... <m>',
			'... didn\'t want to do anything about this matter. So she made a PLAN to destroy the Red Legion for their CRUELTY forever.'
		}, npc, creature)
	elseif MsgContains(message, "plan") then
		npcHandler:say({
			'She ordered her loyal druids and hunters to disguise themselves ... <m>',
			'... as orcs from the near ISLAND and to ATTACK the Red Legion by night over and over again.'
		}, npc, creature)
	elseif MsgContains(message, "stroke") then
		npcHandler:say({
			'Most of the Red Legion went to the island by night. The orcs ... <m>',
			'... were not prepared and the Red Legion killed hundreds of orcs ... <m>',
			'... with nearly no loss. After they were satisfied they WALKED BACK to the castle.'
		}, npc, creature)
	elseif MsgContains(message, "walked back") then
		npcHandler:say({
			'It is said that the orcish shamans cursed the Red Legion. <m>',
			'Nobody knows. But one third of the soldiers died by a disease on the way back. <m>',
			'And the orcs wanted to take revenge, and after some days they stroke back! <m>',
			'The orcs and many allied cyclopses and minotaurs from all ...<m>',
			'... over Tibia came to avenge their friends, and they killed nearly all ... <m>',
			'... workers and soldiers in the castle. The HELP of the king\'s sister came too late.'
		}, npc, creature)
	elseif MsgContains(message, "help") then
		npcHandler:say({
			'She tried to rescue the workers but it was too late. The orcs ... <m>',
			'... started immediately to attack her troops, too. Her royal troops ... <m>',
			'... went back to the city. A TRICK saved the city from DESTRUCTION.'
		}, npc, creature)
	elseif MsgContains(message, "destruction") then
		npcHandler:say({
			'They used the same trick as against the Red Legion and the orcs ... <m>',
			'... started to fight their non-orcish-allies. After a bloody long fight ... <m>',
			'... the orcs went back to their cities. The city of Carlin was rescued. <m>',
			'Since then, a woman has always been ruling over Carlin and this statue ... <m>',
			'... was made to remind us of their great tactics against the orcs ... <m>',
			'... and the Red Legion. So that was the story of Carlin and these Fields of Glory. I hope you liked it. *He smiles*'
		}, npc, creature)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings adventurer |PLAYERNAME|. What leads you to me?")
npcHandler:setMessage(MESSAGE_FAREWELL, "Good bye and take care of you!")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
