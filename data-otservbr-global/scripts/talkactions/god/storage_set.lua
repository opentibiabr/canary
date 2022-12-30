local storageSet = TalkAction("/set")

function storageSet.onSay(cid, words, param)
	local player = Player(cid)
	if not player:getGroup():getAccess() then
		return true
	end

	if player:getAccountType() < ACCOUNT_TYPE_GOD then
		return false
	end

	local split = param:split(",")
	if split[2] == nil then
		player:sendCancelMessage("Insufficient parameters.")
		return false
	end

	local target = Player(split[1])
	if target == nil then
		player:sendCancelMessage("A player with that name is not online.")
		return false
	end

	-- Trim left
	split[2] = split[2]:gsub("^%s*(.-)$", "%1")
	split[3] = split[3]:gsub("^%s*(.-)$", "%1")
	local ch = split[2]
	local ch2 = split[3]
	setPlayerStorageValue(getPlayerByName(split[1]), tonumber(ch), tonumber(ch2))
	doPlayerSendTextMessage(cid, MESSAGE_EVENT_ADVANCE, "The storage with id: "..tonumber(ch).." from player "..split[1].." is now: "..ch2..".")
	return false
end

storageSet:separator(" ")
storageSet:register()
