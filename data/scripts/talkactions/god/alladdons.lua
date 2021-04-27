-- /addons playername

local addons = TalkAction("/addons")
local looktypes = {

	-- Female Outfits
	136, 137, 138, 139, 140, 141, 142, 147, 148, 149, 150, 155, 156, 157, 158, 252, 269, 270, 279, 288,
	324, 329, 336, 366, 431, 433, 464, 466, 471, 513, 514, 542, 575, 578, 618, 620, 632, 635, 636, 664,
	666, 683, 694, 696, 698, 724, 732, 745, 749, 759, 845, 852, 874, 885, 900, 909, 929, 956, 958, 963,
	965, 967, 969, 971, 973, 975, 1020, 1024, 1043, 1050, 1057, 1070, 1095, 1103, 1128, 1147, 1162, 1174, 1187,
	1203, 1205, 1207, 1211, 1244, 1246, 1252, 1271, 1280, 1283, 1289, 1293, 1323, 1332, 1339, 1372, 1383, 1385,
	
	-- Male Outfits
	128, 129, 130, 131, 132, 133, 134, 143, 144, 145, 146, 151, 152, 153, 154, 251, 268, 273, 278, 289,
	325, 328, 335, 367, 430, 432, 463, 465, 472, 512, 516, 541, 574, 577, 610, 619, 633, 634, 637, 665,
	667, 684, 695, 697, 699, 725, 733, 746, 750, 760, 846, 853, 873, 884, 899, 908, 931, 955, 957, 962,
	964, 966, 968, 970, 972, 974, 1021, 1023, 1042, 1051, 1056, 1069, 1094, 1102, 1127, 1146, 1161,	1173, 1186,
	1202, 1204, 1206, 1210, 1243, 1245, 1251, 1270, 1279, 1282, 1288, 1292, 1322, 1331, 1338, 1371, 1382, 1384 
}

function addons.onSay(player, words, param)
	if not player:getGroup():getAccess() then
		return true
	end

	local target
	if param == '' then
		target = player:getTarget()
		if not target then
			player:sendTextMessage(MESSAGE_ATTENTION, 'Gives players the ability to wear all addons. Usage: /addons <player name>')
			return false
		end
	else
		target = Player(param)
	end

	if not target then
		player:sendTextMessage(MESSAGE_ATTENTION, 'Player ' .. param .. ' is currently not online.')
		return false
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD  then
		player:sendTextMessage(MESSAGE_ATTENTION, 'Cannot perform action.')
		return false
	end

	for i = 1, #looktypes do
		target:addOutfitAddon(looktypes[i], 3)
	end

	player:sendTextMessage(MESSAGE_ATTENTION, 'All addons unlocked for ' .. target:getName() .. '.')
	target:sendTextMessage(MESSAGE_ATTENTION, 'All of your addons have been unlocked!')
	return false
end

addons:separator(" ")
addons:register()