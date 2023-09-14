local shutdown = TalkAction("/shutdown")

function shutdown.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

		Game.setGameState(GAME_STATE_SHUTDOWN)

end

shutdown:separator(" ")
shutdown:register()
