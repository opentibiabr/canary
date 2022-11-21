local internalNpcName = "Gurbasch"
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
	{text = 'Passages to Kazordoon! Gotta try the beer there.'}
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

addTravelKeyword('farmine',{'Do you seek a ride to Farmine for |TRAVELCOST|?', 'Hold on!', 'You shouldn\'t miss the experience.'}, 110, {'postman', 'new frontier'},
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

addTravelKeyword('kazordoon', {'Do you want to go to Kazordoon to try the beer there? |TRAVELCOST|?', 'Set the sails!', 'Then not.'}, 160, 'postman', Position(32660, 31957, 15))
addTravelKeyword('gnomprona', {'Would you like to travel to Gnomprona for |TRAVELCOST|?', 'Full steam ahead!', 'Then not.'}, 200, 'postman', Position(33516, 32856, 14))
keywordHandler:addKeyword({'passage'}, StdModule.say, {npcHandler = npcHandler, text = 'Where do you want me to take you? To {Kazordoon}, {Farmine} or {Gnomprona}?'})

npcHandler:setMessage(MESSAGE_GREET, 'Welcome, |PLAYERNAME|! Lovely steamboat, ain\'t it? I can even offer you a {passage} if you like.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Until next time.')
npcHandler:setMessage(MESSAGE_WALKAWAY, 'Until next time.')

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
