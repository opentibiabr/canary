local internalNpcName = "Eroth"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 63,
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

	-- Check if NPC can interact with the creature
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	-- Check if the message contains "mission"
	if MsgContains(message, "mission") then
		-- Check if player is starting the quest
		if player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.Questline) < 1 then
			npcHandler:say("Have you ever heard of Elvenbane? It is the castle west of Ab'Dendriel which is inhabited by villains from all over the continent. Any support in this war is welcome. Are you willing to help?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		-- Check if player has completed certain objectives
		elseif player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.Questline) == 2 and player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.DwarvenShield) == 1 and player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.MorningStar) == 1 and player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.BP1) == 1 and player:getStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.BP2) == 1 then
			npcHandler:say("I heard the blow! The reflection must have caused a overcharge of magical energy leading to the contraction and the implosion. Just like I hoped! Please take this as a reward. Thank you very much.", npc, creature)
			player:addItem(3082, 1)
			player:addItem(3035, 10)
			player:setStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.Questline, 3)
			npcHandler:setTopic(playerId, 0)
		end
	-- Check if the player has accepted the mission
	elseif npcHandler:getTopic(playerId) == 1 and MsgContains(message, "yes") then
		npcHandler:say({
			"Recently we found out that they are in the possession of a scrying crystal ball. They can hear all our discussions about tactics and upcoming attacks. ...",
			"No wonder that they always have been so well prepared. Now you come into play, destroy the scrying crystal ball in Elvenbane. It should be on the top floor. ...",
			"We don't really know how to destroy it but we suppose it may work if you reflect the invisible power of the ball. The beam should be adjusted to Ab'Dendriel. Take this mirror and give it a try. Good luck.",
		}, npc, creature)
		player:addItem(3463, 1)
		player:setStorageValue(Storage.Quest.U8_1.ToBlindTheEnemy.Questline, 1)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the leader of the Cenath caste." })
keywordHandler:addKeyword({ "kuridai" }, StdModule.say, { npcHandler = npcHandler, text = "The Kuridai are aggressive and victims of their instincts. Without our help they would surely die in a foolish war." })
keywordHandler:addKeyword({ "crunor" }, StdModule.say, { npcHandler = npcHandler, text = "Gods are for the weak. We will master the world on our own. We need no gods." })
keywordHandler:addKeyword({ "deraisim" }, StdModule.say, { npcHandler = npcHandler, text = "They lack the understanding of unity. We are keeping them together and prevent them from being slaughtered one by one." })
keywordHandler:addKeyword({ "cenath" }, StdModule.say, { npcHandler = npcHandler, text = "We are the shepherds of our people. The other castes need our guidance." })
keywordHandler:addKeyword({ "magic" }, StdModule.say, { npcHandler = npcHandler, text = "Magic comes almost naturally to the Cenath. We keep the secrets of ages." })
keywordHandler:addKeyword({ "spell" }, StdModule.say, { npcHandler = npcHandler, text = "I can teach the spells 'magic shield', 'destroy field', 'creature illusion', 'chameleon', 'convince creature', and 'summon creature'." })

-- Greeting message
keywordHandler:addGreetKeyword({ "ashari" }, { npcHandler = npcHandler, text = "I greet thee, outsider." })
--Farewell message
keywordHandler:addFarewellKeyword({ "asgha thrazi" }, { npcHandler = npcHandler, text = "Asha Thrazi. Go, where you have to go." })

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "I greet thee, outsider.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Asha Thrazi. Go, where you have to go.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Asha Thrazi.")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
