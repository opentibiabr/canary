local kick = TalkAction("/kick")

function kick.onSay(player, words, param)
	local target = Player(param)
	if not target then
		player:sendCancelMessage("Player not found.")
		return false
	end

	if target:getGroup():getAccess() then
		player:sendCancelMessage("You cannot kick this player.")
		return false
	end

	target:remove()
	return false
end

kick:separator(" ")
kick:groupType("gamemaster")
kick:register()
