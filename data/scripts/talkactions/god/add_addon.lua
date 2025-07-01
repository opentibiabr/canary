local addaddon = TalkAction("/addaddon")

local looktypes = {
	-- Female Outfits
	136,
	137,
	138,
	139,
	140,
	141,
	142,
	147,
	148,
	149,
	150,
	155,
	156,
	157,
	158,
	252,
	269,
	270,
	279,
	288,
	324,
	329,
	336,
	366,
	431,
	433,
	464,
	466,
	471,
	513,
	514,
	542,
	575,
	578,
	618,
	620,
	632,
	635,
	636,
	664,
	666,
	683,
	694,
	696,
	698,
	724,
	732,
	745,
	749,
	759,
	845,
	852,
	874,
	885,
	900,
	909,
	929,
	956,
	958,
	963,
	965,
	967,
	969,
	971,
	973,
	975,
	1020,
	1024,
	1043,
	1050,
	1057,
	1070,
	1095,
	1103,
	1128,
	1147,
	1162,
	1174,
	1187,
	1203,
	1205,
	1207,
	1211,
	1244,
	1246,
	1252,
	1271,
	1280,
	1283,
	1289,
	1293,
	1323,
	1332,
	1339,
	1372,
	1383,
	1385,
	1387,
	1416,
	1437,
	1445,
	1450,
	1456,
	1461,
	1490,
	1501,
	1569,
	1576,
	1582,
	1598,
	1613,
	1619,
	1663,
	1676,
	1681,
	1825,
	1832,
	1838,

	-- Male Outfits
	1714,
	1723,
	1726,
	1746,
	1775,
	1777,
	128,
	129,
	130,
	131,
	132,
	133,
	134,
	143,
	144,
	145,
	146,
	151,
	152,
	153,
	154,
	251,
	268,
	273,
	278,
	289,
	325,
	328,
	335,
	367,
	430,
	432,
	463,
	465,
	472,
	512,
	516,
	541,
	574,
	577,
	610,
	619,
	633,
	634,
	637,
	665,
	667,
	684,
	695,
	697,
	699,
	725,
	733,
	746,
	750,
	760,
	846,
	853,
	873,
	884,
	899,
	908,
	931,
	955,
	957,
	962,
	964,
	966,
	968,
	970,
	972,
	974,
	1021,
	1023,
	1042,
	1051,
	1056,
	1069,
	1094,
	1102,
	1127,
	1146,
	1161,
	1173,
	1186,
	1202,
	1204,
	1206,
	1210,
	1243,
	1245,
	1251,
	1270,
	1279,
	1282,
	1288,
	1292,
	1322,
	1331,
	1338,
	1371,
	1382,
	1384,
	1386,
	1415,
	1436,
	1444,
	1449,
	1457,
	1460,
	1489,
	1500,
	1568,
	1575,
	1581,
	1597,
	1612,
	1618,
	1662,
	1675,
	1680,
	1713,
	1722,
	1725,
	1745,
	1774,
	1776,
	1824,
	1831,
	1837,
}

function addaddon.onSay(player, words, param)
	-- Create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if #split < 3 then
		player:sendCancelMessage("Usage: /addaddon <player name>, <looktype or 'all'>, <value>")
		return true
	end

	local playerName = split[1]
	local target = Player(playerName)

	if not target then
		player:sendCancelMessage("Player not found.")
		return true
	end

	local addonParam = string.trim(split[2])
	local addonValue = tonumber(string.trim(split[3]))

	if not addonValue or addonValue < 0 or addonValue > 3 then
		player:sendCancelMessage("Invalid addon value. It should be between 0 and 3.")
		return true
	end

	if addonParam == "all" then
		for _, looktype in ipairs(looktypes) do
			target:addOutfitAddon(looktype, addonValue)
		end

		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added addon %d to all your looktypes.", player:getName(), addonValue))
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have successfully added addon %d to all looktypes of player %s.", addonValue, target:getName()))
	else
		local looktype = tonumber(addonParam)
		if not looktype then
			player:sendCancelMessage("Invalid looktype.")
			return true
		end

		target:addOutfitAddon(looktype, addonValue)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("Addon %d for looktype %d set for player %s.", addonValue, looktype, target:getName()))
		target:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("%s has added addon %d for looktype %d to you.", player:getName(), addonValue, looktype))
	end
	return true
end

addaddon:separator(" ")
addaddon:groupType("god")
addaddon:register()
