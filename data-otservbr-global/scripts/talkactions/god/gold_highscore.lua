local gold_rank = TalkAction("/goldrank")

function gold_rank.onSay(player, words, param)

	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	logCommand(player, words, param)

	local resultId = db.storeQuery("SELECT `balance`, `name` FROM `players` WHERE group_id < 3 ORDER BY balance DESC LIMIT 10")
	if resultId ~= false then
		local str = ""
		local x = 0
		repeat
			x = x + 1
				str = str.."\n"..x.."- "..result.getDataString(resultId, "name").." ("..result.getDataInt(resultId, "balance")..")."
		until not result.next(resultId)
		result.free(resultId)
		if str == "" then
			str = "No highscore to show."
		end
		player:popupFYI("Current gold highscore for this server:\n" .. str)
	else
		player:sendCancelMessage("No highscore to show.")
	end
return false
end

gold_rank:separator(" ")
gold_rank:register()
