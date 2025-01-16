dofile(CORE_DIRECTORY .. "/modules/scripts/blessings/blessings.lua")

local blessStatus = TalkAction("/bless")

function blessStatus.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	Blessings.sendBlessStatus(player)
	return true
end

blessStatus:separator(" ")
blessStatus:groupType("gamemaster")
blessStatus:register()
