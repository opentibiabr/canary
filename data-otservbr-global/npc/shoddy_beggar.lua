local internalNpcName = "Shoddy Beggar"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 153,
	lookHead = 20,
	lookBody = 39,
	lookLegs = 39,
	lookFeet = 116,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = '*mumbles*' },
	{ text = 'That astronomer of the academy simply has no idea what he is dealing with...' },
	{ text = 'Some secrets should better be left uncovered.' },
	{ text = 'Ha, ha... *mumbles* Hmm.' }
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


	if MsgContains(message, 'spare') then
		npcHandler:say('Hmm, if you can spare a coin... we can talk. What do you say?', npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'device') then
		if player:getStorageValue(Storage.SeaOfLight.Questline) == 1 then
			npcHandler:say('Persistent little nuisance, aren\'t we? Well, I like your spirit so I will tell you a secret. I may not look the part but I was once a {scientist}. The academy seemed to not like my... attitude and never actually invited me.', npc, creature)
		end
	elseif MsgContains(message, 'scientist') then
		if player:getStorageValue(Storage.SeaOfLight.Questline) == 1 then
			npcHandler:say('Indeed, I was one myself a long time ago. I may seem a little... distracted by now, but I was working on many important projects. I even created a device to... well, it will cost you another gold coin if you want me to tell you the whole story. You\'re in?', npc, creature)
			npcHandler:setTopic(playerId, 2)
		end
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 1 then
			if not player:removeMoneyBank(1) then
				npcHandler:say(player:getStorageValue(Storage.SeaOfLight.Questline) ~= 1 and 'Is that all you have? That would be less than I have... *mumbles*' or 'Mh, it seems you don\'t have any coins.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			npcHandler:say(player:getStorageValue(Storage.SeaOfLight.Questline) ~= 1 and 'Very kind indeed. Maybe you are not such a bad guy after all. Maybe I can even give it back to you one day... you know I was not always like that *mumbles*.' or 'Thank you very much... plans you say? I don\'t know what you are talking about. Plans for a magic... device? And the people call ME crazy.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			if not player:removeMoneyBank(1) then
				npcHandler:say('Well, if that is all you can spare... better keep it.', npc, creature)
				npcHandler:setTopic(playerId, 0)
				return true
			end

			npcHandler:say('Alright, it seems you are serious about this. I will tell you about my device. Every night I looked up to the stars and wondered what worlds we would be able to find if we could just look where we wanted to. So... hey are you still listening?', npc, creature)
			npcHandler:setTopic(playerId, 3)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say('Good, good. So eventually I found a way and invented a magic device I called the Lightboat. It was a large construction you could sit in and... well, judging by your looks you don\'t believe a word. Do you want to hear the story or not?', npc, creature)
			npcHandler:setTopic(playerId, 4)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say('Fine. For years I gathered all the necessary items to build the device. I travelled, traded and took advantage of some rare opportunities. With luck and patience I eventually got every component I needed. Can you imagine the excitement I experienced?', npc, creature)
			npcHandler:setTopic(playerId, 5)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say('And there I stood before my greatest invention. Door to unknown places, mysterious worlds... yet one of my components was flawed. A small crack in a vital element of my construction quickly led to the failure of the whole project. Still following?', npc, creature)
			npcHandler:setTopic(playerId, 6)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say('The device was ultimately destroyed. I barely escaped the chaos with my life. My laboratory was shattered, as were all the components of the cursed device. With nothing left, I started to lead a new, different life. Do you know what that means?', npc, creature)
			npcHandler:setTopic(playerId, 7)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say('Pah!! You have NO idea, leave me alone now.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say('Right... I\'m glad everything was destroyed. I don\'t even know why I kept the remaining copy of the plans all those years... oh, did I say this aloud?', npc, creature)
			npcHandler:setTopic(playerId, 9)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say('Yes, well... I do have one remaining copy of the plans. I will keep them as a... reminder. Such ill-fated devices only cause trouble and despair. Mankind would be better off, without them, right?', npc, creature)
			npcHandler:setTopic(playerId, 10)
		elseif npcHandler:getTopic(playerId) == 10 then
			npcHandler:say('Ah, you think you are wise but you know nothing, nothing about science, nothing about the opportunities it offers... You will never understand scientists like me.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 11 then
			player:addItem(9696, 1)
			player:setStorageValue(Storage.SeaOfLight.Questline, 2)
			player:setStorageValue(Storage.SeaOfLight.Mission1, 2)
			npcHandler:say('Well, to be honest, I envy him a little. He can continue his research in his laboratory. He still has working equipment... I sometimes read his publications. He is an able man, but completely on the wrong track... give these plans to him.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'no') then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say('Mean, heartless... go and leave me be.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say('Well, whatever then...', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say('Then stop bothering me.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 4 then
			npcHandler:say('Your decision.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 5 then
			npcHandler:say('Yes and I, I... you mean what? Can\'t imagine? Well, then there is no purpose to continue telling you this story.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 6 then
			npcHandler:say('*mumbles*', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 7 then
			npcHandler:say('Thought so. It means starting anew, without any home, money or goal in your life. However, it also opens up opportunities... don\'t you agree?', npc, creature)
			npcHandler:setTopic(playerId, 8)
		elseif npcHandler:getTopic(playerId) == 8 then
			npcHandler:say('No, no, you are right, I should have tried to rebuild it, I should have been more careful, I should... ah, why did I even tell you this.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 9 then
			npcHandler:say('Phew... alright, it was nice talking to you.', npc, creature)
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 10 then
			npcHandler:say('Hm, maybe you are right. You could give these plans to someone who might be able to finish this project. Someone who will not make the mistakes I made. Someone... hm, do you know the astronomer Spectulus?', npc, creature)
			npcHandler:setTopic(playerId, 11)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "What do you want? Listen to the old madman? If you have nothing to spare, leave me alone.")
npcHandler:setMessage(MESSAGE_FAREWELL, "Yes, whatever.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Yes, whatever.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
