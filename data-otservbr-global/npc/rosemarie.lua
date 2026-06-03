local internalNpcName = "Rosemarie"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}
npcConfig.name = internalNpcName
npcConfig.description = internalNpcName
npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2
npcConfig.outfit = {
	lookType = 137,
	lookHead = 63,
	lookBody = 119,
	lookLegs = 102,
	lookFeet = 82,
	lookAddons = 3,
}
npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Flowers are one of the most beautiful gifts that Crunor blessed us with." },
	{ text = "Celebrate life and nature!" },
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

npcHandler:setMessage(MESSAGE_GREET, "Greetings and nature's blessing, traveller!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell |PLAYERNAME|.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Farewell.")

keywordHandler:addKeyword({ "blessing", "job", "offer" }, StdModule.say, { npcHandler = npcHandler, text = "I'm here to celebrate life. I will stay with you mortals for a while. I exchange {seeds}, which you might have found on your adventures, for flowerpots with rare seedlings." })
keywordHandler:addKeyword({ "plant" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"You will have to water it regularly, then it will flourish and grow. There are several stages of growth that your plant has to pass ...",
		"With good care and luck, it will grow into the next stage until it finally becomes a fully blooming flower. ...",
		"Of course plants won't grow in the darkness of a depot box. On the other hand, it won't dry out there either ...",
		"So if you know you can't take care of your plant for a longer time, it might be a good idea to store it into your depot box.",
	},
})
keywordHandler:addKeyword({ "flower" }, StdModule.say, { npcHandler = npcHandler, text = "Flowers are one of the most beautiful gifts that {Crunor} blessed us with. They are very delicate creatures and must be treated with utmost care." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "I'm Rosemarie the {dryad}, and just like my name is linked to flowers, my whole existence is connected to the life of plants." })
keywordHandler:addKeyword({ "dryad" }, StdModule.say, { npcHandler = npcHandler, text = "Dryads are the daughters of {Crunor} and the protectors of {plant} life. Sadly, most of my sisters are quite aggressive on their mission." })
keywordHandler:addKeyword({ "crunor" }, StdModule.say, { npcHandler = npcHandler, text = "The bringer of life and fertility is worshipped by all dryads." })
keywordHandler:addKeyword({ "mission" }, StdModule.say, { npcHandler = npcHandler, text = { "Many dryads consider almost everything that is no {plant} as a threat to plants and the forests ...", "Humans that lumber our forests to build their wooden caves and the strange things they use to cross the seas are especially threatening." } })
keywordHandler:addKeyword({ "port hope", "jungle" }, StdModule.say, { npcHandler = npcHandler, text = "I love to stroll around in the jungle. The diversity of plants is fantastic there and even the poisonous spit nettle remains calm if it feels the unconditional love for all plants in your heart." })
keywordHandler:addKeyword({ "thais", "venore", "edron", "liberty bay" }, StdModule.say, { npcHandler = npcHandler, text = "I prefer to stay outside of towns to enjoy the nature around me." })
keywordHandler:addKeyword({ "darashia", "ankrahmun" }, StdModule.say, { npcHandler = npcHandler, text = "It has its charm but the more plants I have around me the better I feel." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "I prefer to stay outside of towns but this spot here is tolerable." })
keywordHandler:addKeyword({ "ab'dendriel", "elves", "elf" }, StdModule.say, { npcHandler = npcHandler, text = "The elves found the perfect balance between living from the plants and living with the plants. They should be role models for every living being." })
keywordHandler:addKeyword({ "dwarves", "dwarf" }, StdModule.say, { npcHandler = npcHandler, text = "I accept every way of life but this of the dwarfs is not mine. Without sunlight, I would shrivel within days like a plant." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "For me, the trees in the {jungle} of Tiquanda are the kings. Oh, you mean the Tibian king? I'm not interested in human bureaucracy." })
keywordHandler:addKeyword({ "queen" }, StdModule.say, { npcHandler = npcHandler, text = "The griffinclaw is the queen among the plants." })
keywordHandler:addKeyword({ "how are you" }, StdModule.say, { npcHandler = npcHandler, text = "Well, how do I look? Beautiful isn't?" })
keywordHandler:addKeyword({ "plant" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"You will have to water it regularly, then it will flourish and grow. There are several stages of growth that your plant has to pass ...",
		"With good care and luck, it will grow into the next stage until it finally becomes a fully blooming {flower}. ...",
		"Of course plants won't grow in the darkness of a depot box. On the other hand, it won't dry out there either ...",
		"So if you know you can't take care of your plant for a longer time, it might be a good idea to store it into your depot box.",
	},
})

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "seed") then
		npcHandler:say({
			"Each seed is like a baby to us dryads. For every 5 seeds you bring me, I'll reward you with a flowerpot that contains a seedling that might flourish into a rare and beautiful plant if you care for it. ...",
			"Do you have any seeds that you would like to exchange?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "yes") and npcHandler:getTopic(playerId) == 1 then
		if player:getItemCount(647) >= 5 then
			player:removeItem(647, 5)
			player:addItem(306, 1)
			npcHandler:say("Here, I planted this little baby in a flowerpot for you. Don't forget to water it regularly - buy a watering can somewhere!", npc, creature)
		else
			npcHandler:say("You don't have enough seeds.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) == 1 then
		npcHandler:say("Perhaps you are interested when you have more seeds.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
