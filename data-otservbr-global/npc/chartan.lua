local internalNpcName = "Chartan"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 338,
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

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if MsgContains(message, "mission") then
		if player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 2 then
			npcHandler:say("Mhm, what are you doing here. Who zent you? ", npc, creature)
			npcHandler:setTopic(playerId, 1)
		elseif player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 3 then
			npcHandler:say("Zo are you ready to get zomezing done?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif player:getStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline) == 5 then
			npcHandler:say("Zo? Did you find a way to reztore ze teleporter? ", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	elseif MsgContains(message, "zalamon") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say({
				"I zee. Zalamon zent word of ze arrival of a zoftzkin quite zome time ago. Zat muzt be you zen. ... ",
				"Well, I exzpected zomeone more - imprezzive. However, we will zee how far you can get. You've got newz from ze zouz? ... ",
				"Hm, I underztand. ... ",
				"Oh you did. ... ",
				"I zee. Interezting. ... ",
				"You being here meanz we have eztablished connectionz to ze zouz. Finally. And you are going to help uz. Well, zere iz zertainly a lot for you to do. Zo better get ztarted. ",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 3)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission01, 3) --Questlog, Wrath of the Emperor "Mission 01: Catering the Lions Den"
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 2 then
			npcHandler:say({
				"Alright. Well, az you might not be aware of it yet - we are on top of an old temple complex. It haz been abandoned and it haz crumbled over time. ...",
				"Ze teleporter over zere uzed to work juzt fine to get uz back to ze zouz. But it haz ztopped operating for quite zome time. ... ",
				"My men believe it iz a dizturbanze cauzed by ze corruption zat zpreadz everywhere. Zey are too zcared to go down zere. And zat'z where you come in. ... ",
				"Zere were meanz to activate teleporterz zomewhere in ze complex. But zinze you cannot reach all ze roomz, I guezz you will have to improvize. ... ",
				"Here iz ze key to ze entranze to ze complex. Figure zomezing out, reztore ze teleporter zo we can get back to ze plainz in ze zouz. ",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 4)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission02, 1) --Questlog, Wrath of the Emperor "Mission 02: First Contact"
			npcHandler:setTopic(playerId, 0)
		elseif npcHandler:getTopic(playerId) == 3 then
			npcHandler:say({
				"You did it! Zere waz zome kind of zparkle and I zink it iz working again - oh pleaze feel free to try it, I uhm, I will wait here and be ready juzt in caze zomezing uhm happenz to you. ... ",
				"And if you head to Zalamon, be zure to inform him about our zituation. Food rationz are running low and we are ztill not well equipped. We need to eztablish a working zupply line. ",
			}, npc, creature)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.TeleportAccess.Rebel, 1)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Questline, 6)
			player:setStorageValue(Storage.Quest.U8_6.WrathOfTheEmperor.Mission02, 3) --Questlog, Wrath of the Emperor "Mission 02: First Contact"
			npcHandler:setTopic(playerId, 0)
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Great Znake forgive me to converze wiz ziz unworzy blankzkin.")

npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

npcConfig.shop = {
	{ itemName = "avalanche rune", clientId = 3161, buy = 64 },
	{ itemName = "blank rune", clientId = 3147, buy = 10 },
	{ itemName = "chameleon rune", clientId = 3178, buy = 210 },
	{ itemName = "convince creature rune", clientId = 3177, buy = 80 },
	{ itemName = "cure poison rune", clientId = 3153, buy = 65 },
	{ itemName = "destroy field rune", clientId = 3148, buy = 15 },
	{ itemName = "dragonfruit", clientId = 11682, buy = 5 },
	{ itemName = "egg", clientId = 3606, buy = 3 },
	{ itemName = "empty potion flask", clientId = 283, sell = 5 },
	{ itemName = "empty potion flask", clientId = 284, sell = 5 },
	{ itemName = "empty potion flask", clientId = 285, sell = 5 },
	{ itemName = "energy field rune", clientId = 3164, buy = 38 },
	{ itemName = "energy wall rune", clientId = 3166, buy = 85 },
	{ itemName = "explosion rune", clientId = 3200, buy = 31 },
	{ itemName = "fire bomb rune", clientId = 3192, buy = 147 },
	{ itemName = "fire field rune", clientId = 3188, buy = 28 },
	{ itemName = "fire wall rune", clientId = 3190, buy = 61 },
	{ itemName = "great fireball rune", clientId = 3191, buy = 64 },
	{ itemName = "great health potion", clientId = 239, buy = 225 },
	{ itemName = "great mana potion", clientId = 238, buy = 158 },
	{ itemName = "great spirit potion", clientId = 7642, buy = 254 },
	{ itemName = "ham", clientId = 3582, buy = 10 },
	{ itemName = "health potion", clientId = 266, buy = 50 },
	{ itemName = "heavy magic missile rune", clientId = 3198, buy = 12 },
	{ itemName = "intense healing rune", clientId = 3152, buy = 95 },
	{ itemName = "light magic missile rune", clientId = 3174, buy = 4 },
	{ itemName = "mana potion", clientId = 268, buy = 56 },
	{ itemName = "poison field rune", clientId = 3172, buy = 21 },
	{ itemName = "poison wall rune", clientId = 3176, buy = 52 },
	{ itemName = "stalagmite rune", clientId = 3179, buy = 12 },
	{ itemName = "strong health potion", clientId = 236, buy = 115 },
	{ itemName = "strong mana potion", clientId = 237, buy = 108 },
	{ itemName = "sudden death rune", clientId = 3155, buy = 162 },
	{ itemName = "supreme health potion", clientId = 23375, buy = 650 },
	{ itemName = "ultimate healing rune", clientId = 3160, buy = 175 },
	{ itemName = "ultimate health potion", clientId = 7643, buy = 379 },
	{ itemName = "ultimate mana potion", clientId = 23373, buy = 488 },
	{ itemName = "ultimate spirit potion", clientId = 23374, buy = 488 },
	{ itemName = "vial", clientId = 2874, sell = 5 },
}
-- On buy npc shop message
npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
	npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
end
-- On sell npc shop message
npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
	player:sendTextMessage(MESSAGE_TRADE, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
end
-- On check npc shop message (look item)
npcType.onCheckItem = function(npc, player, clientId, subType) end

npcType:register(npcConfig)
