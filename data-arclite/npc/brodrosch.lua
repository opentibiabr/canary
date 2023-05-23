local internalNpcName = "Brodrosch"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 66
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Passage to Cormaya! Unforgettable steamboat ride!'}
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

local TheNewFrontier = Storage.Quest.U8_54.TheNewFrontier
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'ticket') then
		if Player(creature):getStorageValue(Storage.WagonTicket) >= os.time() then
			npcHandler:say('Your weekly ticket is still valid. Would be a waste of money to purchase a second one', npc, creature)
			return true
		end

		npcHandler:say('Do you want to purchase a weekly ticket for the ore wagons? With it you can travel freely and swiftly through Kazordoon for one week. 250 gold only. Deal?', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) > 0 then
		local player = Player(creature)
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeMoneyBank(250) then
				npcHandler:say('You don\'t have enough money.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			player:setStorageValue(Storage.WagonTicket, os.time() + 7 * 24 * 60 * 60)
			npcHandler:say('Here is your stamp. It can\'t be transferred to another person and will last one week from now. You\'ll get notified upon using an ore wagon when it isn\'t valid anymore.', npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, 'no') and npcHandler:getTopic(playerId) > 0 then
		npcHandler:say('No then.', npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

-- Travel
local function addTravelKeyword(keyword, text, cost, discount, destination, condition, action)
	if condition then
		keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = {'Well, you might be just the hero they need there. To tell you the truth, some our most reliable ore mines have started to run low. ...',
		'This is why we developed new steamship technologies to be able to further explore and cartograph the great subterraneous rivers. Our brothers have established a base on a continent far, far away. ...',
		'We call that the far, far away base. But since it will hopefully become a flourishing mine one day, most of us started to call it {Farmine}. The dwarfs there could really use some help right now.'
		}
	}, condition, action)
	end

	local travelKeyword = keywordHandler:addKeyword({keyword}, StdModule.say, {npcHandler = npcHandler, text = {text[1]}, cost = cost, discount = discount})
		travelKeyword:addChildKeyword({'yes'}, StdModule.travel, {npcHandler = npcHandler, premium = false, text = text[2], cost = cost, discount = discount, destination = destination})
		travelKeyword:addChildKeyword({'no'}, StdModule.say, {npcHandler = npcHandler, text = text[3], reset = true})
end

addTravelKeyword('farmine',{'Do you seek a ride to Farmine for |TRAVELCOST|?', 'Full steam ahead!', 'We would like to serve you some time.'}, 210, {'postman', 'new frontier'},
function(player)
	local destination = Position(33025, 31553, 14)
	if player:getStorageValue(TheNewFrontier.Mission05[1]) == 2 then --if The New Frontier Quest 'Mission 05: Getting Things Busy' complete then Stage 3
		destination.z = 10
	elseif player:getStorageValue(TheNewFrontier.Mission03) >= 2 then --if The New Frontier Quest 'Mission 03: Strangers in the Night' complete then Stage 2
		destination.z = 12
	end
	return destination
end, function(player) return player:getStorageValue(TheNewFrontier.FarmineFirstTravel) < 1 end,
function(player)
	if player:getStorageValue(TheNewFrontier.FarmineFirstTravel) < 1 then
		player:setStorageValue(TheNewFrontier.FarmineFirstTravel, 1)
	end
end
)

addTravelKeyword('cormaya',{'Do you seek a ride to Cormaya for |TRAVELCOST|?', 'Full steam ahead!', 'We would like to serve you some time.'}, 160, {'postman'}, Position(33311, 31989, 15),
function(player)
	if player:getStorageValue(Storage.Postman.Mission01) == 4 then
		player:setStorageValue(Storage.Postman.Mission01, 5)
	end
end
)

addTravelKeyword('gnomprona', {'Would you like to travel to Gnomprona for |TRAVELCOST|?', 'Full steam ahead!', 'Then not.'}, 200, 'postman', Position(33516, 32856, 14))
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Do you want me take you to {Cormaya}, {Farmine} or to {Gnomprona}?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome, |PLAYERNAME|! May earth protect you on the rocky grounds. If you need a {passage}, I can help you.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Good bye then.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
