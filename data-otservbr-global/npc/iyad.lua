local internalNpcName = "Iyad"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 75,
	lookBody = 94,
	lookLegs = 106,
	lookFeet = 76,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'A... aargh. I wish I had some e... earmuffs to put over this useless t... turban.' },
	{ text = 'Oh p.. please. P... lease let me fly us out of this c... cold.' }
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

-- Travel
local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function addTravelKeyword(keyword, text, cost, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Never heard about a place like this.'}, condition)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = 'Do you seek a ride to ' .. text .. ' for |TRAVELCOST|?', cost = cost, discount = 'postman'})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = 'Hold on!', cost = cost, discount = 'postman', destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = 'You shouldn\'t miss the experience.', reset = true})
end

addTravelKeyword('farmine', 'Do you seek a ride to Farmine for |TRAVELCOST|?', 60, Position(32983, 31539, 1), function(player) return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2 end)
addTravelKeyword('zao', 'Do you seek a ride to Farmine for |TRAVELCOST|?', 60, Position(32983, 31539, 1), function(player) return player:getStorageValue(TheNewFrontier.Mission10[1]) ~= 2 end)
addTravelKeyword('darashia', 'Darashia on Darama', 60, Position(33270, 32441, 6))
addTravelKeyword('darama', 'Darashia on Darama', 60, Position(33270, 32441, 6))
addTravelKeyword('kazordoon', 'Kazordoon', 70, Position(32588, 31941, 0))
addTravelKeyword('kazor', 'Kazordoon', 70, Position(32588, 31941, 0))
addTravelKeyword('femor hills', 'the Femor Hills', 60, Position(32536, 31837, 4))
addTravelKeyword('hills', 'the Femor Hills', 60, Position(32536, 31837, 4))
addTravelKeyword('edron', 'Edron', 60, Position(33193, 31784, 3))
addTravelKeyword('issavi', 'Issavi', 100, Position(33957, 31515, 0))
addTravelKeyword('marapur', 'Marapur', 70, Position(33805, 32767, 2))

-- Basic
keywordHandler:addKeyword({'job'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m a licensed c...carpet pilot. I can {transport} you t...to a warm p...place.'})
keywordHandler:addKeyword({'fly'}, StdModule.say, {npcHandler = npcHandler, text = 'I t...{transport} travellers to the continent of Darama for a small fee. It\'s w...warm there.'})
keywordHandler:addKeyword({'transport'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Edron}, to {Kazordoon}, to Z... Zao, to the F...{Femor Hills}, to {Issavi} or to M... {Marapur} if you like. W....Where do you want to go?'})
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Edron}, to {Kazordoon}, to Z... Zao, to the F...{Femor Hills}, to {Issavi} or to M... {Marapur} if you like. W....Where do you want to go?'})
keywordHandler:addKeyword({'ride'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Edron}, to {Kazordoon}, to Z... Zao, to the F...{Femor Hills}, to {Issavi} or to M... {Marapur} if you like. W....Where do you want to go?'})
keywordHandler:addKeyword({'name'}, StdModule.say, {npcHandler = npcHandler, text = 'I\'m k...known as Iyad Ibn Abdul.'})
keywordHandler:addKeyword({'ferumbras'}, StdModule.say, {npcHandler = npcHandler, text = 'The thought of s...some mad sorcerer unleashing some f...fire magic is very tempting.'})
keywordHandler:addKeyword({'carlin'}, StdModule.say, {npcHandler = npcHandler, text = 'S...so close and s...still that far away.'})
keywordHandler:addKeyword({'thais'}, StdModule.say, {npcHandler = npcHandler, text = 'For all its m...mistakes, Thais is warm at least.'})
keywordHandler:addKeyword({'go'}, StdModule.say, {npcHandler = npcHandler, text = 'I can fly you to {Darashia}, to {Edron}, to {Kazordoon}, to Z... Zao, to the F...{Femor Hills}, to {Issavi} or to M... {Marapur} if you like. W....Where do you want to go?'})
keywordHandler:addKeyword({'excalibug'}, StdModule.say, {npcHandler = npcHandler, text = 'I would t...trade it for some firewood.'})
keywordHandler:addKeyword({'continent'}, StdModule.say, {npcHandler = npcHandler, text = 'This h...here is no continent. This is h...hell.'})
keywordHandler:addKeyword({'drefia'}, StdModule.say, {npcHandler = npcHandler, text = 'Even D...Drefia can\'t be worse than this land.'})
keywordHandler:addKeyword({'news'}, StdModule.say, {npcHandler = npcHandler, text = 'I d...don\'t care about any n...news unless it\'s the announcement of a h....heatwave.'})
keywordHandler:addKeyword({'time'}, StdModule.say, {npcHandler = npcHandler, text = 'It\'s p...probably the ice age.'})
keywordHandler:addKeyword({'trade'}, StdModule.say, {npcHandler = npcHandler, text = 'Th...there, in case you have {earmuffs}, I pay w...well!'})
keywordHandler:addKeyword({'earmuffs'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you really have earmuffs f...for me?? If so, just ask me for a {trade}!'})

npcHandler:setMessage(MESSAGE_GREET, "Finally! A c...c...customer! Wh... where do you want to f...f...{fly}?")
npcHandler:setMessage(MESSAGE_FAREWELL, "D...Daraman's blessings... oh, how I m...miss my warm Darashia...")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Good bye!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
