-- /addstorage <key>,[<value>=1],[<player>=self]

local storage = TalkAction("/addstorage")

function storage.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	-- Sanity check for parameters
	if param == "" then
		player:sendCancelMessage("You need to pass at least the storage that will be set.")
		return false
	end

	local split = param:split(",")
	local value = 1 -- Check if it was passed some value to be set to the storage
	if split[2] then
		value = split[2]
	end

	-- Check if it should add storage to another player
	if split[3] then
		local targetPlayer = Player(param[3])
		if not targetPlayer then
			player:sendCancelMessage("Player not found.")
			return false
		else
			targetPlayer:setStorageValue(split[1], value)
			return false
		end
	else
		player:setStorageValue(split[1], value)
	end
	return false
end

storage:separator(" ")
storage:register()
