dofile(CORE_DIRECTORY .. "/modules/scripts/blessings/blessings.lua")

local blessStatus = TalkAction("/bless")

function blessStatus.onSay(player, words, param)
	Blessings.sendBlessStatus(player)
	return false
end

blessStatus:separator(" ")
blessStatus:groupType("god")
blessStatus:register()
