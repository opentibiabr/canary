local internalNpcName = "Vanys"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 0
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1137,
	lookHead = 0,
	lookBody = 38,
	lookLegs = 34,
	lookFeet = 73,
	lookAddons = 0,
	lookMount = 0,
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

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local dreamTalisman = 30132

	if MsgContains(message, "talk") then
		npcHandler:say("So do you want to learn the {story} behind of this or rather talk about the {task} at hand? ", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, "story") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("Do you prefer the {long} version or the {short} version?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "short") and npcHandler:getTopic(playerId) == 3 then
		npcHandler:say({
			"You will have to re-empower several wardstones all over the world, to weaken the beast of nightmares. ...",
			"The next step would be to enter a place known as dream scar and participate in battles, to gain access to the lower areas. ...",
			"There the nightmare beast can be challenged and defeated.",
			"So do you want to learn the story behind of this or rather talk about the {task} at hand?",
		}, npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif npcHandler:getTopic(playerId) == 4 or npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "task") then
			if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline) >= 3 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheSummerCourt) == 1 and not (player:hasOutfit(1146) or player:hasOutfit(1147)) then
				npcHandler:say("The Nightmare Beast is slain. You have done well. The Courts of Summer and Winter will be forever grateful. For your efforts I want to reward you with our traditional dream warrior outfit. May it suit you well!", npc, creature)
				for i = 1146, 1147 do
					player:addOutfit(i)
				end
				npcHandler:setTopic(playerId, 0)
			elseif player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Count) >= 8 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheSummerCourt) == 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline) == 1 then
				npcHandler:say({
					"You empowered all eight ward stones. Well done! You may now enter the Dream Labyrinth via the portal here in the Court. Beneath it you will find the Nightmare Beast's lair. But the labyrinth is protected by seven so called Dream Doors. ...",
					"You have to find the Seven {Keys} to unlock the Seven Dream Doors down there. Only then you will be able to enter the Nightmare Beast's lair.",
				}, npc, creature)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline, 2)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.TheSevenKeys.Questline, 1)
				npcHandler:setTopic(playerId, 5)
			elseif player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline) < 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheSummerCourt) < 1 and player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheWinterCourt) < 1 then
				npcHandler:say({
					"You have to empower eight ward stones. Once charged with arcane energy, they will strengthen the Nightmare Beast's prison and at the same time weaken this terrible creature. We know about the specific location of six of those stones. ...",
					"You can find them in the mountains of the island Okolnir, in a water elemental cave beneath Folda, in the depths of Calassa, in the forests of Feyrist and on the islands Meriana and Cormaya. ...",
					"The location of the other two ward stones is a bit more obscure, however. We are not completely sure where they are. You should make inquiries at an abandoned house in the Plains of Havoc. You may find it east of an outlaw camp. ...",
					"The other stone seems to be somewhere in Tiquanda. Search for a small stone building south-west of Banuta. Take this talisman to empower the ward stones. It will work with the six stones at the known locations. ...",
					"However, the empowering of the two hidden stones could be a bit more complicated. But you have to find out on yourself what to do with those stones.",
				}, npc, creature)
				if player:getStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.Questline) < 1 then
					player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.Questline, 1)
				end
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.Main.TheSummerCourt, 1)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Questline, 1)
				player:setStorageValue(Storage.Quest.U12_00.TheDreamCourts.WardStones.Count, 0)
				player:addItem(dreamTalisman, 1)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("I already gave your task.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	elseif MsgContains(message, "keys") and npcHandler:getTopic(playerId) == 5 then
		npcHandler:say("They are not literally keys but rather puzzles you have to solve or a secret mechanism you have to discover in order to open the Dream Doors. A parchment in the chest here can tell you more about it.", npc, creature)
	elseif MsgContains(message, "addon") then
		if player:hasOutfit(1146) or player:hasOutfit(1147) then
			npcHandler:say("Are you interested in one or two addons to your dream warrior outfit?", npc, creature)
			npcHandler:setTopic(playerId, 6)
		else
			npcHandler:say("You don't even have the outfit.", npc, creature)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 6 then
			npcHandler:say("I provide two addons. For the first one I need you to bring me five pomegranates. For the second addon you need an ice shield. Do you want one of these addons?", npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say("What do you have for me: the {pomegranates} or the {ice shield}?", npc, creature)
			npcHandler:setTopic(playerId, 8)
		end
	elseif npcHandler:getTopic(playerId) == 8 then
		if MsgContains(message, "pomegranates") then
			if player:getItemCount(30169) >= 5 then
				npcHandler:say("Very good! You gained the second addon to the dream warrior outfit.", npc, creature)
				player:removeItem(30169, 5)
				for i = 1146, 1147 do
					player:addOutfitAddon(i, 2)
				end
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You do not have enough items.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		elseif MsgContains(message, "ice shield") then
			if player:getItemCount(30168) >= 1 then
				npcHandler:say("Very good! You gained the first addon to the dream warrior outfit.", npc, creature)
				player:removeItem(30168, 1)
				for i = 1146, 1147 do
					player:addOutfitAddon(i, 1)
				end
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say("You do not have enough items.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			end
		end
	else
		npcHandler:say("Sorry, I didn't understand.", npc, creature)
	end
end

npcHandler:setMessage(MESSAGE_GREET, "Greetings hero. I guess you came to {talk}.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Well, bye then.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
