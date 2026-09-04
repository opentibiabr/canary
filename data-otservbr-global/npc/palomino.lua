local internalNpcName = "Palomino"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 128,
	lookHead = 116,
	lookBody = 39,
	lookLegs = 12,
	lookFeet = 97,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
	profession = "banker",
}
npcConfig.speechBubble = SPEECHBUBBLE_BANKER

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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "transport") then
		npcHandler:say("We can bring you to Venore with one of our coaches for 125 gold. Are you interested?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif table.contains({ "rent", "horses" }, message) then
		npcHandler:say("Do you want to rent a horse for one day at a price of 500 gold?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "yes") then
		local player = Player(creature)
		if npcHandler:getTopic(playerId) == 1 then
			if player:isPzLocked() then
				npcHandler:say("First get rid of those blood stains!", npc, creature)
				return true
			end

			if not player:removeMoneyBank(125) then
				npcHandler:say("You don't have enough money.", npc, creature)
				return true
			end

			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
			local destination = Position(32850, 32124, 7)
			player:teleportTo(destination)
			destination:sendMagicEffect(CONST_ME_TELEPORT)
			npcHandler:say("Have a nice trip!", npc, creature)
		elseif npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer) >= os.time() then
				npcHandler:say("You already have a horse.", npc, creature)
				return true
			end

			if not player:removeMoneyBank(500) then
				npcHandler:say("You do not have enough money to rent a horse!", npc, creature)
				return true
			end

			local mountId = { 22, 25, 26 }
			player:addMount(mountId[math.random(#mountId)])
			player:setStorageValue(Storage.Quest.U9_1.HorseStationWorldChange.Timer, os.time() + 86400)
			player:addAchievement("Natural Born Cowboy")
			npcHandler:say("I'll give you one of our experienced ones. Take care! Look out for low hanging branches.", npc, creature)
		end
		npcHandler:setTopic(playerId, 0)
	elseif MsgContains(message, "no") and npcHandler:getTopic(playerId) > 0 then
		npcHandler:say("Then not.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Salutations, |PLAYERNAME| I guess you are here for the {horses}.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "minotaur" }, StdModule.say, { npcHandler = npcHandler, text = "Did you know that minotaurs ride giant bulls? It seems somewhat strange, like a human riding a cyclops." })
keywordHandler:addKeyword({ "cyclops" }, StdModule.say, { npcHandler = npcHandler, text = "There is nothing big enough for a cyclops to ride." })
keywordHandler:addKeyword({ "donkey" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, but the donkeys and the horses did not get along well with each other. So we sold all of the donkeys to the dwarfs." })
keywordHandler:addKeyword({ "venore" }, StdModule.say, { npcHandler = npcHandler, text = "Venore is the heart of trade and commerce. Not even Thais can rival Venore in that field." })
keywordHandler:addKeyword({ "carlin" }, StdModule.say, { npcHandler = npcHandler, text = "Perhaps one day we will expand to Carlin. The women there will just love our ponies!" })
keywordHandler:addKeyword({ "goblin" }, StdModule.say, { npcHandler = npcHandler, text = "As far as I know, the goblins ride all kinds of creepy things like lizards, centipedes, spiders and slugs. Most of those beasts can even walk on the ceilings of caverns and climb walls with ease!" })
keywordHandler:addKeyword({ "mounts" }, StdModule.say, { npcHandler = npcHandler, text = "We loan mounts for a certain time. Those horses are easy to handle and loyal." })
keywordHandler:addKeyword({ "dwarf" }, StdModule.say, { npcHandler = npcHandler, text = "Most dwarfs don't like riding at all. Though I heard one of their heroes is riding a ram, they usually use horses and donkeys as beasts of burden. Given their size it is not astounding that they prefer the smaller donkeys over the horses." })
keywordHandler:addKeyword({ "thais" }, StdModule.say, { npcHandler = npcHandler, text = "The city is the centre of the known world. It is almost as if everything else is just built around it!" })
keywordHandler:addKeyword({ "elves" }, StdModule.say, { npcHandler = npcHandler, text = "I heard the elves ride every animal that roams the woods. From wolves and bears to squirrels, the elves befriend and ride them all. Just amazing!" })
keywordHandler:addKeyword({ "straw" }, StdModule.say, { npcHandler = npcHandler, text = "Be careful, the straw is highly inflammable." })
keywordHandler:addKeyword({ "coach" }, StdModule.say, { npcHandler = npcHandler, text = "We order our coaches from the dwarfs. They deliver high quality work that rarely breaks. Therefore we rarely have any delays. That is if there are no bandits, or monsters, or bad weather, or the horses are on the loose and such." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "If we could convince the king to use one of our coaches on his next visit to Venore, our business would get a fundamental boost!" })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "I can rent you a horse for a day or I can transport you with a coach." })
keywordHandler:addKeyword({ "orc" }, StdModule.say, { npcHandler = npcHandler, text = "Orcs ride wolves and sometimes boars, and even spiders, as far as one can trust the rumour mill." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
