local internalNpcName = "Eshaya"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1200,
	lookHead = 95,
	lookBody = 86,
	lookLegs = 79,
	lookFeet = 0,
	lookAddons = 2,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Praised be Suon and Bastesh." },
	{ text = "I should talk to Kallimae soon." },
	{ text = "Issavi's safety is my first concern." },
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

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Third.Recovering) == 3 and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) < 1 then
			npcHandler:say("Very good. But now you need the Ring of Secret Thoughts back in order to extract the Ambassador's memories.", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getItemById(31263, true) and player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Third.Recovering) < 2 then
			npcHandler:say("You found the Ring of Secret Thoughts! Well done! Now give it to the Ambassador as a present. He's a peacock and will accept such a precious gift for sure. As soon as he wears it, his memories will be stored in the ring.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Third.Recovering, 2)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Title) < 1 then
			npcHandler:say("I'm willing to admit that I need help. And the help of someone who is not from {Issavi} at that. But the task could be dangerous and you would become embroiled in the politics and court intrigues of {Kilmaresh}. Will you help me anyhow?", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating) == 5 then
			npcHandler:say({
				"It seems that he destroyed every visible evidence of his treason. That's very unfortunate and I see only one remaining possibility: You need to see the {Ambassador}'s memories. ...",
				"But there is only one way to achieve this: You have to find a Ring of {Secret Thoughts}. Legend has it that a monstrous being called {Urmahlullu} has such a ring. If the myths are true you can find this creature in a subterranean tomb south of Issavi.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, 6)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.Memories) == 4 then
			npcHandler:say("This is the proof we need! Very well done! You have to report this to our {Empress}. She will grant you an audience now.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fifth.Memories, 5)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You haven't completed your mission yet. Keep searching!", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"You are a noble soul! So listen: for many decades, over a century actually, the city of {Rathleton} had an Ambassador here in {Issavi}. ...",
				"{Kilmaresh} and {Oramond} maintain important commercial relations, and for this reason Rathleton has an envoy here. In the past, the relations were good but now ..",
				"I hate to admit it but I heavily suspect that the current {Ambassador} is a traitor and consorts with the forbidden cult of {Fafnar}. I have several hints and {Kallimae} saw it in one of her visions. ...",
				"But the vision of a Kilmareshian seer is no proof they will ever accept in Rathleton. And without proof we can't banish the {Ambassador}, this would cause major diplomatic fallout or even a war. I can't risk that. ...",
				"I need unequivocal evidence that the {Ambassador} conspires with the Fafnar cultists. Please go to his residence in the eastern part of the city and search for letters, journals ... anything that could prove him guilty.",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.First.Title, 1)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Second.Investigating, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "theft") then
		if npcHandler:getTopic(playerId) == 3 then
			npcHandler:say("I don't know whether you are experienced in such things. If not, you could ask somebody who is. But I'm not sure where in Issavi you should look to hire a thief.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "ring of secret thoughts back") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("I guess claiming back a present would be a bit suspicious. You'll have to find another way. I resent thinking about theft but sometimes, desperate times call for desperate measures.", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "ring") then
		if player:getStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe) == 4 then
			npcHandler:say("You got the ring back? Very well done! Now search for the memories that will prove the Ambassador's treason. I don't know much about ancient artefacts but you could ask the librarian in the palace. I'm sure he knows something helpful.", npc, creature)
			player:setStorageValue(Storage.Quest.U12_20.KilmareshQuest.Fourth.Moe, 5)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "empress") then
		npcHandler:say("Good luck on your audience with the Empress. May Kilmaresh prosper.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end

	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Suon's and Bastesh's blessing, dear guest!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
