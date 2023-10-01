-- Sync outfits that player own with Znote AAC
-- So its possible to see which full sets player
-- has in characterprofile.php

znote_outfit_list = {
	{ -- Female outfits
		136, 137, 138, 139, 140, 141, 142, 147, 148,
		149, 150, 155, 156, 157, 158, 252, 269, 270,
		279, 288, 324, 329, 336, 366, 431, 433, 464,
		466, 471, 513, 514, 542, 575, 578, 618, 620,
		632, 635, 636, 664, 666, 683, 694, 696, 698,
		724, 732, 745, 749, 759, 845, 852, 874, 885,
		900, 973, 975, 1020, 1024, 1043, 1050, 1057,
		1070, 1095, 1103, 1128, 1147, 1162, 1174,
		1187, 1203, 1205, 1207, 1211, 1246, 1244,
		1252, 1271, 1280, 1283, 1289, 1293, 1332
	},
	{ -- Male outfits
		128, 129, 130, 131, 132, 133, 134, 143, 144,
		145, 146, 151, 152, 153, 154, 251, 268, 273,
		278, 289, 325, 328, 335, 367, 430, 432, 463,
		465, 472, 512, 516, 541, 574, 577, 610, 619,
		633, 634, 637, 665, 667, 684, 695, 697, 699,
		725, 733, 746, 750, 760, 846, 853, 873, 884,
		899, 908, 931, 955, 957, 962, 964, 966, 968,
		970, 972, 974, 1021, 1023, 1042, 1051, 1056,
		1069, 1094, 1102, 1127, 1146, 1161, 1173,
		1186, 1202, 1204, 1206, 1210, 1245, 1243,
		1251, 1270, 1279, 1282, 1288, 1292, 1331
	}
}

local outfitLogin = CreatureEvent("OutfitLogin")
function outfitLogin.onLogin(player)
	-- storage_value + 1000 storages (highest outfit id) must not be used in other script.
	-- Must be identical to Znote AAC config.php: $config['EQ_shower'] -> storage_value
	local storage_value = 10000
	-- Loop through outfits
	for _, outfit in pairs(znote_outfit_list[player:getSex() + 1]) do
		if player:hasOutfit(outfit,3) then
			if player:getStorageValue(storage_value + outfit) ~= 3 then
				player:setStorageValue(storage_value + outfit, 3)
			end
		end
	end
	return true
end

outfitLogin:register()