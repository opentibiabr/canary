local internalNpcName = "Dedoras"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 146,
	lookHead = 76,
	lookBody = 57,
	lookLegs = 78,
	lookFeet = 77,
	lookAddons = 2,
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

local quests = {
	[1] = { stg = Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Questline, value = 4 },
	[2] = { stg = Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, value = 8 },
	[3] = { stg = Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline, value = 7 },
	[4] = { stg = Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline, value = 3 },
	[5] = { stg = Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, value = 9 },
	[6] = { stg = Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, value = 8 },
}

local function startMission(pid, storage, value)
	local player = Player(pid)
	if player then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Questlog) < 1 then
			player:setStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Questlog, 1)
		end
		if player:getStorageValue(storage) < value then
			player:setStorageValue(storage, value)
		end
	end
end

local function isQuestDone(pid)
	local player = Player(pid)
	if player then
		for i = 1, #quests do
			if player:getStorageValue(quests[i].stg) ~= quests[i].value then
				return false
			end
		end
	end
	return true
end

local function creatureSayCallback(npc, creature, type, message)
	local player = Player(creature)
	local playerId = player:getId()

	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	local currentStorage = player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission)
	if currentStorage < 0 then
		currentStorage = 0
	end

	if MsgContains(message, "search") then
		npcHandler:say({
			"I gathered some lore on my own, but I desperately need more information that you might provide me. ...",
			"My leads are the {museum} in thais, something strange in the darashian {desert}, rumors about {fishmen}, an ancient {order}, the mysterious {asuri}, or a lost {isle}?",
		}, npc, creature)
	elseif MsgContains(message, "museum") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) == 7 then
			npcHandler:say({
				"This is ...",
				"An astonishing find to say the least! I'm certain it will help the efforts of accessing the library a lot!",
			}, npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, currentStorage + 1)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 8)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline) < 1 then
			npcHandler:say("I have heard that it was recently planned to expand the Museum of Tibian Arts. In the course of these activities unexpected difficulties occurred.", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.MoTA.Questline, 1)
		end
	elseif MsgContains(message, "desert") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline) == 8 then
			npcHandler:say("That's simply a scientific sensation. It will provide me with lots of much needed knowledge!", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, currentStorage + 1)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, 9)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline) < 1 then
			npcHandler:say("There are rumors of a mysterious statue in the desert next to Darashia. Nobody really knows the meaning of it.", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.Darashia.Questline, 1)
		end
	elseif MsgContains(message, "fishmen") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) == 7 then
			npcHandler:say("You brought incredible news. This book proves an invaluable clue!", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, currentStorage + 1)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, 8)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline) < 1 then
			npcHandler:say({
				"Sightings of strange fishmen in Tiquanda are stirring up the region. You should be careful when investigating this. ...",
				"As far as I know a scholar in Edron already dealt with fish-like creatures before.",
			}, npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LiquidDeath.Questline, 1)
		end
	elseif MsgContains(message, "order") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline) == 2 then
			npcHandler:say("You brought incredible news. This book proves an invaluable clue!", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, currentStorage + 1)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline, 3)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline) < 1 then
			npcHandler:say({
				"Our world has seen many noble knights and orders throughout the centuries. Most of them vanished a long time ago but only few under such mysterious circumstances as the Order of the Falcon. ...",
				"This noble alliance of honourable knights once resided in Edron to serve the king. Legend has it they vanished practically over night. Rumor has it their disappearance is connected to a forbidden book.",
			}, npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.FalconBastion.Questline, 1)
		end
	elseif MsgContains(message, "asuri") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline) == 6 then
			npcHandler:say("This is incredible! Thank you so much for digging out that hint!", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, currentStorage + 1)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline, 7)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline) < 1 then
			npcHandler:say({
				"There's a beautiful but very dangerous palace in the Tiquandan jungle. The young women who live there are actually demons and they are luring unsuspecting mortals in there. ...",
				"A lucky survivor told me about a portal at the very top of the palace that may lead to another asuri hideout.",
			}, npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.Asuras.Questline, 1)
		end
	elseif MsgContains(message, "isle") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Questline) == 3 then
			npcHandler:say("Thank you so much for your efforts to provide this valuable piece of the puzzle!", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, currentStorage + 1)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Questline, 4)
		elseif player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Questline) < 1 then
			npcHandler:say("Talk to Captain Charles in Port Hope. He told me that he once ran ashore on a small island where he discovered a small ruin. The architecture was like nothing he had seen before.", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.SmallIslands.Questline, 1)
		end
	elseif MsgContains(message, "progress") then
		if player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission) < 6 then
			npcHandler:say({
				"About what of your mission s do you want to report? The {museum}, the darashian {desert}, the rumors about strange {fishmen}, the ancient {order}, the mysterious {asuri}, or the lost {isle}? ...",
				"Or shall me {check} how much information we acquired?",
			}, npc, creature)
		end
	elseif MsgContains(message, "check") then
		if isQuestDone(player:getId()) and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission) == 6 then
			npcHandler:say({
				"Marvellous! With this information combined we have all that's needed! ...",
				"So let me see. ...",
				"Hmm, interesting. And we shouldn't forget about the chant! Yes, excellent! ...",
				"So listen: To enter the veiled library, travel to the white raven monastery on the Isle of Kings and enter its main altar room. ...",
				"There, use an ordinary scythe on the right of the two monuments, while concentrating on this glyph here and chant the words: Chamek Athra Thull Zathroth ...",
				"Oh, and one other thing. For your efforts I want to reward you with one of my old outfits, back from my adventuring days. May it suit you well! ...",
				"Hurry now my friend. Time is of essence!",
			}, npc, creature)
			player:addOutfit(1069, 0)
			player:addOutfit(1070, 0)
			player:addAchievement("Battle Mage")
			startMission(player:getId(), Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission, 7)
			npcHandler:setTopic(playerId, 0)
		else
			npcHandler:say("You're still searching for informations.", npc, creature)
		end
	end

	if MsgContains(message, "addon") and player:getStorageValue(Storage.Quest.U11_80.TheSecretLibrary.LibraryPermission) == 7 then
		npcHandler:say("Are you interested in one or two addons to your battle mage outfit?", npc, creature)
		npcHandler:setTopic(playerId, 1)
	elseif MsgContains(message, "book") and npcHandler:getTopic(playerId) == 3 then
		if player:getStorageValue(Storage.Quest.U11_80.BattleMageOutfits.Addon1) < 1 and player:getItemCount(28792) > 5 then
			player:removeItem(28792, 5)
			player:addOutfit(1069, 1)
			player:addOutfit(1070, 1)
			npcHandler:say("Very good! You gained the first addon to the battle mage outfit.", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.BattleMageOutfits.Addon1, 1)
			npcHandler:setTopic(playerId, 0)
		elseif player:getStorageValue(Storage.Quest.U11_80.BattleMageOutfits.Addon2) < 1 and player:getItemCount(28793) > 20 then
			player:removeItem(28793, 20)
			player:addOutfit(1069, 2)
			player:addOutfit(1070, 2)
			npcHandler:say("Very good! You gained the second addon to the battle mage outfit.", npc, creature)
			startMission(player:getId(), Storage.Quest.U11_80.BattleMageOutfits.Addon2, 1)
			npcHandler:setTopic(playerId, 0)
		end
	elseif MsgContains(message, "yes") then
		if npcHandler:getTopic(playerId) == 1 then
			npcHandler:say("I provide two addons. For the first one I need you to bring me five sturdy books. For the second addon you need twenty epaulettes. Do you want one of these addons?", npc, creature)
			npcHandler:setTopic(playerId, 2)
		elseif npcHandler:getTopic(playerId) == 2 then
			npcHandler:say("What do you have for me: the sturdy books or the epaulettes?", npc, creature)
			npcHandler:setTopic(playerId, 3)
		end
	end

	return true
