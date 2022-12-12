local internalNpcName = "Chief Grarkharok"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 281
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Grarkharok\'s bestest troll tribe! Yeee, good name!' },
	{ text = 'Grarkharok make new tribe here! Me Chief now!' },
	{ text = 'Me like to throw rocks, me also like frogs! Yumyum!' }
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

local mission = Storage.Quest.U8_2.TrollSabotage
local ThreatenedDreams = Storage.Quest.U11_40.ThreatenedDreams
local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'cloak') or MsgContains(message, 'feather') or MsgContains(message, 'swan') or MsgContains(message, 'maiden') then
		if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 12 then
			npcHandler:say("Hahaha! Grarkharok take cloak from pretty girl. Then ... girl is swan. Grarkharok wants eat but flies away. Grarkharok not understand. Not need cloak, too many feathers. Give cloak to To ... Ta ... Tereban in Edron. Getting shiny coins and meat.", npc, creature)
		else
			npcHandler:say("Grarkharok already say everything! Not want talk! Go away!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "kill") or MsgContains(message, "hurt") or MsgContains(message, "pain") then
		if player:getStorageValue(Storage.Quest.U8_2.TrollSabotage.Questline) == 1 then
			npcHandler:setTopic(playerId, 1)
		end
		npcHandler:say("Hrhrhrhr! Me no fear of human! Me Chief Grarkharok!!", npc, creature)
	elseif MsgContains(message, "lady") or MsgContains(message, "queen") or MsgContains(message, "woman") or MsgContains(message, "cave") or MsgContains(message, "house") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("You help?? Human know troll lady for Grarkharok??", npc, creature)
			npcHandler:setTopic(playerId, 2)
		else
			npcHandler:say("Found lady for Grarkharok?!? Must be good-looking, hairy lady, yknow! Go find!!", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("What name of troll lady??", npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 100 then
			if player:removeItem(5934, 1) then
				npcHandler:say("Gimme gimme! Yumyumyum! <BUUUURP>.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You no have dead frog! Bring dead frog!!! Grarkharok hungry!!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 101 then
			if player:removeItem(3998, 1) then
				npcHandler:say("Gimme gimme! Yumyumyum! <BUUUURP>.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You no have tasty snake! Bring tasty snake!!! Grarkharok hungry!!", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif npcHandler:getTopic(playerId) == 3 then
		npcHandler:say("|PLAYERNAME|?!? Sound good! Bring troll lady to Grarkharok!! Here, give troll lady! Take take! Bring lady to Grarkharok for make tribe!! Now GO!", npc, creature)
		npcHandler:setTopic(playerId, 0)
		player:setStorageValue(mission.Questline, 2)
		player:addItem(7754, 1)
	elseif MsgContains(message, "frog") then
		npcHandler:say("Have dead frog for Grarkharok??", npc, creature)
		npcHandler:setTopic(playerId, 100)
	elseif MsgContains(message, "snake") then
		npcHandler:say("Have tasty snake for Grarkharok??", npc, creature)
		npcHandler:setTopic(playerId, 101)
	elseif MsgContains(message, "no") then
		if npcHandler:getTopic(playerId) == 100 or npcHandler:getTopic(playerId) == 101 then
			npcHandler:say("Grarkharok angry now!! Want throw rock on human cave down hill again!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif npcHandler:getTopic(playerId) == 101 then
		npcHandler:say("Huh?? No understand!", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end
-- basic
keywordHandler:addKeyword({"tribe"}, StdModule.say, {npcHandler = npcHandler, text = "Me tribe in production! Only need troll lady!"})
keywordHandler:addAliasKeyword({"troll"})
keywordHandler:addAliasKeyword({"other"})

keywordHandler:addKeyword({"gold"}, StdModule.say, {npcHandler = npcHandler, text = "Me no nothing! Need all money to make Grarkharok tribe!"})
keywordHandler:addAliasKeyword({"crystal"})
keywordHandler:addAliasKeyword({"platinum"})
keywordHandler:addAliasKeyword({"money"})
keywordHandler:addAliasKeyword({"pay"})
keywordHandler:addKeyword({"boom"}, StdModule.say, {npcHandler = npcHandler, text = "Grarkharok like BOOM, BOOM sound! Go mountain, push rock and BOOM!"})
keywordHandler:addKeyword({"bottom"}, StdModule.say, {npcHandler = npcHandler, text = "Like it?? Hope troll lady also like it!"})
keywordHandler:addAliasKeyword({"butt"})
keywordHandler:addKeyword({"human"}, StdModule.say, {npcHandler = npcHandler, text = "Me no like human. Need quiet to make tribe! Only need troll lady!"})
keywordHandler:addKeyword({"chief"}, StdModule.say, {npcHandler = npcHandler, text = "Yeye, me stole chief club from Fragratosh, hrhrhrh! Now make me own tribe!"})
keywordHandler:addKeyword({"fragratosh"}, StdModule.say, {npcHandler = npcHandler, text = "Fragratosh stupid. He chief of me old tribe. No frogs, no snakes, no smashing humans withrocks. Booooooring tribe! Now me make own tribe!!"})
keywordHandler:addKeyword({"necklace"}, StdModule.say, {npcHandler = npcHandler, text = "Grarkharok no listen to talk of stinky human! Lalalalalala! Like song? Grarkharok made!"})
keywordHandler:addAliasKeyword({"do"})
keywordHandler:addAliasKeyword({"reason"})
keywordHandler:addAliasKeyword({"why"})
keywordHandler:addKeyword({"destroy"}, StdModule.say, {npcHandler = npcHandler, text = "You have what want! Go go, find lady so be Grarkharok tribe!!"})
keywordHandler:addKeyword({"name"}, StdModule.say, {npcHandler = npcHandler, text = "Me be Grarkharok!!"})
keywordHandler:addAliasKeyword({"grarkharok"})
keywordHandler:addKeyword({"gurak cha rak"}, StdModule.say, {npcHandler = npcHandler, text = "You say troll speak!! Hmmm, sound like south tribe! You know Ingortrak ?? He chief of big tribe in jungle! Good chief he is!"})
keywordHandler:addKeyword({"item"}, StdModule.say, {npcHandler = npcHandler, text = "I Tem?!?!? No know! Maybe YOU Tem?"})
keywordHandler:addKeyword({"job"}, StdModule.say, {npcHandler = npcHandler, text = "Me be Grarkharok. No me name Job!"})
keywordHandler:addAliasKeyword({"nothing"})
keywordHandler:addKeyword({"tibia"}, StdModule.say, {npcHandler = npcHandler, text = "Tribe Grarkharok will rules Tibia! Me only need troll lady, then start tribe!"})
keywordHandler:addKeyword({"mission"}, StdModule.say, {npcHandler = npcHandler, text = "Grarkharok destroy human cave down hill! Human away, my mission done,hrhrhrhrhr!"})
keywordHandler:addAliasKeyword({"quest"})
npcHandler:setMessage(MESSAGE_GREET, "Me Chief Grarkharok! No do {nothing}!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Grarkharok be {chief}!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Grarkharok be {chief}!")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)


npcType:register(npcConfig)
