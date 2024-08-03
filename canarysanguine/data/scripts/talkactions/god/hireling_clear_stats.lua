-- Very useful for testing environments
local talk = TalkAction("/clearhirelingstas")

function talk.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local split = param:split(",")
	local name = split[1] ~= "" and split[1]
	local target = Player(name)
	if target then
		target:clearAllHirelingStats()
	else
		player:clearAllHirelingStats()
	end

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	return true
end

talk:separator(" ")
talk:groupType("god")
talk:register()
