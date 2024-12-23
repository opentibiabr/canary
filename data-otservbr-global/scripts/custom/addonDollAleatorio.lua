local outfits = {
    {155, 151, "Pirate"},
    {156, 152, "Assassin"},
    {157, 153, "Beggar"},
    {158, 154, "Shaman"},
	{252, 251, "Norsewoman"},
	{269, 268, "Nightmare"},
	{270, 273, "Jester"},
	{279, 278, "Brotherhood"},
	{288, 289, "Demon Hunter"},
	{324, 325, "Yalaharian"},
	{329, 328, "Newly Wed"},
	{336, 335, "Warmaster"},
	{366, 367, "Wayfarer"},
	{431, 430, "Afflicted"},
	{433, 432, "Elementalist"},
	{464, 463, "Deepling"},
	{466, 465, "Insectoid"},
	{471, 472, "Entrepreneur"},
	{513, 512, "Crystal Warlord"},
	{514, 516, "Soil Guardian"},
	{542, 541, "Demon"},
	{575, 574, "Cave Explorer"},
	{578, 577, "Dream Warden"},
	{618, 610, "Glooth Engineer"},
	{620, 619, "Jersey"},
	{632, 633, "Champion"},
	{635, 634, "Conjurer"},
	{636, 637, "Beastmaster"},
	{664, 665, "Chaos Acolyte"},
	{666, 667, "Death Herald"},
	{683, 684, "Ranger"},
	{694, 695, "Ceremonial Garb"},
	{696, 697, "Puppeteer"},
	{698, 699, "Spirit Caller"},
	{724, 725, "Evoker"},
	{732, 733, "Seaweaver"},
	{745, 746, "Recruiter"},
	{749, 750, "Sea Dog"},
	{759, 760, "Royal Pumpkin"},
	{845, 846, "Rift Warrior"},
	{852, 853, "Winter Warden"},
	{874, 873, "Philosopher"},
	{885, 884, "Arena Champion"},
	{900, 899, "Lupine Warden"},
	{909, 908, "Grove Keeper"},
	{929, 931, "Festive"},
	{956, 955, "Pharaoh"},
	{958, 957, "Trophy Hunter"},
	{1020, 1021, "Herbalist"},
	{1024, 1023, "Sun Priest"},
	{1043, 1042, "Makeshift Warrior"},
	{1050, 1051, "Siege Master"},
	{1057, 1056, "Mercenary"},
	{1070, 1069, "Battle Mage"},
	{1095, 1094, "Discoverer"},
	{1103, 1102, "Sinister Archer"},
	{1128, 1127, "Pumpkin Mummy"},
	{1147, 1146, "Dream Warrior"},
	{1162, 1161, "Percht Raider"},
	{1174, 1173, "Owl Keeper"},
	{1187, 1186, "Guidon Bearer"},
	{1203, 1202, "Void Master"},
	{1205, 1204, "Veteran Paladin"},
	{1207, 1206, "Lion of War"},
	{1244, 1243, "Hand of the Inquisition"},
	{1246, 1245, "Breezy Garb"},
	{1252, 1251, "Orcsoberfest Garb"},
	{1271, 1270, "Poltergeist"},
	{1280, 1279, "Herder"},
	{1283, 1282, "Falconer"},
	{1293, 1292, "Trailblazer"},
	{1323, 1322, "Revenant"},
	{1332, 1331, "Jouster"},
	{1339, 1338, "Moth Cape"},
	{1372, 1371, "Rascoohan"},
	{1383, 1382, "Merry Garb"},
	{1385, 1384, "Rune Master"},
	{1387, 1386, "Citizen of Issavi"},
	{1416, 1415, "Forest Warden"},
	{1437, 1436, "Royal Bounacean Advisor"},
	{1450, 1449, "Arbalester"},
	{1461, 1460, "Formal Dress"},
	{1490, 1489, "Ghost Blade"},
	{1501, 1500, "Nordic Chieftain"},
	{1569, 1568, "Fire-Fighter"},
	{1576, 1575, "Fencer"},
	-- Outfits that will be granted during quests or store only.
	-- Golden
	-- Retro Warruir
	-- Retro Summoner
	-- Retro Noblewoman
	-- Retro Mage
	-- Retro knight
	-- Retro hunter
	-- REtro Citizen
	-- Dragon Knight
	-- Royal Costume
	-- Shadowlotus Disciple
	-- Ancient Aucar
}

local randOutfit = Action("RandomOutfitForNewPlayers")

function randOutfit.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local outfit = outfits[math.random(1, #outfits)]
    local addon = math.random(1, 2)
		
    if player:hasOutfit(outfit[1], addon) and player:hasOutfit(outfit[2], addon) then
		outfit = outfits[math.random(1, #outfits)]
		addon = math.random(1, 2)
		if player:hasOutfit(outfit[1], addon) and player:hasOutfit(outfit[2], addon) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You already have the %s outfit and addon %d.", outfit[3], addon))
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			item:remove(1)
			return true
		else
			player:addOutfitAddon(outfit[1], addon)
			player:addOutfitAddon(outfit[2], addon)
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You obtained the %s outfit with addon %d.", outfit[3], addon))
			player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
			item:remove(1)
			return true
		end
		
	else
		player:addOutfitAddon(outfit[1], addon)
		player:addOutfitAddon(outfit[2], addon)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You obtained the %s outfit with addon %d.", outfit[3], addon))
		player:getPosition():sendMagicEffect(CONST_ME_FIREWORK_BLUE)
		item:remove(1)
		return true
    end
    return true
end

randOutfit:id(8778)
randOutfit:register()