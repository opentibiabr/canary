local resetCastle = TalkAction("/resetcastle")

function resetCastle.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	setDominantGuild(-1)

	local players = Game.getPlayers()
	for i, p in pairs(players) do
		if p then
			setInvadingCastle(p, false)
		end
	end

	stopInvasion()
	setCastleCooldown(0)

	return true
end

resetCastle:separator(" ")
resetCastle:groupType("god")
resetCastle:register()
