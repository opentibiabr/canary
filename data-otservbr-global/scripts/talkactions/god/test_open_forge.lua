local forge = TalkAction("/openforge")

function forge.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	return player:openForge()
end

forge:register()
