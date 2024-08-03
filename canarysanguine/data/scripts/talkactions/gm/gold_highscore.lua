local gold_rank = TalkAction("/goldrank")

function gold_rank.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local resultId = db.storeQuery("SELECT `balance`, `name` FROM `players` WHERE group_id < 3 ORDER BY balance DESC LIMIT 10")
	if resultId ~= false then
		local str = ""
		local x = 0
		repeat
			x = x + 1
			str = str .. "\n" .. x .. "- " .. Result.getString(resultId, "name") .. " (" .. Result.getNumber(resultId, "balance") .. ")."
		until not Result.next(resultId)
		Result.free(resultId)
		if str == "" then
			str = "No highscore to show."
		end
		player:popupFYI("Current gold highscore for this server:\n" .. str)
	else
		player:sendCancelMessage("No highscore to show.")
	end
	return true
end

gold_rank:separator(" ")
gold_rank:groupType("gamemaster")
gold_rank:register()
