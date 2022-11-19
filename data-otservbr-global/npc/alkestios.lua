local internalNpcName = "Alkestios"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 400,
	lookHead = 0,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 0,
	lookAddons = 0
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

	if MsgContains(message, "mission") then
		if player:getStorageValue(ThreatenedDreams.Mission01[1]) == 1
			and player:getStorageValue(ThreatenedDreams.Mission01.PoacherChest) == 1 then
			npcHandler:say({
				"Uhmn.. Maybe Ahmet in Ankrahmun can help we to fake this book."
			}, npc, creature)
		elseif player:getStorageValue(ThreatenedDreams.Mission01[1]) == 2 then
			npcHandler:say({
				"The poachers are still chasing me. Please hurry and find a way to help me."
			}, npc, creature)
		elseif player:getStorageValue(ThreatenedDreams.Mission01[1]) == 3 then
			npcHandler:say({
				"You succeeded! It seems the poachers have read your little faked story about killing white deer and the ensuing doom. They stopped chasing me. Thank you! ...",
				"You proved yourself trustworthy - at least as far as I am concerned. But as I told you I'm actually not a real animal. If you want to enter our hidden island, you must prove that you are also willing to help real animals. Would you do that?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(ThreatenedDreams.Mission01[1]) == 15 then
			npcHandler:say({
				"I'm very happy that you could help fae and animals alike. You earned our trust and may now visit our secret realm. I marked you with an arcane fae seal. Hereby you will be able to use the elemental shrines strewn about Tibia. ...",
				"There are fire, ice, energy and earth shrines. If you don't know their locations you can also reach them by most temples in this world. The elemental shrines will transport you to Feyrist now that you bear the magical seal."
			}, npc, creature)
			player:setStorageValue(ThreatenedDreams.Mission01[1], 16)
		else
			npcHandler:say({
				"I indeed have some troubles since I'm travelling this part of the world. When I took over the body of a white deer I wasn't aware that such an animal is a sought after quarry for hunters and poachers. ...",
				"Now I'm living in the constant danger of being caught and killed. Of course, I could just take over another animal but this deer has really grown on me. I'd like to help this beautiful stag but I need your assistance. Are you willing to help me?"
			}, npc, creature)
			npcHandler:setTopic(playerId, 1)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			if player:getStorageValue(ThreatenedDreams.QuestLine) == 1 then
				npcHandler:say("You have already started this mission.", npc, creature)
				npcHandler:setTopic(playerId, 0)
			else
				npcHandler:say({
					"Your decision honours you. However, if you consider killing the poachers in question I ask you to halt. We, the fae, are rather peaceful beings and abhor bloodshed. Therefore, we must find another way to solve this problem. ...",
					"I already have an idea: Some birds told me that poachers are a superstitious lot. Perhaps we can get them with their own misbelief. I know that the poachers have a kind of camp north of the Green Claw Swamps. ...",
					"Please search it out and examine it closely. Perhaps you will find something you can use against them in order to stop them from hunting white deer."
				}, npc, creature)
				player:setStorageValue(ThreatenedDreams.QuestLine, 1)
				player:setStorageValue(ThreatenedDreams.Mission01[1], 1)
				npcHandler:setTopic(playerId, 0)
			end
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"I heard there is a problem with a wolf mother and her whelps. However, I don't know more about it. One of my sisters, Ikassis, has taken over the body of a snake. ...",
				"She knows more about the wolf. Seek her out in the north-west of Edron, near a circle of standing stones."
			}, npc, creature)
			player:setStorageValue(ThreatenedDreams.Mission01[1], 4)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "no") then
		npcHandler:say("Then not.", npc, creature)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

keywordHandler:addKeyword({'deer'}, StdModule.say, {npcHandler = npcHandler, text = "Outside of our secret {realm} my siblings and I can't keep our true shape. If we want to travel other parts of the world, we must take over the bodies of animals. But we are causing them no harm and we just take control if necessary."})
keywordHandler:addKeyword({'realm'}, StdModule.say, {npcHandler = npcHandler, text = "We call it Feyrist and it is a secret, hidden place. Just few mortals get permission to enter it. A long time ago, we learned how to hide our realm from the outside world. Only if you gain our trust I will tell you how to reach it."})
keywordHandler:addKeyword({'siblings'}, StdModule.say, {npcHandler = npcHandler, text = "We call ourselves the fae. Some name us nature spirits or peri but we prefer the former term. Most of us are rather reclusive and live peaceful lives in our secret realm. We only leave it in order to {protect} our home. ..."})
keywordHandler:addKeyword({'kind'}, StdModule.say, {npcHandler = npcHandler, text = "We call ourselves the fae. Some name us nature spirits or peri but we prefer the former term. Most of us are rather reclusive and live peaceful lives in our secret realm. We only leave it in order to {protect} our home. ..."})
keywordHandler:addKeyword({'protect'}, StdModule.say, {npcHandler = npcHandler, text = "I can sense a kind of dark energy lately. It is pervading this world, more and more every day. Yet I don't know where it arises from nor what we could do to dispel it."})
keywordHandler:addKeyword({'energy'}, StdModule.say, {npcHandler = npcHandler, text = "It is rather subversive, so most creatures won't sense it ... yet. But its corrosive power has already begun to affect my kind and our hidden realm in unpleasant ways."})
keywordHandler:addKeyword({'fae'}, StdModule.say, {npcHandler = npcHandler,
	text = {
		'Some call us nature spirits or peri but we prefer the term fae. Most of us are rather reclusive and live peaceful lives in our secret realm. We only leave it in order to protect our home. ...',
		'We tend to be secretive about our true nature, but I guess there was once an elven sage who visited our realm and put his experiences down on paper. There might be a book about the fae in the library of Ab\'Dendriel.'
	}}
)

npcHandler:setMessage(MESSAGE_GREET, "Nature's blessing, traveller! |PLAYERNAME|!")
npcHandler:setMessage(MESSAGE_FAREWELL, "May your path always be even.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "May your path always be even.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
