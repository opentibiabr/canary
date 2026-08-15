local internalNpcName = "Quentin"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 57,
}

npcConfig.flags = {
	floorchange = false,
	profession = "normal",
}
npcConfig.speechBubble = SPEECHBUBBLE_NORMAL

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

-- Wooden Stake Quest
local stakeKeyword = keywordHandler:addKeyword({ "stake" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"A blessed stake to defeat evil spirits? I do know an old prayer which is said to grant sacred power and to be able to bind this power to someone, or something. ...",
		"However, this prayer needs the combined energy of ten priests. Each of them has to say one line of the prayer. ...",
		"I could start with the prayer, but since the next priest has to be in a different location, you probably will have to travel a lot. ...",
		"Is this stake really important enough to you so that you are willing to take this burden?",
	},
}, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == -1
end)
stakeKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Alright, I guess you need a stake first. Maybe Gamon can help you, the leg of a chair or something could just do. Try asking him for a stake, and if you have one, bring it back to me.", reset = true, ungreet = true }, nil, function(player)
	player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.DefaultStart, 1)
	player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake, 1)
end)

-- First prayer
keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "I guess you couldn't convince Gamon to give you a stake, eh?" }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 1 and player:getItemCount(5941) == 0
end)

local stakeKeyword = keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, I see you brought a stake with you. Are you ready to receive my line of the prayer then?" }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 1
end)
stakeKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "So receive my prayer: 'Light shall be near - and darkness afar'. Now, bring your stake to Tibra in the Carlin church for the next line of the prayer. I will inform her what to do.", reset = true }, nil, function(player)
	player:setStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake, 2)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
end)
stakeKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "I will wait for you.", reset = true })

keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "You should visit Tibra in the Carlin church now." }, function(player)
	return player:getStorageValue(Storage.Quest.U7_8.FriendsAndTraders.TheBlessedStake) == 2
end)
keywordHandler:addKeyword({ "stake" }, StdModule.say, { npcHandler = npcHandler, text = "You already received my line of the prayer." })

-- Twist of Fate
local blessKeyword = keywordHandler:addKeyword({ "twist of fate" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"This is a special blessing I can bestow upon you once you have obtained at least one of the other blessings and which functions a bit differently. ...",
		"It only works when you're killed by other adventurers, which means that at least half of the damage leading to your death was caused by others, not by monsters or the environment. ...",
		"The {twist of fate} will not reduce the death penalty like the other blessings, but instead prevent you from losing your other blessings as well as the amulet of loss, should you wear one. It costs the same as the other blessings. ...",
		"Would you like to receive that protection for a sacrifice of |PVPBLESSCOST| gold, child?",
	},
})
blessKeyword:addChildKeyword({ "yes" }, StdModule.bless, { npcHandler = npcHandler, text = "So receive the protection of the twist of fate, pilgrim.", cost = "|PVPBLESSCOST|", bless = 1 })
blessKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "Fine. You are free to decline my offer.", reset = true })

-- Adventurer Stone
keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Keep your adventurer's stone well." }, function(player)
	return player:getItemById(16277, true)
end)

local stoneKeyword = keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, you want to replace your adventurer's stone for free?" }, function(player)
	return player:getStorageValue(Storage.Quest.U9_80.AdventurersGuild.FreeStone.Quentin) ~= 1
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, nil, function(player)
	player:addItem(16277, 1)
	player:setStorageValue(Storage.Quest.U9_80.AdventurersGuild.FreeStone.Quentin, 1)
end)
stoneKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "No problem.", reset = true })

local stoneKeyword = keywordHandler:addKeyword({ "adventurer stone" }, StdModule.say, { npcHandler = npcHandler, text = "Ah, you want to replace your adventurer's stone for 30 gold?" })
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Here you are. Take care.", reset = true }, function(player)
	return player:getMoney() + player:getBankBalance() >= 30
end, function(player)
	if player:removeMoneyBank(30) then
		player:addItem(16277, 1)
	end
end)
stoneKeyword:addChildKeyword({ "yes" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, you don't have enough money.", reset = true })
stoneKeyword:addChildKeyword({ "" }, StdModule.say, { npcHandler = npcHandler, text = "No problem.", reset = true })

-- Healing
local function addHealKeyword(text, condition, effect)
	keywordHandler:addKeyword({ "heal" }, StdModule.say, { npcHandler = npcHandler, text = text }, function(player)
		return player:getCondition(condition) ~= nil
	end, function(player)
		player:removeCondition(condition)
		player:getPosition():sendMagicEffect(effect)
	end)
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

-- Basic
keywordHandler:addKeyword({ "pilgrimage" }, StdModule.say, { npcHandler = npcHandler, text = "Whenever you receive a lethal wound, your vital force is damaged and there is a chance that you lose some of your equipment. With every single of the five {blessings} you have, this damage and chance of loss will be reduced." })
keywordHandler:addKeyword({ "blessings" }, StdModule.say, { npcHandler = npcHandler, text = "There are five blessings available in five sacred places: the {spiritual} shielding, the spark of the {phoenix}, the {embrace} of Tibia, the fire of the {suns} and the wisdom of {solitude}. Additionally, you can receive the {twist of fate} here." })
keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "I see you received the spiritual shielding in the whiteflower temple south of Thais." }, function(player)
	return player:hasBlessing(1)
end)
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense that the druids north of Carlin have provided you with the Embrace of Tibia." }, function(player)
	return player:hasBlessing(2)
