local internalNpcName = "The First Dragon"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 947,
	lookAddons = 3,
	lookHead = 113,
	lookBody = 117,
	lookLegs = 119,
	lookFeet = 80,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if MsgContains(message, "reward") and player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers) == 1 then
		npcHandler:say({
			"Have a look at the chests over there. Feel free to take the things you find within. You know, gold, gems and the like. There's also a garment I'm storing here for a while. As it doesn't fit me I have no need for it. ...",
			"But it might be a nice outfit for a little human. You also can take the porcelain mask and the feathers. There's a wizard named Muriel in Thais who reportedly embellishes outfits with stuff like this.",
		}, npc, creature)
		player:addOutfit(929, 0)
		player:addOutfit(931, 0)
		player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
		if player:getStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers) < 2 then
			player:setStorageValue(Storage.Quest.U11_02.TheFirstDragon.Feathers, 2)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "fight") then
		npcHandler:say({
			"Even in {retirement} I sometimes succumb to the temptation of sweet battle. Fighting was so different back in the old {times}. You can read about it in my {memoirs}. There should be a copy lying here somewhere.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "retirement") then
		npcHandler:say({
			"When you are young, you are much more tolerant towards the burden of life. At a certain age even a {dragon} will start to think about if things will go on forever. ...",
			"Eventually there comes a time when you decide all the {hassle} isn't worth it anymore and you decide to concentrate on the {finer} things life has to offer.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "memoirs") then
		npcHandler:say({
			"I dictated my memoirs to a human servant. I like the idea to share my thoughts and memories with humanity with the help of a {book}. ...",
			"You are my greatest fans after all. ...",
			"If it becomes popular, I might consider an orcish translation or even one in bonelord language. ...",
			"By the way, it's a funny story how I learnt the bonelord language. However, I saved it for a possible part two of my memoirs.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "hassle") then
		npcHandler:say({
			"I really enjoy a good fight now and then. ...",
			"A real pain, however, is the constant annoyance caused by tedious fights against adventurers with more healing pots than brain.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "worthy") then
		npcHandler:say({
			"To be honest, the first dragon hunters weren't {worthy}. ...",
			"They used {weaknesses} to their advantage. It took some time before a dragon could be killed in a fair fight.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "weaknesses") then
		npcHandler:say({
			"The first awoken dragons were quite disoriented when leaving the {mists} and re-entering reality. ...",
			"This led to certain vulnerabilities. However, the dragons overcame such shortcomings quickly and soon took their rightful place in the food chain, so to say.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "mists") then
		npcHandler:say({
			"There was a time before the gods cast the mists of healing over the world. At that time the dragons ruled and burnt the {world}. ...",
			"In hindsight I'm not too proud of this. This was some kind of juvenile bullying.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "world") then
		npcHandler:say({
			"The world has changed so much; I'm beginning to feel really old. People have changed, the face of the world has changed, even the laws of nature are no longer the same. ...",
			"I think it is the greatest advantage of you {humans} to be more flexible and adaptable.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "books") then
		npcHandler:say({
			"Your books are an amazing thing. Draconic glyphs are so different. ...",
			"They are not only more complicated but also more specific. A single word which always keeps the same meaning is astonishingly effective in its primitive way. ...",
			"It helps you to conserve thoughts, stories and history and to share them with others - a {concept} I really appreciate. ...",
			"Books are a wonderful {invention}. If you are ever tired of your heroic exploits, take the time to read one.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "invention") then
		npcHandler:say({
			"Being powerful creatures themselves, dragons had no need for inventions. ...",
			"However, now that times have changed and the pressure increases, even my kin might slowly start to change in order to {adapt}.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "adapt") then
		npcHandler:say({
			"Well, surely some of my kin might whine and complain as they always do. ...",
			"You have no idea how backwards thinking some dragons can be. A few are even still idealising the times before the {mists}.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "finer") then
		npcHandler:say({
			"The definition of finer things is different for a dragon than for a human. ...",
			"A young dragon appreciates diving into a lava pool, while an old dragon just can't stand to get rid of the {lava} afterwards and prefers bathing in boiling water.",
		}, npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Hello, my sparring buddy. We should have another fight sometimes. I think you may have earned a little reward.")

keywordHandler:addKeyword({ "times" }, StdModule.say, { npcHandler = npcHandler, text = "Times have changed <sigh>. In the past dragons were feared and respected. Only the {demons} rivalled our notoriety." })
keywordHandler:addKeyword({ "demons" }, StdModule.say, { npcHandler = npcHandler, text = "Those upstarts! I wonder why would anyone care about them. They lack our style. For them it is all about brute force and showing-off." })
keywordHandler:addKeyword({ "style" }, StdModule.say, { npcHandler = npcHandler, text = "Breathing fire is an art! Instead of setting everything on fire, you exhale a cone of fire to give a worthy opponent a chance to avoid it." })
keywordHandler:addKeyword({ "humans" }, StdModule.say, { npcHandler = npcHandler, text = "Your lives are so short and meaningless and yet you are here! And as a race you even have your own history and remember things with the help of {books}, which amazes me." })
keywordHandler:addKeyword({ "concept" }, StdModule.say, { npcHandler = npcHandler, text = "I like the idea of books so much that I acquired a human servant to record my memoirs. You find a copy somewhere in my lair." })
keywordHandler:addKeyword({ "lava" }, StdModule.say, { npcHandler = npcHandler, text = "Lava is only fun as long as it doesn't harden - then it turns into an annoyance." })

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
