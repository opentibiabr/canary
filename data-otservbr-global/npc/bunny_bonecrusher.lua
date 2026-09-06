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
	profession = "trader",
}
npcConfig.speechBubble = SPEECHBUBBLE_TRADE

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

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "druid" }, StdModule.say, { npcHandler = npcHandler, text = "They are our main magic support and play a major role in our battle tactics." })
keywordHandler:addKeyword({ "dogs of war" }, StdModule.say, { npcHandler = npcHandler, text = "This is a men's club, mainly busy with bragging and drinking alcohol." })
keywordHandler:addKeyword({ "knights of noodles" }, StdModule.say, { npcHandler = npcHandler, text = "They are rumoured to be skilled fighters. Then again, in the land of the blind..." })
keywordHandler:addKeyword({ "reports" }, StdModule.say, { npcHandler = npcHandler, text = "Our reports are only for internal use." })
keywordHandler:addKeyword({ "commoner" }, StdModule.say, { npcHandler = npcHandler, text = "I am the general of the queen's army! You really should consider to join, sister." })
keywordHandler:addKeyword({ "subjects" }, StdModule.say, { npcHandler = npcHandler, text = "Our citizens are lucky to live under the wise rule of our beloved queen!" })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "It's just a rotten hideout for drunks and men too lazy to do some serious work." })
keywordHandler:addKeyword({ "cemetery" }, StdModule.say, { npcHandler = npcHandler, text = "Bah! Just men's tales! Who believes in such rubbish? Perhaps we should put some men there overnight and see what happens. Hehehe!" })
keywordHandler:addKeyword({ "crypt" }, StdModule.say, { npcHandler = npcHandler, text = "Bah! Just men's tales! Who believes in such rubbish? Perhaps we should put some men there overnight and see what happens. Hehehe!" })
keywordHandler:addKeyword({ "graveyard" }, StdModule.say, { npcHandler = npcHandler, text = "Bah! Just men's tales! Who believes in such rubbish? Perhaps we should put some men there overnight and see what happens. Hehehe!" })
keywordHandler:addKeyword({ "castle" }, StdModule.say, { npcHandler = npcHandler, text = "The castle was not built for defence but as a residence for the royal family." })
keywordHandler:addKeyword({ "gods" }, StdModule.say, { npcHandler = npcHandler, text = "I worship Banor, the first warrior!" })
keywordHandler:addKeyword({ "banor" }, StdModule.say, { npcHandler = npcHandler, text = "He is the idol for all fighting women and a reminder of what a man could become if he jumps over his own shadow!" })
keywordHandler:addKeyword({ "zathroth" }, StdModule.say, { npcHandler = npcHandler, text = "Don't mention the dark one in the city of life!" })
keywordHandler:addKeyword({ "armor" }, StdModule.say, { npcHandler = npcHandler, text = "Cornelia forges the armor for our troops." })
keywordHandler:addKeyword({ "cornelia" }, StdModule.say, { npcHandler = npcHandler, text = "Cornelia forges the armor for our troops." })
keywordHandler:addKeyword({ "barbara" }, StdModule.say, { npcHandler = npcHandler, text = "She is one of the Green Ferrets and one of the queen's bodyguards." })
keywordHandler:addKeyword({ "fenbala" }, StdModule.say, { npcHandler = npcHandler, text = "She is one of the Green Ferrets and one of the queen's bodyguards." })
keywordHandler:addKeyword({ "rowenna" }, StdModule.say, { npcHandler = npcHandler, text = "Rowenna is responsible for our troops' supply of weapons." })
keywordHandler:addKeyword({ "weapon" }, StdModule.say, { npcHandler = npcHandler, text = "Rowenna is responsible for our troops' supply of weapons." })
keywordHandler:addKeyword({ "harkath bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "Old man. I can't tell what's worse for the shape of Thais' army." })
keywordHandler:addKeyword({ "legola" }, StdModule.say, { npcHandler = npcHandler, text = "She is a distant cousin of me and my sisters." })
keywordHandler:addKeyword({ "monster" }, StdModule.say, { npcHandler = npcHandler, text = "We cleared the woods around Carlin of most monsters. But lately, more and more show up again." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "Believe it or not, I killed him two times with my own bow, but some unholy forces rise him again and again." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "I'm sure only a woman has the courage and strength to wield this weapon of myth." })
keywordHandler:addKeyword({ "swear" }, StdModule.say, { npcHandler = npcHandler, text = "Take this!" })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