end)
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "I can see you received the blessing of the two suns in the suntower near Ab'Dendriel." }, function(player)
	return player:hasBlessing(3)
end)
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense that the spark of the phoenix already was given to you by the dwarven priests of earth and fire in Kazordoon." }, function(player)
	return player:hasBlessing(4)
end)
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "I can sense you already talked to the hermit Eremo on the isle of Cormaya and received this blessing." }, function(player)
	return player:hasBlessing(5)
end)
keywordHandler:addAliasKeyword({ "wisdom" })
keywordHandler:addKeyword({ "spiritual" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of spiritual shielding in the whiteflower temple south of Thais." })
keywordHandler:addAliasKeyword({ "shield" })
keywordHandler:addKeyword({ "embrace" }, StdModule.say, { npcHandler = npcHandler, text = "The druids north of Carlin will provide you with the embrace of Tibia." })
keywordHandler:addKeyword({ "suns" }, StdModule.say, { npcHandler = npcHandler, text = "You can ask for the blessing of the two suns in the suntower near Ab'Dendriel." })
keywordHandler:addAliasKeyword({ "fire" })
keywordHandler:addKeyword({ "phoenix" }, StdModule.say, { npcHandler = npcHandler, text = "The spark of the phoenix is given by the dwarven priests of earth and fire in Kazordoon." })
keywordHandler:addAliasKeyword({ "spark" })
keywordHandler:addKeyword({ "solitude" }, StdModule.say, { npcHandler = npcHandler, text = "Talk to the hermit Eremo on the isle of Cormaya about this blessing." })
keywordHandler:addAliasKeyword({ "wisdom" })

npcHandler:setMessage(MESSAGE_GREET, "Welcome, young |PLAYERNAME|! If you are heavily wounded or poisoned, I can {heal} you for free or you want the {adventurer stone}?")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Remember: If you are heavily wounded or poisoned, I can heal you for free.")
npcHandler:setMessage(MESSAGE_FAREWELL, "May the gods bless you, |PLAYERNAME|!")

-- Dialogue keywords the NPC answers on the official server
keywordHandler:addKeyword({ "harkath bloodblade" }, StdModule.say, { npcHandler = npcHandler, text = "A hard man but his heart is in the right place." })
keywordHandler:addKeyword({ "ferumbras" }, StdModule.say, { npcHandler = npcHandler, text = "Hush! Do not mention the Evil One in these walls." })
keywordHandler:addKeyword({ "excalibug" }, StdModule.say, { npcHandler = npcHandler, text = "Legends tell us that that Excalibug is a gift of the gods. Banor used in his battles. They say it was passed on to one of his followers." })
keywordHandler:addKeyword({ "equipment" }, StdModule.say, { npcHandler = npcHandler, text = "First you should buy a bag or backpack. That way your hands will be free to hold a weapon and a shield." })
keywordHandler:addKeyword({ "tibianus" }, StdModule.say, { npcHandler = npcHandler, text = "Our king resides in the castle to the west." })
keywordHandler:addKeyword({ "mcronald" }, StdModule.say, { npcHandler = npcHandler, text = "The McRonalds run the local farm." })
keywordHandler:addKeyword({ "eclesius" }, StdModule.say, { npcHandler = npcHandler, text = "I hope I won't become that forgetful when I'm old. But he is a good man, although I don't know him very well." })
keywordHandler:addKeyword({ "general" }, StdModule.say, { npcHandler = npcHandler, text = "Harkath Bloodblade is his name." })
keywordHandler:addKeyword({ "plants" }, StdModule.say, { npcHandler = npcHandler, text = "Just walk around, you will see grass, trees, and bushes." })
keywordHandler:addKeyword({ "people" }, StdModule.say, { npcHandler = npcHandler, text = "I am a simple monk. I just know Sam, Frodo, and Gorn. They all live in the main street to the north." })
keywordHandler:addKeyword({ "muriel" }, StdModule.say, { npcHandler = npcHandler, text = "Muriel is a famous sorcerer. He is the keeper of arcane secrets that are known only to few mortals." })
keywordHandler:addKeyword({ "gregor" }, StdModule.say, { npcHandler = npcHandler, text = "The leader of the Knights' guild is a man of few words." })
keywordHandler:addKeyword({ "marvik" }, StdModule.say, { npcHandler = npcHandler, text = "I admire the healing skills of Marvik." })
keywordHandler:addKeyword({ "baxter" }, StdModule.say, { npcHandler = npcHandler, text = "He is the guard of the royal castle." })
keywordHandler:addKeyword({ "oswald" }, StdModule.say, { npcHandler = npcHandler, text = "This man is spreading horrible rumours all the time." })
keywordHandler:addKeyword({ "donald" }, StdModule.say, { npcHandler = npcHandler, text = "The McRonalds run the local farm." })
keywordHandler:addKeyword({ "sherry" }, StdModule.say, { npcHandler = npcHandler, text = "The McRonalds run the local farm." })
keywordHandler:addKeyword({ "spider" }, StdModule.say, { npcHandler = npcHandler, text = "There are spiders' nests beyond our city near Gorn's shop and at the McRonalds' farm in the east." })
keywordHandler:addKeyword({ "tibia" }, StdModule.say, { npcHandler = npcHandler, text = "That is where we are. The world of Tibia. Admire its beauty." })
keywordHandler:addKeyword({ "frodo" }, StdModule.say, { npcHandler = npcHandler, text = "He is the owner of Frodo's Hut, the tavern north of this temple." })
keywordHandler:addKeyword({ "elane" }, StdModule.say, { npcHandler = npcHandler, text = "She is the leader of the local Paladins' guild." })
keywordHandler:addKeyword({ "lynda" }, StdModule.say, { npcHandler = npcHandler, text = "She is a highly competent priest." })
keywordHandler:addKeyword({ "lugri" }, StdModule.say, { npcHandler = npcHandler, text = "Please do not mention the fallen one." })
keywordHandler:addKeyword({ "money" }, StdModule.say, { npcHandler = npcHandler, text = "If you need money you should slay monsters and take their gold. Look for spiders and rats." })
keywordHandler:addKeyword({ "sewer" }, StdModule.say, { npcHandler = npcHandler, text = "You can enter the sewers thorugh a sewer grate. But watch out. There are many rats. And don't forget to bring a torch." })
keywordHandler:addKeyword({ "fight" }, StdModule.say, { npcHandler = npcHandler, text = "Take a weapon into your hand and select a target. If you are wounded you should eat some food to heal your wounds." })
keywordHandler:addKeyword({ "name" }, StdModule.say, { npcHandler = npcHandler, text = "My name is Quentin." })
keywordHandler:addKeyword({ "news" }, StdModule.say, { npcHandler = npcHandler, text = "Sorry, I know nothing new. Please ask Frodo about that topic." })
keywordHandler:addKeyword({ "life" }, StdModule.say, { npcHandler = npcHandler, text = "On Tibia there are many forms of life. There are plants and people and monsters." })
keywordHandler:addKeyword({ "king" }, StdModule.say, { npcHandler = npcHandler, text = "Our king resides in the castle to the west." })
keywordHandler:addKeyword({ "army" }, StdModule.say, { npcHandler = npcHandler, text = "I don't know much about the Tibian army. Ask general Harkath Bloodblade about that." })
keywordHandler:addKeyword({ "gorn" }, StdModule.say, { npcHandler = npcHandler, text = "He is selling equipment. If you still have no backpack you should go and ask him for one." })
keywordHandler:addKeyword({ "bozo" }, StdModule.say, { npcHandler = npcHandler, text = "He is the king's jester, but he believes himself to be the king of fools." })
keywordHandler:addKeyword({ "gold" }, StdModule.say, { npcHandler = npcHandler, text = "If you need money you should slay monsters and take their gold. Look for spiders and rats." })
keywordHandler:addKeyword({ "slay" }, StdModule.say, { npcHandler = npcHandler, text = "Take a weapon into your hand and select a target. If you are wounded you should eat some food to heal your wounds." })
keywordHandler:addKeyword({ "food" }, StdModule.say, { npcHandler = npcHandler, text = "If you would like to heal your wounds you should eat some food. Frodo sells excellent meals. But if you are very weak you can also come to me. I will heal you." })
keywordHandler:addKeyword({ "job" }, StdModule.say, { npcHandler = npcHandler, text = "Job? I have no job. I just live for the gods of Tibia." })
keywordHandler:addKeyword({ "god" }, StdModule.say, { npcHandler = npcHandler, text = "They created Tibia and all life on it." })
keywordHandler:addKeyword({ "sam" }, StdModule.say, { npcHandler = npcHandler, text = "He is our blacksmith. He sells weapons and armour." })
keywordHandler:addKeyword({ "rat" }, StdModule.say, { npcHandler = npcHandler, text = "There are sewers underneath the city. They say these sewers are brimming with rats." })
keywordHandler:addKeyword({ "eat" }, StdModule.say, { npcHandler = npcHandler, text = "If you would like to heal your wounds you should eat some food. Frodo sells excellent meals. But if you are very weak you can also come to me. I will heal you." })

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
