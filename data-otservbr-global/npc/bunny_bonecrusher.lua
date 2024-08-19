local internalNpcName = "Bunny Bonecrusher"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 139,
	lookHead = 96,
	lookBody = 0,
	lookLegs = 79,
	lookFeet = 115,
	lookAddons = 0,
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
		if player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) < 1 then
			npcHandler:say({
				"Normally we don't assign missions to civilians - and particularly to MALE civilians - but in this case I think we can make an exception. ...",
				"I need a courier to deliver a parcel to the watchtower in Femor Hills. You think you can handle that??",
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline) == 4 then
			npcHandler:say("Alright, you delivered the parcel. So what is the password Thanita told you?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif npcHandler:getTopic(playerId) == 1 and MsgContains(message, "yes") then
		npcHandler:say("I am not sure if I should be glad now or not but anyway ... you will get a password so I will know if you just threw it away or actually delivered it. Here is the parcel. See you ....or not.", npc, creature)
		player:addItem(140, 1)
		player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 1)
		npcHandler:setTopic(playerId, 0)
	elseif npcHandler:getTopic(playerId) == 2 and MsgContains(message, "password*") then
		npcHandler:say("That's right. Here is your reward some elementary arrows. You did pretty well on your mission!", npc, creature)
		player:addItem(762, 50)
		player:addItem(774, 50)
		player:addItem(763, 50)
		player:addItem(761, 50)
		player:setStorageValue(Storage.Quest.U8_1.TowerDefenceQuest.Questline, 5)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

keywordHandler:addKeyword({ "hail general" }, StdModule.say, { npcHandler = npcHandler, text = "Salutations, commoner |PLAYERNAME|!" })
keywordHandler:addKeyword({ "how", "are", "you" }, StdModule.say, { npcHandler = npcHandler, text = "We are in constant training and in perfect health." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I am the general of the queen's army. I don't have time to explain this concept to you." })
keywordHandler:addKeyword({ "bonecrusher" }, StdModule.say, { npcHandler = npcHandler, text = "Our family has been serving the Carlin army since countless generations!" })
keywordHandler:addKeyword({ "sister" }, StdModule.say, { npcHandler = npcHandler, text = "Our family has been serving the Carlin army since countless generations!" })
keywordHandler:addKeyword({ "family" }, StdModule.say, { npcHandler = npcHandler, text = "She is one of my beloved sisters and serves Carlin as a town guard." })
keywordHandler:addKeyword({ "queen" }, StdModule.say, { npcHandler = npcHandler, text = "HAIL TO QUEEN ELOISE, OUR NOBLE {LEADER}!" })
keywordHandler:addKeyword({ "leader" }, StdModule.say, { npcHandler = npcHandler, text = "Queen Eloise is a fine leader for our fair town, indeed!" })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "The army protects the defenceless males of our {city}. Our elite forces are the {Green Ferrets}." })
keywordHandler:addKeyword({ "city" }, StdModule.say, { npcHandler = npcHandler, text = "Our city blends in with the nature surrounding it. Our {druids} take care of that." })
keywordHandler:addKeyword({ "druids" }, StdModule.say, { npcHandler = npcHandler, text = "They are our main magic support and play a major role in our battle {tactics}." })
keywordHandler:addKeyword({ "tactics" }, StdModule.say, { npcHandler = npcHandler, text = "Our tactic is to kiss." })
keywordHandler:addKeyword({ "kiss" }, StdModule.say, { npcHandler = npcHandler, text = "K.I.S.S.! Keep It Simple, Stupid! Complicated tactics are too easy to be crushed by a twist of fate." })
keywordHandler:addKeyword({ "green ferrets" }, StdModule.say, { npcHandler = npcHandler, text = "Our elite forces are trained by rangers and druids. In the woods they come a close second to elves." })
keywordHandler:addKeyword({ "join" }, StdModule.say, { npcHandler = npcHandler, text = "Join what?" })
keywordHandler:addKeyword({ "join army" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, we don't recruit foreigners. Maybe you can join if you prove yourself in a mission for the queen." })

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:setMessage(MESSAGE_GREET, "Address me properly |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "LONG LIVE THE QUEEN!")
npcHandler:setMessage(MESSAGE_FAREWELL, "LONG LIVE THE QUEEN!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
