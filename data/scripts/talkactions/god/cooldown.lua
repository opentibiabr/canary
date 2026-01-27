local resetCooldowns = TalkAction("/resetcd")

function resetCooldowns.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:clearSpellCooldowns()
		return true
	end

	local target = Player(param)
	if not target then
		player:sendCancelMessage("The given player name not exists or it is not online.")
		position:sendMagicEffect(CONST_ME_POFF)
		return true
	end

	target:clearSpellCooldowns()

	return true
end

resetCooldowns:separator(" ")
resetCooldowns:groupType("god")
resetCooldowns:register()
