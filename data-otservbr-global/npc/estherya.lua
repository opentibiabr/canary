local internalNpcName = "Estherya"
local npcType = Game.createNpcType(internalNpcName)
local npcConfig = {}

npcConfig.name = internalNpcName
npcConfig.description = internalNpcName

npcConfig.health = 100
npcConfig.maxHealth = npcConfig.health
npcConfig.walkInterval = 2000
npcConfig.walkRadius = 2

npcConfig.outfit = {
	lookType = 1688,
	lookHead = 87,
	lookBody = 49,
	lookLegs = 36,
	lookFeet = 48,
	lookAddons = 3
}

npcConfig.flags = {
	floorchange = false
}

npcConfig.voices = {
	interval = 15000,
	chance = 50,
	{text = 'Outfits, addons and mounts!'}
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
['first citizen addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 136, outfit_male = 128, addon = 1, storageID = Storage.OutfitQuest.Citizen.AddonBackpack},
['second citizen addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 136, outfit_male = 128, addon = 2, storageID = Storage.OutfitQuest.Citizen.AddonHat},
['first hunter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 137, outfit_male = 129, addon = 1, storageID = Storage.OutfitQuest.Hunter.AddonHat},
['second hunter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 137, outfit_male = 129, addon = 2, storageID = Storage.OutfitQuest.Hunter.AddonGlove},
['first knight addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 139, outfit_male = 131, addon = 1, storageID = Storage.OutfitQuest.Knight.AddonSword},
['second knight addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 139, outfit_male = 131, addon = 2, storageID = Storage.OutfitQuest.Knight.AddonHelmet},
['first mage addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 138, outfit_male = 130, addon = 1, storageID = Storage.OutfitQuest.MageSummoner.AddonWand},
['second mage addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 138, outfit_male = 130, addon = 2, storageID = Storage.OutfitQuest.MageSummoner.AddonHatCloak},
['first summoner addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 141, outfit_male = 133, addon = 1, storageID = Storage.OutfitQuest.MageSummoner.AddonBelt},
['second summoner addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 141, outfit_male = 133, addon = 2, storageID = Storage.OutfitQuest.MageSummoner.AddonWandTimer},
['first barbarian addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 147, outfit_male = 143, addon = 1, storageID = 51032},
['second barbarian addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 147, outfit_male = 143, addon = 2, storageID = 51033},
['first druid addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 148, outfit_male = 144, addon = 1, storageID = Storage.OutfitQuest.DruidHatAddon},
['second druid addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 148, outfit_male = 144, addon = 2, storageID = Storage.OutfitQuest.DruidBodyAddon},
['first nobleman addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 140, outfit_male = 132, addon = 1, storageID = Storage.OutfitQuest.NoblemanFirstAddon},
['second nobleman addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 140, outfit_male = 132, addon = 2, storageID = Storage.OutfitQuest.NoblemanSecondAddon},
['first oriental addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 150, outfit_male = 146, addon = 1, storageID = Storage.OutfitQuest.FirstOrientalAddon},
['second oriental addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 150, outfit_male = 146, addon = 2, storageID = Storage.OutfitQuest.SecondOrientalAddon},
['first warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 142, outfit_male = 134, addon = 1, storageID = Storage.OutfitQuest.WarriorShoulderAddon},
['second warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 142, outfit_male = 134, addon = 2, storageID = Storage.OutfitQuest.WarriorSwordAddon},
['first wizard addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 149, outfit_male = 145, addon = 1, storageID = 51034},
['second wizard addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 149, outfit_male = 145, addon = 2, storageID = 51035},
['first assassin addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 156, outfit_male = 152, addon = 1, storageID = Storage.OutfitQuest.AssassinFirstAddon},
['second assassin addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 156, outfit_male = 152, addon = 2, storageID = Storage.OutfitQuest.AssassinSecondAddon},
['first beggar addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 157, outfit_male = 153, addon = 1, storageID = Storage.OutfitQuest.BeggarFirstAddonDoor},
['second beggar addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 157, outfit_male = 153, addon = 2, storageID = Storage.OutfitQuest.BeggarSecondAddon},
['first pirate addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 155, outfit_male = 151, addon = 1, storageID = Storage.OutfitQuest.PirateSabreAddon},
['second pirate addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 155, outfit_male = 151, addon = 2, storageID = Storage.OutfitQuest.PirateHatAddon},
['first shaman addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 158, outfit_male = 154, addon = 1, storageID = 51036},
['second shaman addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 158, outfit_male = 154, addon = 2, storageID = 51037},
['first norseman addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 252, outfit_male = 251, addon = 1, storageID = 51038},
['second norseman addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 252, outfit_male = 251, addon = 2, storageID = 51039},

['base nightmare outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 269, outfit_male = 268, addon = 0, storageID = 181752},
['first nightmare addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 269, outfit_male = 268, addon = 1, storageID = 181753},
['second nightmare addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 269, outfit_male = 268, addon = 2, storageID = 181754},
['base jester outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 270, outfit_male = 273, addon = 0, storageID = 181755},
['first jester addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 270, outfit_male = 273, addon = 1, storageID = 181756},
['second jester addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 270, outfit_male = 273, addon = 2, storageID = 181757},
['base brotherhood outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 279, outfit_male = 278, addon = 0, storageID = 181758},
['first brotherhood addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 279, outfit_male = 278, addon = 1, storageID = 181759},
['second brotherhood addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 279, outfit_male = 278, addon = 2, storageID = 181760},
['base demon hunter outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 288, outfit_male = 289, addon = 0, storageID = 181761},
['first demon hunter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 288, outfit_male = 289, addon = 1, storageID = 181762},
['second demon hunter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 288, outfit_male = 289, addon = 2, storageID = 181763},
['base yalaharian outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 324, outfit_male = 325, addon = 0, storageID = 181764},
['first yalaharian addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 324, outfit_male = 325, addon = 1, storageID = 181765},
['second yalaharian addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 324, outfit_male = 325, addon = 2, storageID = 181766},
['base newly wed outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 329, outfit_male = 328, addon = 0, storageID = 181767},
['first newly wed addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 329, outfit_male = 328, addon = 1, storageID = 181768},
['second newly wed addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 329, outfit_male = 328, addon = 2, storageID = 181769},
['base warmaster outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 336, outfit_male = 335, addon = 0, storageID = 181770},
['first warmaster addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 336, outfit_male = 335, addon = 1, storageID = 181771},
['second warmaster addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 336, outfit_male = 335, addon = 2, storageID = 181772},
['base wayfarer outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 366, outfit_male = 367, addon = 0, storageID = 181773},
['first wayfarer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 366, outfit_male = 367, addon = 1, storageID = 181774},
['second wayfarer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 366, outfit_male = 367, addon = 2, storageID = 181775},
['base afflicted outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 431, outfit_male = 430, addon = 0, storageID = 181776},
['first afflicted addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 431, outfit_male = 430, addon = 1, storageID = 181777},
['second afflicted addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 431, outfit_male = 430, addon = 2, storageID = 181778},
['base elementalist outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 433, outfit_male = 432, addon = 0, storageID = 181779},
['first elementalist addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 433, outfit_male = 432, addon = 1, storageID = 181780},
['second elementalist addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 433, outfit_male = 432, addon = 2, storageID = 181781},
['base deepling outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 464, outfit_male = 463, addon = 0, storageID = 181782},
['first deepling addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 464, outfit_male = 463, addon = 1, storageID = 181783},
['second deepling addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 464, outfit_male = 463, addon = 2, storageID = 181784},
['base insectoid outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 466, outfit_male = 465, addon = 0, storageID = 181785},
['first insectoid addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 466, outfit_male = 465, addon = 1, storageID = 181786},
['second insectoid addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 466, outfit_male = 465, addon = 2, storageID = 181787},
['base crystal warlord outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 513, outfit_male = 512, addon = 0, storageID = 181788},
['first crystal warlord addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 513, outfit_male = 512, addon = 1, storageID = 181789},
['second crystal warlord addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 513, outfit_male = 512, addon = 2, storageID = 181790},
['base soil guardian outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 514, outfit_male = 516, addon = 0, storageID = 181791},
['first soil guardian addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 514, outfit_male = 516, addon = 1, storageID = 181792},
['second soil guardian addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 514, outfit_male = 516, addon = 2, storageID = 181793},
['base demon outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 542, outfit_male = 541, addon = 0, storageID = 181794},
['first demon addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 542, outfit_male = 541, addon = 1, storageID = 181795},
['second demon addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 542, outfit_male = 541, addon = 2, storageID = 181796},
['base cave explorer outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 575, outfit_male = 574, addon = 0, storageID = 181797},
['first cave explorer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 575, outfit_male = 574, addon = 1, storageID = 181798},
['second cave explorer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 575, outfit_male = 574, addon = 2, storageID = 181799},
['base dream warden outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 578, outfit_male = 577, addon = 0, storageID = 181800},
['first dream warden addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 578, outfit_male = 577, addon = 1, storageID = 181801},
['second dream warden addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 578, outfit_male = 577, addon = 2, storageID = 181802},
['base glooth engineer outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 618, outfit_male = 610, addon = 0, storageID = 181803},
['first glooth engineer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 618, outfit_male = 610, addon = 1, storageID = 181804},
['second glooth engineer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 618, outfit_male = 610, addon = 2, storageID = 181805},
['base recruiter outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 745, outfit_male = 746, addon = 0, storageID = 181806},
['first recruiter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 745, outfit_male = 746, addon = 1, storageID = 181807},
['second recruiter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 745, outfit_male = 746, addon = 2, storageID = 181808},
['base rift warrior outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 845, outfit_male = 846, addon = 0, storageID = 181809},
['first rift warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 845, outfit_male = 846, addon = 1, storageID = 181810},
['second rift warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 845, outfit_male = 846, addon = 2, storageID = 181811},
['base festive outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 929, outfit_male = 931, addon = 0, storageID = 181812},
['first festive addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 929, outfit_male = 931, addon = 1, storageID = 181813},
['second festive addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 929, outfit_male = 931, addon = 2, storageID = 181814},
['base makeshift warrior outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1043, outfit_male = 1042, addon = 0, storageID = 181815},
['first makeshift warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1043, outfit_male = 1042, addon = 1, storageID = 181816},
['second makeshift warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1043, outfit_male = 1042, addon = 2, storageID = 181817},
['base battle mage outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1070, outfit_male = 1069, addon = 0, storageID = 181818},
['first battle mage addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1070, outfit_male = 1069, addon = 1, storageID = 181819},
['second battle mage addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1070, outfit_male = 1069, addon = 2, storageID = 181820},
['base discoverer outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1095, outfit_male = 1094, addon = 0, storageID = 181821},
['first discoverer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1095, outfit_male = 1094, addon = 1, storageID = 181822},
['second discoverer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1095, outfit_male = 1094, addon = 2, storageID = 181823},
['base dream warrior outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1147, outfit_male = 1146, addon = 0, storageID = 181824},
['first dream warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1147, outfit_male = 1146, addon = 1, storageID = 181825},
['second dream warrior addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1147, outfit_male = 1146, addon = 2, storageID = 181826},
['base percht raider outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1162, outfit_male = 1161, addon = 0, storageID = 181827},
['first percht raider addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1162, outfit_male = 1161, addon = 1, storageID = 181828},
['second percht raider addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1162, outfit_male = 1161, addon = 2, storageID = 181829},
['base golden outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1211, outfit_male = 1210, addon = 0, storageID = 181830},
['first golden addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1211, outfit_male = 1210, addon = 1, storageID = 181831},
['second golden addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1211, outfit_male = 1210, addon = 2, storageID = 181832},
['base hand of the inquisition outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1244, outfit_male = 1243, addon = 0, storageID = 181833},
['first hand of the inquisition addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1244, outfit_male = 1243, addon = 1, storageID = 181834},
['second hand of the inquisition addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1244, outfit_male = 1243, addon = 2, storageID = 181835},
['base orcsoberfest garb outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1252, outfit_male = 1251, addon = 0, storageID = 181836},
['first orcsoberfest garb addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1252, outfit_male = 1251, addon = 1, storageID = 181837},
['second orcsoberfest garb addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1252, outfit_male = 1251, addon = 2, storageID = 181838},
['base poltergeist outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1271, outfit_male = 1270, addon = 0, storageID = 181839},
['first poltergeist addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1271, outfit_male = 1270, addon = 1, storageID = 181840},
['second poltergeist addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1271, outfit_male = 1270, addon = 2, storageID = 181841},
['base falconer outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1283, outfit_male = 1282, addon = 0, storageID = 181842},
['first falconer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1283, outfit_male = 1282, addon = 1, storageID = 181843},
['second falconer addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1283, outfit_male = 1282, addon = 2, storageID = 181844},
['base revenant outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1323, outfit_male = 1322, addon = 0, storageID = 181845},
['first revenant addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1323, outfit_male = 1322, addon = 1, storageID = 181846},
['second revenant addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1323, outfit_male = 1322, addon = 2, storageID = 181847},
['base rascoohan outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1372, outfit_male = 1371, addon = 0, storageID = 181848},
['first rascoohan addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1372, outfit_male = 1371, addon = 1, storageID = 181849},
['second rascoohan addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1372, outfit_male = 1371, addon = 2, storageID = 181850},
['base citizen of issavi outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1387, outfit_male = 1386, addon = 0, storageID = 181851},
['first citizen of issavi addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1387, outfit_male = 1386, addon = 1, storageID = 181852},
['second citizen of issavi addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1387, outfit_male = 1386, addon = 2, storageID = 181853},
['base royal bounacean advisor outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1437, outfit_male = 1436, addon = 0, storageID = 181854},
['first royal bounacean advisor addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1437, outfit_male = 1436, addon = 1, storageID = 181855},
['second royal bounacean advisor addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1437, outfit_male = 1436, addon = 2, storageID = 181856},
['base fire-fighter outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1569, outfit_male = 1568, addon = 0, storageID = 181857},
['first fire-fighter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1569, outfit_male = 1568, addon = 1, storageID = 181858},
['second fire-fighter addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1569, outfit_male = 1568, addon = 2, storageID = 181859},
['base ancient aucar outfit'] = {cost = 0, items = {{31965,4}}, outfit_female = 1598, outfit_male = 1597, addon = 0, storageID = 181860},
['first ancient aucar addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1598, outfit_male = 1597, addon = 1, storageID = 181861},
['second ancient aucar addon'] = {cost = 0, items = {{31965,4}}, outfit_female = 1598, outfit_male = 1597, addon = 2, storageID = 181862},


['widow queen mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 1, storageID = 181927},
['titanica mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 7, storageID = 181931},
['tin lizzard mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 8, storageID = 181932},
['blazebringer mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 9, storageID = 181933},
['rapid boar mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 10, storageID = 181934},
['stampor mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 11, storageID = 181935},
['undead cavebear mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 12, storageID = 181936},
['donkey mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 13, storageID = 181937},
['tiger slug mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 14, storageID = 181938},
['uniwheel mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 15, storageID = 181939},
['crystal wolf mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 16, storageID = 181940},
['war horse mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 17, storageID = 181941},
['kingly deer mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 18, storageID = 181942},
['tamed panda mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 19, storageID = 181943},
['dromedary mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 20, storageID = 181944},
['scorpion king mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 21, storageID = 181945},
['lady bug mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 27, storageID = 181946},
['manta ray mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 28, storageID = 181947},
['ironblight mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 29, storageID = 2148},
['magma crawler mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 30, storageID = 181949},
['dragonling mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 31, storageID = 181950},
['gnarlhound mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 32, storageID = 181951},
['water buffalo mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 35, storageID = 181952},
['ursagrodon mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 38, storageID = 181953},
['the hellgrip mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 39, storageID = 181954},
['noble lion mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 28, storageID = 181955},
['walker mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 43, storageID = 181956},
['glooth glider mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 71, storageID = 181957},
['rift runner mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 87, storageID = 181958},
['sparkion mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 94, storageID = 181959},
['shock head mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 42, storageID = 181960},
['neon sparkid mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 98, storageID = 181961},
['vortexion mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 99, storageID = 181962},
['stone rhino mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 106, storageID = 181963},
['mole mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 119, storageID = 181964},
['fleeting knowledge mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 126, storageID = 181965},
['lacewig moth mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 280, storageID = 181966},
['hibernal moth mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 131, storageID = 181967},
['cold percht sleigh mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 132, storageID = 181968},
['bright percht sleigh mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 133, storageID = 181969},
['dark percht sleigh mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 134, storageID = 181970},
['gryphon mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 144, storageID = 181971},
['cold percht sleigh variant mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 147, storageID = 181972},
['bright percht sleigh variant mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 148, storageID = 181973},
['dark percht sleigh variant mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 149, storageID = 181974},
['cold percht sleigh final mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 150, storageID = 181975},
['bright percht sleigh final mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 151, storageID = 181976},
['dark percht sleigh final mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 152, storageID = 181977},
['blue rolling barrel mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 156, storageID = 181978},
['red rolling barrel mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 157, storageID = 181979},
['green rolling barrel mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 158, storageID = 181980},
['haze mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 162, storageID = 181981},
['antelope mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 163, storageID = 181982},
['phantasmal jade mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 167, storageID = 181983},
['white lion mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 174, storageID = 181984},
['krakoloss mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 175, storageID = 181985},
['phant mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 182, storageID = 181986},
['shellodon mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 183, storageID = 181987},
['singeing steed mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 184, storageID = 181988},
['gloothomotive mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 194, storageID = 181989},
['red draggy mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 201, storageID = 181990},
['black draggy mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 202, storageID = 181991},
['giant beaver mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 203, storageID = 181992},
['ripptor mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 204, storageID = 181993},
['armoured dromedary mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 208, storageID = 181994},
['blue tiger mount'] = {cost = 0, items = {{31966, 40}}, mount_id = 209, storageID = 181995},
['rage draptor mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 210, storageID = 181996},
['flame horse mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 211, storageID = 181997},
['guardian bear mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 212, storageID = 181998},
['polar bear mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 213, storageID = 181999},
['soho bear mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 214, storageID = 182000},
['angry draptor mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 215, storageID = 182001},
['crawl monkey mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 216, storageID = 182002},
['Tangerine Flecked Koi mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 217, storageID = 182003},
['Brass Speckled Koi mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 218, storageID = 182004},
['Ink Spotted Koi mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 219, storageID = 182005},
['Boisterous Black bull mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 219, storageID = 182006},
['Boisterous Grey bull mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 219, storageID = 182007},
['Boisterous Brown bull mount'] = {cost = 0, items = {{31966, 4}}, mount_id = 219, storageID = 182008},
}
local o = {'citizen', 'hunter', 'knight', 'mage', 'nobleman', 'summoner', 'warrior', 'barbarian', 'druid', 'wizard', 'oriental', 'pirate', 'assassin', 'beggar', 'shaman', 'norseman',
'nightmare', 'jester', 'brotherhood', 'demon hunter', 'yalaharian', 'newly wed', 'warmaster', 'wayfarer', 'afflicted', 'elementalist', 'deepling', 'insectoid', 'crystal warlord', 'soil guardian'}

local p = {'demon', 'cave explorer', 'dream warden', 'glooth engineer', 'recruiter', 'rift warrior', 'festive', 'makeshift', 'battle mage', 'discoverer', 'dream warrior',
'percht raider', 'golden', 'hand of the inquisition', 'orcsoberfest', 'poltergeist', 'falconer', 'revenant', 'rascoohan', 'citizen of issavi', 'royal bounacean advisor', 'fire-fighter', 'ancient aucar'}

local b = {'widow queen', 'racing bird', 'war bear', 'black sheep', 'titanica', 'tin lizzard', 'blazebringer', 'rapid boar', 'stampor', 'undead cavebear', 'donkey', 'tiger slug',
'uniwheel', 'crystal wolf', 'war horse', 'kingly deer', 'tamed panda', 'dromedary', 'scropion king', 'lady bug', 'manta ray', 'ironblight', 'magma crawler', 'dragonling', 'gnarlhound',
'water buffalo', 'ursagrodon', 'the hellgrip', 'noble lion' }
local c = {'walker','glooth glider', 'rift runner', 'sparkion', 'shock head', 'neon sparkid', 'vortexion', 'stone rhino', 'mole', 'fleeting knowledge', 'lacewig moth', 'hibernal moth', 'cold percht sleigh',
'bright percht sleigh', 'dark percht sleigh', 'gryphon', 'cold percht sleigh variant', 'bright percht sleigh varian', 'dark percht sleight variant', 'cold percht sleigh final', 'bright percht sleigh final',
'dark percht sleigh final', 'blue rolling barrel', 'red rolling barrel', 'green rolling barrel', 'haze'}
local d = {'antelope', 'phantasmal jade', 'white lion', 'krakoloss', 'phant', 'shellodon', 'singeing steed', 'gloothomotive', 'red draggy', 'black draggy', 'giant beaver', 'ripptor', 'armoured dromedary',
'blue tiger', 'rage draptor', 'flame horse', 'guardian bear', 'polar bear', 'soho bear', 'anrgy draptor', 'crawl monkey', 'tangerine flecked koi', 'brass speckled koi', 'ink spotted koi', 'Boisterous black bull', 'Boisterous grey bull', 'Boisterous brown bull'}
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
        local items_list = ''
        if (getPlayerStorageValue(creature, addoninfo[message].storageID) ~= -1) then
                npcHandler:say('You already have this addon!', npc, creature)
                npcHandler:resetNpc(creature)
                return true
        elseif table.maxn(itemsTable) > 0 then
            for i = 1, table.maxn(itemsTable) do
                local item = itemsTable[i]
                items_list = items_list .. item[2] .. ' ' .. ItemType(item[1]):getName()
                if i ~= table.maxn(itemsTable) then
                    items_list = items_list .. ', '
                end
            end
        end
        local text = ''
        if (addoninfo[message].cost > 0) then
            text = addoninfo[message].cost .. ' gp'
        elseif table.maxn(addoninfo[message].items) then
            text = items_list
        elseif (addoninfo[message].cost > 0) and table.maxn(addoninfo[message].items) then
            text = items_list .. ' and ' .. addoninfo[message].cost .. ' gp'
        end
        npcHandler:say('For ' .. message .. ' you will need ' .. text .. '. Do you want buy it?', npc, creature)
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
                    if (getPlayerItemCount(creature,item[1]) >= item[2]) then
                        items_number = items_number + 1
                    end
                end
            end
            if(getPlayerMoney(creature) >= addoninfo[rtnt].cost) and (items_number == table.maxn(addoninfo[rtnt].items)) then
                doPlayerRemoveMoney(creature, addoninfo[rtnt].cost)
                if table.maxn(addoninfo[rtnt].items) > 0 then
                    for i = 1, table.maxn(addoninfo[rtnt].items) do
                        local item = addoninfo[rtnt].items[i]
                        doPlayerRemoveItem(creature,item[1],item[2])
                    end
                end
                doPlayerAddOutfit(creature, addoninfo[rtnt].outfit_male, addoninfo[rtnt].addon)
                doPlayerAddOutfit(creature, addoninfo[rtnt].outfit_female, addoninfo[rtnt].addon)
                doPlayerAddMount(creature, addoninfo[rtnt].mount_id)
                setPlayerStorageValue(creature,addoninfo[rtnt].storageID,1)
                npcHandler:say('Here you are.', npc, creature)
            else
                npcHandler:say('You do not have needed items!', npc, creature)
            end
            rtnt = nil
            talkState[talkUser] = 0
            npcHandler:resetNpc(creature)
            return true
        end
    elseif MsgContains(message, "outfits") then
        npcHandler:say('I can give you {base} outfit, {first} or {second} addons in exchange of Outfit Coins, {' .. table.concat(o, "}, {") .. '} outfits. You can also see the {second part} of outfits table.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    elseif MsgContains(message, "second part") then
        npcHandler:say('Here is the second part of outfits: {' .. table.concat(p, "}, {") .. '} outfits. Others outfits non listed here are buyable from store or obtained in game.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    elseif MsgContains(message, "mounts") then
        npcHandler:say('I can give you these mounts in exchange of Mount Coins, {' .. table.concat(b, "}, {") .. '} maybe you wish to see {more} ?.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    elseif MsgContains(message, "more") then
        npcHandler:say('The next mounts are: {' .. table.concat(c, "}, {") .. '}., maybe you wish i {extend} the list?', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    elseif MsgContains(message, "extend") then
        npcHandler:say('The next mounts are: {' .. table.concat(d, "}, {") .. '}. If you didn\'t see the mount on table it means is buyable on the store or can be obtained in game.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    elseif MsgContains(message, "help") then
        npcHandler:say('For example if you are looking for Citizen of Issavi base outfit ask me for \'base citizen of issavi outfit\', while for addons \'first citizen of issavi addon\' or \'second citizen of issavi addon\'. For the mounts it\'s similar ask me for the name of the mount example: \'Boisterous black bull mount\'.', npc, creature)
        rtnt = nil
        talkState[talkUser] = 0
        npcHandler:resetNpc(creature)
        return true
    else
        if talkState[talkUser] ~= nil then
            if talkState[talkUser] > 0 then
            npcHandler:say('Come back when you get outfit coins or mount coins.', npc, creature)
            rtnt = nil
            talkState[talkUser] = 0
            npcHandler:resetNpc(creature)
            return true
            end
        end
    end
    return true
end

npcHandler:setMessage(MESSAGE_GREET, 'Blessings, |PLAYERNAME|! How may I be of service? Do you wish to trade some Outfit Coins or Mounts Coins for {Outfits} or {Mounts}? Or maybe you need {help} ?')
npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)
npcType:register(npcConfig)