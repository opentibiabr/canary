local internalNpcName = "Tomruk The Ruddy"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 553
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = 'Interesting reaction. Bloodcurdling. Must inspect further.' },
	{ text = 'This is really sanguine!' },
	{ text = 'Hmm... the conductors are too dry to transmit energy.' },
	{ text = 'Ah, fresh blood. My favourite.' }
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

	if(MsgContains(message, 'scroll') or MsgContains(message, 'mission')) and player:getStorageValue(Storage.GravediggerOfDrefia.Mission35) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission36) < 1 then
		npcHandler:say({
			"So someone sent you after a scroll, eh? A stroll for a scroll! <chuckles> Sounds like an old-fashioned necromancer thing. ...",
			"Well, this piece here is a rather fascinating thing - see those strange blood stains? - ...",
			"My predecessors have had it for quite a while without finding out more - I was hoping to investigate, but there's always so much to do! ...",
			"Ah, so you want it, too? Well, do me a favour: fetch two samples and assist in my experiment, in exchange for the scroll piece. Yes?"
		}, npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission35) == 1 then
		npcHandler:say({
			"Sanguine! I need two different blood samples - The first one from the necromancer's pure blood chamber. ... ",
			"I was barred from the premises. For my research! Shameful! I'm a martyr to the cause - oh, the second sample you said? ...",
			"The second sample you must retrieve from the sacrificial chamber in the ancient vampire crypts, first floor, far west. ...",
			"Take these two sterilised vials, one for each blood basin. Oh, I wish I could go myself! Come back when you have filled both vials."
		}, npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission36, 1)
		player:addItem(19100, 2)
		npcHandler:setTopic(playerId, 0)
	elseif(MsgContains(message, 'scroll') or MsgContains(message, 'mission') or MsgContains(message, 'blood')) and player:getStorageValue(Storage.GravediggerOfDrefia.Mission37) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission38) < 1 then
		npcHandler:say("Hello hello! Did you bring those blood samples?", npc, creature)
		npcHandler:setTopic(playerId, 2)
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 2 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission37) == 1 then
		if player:getItemCount(19102) >= 1 and player:getItemCount(19101) >= 1 then
			npcHandler:say({
				"Now, let me see... yes... yes... very good. Let me add THIS ..... swill it... there. Sanguine! ...",
				"We're not finished yet. Take this tainted blood vial ...",
				"Dab some drops from it on to the four blood pagodas in the inner circle here. Then pull the lightning lever over there."
			}, npc, creature)
			player:setStorageValue(Storage.GravediggerOfDrefia.Mission38, 1)
			player:removeItem(19101, 1)
			player:removeItem(19102, 1)
			player:addItem(19133, 1)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You haven't got any blood.", npc, creature)
			npcHandler:setTopic(playerId, 0)
		end
	elseif(MsgContains(message, 'scroll') or MsgContains(message, 'mission')) and player:getStorageValue(Storage.GravediggerOfDrefia.Mission40) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission41) < 1 then
		npcHandler:say("Hello hello! Did Hello hello! Well now, painted all those blood pagodas properly?", npc, creature)
		npcHandler:setTopic(playerId, 3)
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 3 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission40) == 1 then
		npcHandler:say({
			"Sanguine! Did you see those sparks! We definitely had some energy transfer! Well done! Now, for your reward. ...",
			"Err... I would awfully like to know more about the scroll ...",
			"Would you settle for a heartfelt handshake instead - oh, you wouldn't? Well, er, okay ...",
			"Give me a minute or two to retrieve it. Ask me for the {scroll} or the {mission}"
		}, npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission41, 1)
		npcHandler:setTopic(playerId, 0)
	elseif(MsgContains(message, 'scroll') or MsgContains(message, 'mission')) and player:getStorageValue(Storage.GravediggerOfDrefia.Mission41) == 1 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission42) < 1 then
		npcHandler:say("Hello hell- oh, you've come for the scroll, haven't you?", npc, creature)
		npcHandler:setTopic(playerId, 4)
	elseif MsgContains(message, 'yes') and npcHandler:getTopic(playerId) == 4 and player:getStorageValue(Storage.GravediggerOfDrefia.Mission41) == 1 then
		npcHandler:say("My heart bleeds to part from it. Here. Extend your hand - I'll just retrieve some blood from in exchange - HOLD STILL.", npc, creature)
		player:setStorageValue(Storage.GravediggerOfDrefia.Mission42, 1)
		player:addItem(18933, 1)
		npcHandler:setTopic(playerId, 0)
	end
	return true
end

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
