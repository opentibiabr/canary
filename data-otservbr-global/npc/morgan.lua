local internalNpcName = "Morgan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 134,
	lookHead = 78,
	lookBody = 120,
	lookLegs = 122,
	lookFeet = 132,
	lookAddons = 2
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, 'firebird') then
		if player:getStorageValue(Storage.OutfitQuest.PirateSabreAddon) == 4 then
			player:setStorageValue(Storage.OutfitQuest.PirateSabreAddon, 5)
			player:addOutfitAddon(151, 1)
			player:addOutfitAddon(155, 1)
			player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
			npcHandler:say(
				'Ahh. So Duncan sent you, eh? You must have done something really impressive. \
				Okay, take this fine sabre from me, mate.',
			creature)
		end
	elseif MsgContains(message, 'mission') then
		if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 3 then
			npcHandler:say(
				{
					'Hm, if you are that eager to work I have an idea how you could help me out. \
					A distant relative of mine, the old sage Eremo lives on the isle Cormaya, near Edron. ...',
					"He has not heard from me since ages. He might assume that I am dead. \
					Since I don't want him to get into trouble for receiving a letter from a \
					pirate I ask you to deliver it personally. ...",
					"Of course it's a long journey but you asked for it. \
					You will have to prove us your worth. Are you up to that?"
				},
			creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 5 then
			npcHandler:say('Thank you for delivering my letter to Eremo. I have no more missions for you.', npc, creature)
			player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 6)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "warrior's sword") then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 142 or 134, 2) then
			npcHandler:say('You already have this outfit!', npc, creature)
			return true
		end

		if player:getStorageValue(Storage.OutfitQuest.WarriorSwordAddon) < 1 then
			player:setStorageValue(Storage.OutfitQuest.WarriorSwordAddon, 1)
			npcHandler:say('Great! Simply bring me 100 iron ore and one royal steel and I will happily {forge} it for you.', npc, creature)
		elseif player:getStorageValue(Storage.OutfitQuest.WarriorSwordAddon) == 1 and npcHandler:getTopic(playerId) == 1 then
			if player:getItemCount(5887) > 0 and player:getItemCount(5880) > 99 then
				player:removeItem(5887, 1)
				player:removeItem(5880, 100)
				player:addOutfitAddon(134, 2)
				player:addOutfitAddon(142, 2)
				player:setStorageValue(Storage.OutfitQuest.WarriorSwordAddon, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				player:addAchievementProgress('Wild Warrior', 2)
				npcHandler:say('Alright! As a matter of fact, I have one in store. Here you go!', npc, creature)
			else
				npcHandler:say('You do not have all the required items.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "knight's sword") then
		if player:hasOutfit(player:getSex() == PLAYERSEX_FEMALE and 139 or 131, 1) then
			npcHandler:say('You already have this outfit!', npc, creature)
			return true
		end

		if player:getStorageValue(Storage.OutfitQuest.Knight.AddonSword) < 1 then
			player:setStorageValue(Storage.OutfitQuest.Knight.AddonSword, 1)
			npcHandler:say('Great! Simply bring me 100 Iron Ore and one Crude Iron and I will happily {forge} it for you.', npc, creature)
		elseif player:getStorageValue(Storage.OutfitQuest.Knight.AddonSword) == 1 and npcHandler:getTopic(playerId) == 1 then
			if player:getItemCount(5892) > 0 and player:getItemCount(5880) > 99 then
				player:removeItem(5892, 1)
				player:removeItem(5880, 100)
				player:addOutfitAddon(131, 1)
				player:addOutfitAddon(139, 1)
				player:setStorageValue(Storage.OutfitQuest.Knight.AddonSword, 2)
				player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
				npcHandler:say('Alright! As a matter of fact, I have one in store. Here you go!', npc, creature)
			else
				npcHandler:say('You do not have all the required items.', npc, creature)
			end
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, 'forge') then
		npcHandler:say("What would you like me to forge for you? A {knight's sword} or a {warrior's sword}?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, 'yes') then
		if npcHandler:getTopic(playerId) == 2 then
			if player:getStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven) == 3 then
				npcHandler:say('Alright, we will see. Here, take this letter and deliver it safely to old Eremo on Cormaya.', npc, creature)
				player:addItem(3506, 1)
				player:setStorageValue(Storage.TheShatteredIsles.ReputationInSabrehaven, 4)
				npcHandler:setTopic(playerId, 0)
			end
		end
	end
	return true
end

keywordHandler:addKeyword(
	{'addon'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = 'I can forge the finest {weapons} for knights and warriors. \
		They may wear them proudly and visible to everyone.'
	}
)
keywordHandler:addKeyword(
	{'weapons'},
	StdModule.say,
	{
		npcHandler = npcHandler,
		text = "Would you rather be interested in a {knight's sword} or in a {warrior's sword}?"
	}
)

npcHandler:setMessage(MESSAGE_GREET, 'Hello there.')
npcHandler:setMessage(MESSAGE_FAREWELL, 'Good bye.')

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
