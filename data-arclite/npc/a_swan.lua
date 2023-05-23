local internalNpcName = "A Swan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookTypeEx = 25445
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

local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'mission') then
		if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 11 then
			npcHandler:say({
				"My sister Ikassis sent you? Blessed be her soul! Yes, it is true: I need help. Listen, I will tell you a secret but please don't break it. As you might already suspect I'm not really a swan but a fae. ...",
				"But other than many of my siblings I did not take over a swan's body. I'm a swan maiden and this is one of my two aspects. I can take the shape of a swan as well as that of a young maiden. ...",
				"But to do so I need a magical artefact: a cloak made of swan feathers. If I lose this cloak - or someone steals it from me - I'm stuck to the form of a swan and can't change shape anymore. And this is exactly what happened: ...",
				"A troll stalked me while I was bathing in the river and he stole my cloak. Now I am trapped in the form of a swan. Please, can you find the thief and bring back the cloak?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(ThreatenedDreams.Mission01[1]) == 14 then
			if player:getItemCount(25244) >= 5 then
				player:removeItem(25244, 5)
				player:setStorageValue(ThreatenedDreams.Mission01[1], 15)
				npcHandler:say({
					"This is everything that remained of my cloak? That's terrible! However, I guess I can put the feathers together again. Yes, that should be enough feathers. ...",
					"Please give them to me so I can restore my cloak. But don't watch me! Swan maidens don't like to be observed. Nature's blessings, human being. I will tell Ikassis that you have been of great assistance."
				}, npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You need to deliver me like 5 feathers.", npc, creature)
			end
		else
			npcHandler:say("You are not on that mission.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"Thank you, human being! I guess the thieving troll headed to the mountains east of here. As far as I know you can only reach these mountain tops by diving into a small cave. ...",
				"The connecting tunnels will lead you to a mountain where you may discover him. I heard a man named Jerom talking about this when he passed by this river. Perhaps he knows more about it."
			}, npc, creature)
			player:setStorageValue(ThreatenedDreams.Mission01[1], 12)
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "I salute you, mortal being.")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
