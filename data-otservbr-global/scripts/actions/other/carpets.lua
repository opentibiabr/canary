local carpetItems = {
	[22737] = 22736, [22736] = 22737, -- rift carpet
	[23537] = 23536, [23536] = 23537, -- void carpet
	[23431] = 23453, [23453] = 23431, -- yalahahari carpet
	[23432] = 23454, [23454] = 23432, -- white fur carpet
	[23433] = 23455, [23455] = 23433, -- bamboo mat carpet
	[23715] = 23707, [23707] = 23715, -- crimson carpet
	[23710] = 23716, [23716] = 23710, -- azure carpet
	[23711] = 23717, [23717] = 23711, -- emerald carpet
	[23712] = 23718, [23718] = 23712, -- light parquet carpet
	[23713] = 23719, [23719] = 23713, -- dark parquet carpet
	[23714] = 23720, [23720] = 23714, -- marble floor
	[24416] = 24424, [24424] = 24416, -- flowery carpet
	[24417] = 24425, [24425] = 24417, -- colourful Carpet
	[24418] = 24426, [24426] = 24418, -- striped carpet
	[24419] = 24427, [24427] = 24419, -- fur carpet
	[24420] = 24428, [24428] = 24420, -- diamond carpet
	[24421] = 24429, [24429] = 24421, -- patterned carpet
	[24422] = 24430, [24430] = 24422, -- night sky carpet
	[24423] = 24431, [24431] = 24423, -- star carpet
	[26114] = 26115, [26115] = 26114, -- verdant carpet
	[26116] = 26117, [26117] = 26116, -- shaggy carpet
	[26119] = 26118, [26118] = 26119, -- mystic carpet
	[26120] = 26121, [26121] = 26120, -- stone tile
	[26123] = 26122, [26122] = 26123, -- wooden plank
	[26150] = 26151, [26151] = 26150, -- wheat carpet
	[26152] = 26153, [26153] = 26152, -- crested carpet
	[26154] = 26155, [26155] = 26154, -- decorated carpet
	[31466] = 31468, [31468] = 31466, -- tournament carpet
	[31467] = 31469, [31469] = 31467, -- sublime tournament carpet
	[35887] = 35888, [35888] = 35887, -- lilac carpet
	[35889] = 35890, [35890] = 35889, -- colourful pom-pom carpet
	[35891] = 35892, [35892] = 35891, -- natural pom-pom carpet
	[35893] = 35894, [35894] = 35893, -- owin rug
	[35895] = 35896, [35896] = 35895, -- midnight panther rug
	[35897] = 35898, [35898] = 35897, -- moon carpet
	[35899] = 35900, [35900] = 35899, -- romantic carpet
	[35941] = 35942, [35942] = 35941, -- grandiose carpet
	[36496] = 36838, [36838] = 36496, -- eldritch carpet
	[36939] = 36951, [36951] = 36939, -- folded artefact carpet I
	[36940] = 36939, -- the sylvan sapling carpet
	[36941] = 36952, [36952] = 36941, -- folded artefact carpet II
	[36942] = 36941, -- the spatial almanach carpet
	[36943] = 36953, [36953] = 36943, -- folded artefact carpet III
	[36944] = 36943, -- the book of death carpet
	[36945] = 36954, [36954] = 36945, -- folded artefact carpet IV
	[36946] = 36945, -- the supreme cube carpet
	[36947] = 36955, [36955] = 36947, -- folded artefact carpet V
	[36948] = 36947, -- the ring of ending carpet
	[36949] = 36956, [36956] = 36949, -- folded artefact carpet VI
	[36950] = 36949, -- the cobra amulet carpet
	[37019] = 37020, [37020] = 37019, -- grass
	[37353] = 37354, [37354] = 37353, -- dragon lord carpet
	[37355] = 37357, [37357] = 37355, -- dragon carpet
	[37356] = 37358, [37358] = 37356, -- elemental carpet
	[37359] = 37360, [37360] = 37359, -- Morgaroth carpet
	[37361] = 37362, [37362] = 37361, -- Ghazbaran carpet
	[37363] = 37364, [37364] = 37363, -- Orshabaal carpet
	[37365] = 37366, [37366] = 37365, -- red cake carpet
	[37367] = 37374, [37374] = 37367, -- orange cake carpet
	[37368] = 37375, [37375] = 37368, -- yellow cake carpet
	[37369] = 37376, [37376] = 37369, -- green cake carpet
	[37370] = 37377, [37377] = 37370, -- sky cake carpet
	[37371] = 37378, [37378] = 37371, -- blue cake carpet
	[37372] = 37379, [37379] = 37372, -- purple cake carpet
	[37373] = 37380, [37380] = 37373, -- pink cake carpet
	[37382] = 37381, [37381] = 37382, -- red tibia carpet
	[37383] = 37390, [37390] = 37383, -- orange tibia carpet
	[37384] = 37391, [37391] = 37384, -- yellow tibia carpet
	[37385] = 37392, [37392] = 37385, -- green tibia carpet
	[37386] = 37393, [37393] = 37386, -- sky tibia carpet
	[37387] = 37394, [37394] = 37387, -- blue tibia carpet
	[37388] = 37395, [37395] = 37388, -- purple tibia carpet
	[37389] = 37396, [37396] = 37389, -- pink tibia carpet
	[37763] = 37764, [37764] = 37763, -- zaoan bamboo tiles I
	[37765] = 37766, [37766] = 37765, -- zaoan bamboo tiles II
	[37767] = 37768, [37768] = 37767, -- zaoan bamboo tiles III
	[37769] = 37770, [37770] = 37769, -- zaoan bamboo tiles IV
	[37771] = 37772, [37772] = 37771, -- zaoan bamboo tiles V
	[37773] = 37774, [37774] = 37773, -- zaoan bamboo tiles VI
	[39797] = 39798, [39798] = 39797, -- flowery grass
}

local carpets = Action()

function carpets.onUse(player, item, fp, target, toPosition, isHotkey)
	local carpet = carpetItems[item.itemid]
	if not carpet then
		return false
	end

	local fromPosition = item:getPosition()
	local tile = Tile(fromPosition)
	if not fromPosition:getTile():getHouse() then
		player:sendTextMessage(MESSAGE_FAILURE, "You may use this only inside a house.")
	elseif tile:getItemCountById(item.itemid) == 1 then
		for k,v in pairs(carpetItems) do
			if tile:getItemCountById(k) > 0 and k ~= item.itemid then
				player:sendCancelMessage(Game.getReturnMessage(RETURNVALUE_NOTPOSSIBLE))
				return true
			end
		end
		item:transform(carpet)
	end
	return true
end

for index, value in pairs(carpetItems) do
	carpets:id(index)
end

carpets:register()
