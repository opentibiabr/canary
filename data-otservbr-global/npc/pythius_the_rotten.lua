local internalNpcName = "Pythius The Rotten"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 231,
}

npcConfig.flags = {
	floorchange = false,
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

local treasureKeyword = keywordHandler:addKeyword({ "treasure" }, StdModule.say, { npcHandler = npcHandler, text = "LIKE MY TREASURE? WANNA PICK SOMETHING OUT OF IT?" })
treasureKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "ALRIGHT. BUT FIRST OF ALL I WANT YOU TO BRING ME SOMETHING IN EXCHANGE. SURPRISE ME....AND IF I LIKE IT, YOU MAY GET WHAT YOU DESERVE.", reset = true })
treasureKeyword:addChildKeyword({ "no" }, StdModule.say, { npcHandler = npcHandler, text = "HAVE YOU SEEN THESE LEGENDARY ITEMS BACK THERE? WHO COULD REFUSE THE CHANCE OF OBTAINING ONE?!? SO WHAT IS YOUR ANSWER?" })

local offerKeyword = keywordHandler:addKeyword({ "offer" }, StdModule.say, { npcHandler = npcHandler, text = "I GRANT YOU ACCESS TO THE DUNGEON IN THE NORTH. YOU'LL FIND SOME OF MY LIVING BROTHERS THERE....BUT.....EVERY TIME YOU WANT TO ENTER YOU HAVE TO GIVE ME SOMETHING PRECIOUS. ALRIGHT?" }, function(player)
	return player:getLevel() > 99
end)
local mugKeyword = offerKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "AS YOU WISH. WHAT DO YOU HAVE TO OFFER?" })
mugKeyword:addChildKeyword({ "golden mug" }, StdModule.say, { npcHandler = npcHandler, text = "I LIKE THAT AND GRANT YOU ACCESS TO THE DUNGEON IN THE NORTH FOR THE NEXT FEW MINUTES. COME BACK ANYTIME AND BRING ME MORE TREASURES.", reset = true }, function(player)
	return player:getItemCount(2903) > 0
end, function(player)
	player:removeItem(2903, 1)
	player:setStorageValue(Storage.Quest.U8_4.TheHiddenCityOfBeregar.PythiusTheRotten, os.time() + 180)
end)
mugKeyword:addChildKeyword({ "golden mug" }, StdModule.say, { npcHandler = npcHandler, text = "THIS IS NOT WORTH BEING PART OF MY TREASURE! BRING ME SOMETHING ELSE.", reset = true })
mugKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "THIS IS NOT WORTH BEING PART OF MY TREASURE! BRING ME SOMETHING ELSE", reset = true })
offerKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "TELL ME IF YOU CHANGE YOUR MIND. MY TREASURE THIRSTS FOR GOLD.", reset = true })
keywordHandler:addKeyword({ "offer" }, StdModule.say, { npcHandler = npcHandler, text = "YOU LITTLE MAGGOT. COME BACK TO ME WHEN YOU CAN HANDLE A FIGHT AGAINST MY KIND." })

-- Basic keywords
keywordHandler:addKeyword({ "awaited" }, StdModule.say, { npcHandler = npcHandler, text = "I HAVE A MISSION FOR YOU BUT YOU NEED TO DIE FIRST AND RETURN AS AN {UNDEAD} CREATURE. COME BACK TO ME WHEN YOU ACHIEVED THIS GOAL." })
keywordHandler:addKeyword({ "exchange" }, StdModule.say, { npcHandler = npcHandler, text = "EVERYTHING YOU CARRY WITH YOU CAN ALSO BE FOUND IN MY {TREASURE}. BRING ME SOMETHING I DON'T OWN!!!" })
keywordHandler:addKeyword({ "mission" }, StdModule.say, { npcHandler = npcHandler, text = "I HAVE A MISSION FOR YOU BUT YOU NEED TO DIE FIRST AND RETURN AS AN {UNDEAD} CREATURE. COME BACK TO ME WHEN YOU ACHIEVED THIS GOAL." })
keywordHandler:addKeyword({ "undead" }, StdModule.say, { npcHandler = npcHandler, text = "BOON AND BANE. I HAVE CHOSEN THIS LIFE VOLUNTARILLY AND I NEVER REGRET IT. MY {TREASURE} IS GROWING BIGGER EACH DAY." })

npcHandler:setMessage(MESSAGE_GREET, "I {AWAITED} YOU!")
npcHandler:setMessage(MESSAGE_FAREWELL, "COME BACK ANYTIME AND BRING ME TREASURES.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "COME BACK ANYTIME AND BRING ME TREASURES.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
