dofile(CORE_DIRECTORY .. "/libs/systems/blessing.lua")

local blessStatus = TalkAction("/bless")

function blessStatus.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	player:sendBlessStatus()
	return true
end

blessStatus:separator(" ")
blessStatus:groupType("gamemaster")
blessStatus:register()
