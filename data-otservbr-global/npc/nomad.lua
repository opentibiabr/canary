local internalNpcName = "Nomad"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 143,
	lookHead = 115,
	lookBody = 116,
	lookLegs = 59,
	lookFeet = 116,
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

-- Heart of the Mountain
local blessKeyword = keywordHandler:addKeyword({ "enhanced" }, StdModule.say, { npcHandler = npcHandler, text = "I am able to grant you the heart of the mountain's blessing. But I must ask of you to sacrifice |BLESSCOST| gold. Are you willing to part with that amount of wealth?" })
blessKeyword:addChildKeyword({ "yes" }, StdModule.bless, { npcHandler = npcHandler, text = "Receive the heart of the mountain then.", cost = "|BLESSCOST|", bless = 7 })
blessKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "Fine. You are free to decline my offer.", reset = true })

-- Healing
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = text }, function(player)
		return player:getCondition(condition) ~= nil
	end, function(player)
		player:removeCondition(condition)
		player:getPosition():sendMagicEffect(effect)
	end)
	keywordHandler:addAliasKeyword({ "help" })
end

addHealKeyword("You are burning. Let me quench those flames.", CONDITION_FIRE, CONST_ME_MAGIC_GREEN)
addHealKeyword("You are poisoned. Let me soothe your pain.", CONDITION_POISON, CONST_ME_MAGIC_RED)
addHealKeyword("You are electrified, my child. Let me help you to stop trembling.", CONDITION_ENERGY, CONST_ME_MAGIC_GREEN)

keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You are hurt, my child. I will heal your wounds." }, function(player)
	return player:getHealth() < 40
end, function(player)
	local health = player:getHealth()
	if health < 40 then
		player:addHealth(40 - health)
	end
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
end)
keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = "You aren't looking that bad. Sorry, I can't help you. But if you are looking for additional protection you should go on the {pilgrimage} of ashes or get the protection of the {twist of fate} here." })
keywordHandler:addAliasKeyword({ "help" })

-- Basic
keywordHandler:addKeyword({ "blessing" }, StdModule.say, {
	npcHandler = npcHandler,
	text = "Besides the {enhanced} blessing available from me, I know of one other, granted by a solitary {nomad} far west of Svargrond. There are also five different other blessings available, each in a sacred place. ...\nThese blessings are: the {spiritual} shielding, the spark of the {phoenix}, the {embrace} of Tibia, the fire of the {suns} and the wisdom of {solitude}.",
})

keywordHandler:addKeyword({ "pilgrimage" }, StdModule.say, { npcHandler = npcHandler, text = "Well, as I am quite in a {fix} currently, my only hope to escape this situation may be to grant you {healing} or an {enhanced} blessing if you wish. You must desire SOMETHING, right? Sure you do." })
keywordHandler:addAliasKeyword({ "job" })

keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of spiritual shielding in the whiteflower temple south of Thais." })
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of the two suns in the suntower near Ab'Dendriel." })
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon." })
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "Talk to the hermit Eremo on the isle of Cormaya about this blessing." })
keywordHandler:addAliasKeyword({ "wisdom" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "The druids north of Carlin will provide you with the embrace of Tibia." })
keywordHandler:addAliasKeyword({ "tibia" })

keywordHandler:addKeyword({ "djinn" }, StdModule.say, { npcHandler = npcHandler, text = "I know of a mysterious djinn, bound to an existence of slavery far to the north of Tiquanda's jungles. He is bound to tell you his secrets and offer you the 'blood of the mountain'. ...\nI do not know where exactly but I guess you must first dig that one out to actually talk to him." })
keywordHandler:addKeyword({ "nomad" }, StdModule.say, { npcHandler = npcHandler, text = "I am one with nature, one with the ice and the cold. Names are of no worth out here. Out here, you face isolation and loneliness. Only your strength, willpower and {training} can keep you alive." })
keywordHandler:addKeyword({ "training" }, StdModule.say, { npcHandler = npcHandler, text = "My life is one of hardship, hardship I chose freely. Endurance, strength and the power of the will are my only companions in this frigid wilderness. My strength comes from disciplined training and knowledge of the outdoors." })

npcHandler:setMessage(MESSAGE_GREET, "Ah, another diciple of the extreme... surviving the icy outdoors? Let me {help}! If you need some first aid out here, I can provide {healing} or grant you an {enhanced} blessing!")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Keep a stiff upper lip!")
npcHandler:setMessage(MESSAGE_FAREWELL, "Keep a stiff upper lip!")

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
