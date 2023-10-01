local internalNpcName = "The Empress"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1188,
	lookHead = 79,
	lookBody = 0,
	lookLegs = 0,
	lookFeet = 3,
	lookAddons = 3
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

local function greetCallback(npc, creature)
	local player = Player(creature)
	local playerId = player:getId()

	if player:getStorageValue(Storage.Kilmaresh.Fifth.Memories) == 4 then
		player:addItem(31414, 1)
		npcHandler:setMessage(MESSAGE_GREET, {
			"I see. There is enough and adequate evidence that the Ambassador of Rathleton is indeed an arch traitor. So, Eshaya was right. Well done, mortal being. You have proven your loyalty and bravery, therefore allow me to ask you one more favour. ...", 
			"The Cult of Fafnar is a serious problem for Issavi. The cultists are roaming the sewers and catacombs beneath the city now and again but this time they are really up to something. ...",
			"As a member of the Sapphire Blade found out, they are planning to cause a major earthquake, that could severely damage or even destroy Issavi. You may wonder how. ...",
			"Well, they want to activate five Fafnar statues which they have already enchanted. They are hidden in the catacombs underneath the city. Please go down and search for the statues. ...",
			"Then use this sceptre to bless them in the name of Suon and Bastesh. This will destroy the disastrous enchantment and Issavi will be safe again."
		})
		player:setStorageValue(Storage.Kilmaresh.Sixth.Favor, 1)
		player:setStorageValue(Storage.Kilmaresh.Sixth.FourMasks, 0)
		player:setStorageValue(Storage.Kilmaresh.Sixth.BlessedStatues, 0)
		player:setStorageValue(Storage.Kilmaresh.Fifth.Memories, 6)
	else
		npcHandler:setMessage(MESSAGE_GREET, "Greetings.")
	end
	return true
end

local masksDialogue = keywordHandler:addKeyword(
	{"mission"}, StdModule.say, { npcHandler = npcHandler,
	text = "Did you take all the masks and enchant all the statues?"},
	function (player) return player:getStorageValue(Storage.Kilmaresh.Sixth.Favor) == 10 end
)

	masksDialogue:addChildKeyword(
		{"yes"}, StdModule.say, { npcHandler = npcHandler,
		text = "Thank you."},
		nil,
		function (player)
			player:addItem(31573, 1) -- Sun Medal
			player:setStorageValue(Storage.Kilmaresh.Sixth.Favor, 11)
		end
	)

npcHandler:setMessage(MESSAGE_WALKAWAY, 'Well, bye then.')

npcHandler:setCallback(CALLBACK_SET_INTERACTION, onAddFocus)
npcHandler:setCallback(CALLBACK_REMOVE_INTERACTION, onReleaseFocus)
npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
