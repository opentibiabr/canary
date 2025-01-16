local internalNpcName = "Addoner"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 130,
	lookHead = 115,
	lookBody = 39,
	lookLegs = 96,
	lookFeet = 118,
	lookAddons = 3,
}

npcConfig.flags = {
	floorchange = false,
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{ text = "Come see my Addons bro!" },
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

addoninfo = {
	["first citizen addon"] = { cost = 0, items = { { 5878, 100 } }, outfit_female = 136, outfit_male = 128, addon = 1, storageID = Storage.OutfitQuest.Citizen.AddonBackpack },
	["second citizen addon"] = { cost = 0, items = { { 5890, 50 }, { 5902, 25 }, { 3374, 1 } }, outfit_female = 136, outfit_male = 128, addon = 2, storageID = Storage.OutfitQuest.Citizen.AddonHat },

	["first hunter addon"] = { cost = 0, items = { { 5876, 100 }, { 5948, 100 }, { 5891, 5 }, { 5887, 1 }, { 5889, 1 }, { 5888, 1 } }, outfit_female = 137, outfit_male = 129, addon = 1, storageID = Storage.OutfitQuest.Hunter.AddonHat },
	["second hunter addon"] = { cost = 0, items = { { 5875, 1 } }, outfit_female = 137, outfit_male = 129, addon = 2, storageID = Storage.OutfitQuest.Hunter.AddonGlove },

	["first knight addon"] = { cost = 0, items = { { 5880, 100 }, { 5892, 1 } }, outfit_female = 139, outfit_male = 131, addon = 1, storageID = Storage.OutfitQuest.Knight.AddonSword },
	["second knight addon"] = { cost = 0, items = { { 5893, 100 }, { 5924, 1 }, { 5885, 1 }, { 5887, 1 } }, outfit_female = 139, outfit_male = 131, addon = 2, storageID = Storage.OutfitQuest.Knight.AddonHelmet },

	["first mage addon"] = { cost = 0, items = { { 3074, 1 }, { 3075, 1 }, { 3072, 1 }, { 3073, 1 }, { 3071, 1 }, { 3066, 1 }, { 3070, 1 }, { 3069, 1 }, { 3065, 1 }, { 3067, 1 }, { 5904, 10 }, { 3077, 20 }, { 5809, 1 } }, outfit_female = 138, outfit_male = 130, addon = 1, storageID = Storage.OutfitQuest.MageSummoner.AddonWand },
	["second mage addon"] = { cost = 0, items = { { 5903, 1 } }, outfit_female = 138, outfit_male = 130, addon = 2, storageID = Storage.OutfitQuest.MageSummoner.AddonHatCloak },

	["first nobleman addon"] = { cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 1, storageID = Storage.OutfitQuest.NoblemanFirstAddon },
	["second nobleman addon"] = { cost = 150000, items = {}, outfit_female = 140, outfit_male = 132, addon = 2, storageID = Storage.OutfitQuest.NoblemanSecondAddon },

	["first summoner addon"] = { cost = 0, items = { { 5958, 1 } }, outfit_female = 141, outfit_male = 133, addon = 1, storageID = Storage.OutfitQuest.MageSummoner.AddonBelt },
	["second summoner addon"] = { cost = 0, items = { { 5894, 70 }, { 5911, 20 }, { 5883, 40 }, { 5922, 35 }, { 5886, 10 }, { 5881, 60 }, { 5882, 40 }, { 5904, 15 }, { 5905, 30 } }, outfit_female = 141, outfit_male = 133, addon = 2, storageID = Storage.OutfitQuest.MageSummoner.AddonWandTimer },

	["first warrior addon"] = { cost = 0, items = { { 5925, 100 }, { 5899, 100 }, { 5884, 1 }, { 5919, 1 } }, outfit_female = 142, outfit_male = 134, addon = 1, storageID = Storage.OutfitQuest.WarriorShoulderAddon },
	["second warrior addon"] = { cost = 0, items = { { 5880, 100 }, { 5887, 1 } }, outfit_female = 142, outfit_male = 134, addon = 2, storageID = Storage.OutfitQuest.WarriorSwordAddon },

	["first barbarian addon"] = { cost = 0, items = { { 5880, 100 }, { 5892, 1 }, { 5893, 50 }, { 5876, 50 } }, outfit_female = 147, outfit_male = 143, addon = 1, storageID = 51032 },
	["second barbarian addon"] = { cost = 0, items = { { 5884, 1 }, { 5885, 1 }, { 5910, 50 }, { 5911, 50 }, { 5886, 10 } }, outfit_female = 147, outfit_male = 143, addon = 2, storageID = 51033 },

	["first druid addon"] = { cost = 0, items = { { 5896, 50 }, { 5897, 50 } }, outfit_female = 148, outfit_male = 144, addon = 1, storageID = Storage.OutfitQuest.DruidHatAddon },
	["second druid addon"] = { cost = 0, items = { { 5906, 100 } }, outfit_female = 148, outfit_male = 144, addon = 2, storageID = Storage.OutfitQuest.DruidBodyAddon },

	["first wizard addon"] = { cost = 0, items = { { 5922, 50 } }, outfit_female = 149, outfit_male = 145, addon = 1, storageID = 51034 },
	["second wizard addon"] = { cost = 0, items = { { 3436, 1 }, { 3386, 1 }, { 3382, 1 }, { 3006, 1 } }, outfit_female = 149, outfit_male = 145, addon = 2, storageID = 51035 },

	["first oriental addon"] = { cost = 0, items = { { 5945, 1 } }, outfit_female = 150, outfit_male = 146, addon = 1, storageID = Storage.OutfitQuest.FirstOrientalAddon },
	["second oriental addon"] = { cost = 0, items = { { 5883, 100 }, { 5895, 100 }, { 5891, 2 }, { 5912, 100 } }, outfit_female = 150, outfit_male = 146, addon = 2, storageID = Storage.OutfitQuest.SecondOrientalAddon },

	["first pirate addon"] = { cost = 0, items = { { 6098, 100 }, { 6126, 100 }, { 6097, 100 } }, outfit_female = 155, outfit_male = 151, addon = 1, storageID = Storage.OutfitQuest.PirateSabreAddon },
	["second pirate addon"] = { cost = 0, items = { { 6101, 1 }, { 6102, 1 }, { 6100, 1 }, { 6099, 1 } }, outfit_female = 155, outfit_male = 151, addon = 2, storageID = Storage.OutfitQuest.PirateHatAddon },

	["first assassin addon"] = { cost = 0, items = { { 5912, 50 }, { 5910, 50 }, { 5911, 50 }, { 5913, 50 }, { 5914, 50 }, { 5909, 50 }, { 5886, 10 } }, outfit_female = 156, outfit_male = 152, addon = 1, storageID = Storage.OutfitQuest.AssassinFirstAddon },
	["second assassin addon"] = { cost = 0, items = { { 5804, 1 }, { 5930, 1 } }, outfit_female = 156, outfit_male = 152, addon = 2, storageID = Storage.OutfitQuest.AssassinSecondAddon },

	["first beggar addon"] = { cost = 0, items = { { 5878, 50 }, { 5921, 30 }, { 5913, 20 }, { 5894, 10 }, { 5883, 100 } }, outfit_female = 157, outfit_male = 153, addon = 1, storageID = Storage.OutfitQuest.BeggarFirstAddonDoor },
	["second beggar addon"] = { cost = 0, items = { { 6107, 1 } }, outfit_female = 157, outfit_male = 153, addon = 2, storageID = Storage.OutfitQuest.BeggarSecondAddon },

	["first shaman addon"] = { cost = 0, items = { { 3348, 5 }, { 3403, 5 } }, outfit_female = 158, outfit_male = 154, addon = 1, storageID = 51036 },
	["second shaman addon"] = { cost = 0, items = { { 5014, 1 }, { 3002, 5 } }, outfit_female = 158, outfit_male = 154, addon = 2, storageID = 51037 },

	["first norseman addon"] = { cost = 0, items = { { 7290, 5 } }, outfit_female = 252, outfit_male = 251, addon = 1, storageID = 51038 },
	["second norseman addon"] = { cost = 0, items = { { 7290, 10 } }, outfit_female = 252, outfit_male = 251, addon = 2, storageID = 51039 },

	["first battle mage addon"] = { cost = 0, items = { { 28792, 5 } }, outfit_female = 1070, outfit_male = 1069, addon = 1, storageID = 46001 },
	["second battle mage addon"] = { cost = 0, items = { { 28793, 20 } }, outfit_female = 1070, outfit_male = 1069, addon = 2, storageID = 46002 },

	["first dream warden addon"] = { cost = 0, items = { { 20276, 1 } }, outfit_female = 578, outfit_male = 577, addon = 1, storageID = 44401 },
	["second dream warden addon"] = { cost = 0, items = { { 20275, 1 } }, outfit_female = 578, outfit_male = 577, addon = 2, storageID = 44402 },

	["dream warrior"] = { cost = 0, items = { { 30169, 5 }, { 30168, 1 } }, outfit_female = 1147, outfit_male = 1146, addon = 3, storageID = 46301 },
	["first dream warrior addon"] = { cost = 0, items = { { 30169, 5 } }, outfit_female = 1147, outfit_male = 1146, addon = 1, storageID = 46301 },
	["second dream warrior addon"] = { cost = 0, items = { { 30168, 1 } }, outfit_female = 1147, outfit_male = 1146, addon = 2, storageID = 46302 },

	["festive"] = { cost = 0, items = { { 25088, 3 }, { 25089, 50 } }, outfit_female = 929, outfit_male = 931, addon = 3, storageID = 45451 },
	["first festive addon"] = { cost = 0, items = { { 25088, 3 } }, outfit_female = 929, outfit_male = 931, addon = 1, storageID = 45451 },
	["second festive addon"] = { cost = 0, items = { { 25089, 50 }, { ID, QTD } }, outfit_female = 931, outfit_male = 928, addon = 2, storageID = 45452 },

	["first deepling addon"] = { cost = 0, items = { { 14021, 1 }, { 14022, 1 }, { 14023, 1 } }, outfit_female = 464, outfit_male = 463, addon = 1, storageID = 43551 },
	["second deepling addon"] = { cost = 0, items = { { 14019, 1 } }, outfit_female = 464, outfit_male = 463, addon = 2, storageID = 43552 },

	["revenant"] = { cost = 0, items = { { 34075, 1 }, { 34076, 1 } }, outfit_female = 1323, outfit_male = 1322, addon = 3, storageID = 47201 },
	["first revenant addon"] = { cost = 0, items = { { 34076, 1 } }, outfit_female = 1323, outfit_male = 1322, addon = 1, storageID = 47202 },
	["second revenant addon"] = { cost = 0, items = { { 34075, 1 } }, outfit_female = 1323, outfit_male = 1322, addon = 2, storageID = 47203 },

	["rift warrior"] = { cost = 0, items = { { 22516, 200 }, { 22721, 200 } }, outfit_female = 845, outfit_male = 846, addon = 3, storageID = 45201 },
	["first rift warrior addon"] = { cost = 0, items = { { 22516, 100 } }, outfit_female = 845, outfit_male = 846, addon = 1, storageID = 45349 },
	["second rift warrior addon"] = { cost = 0, items = { { 22516, 100 } }, outfit_female = 845, outfit_male = 846, addon = 2, storageID = 45350 },

	["first warmaster addon"] = { cost = 0, items = { { 10199, 1 } }, outfit_female = 336, outfit_male = 335, addon = 1, storageID = 42832 },
	["second warmaster addon"] = { cost = 0, items = { { 10198, 1 } }, outfit_female = 336, outfit_male = 335, addon = 2, storageID = 42833 },

	["wayfarer"] = { cost = 0, items = { { 11701, 1 }, { 11700, 1 } }, outfit_female = 366, outfit_male = 367, addon = 3, storageID = 42951 },
	["first wayfarer addon"] = { cost = 0, items = { { 11701, 1 } }, outfit_female = 366, outfit_male = 367, addon = 1, storageID = 42982 },
	["second wayfarer addon"] = { cost = 0, items = { { 11700, 1 } }, outfit_female = 366, outfit_male = 367, addon = 2, storageID = 42983 },

	["yalaharian"] = { cost = 0, items = { { 9068, 2 } }, outfit_female = 324, outfit_male = 325, addon = 3, storageID = 41913 },
	["first yalaharian addon"] = { cost = 0, items = { { 9041, 1 } }, outfit_female = 324, outfit_male = 325, addon = 1, storageID = 42144 },
	["second yalaharian addon"] = { cost = 0, items = { { 9041, 1 } }, outfit_female = 324, outfit_male = 325, addon = 2, storageID = 42145 },

	["crystal warlord"] = { cost = 0, items = { { 16255, 1 }, { 16256, 1 }, { 16257, 1 } }, outfit_female = 513, outfit_male = 512, addon = 3, storageID = 43851 },

	["soil guardian"] = { cost = 0, items = { { 16252, 1 }, { 16253, 1 }, { 16254, 1 } }, outfit_female = 514, outfit_male = 516, addon = 3, storageID = 43852 },

	["royal costume"] = { cost = 0, items = { { 22516, 30000 }, { 22721, 25000 } }, outfit_female = 1456, outfit_male = 1457, addon = 3, storageID = 47801 },

	["jester"] = { cost = 0, items = { { 894, 1 }, { 894, 1 } }, outfit_female = 270, outfit_male = 273, addon = 3, storageID = 52076 },

	["formal dress"] = { cost = 0, items = { { 37604, 1 }, { 37605, 1 } }, outfit_female = 1461, outfit_male = 1460, addon = 3, storageID = 43552 },

	["rascoohan"] = { cost = 0, items = { { 35595, 1 }, { 35695, 1 } }, outfit_female = 1372, outfit_male = 1371, addon = 3, storageID = 47517 },

	["insectoid"] = { cost = 0, items = { { 24966, 2 } }, outfit_female = 466, outfit_male = 465, addon = 3, storageID = 43551 },

	["cave explorer"] = { cost = 0, items = { { 22756, 1 }, { 22758, 1 }, { 22754, 1 }, { 22760, 1 } }, outfit_female = 575, outfit_male = 574, addon = 3, storageID = 44301 },

	["makeshift"] = { cost = 0, items = { { 27655, 1 }, { 27656, 1 }, { 27657, 1 } }, outfit_female = 1043, outfit_male = 1042, addon = 3, storageID = 45989 },

	["hand"] = { cost = 0, items = { { 31737, 1 }, { 31738, 1 } }, outfit_female = 1244, outfit_male = 1243, addon = 3, storageID = 46879 },

	["poltergeist"] = { cost = 0, items = { { 32630, 1 }, { 32629, 1 } }, outfit_female = 1271, outfit_male = 1270, addon = 3, storageID = 47021 },
}
local o = {
	"citizen",
	"hunter",
	"knight",
	"mage",
	"nobleman",
	"summoner",
	"warrior",
	"barbarian",
	"druid",
	"wizard",
	"oriental",
	"pirate",
	"assassin",
	"beggar",
	"shaman",
	"norseman",
	"battle mage",
	"dream warden",
	"dream warrior",
	"festive",
	"deepling",
	"revenant",
	"rift warrior",
	"warmaster",
	"wayfarer",
	"yalaharian",
	"fire fighter",
	"crystal warlord",
	"soil guardian",
	"royal costume",
	"jester",
	"formal dress",
	"rascoohan",
	"insectoid",
	"cave explorer",
	"makeshift",
	"hand",
	"poltergeist",
}
local rtnt = {}
local function creatureSayCallback(npc, creature, type, message)
	local talkUser = creature
	local player = Player(creature)
	local playerId = player:getId()

	local talkState = {}
	if not npcHandler:checkInteraction(npc, creature) then
		return false
	end

	if addoninfo[message] ~= nil then
		local itemsTable = addoninfo[message].items
		local items_list = ""
		if getPlayerStorageValue(creature, addoninfo[message].storageID) ~= -1 then
			npcHandler:say("You already have this addon!", npc, creature)
			npcHandler:resetNpc(creature)
			return true
		elseif table.maxn(itemsTable) > 0 then
			for i = 1, table.maxn(itemsTable) do
				local item = itemsTable[i]
				items_list = items_list .. item[2] .. " " .. ItemType(item[1]):getName()
				if i ~= table.maxn(itemsTable) then
					items_list = items_list .. ", "
				end
			end
		end
		local text = ""
		if addoninfo[message].cost > 0 then
			text = addoninfo[message].cost .. " gp"
		elseif table.maxn(addoninfo[message].items) then
			text = items_list
		elseif (addoninfo[message].cost > 0) and table.maxn(addoninfo[message].items) then
			text = items_list .. " and " .. addoninfo[message].cost .. " gp"
		end
		npcHandler:say("For " .. message .. " you will need " .. text .. ". Do you have it all with you?", npc, creature)
		rtnt = message
		talkState[talkUser] = addoninfo[message].storageID
		npcHandler:setTopic(playerId, 2)
		return true
	elseif npcHandler:getTopic(playerId) == 2 then
		if MsgContains(message, "yes") then
			local items_number = 0
			if table.maxn(addoninfo[rtnt].items) > 0 then
				for i = 1, table.maxn(addoninfo[rtnt].items) do
					local item = addoninfo[rtnt].items[i]
					if getPlayerItemCount(creature, item[1]) >= item[2] then
						items_number = items_number + 1
					end
				end
			end
			if (getPlayerMoney(creature) >= addoninfo[rtnt].cost) and (items_number == table.maxn(addoninfo[rtnt].items)) then
				doPlayerRemoveMoney(creature, addoninfo[rtnt].cost)
				if table.maxn(addoninfo[rtnt].items) > 0 then
					for i = 1, table.maxn(addoninfo[rtnt].items) do
						local item = addoninfo[rtnt].items[i]
						doPlayerRemoveItem(creature, item[1], item[2])
					end
				end
				doPlayerAddOutfit(creature, addoninfo[rtnt].outfit_male, addoninfo[rtnt].addon)
				doPlayerAddOutfit(creature, addoninfo[rtnt].outfit_female, addoninfo[rtnt].addon)
				setPlayerStorageValue(creature, addoninfo[rtnt].storageID, 1)
				npcHandler:say("Here you are.", npc, creature)
			else
				npcHandler:say("You do not have needed items!", npc, creature)
			end
			rtnt = nil
			talkState[talkUser] = 0
			npcHandler:resetNpc(creature)
			return true
		end
	elseif MsgContains(message, "addon") then
		npcHandler:say("I can give you {first} or {second} addons for {" .. table.concat(o, "}, {") .. "} outfits.", npc, creature)
		rtnt = nil
		talkState[talkUser] = 0
		npcHandler:resetNpc(creature)
		return true
	elseif MsgContains(message, "help") then
		npcHandler:say("You must say 'first NAME addon', for the first addon or 'second NAME addon' for the second.", npc, creature)
		rtnt = nil
		talkState[talkUser] = 0
		npcHandler:resetNpc(creature)
		return true
	else
		if talkState[talkUser] ~= nil then
			if talkState[talkUser] > 0 then
				npcHandler:say("Come back when you get these items.", npc, creature)
				rtnt = nil
				talkState[talkUser] = 0
				npcHandler:resetNpc(creature)
				return true
			end
		end
	end
	return true
end

npcHandler:setMessage(MESSAGE_GREET, "Welcome |PLAYERNAME|! If you want some addons, just ask me! Do you want to see my {addons}, or are you decided? If you are decided, just ask me like this: {first citizen addon}")
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)