end

keywordHandler:addKeyword({ "looking" }, StdModule.say, { npcHandler = npcHandler, text = "I need the help of some competent {adventurers} to handle a threat to all creation." })
keywordHandler:addKeyword({ "value" }, StdModule.say, { npcHandler = npcHandler, text = "This leaves us with no choice but to take action into our own {hands}." })
keywordHandler:addKeyword({ "threat" }, StdModule.say, { npcHandler = npcHandler, text = "I guess you know about the {background} and there is no need to tell you that the forces from beyond managed to acquire the parts of the godbreaker in a coup." })
keywordHandler:addKeyword({ "disassembled" }, StdModule.say, { npcHandler = npcHandler, text = "The secret locations of the godbreaker {parts} were revealed and due to trickery, the minions of Variphor aquired all of them." })
keywordHandler:addKeyword({ "obscure" }, StdModule.say, { npcHandler = npcHandler, text = "Those pieces of knowledge come in several forms and shapes. For most I can give you more or less specific hints where to start your {search}." })
keywordHandler:addKeyword({ "hands" }, StdModule.say, { npcHandler = npcHandler, text = "You have to {find} the veiled hoard of Zathroth, breach it and destroy the knowledge how to use the godbreaker." })
keywordHandler:addKeyword(
	{ "adventurer" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"Of course the first to ask would be the famous Avar Tar, but I heard he's already on a quest of his own and ...",
		"Well, let's say our last collaboration did not end too well. In fact, I'd be not even surprised if he pretended to not even know me. ...",
		"So I have to look elsewhere to handle this new {threat}.",
	} }
)
keywordHandler:addKeyword({ "background" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The goodbreaker was created in ancient times, when the war between the gods and their minions was on its height. Its creation took aeons and incredible sacrifices. ...",
		"Each part had to be crafted perfectly, to emulate the gods, so it would share 'the same place' with them. ...",
		"Mere mortals can not even perceive it in his whole but only recognize the part of it that is the physical representation in our world. ...",
		"If it was meant to be used as an actual weapon, as the ultimate threat, or if Zathroth was just tempted to use his knowledge in the ultimate way - to create something that could undo himself - we don't know. ...",
		"However in the end even Zathroth deemed it too much of a threat but instead of destroying the contraption once and for all, it was {disassembled} and hidden away.",
	},
})
keywordHandler:addKeyword(
	{ "parts" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"The parts alone do them no good. To assemble the parts, great skill, immense power and forbidden knowledge are necessary. ...",
		"The skill will be supplied by the fallen Yalahari and the power by Variphor itself. ...",
		"The only thing they are still lacking is the knowledge to assemble and operate the {godbreaker}.",
	} }
)
keywordHandler:addKeyword({ "godbreaker" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The godbreaker is a complex artifact. Incantation woven into incantation. The powers bound into it are so immense that the slightest mishandling could prove disastrous. ...",
		"o figure out how it works, let alone how it can be operated safely, could require several centuries of tireless study. And even then this information would be only partial. ...",
		"Yet the creation and operation of the godbreaker is just the kind of forbidden {knowledge} Zathroth values most, so it was compiled and stored.",
	},
})
keywordHandler:addKeyword({ "knowledge" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Of course the dangers of such knowledge were obvious. It was hidden in a sacred place devoted to Zathroth and dangerous knowledge. ...",
	"The hidden library, the forbidden hoard, the shrouded trove of knowledge or the veiled hoard of forbidden knowledge, the place has many names in many {myths}.",
} })
keywordHandler:addKeyword({ "myths" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"The myths agree that the place is well hidden, extremely guarded and contains some of the most powerful pieces of knowledge in this world and probably beyond. ...",
		"However the knowledge about the godbreaker now poses a threat to all existence. In the hands of Variphor it can cause disaster in previously unknown ways. The gods themselves are in {peril}.",
	},
})
keywordHandler:addKeyword({ "peril" }, StdModule.say, { npcHandler = npcHandler, text = {
	"Regardless of the dangers, the cult of Zathroth refused to destroy the knowledge of the godbreaker for good. ...",
	"They {value} dangerous knowledge that much, that they are unable to part from it, even when faced with the utter destruction of creation.",
} })
keywordHandler:addKeyword(
	{ "find" },
	StdModule.say,
	{ npcHandler = npcHandler, text = {
		"I know it's asked much but it's no longer a matter of choice. ...",
		"The enemy is moving and I have reports that suggest the minions of Variphor are actively searching for Zathroth's library. They must not be allowed to succeed. ...",
		"We must be the first to {reach} the hoard and make sure the enemy doesn't get the information he needs.",
	} }
)
keywordHandler:addKeyword({ "reach" }, StdModule.say, { npcHandler = npcHandler, text = {
	"I'd recommend to follow the few leads me and my associates could gather so far. ...",
	"Old myths, some {rumors} about old texts and other pieces of knowledge that I could use to figure out where to locate the hidden library and how to enter it.",
} })
keywordHandler:addKeyword({ "rumors" }, StdModule.say, {
	npcHandler = npcHandler,
	text = {
		"Hints about the shrouded hoard are numerous, though most are general mentions in texts that deal with Zathroth. But there are other sources. ...",
		"Like texts about ancient liturgies of Zathroth and historical documents that might give us clues. I already compiled everything of value from the sources that were openly available. ...",
		"To gather the more {obscure} parts of knowledge, however, I'll need your help.",
	},
})

npcHandler:setMessage(MESSAGE_GREET, "Greetings seekers of knowledge. You seem to be just the person I'm {looking} for.")
npcHandler:setMessage(MESSAGE_WALKAWAY, "Well, bye then.")

npcHandler:setCallback(CALLBACK_GREET, greetCallback)
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)

npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

-- npcType registering the npcConfig table
npcType:register(npcConfig)
