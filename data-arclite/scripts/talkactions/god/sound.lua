local areasound = TalkAction("/areasound")

function areasound.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local split = param:split(",")
	if not(split[2]) then
		local primaryEffect = tonumber(param)
		if (primaryEffect == nil or primaryEffect == 0) then
			player:sendCancelMessage("Invalid command param.")
			return false
		end

		player:sendCancelMessage("Playing sound number " .. primaryEffect .. " on the area.")
		player:getPosition():sendSingleSoundEffect(primaryEffect, player:isInGhostMode() and nil or player)
		return false
	end

	local primaryEffect = tonumber(split[1])
	local secondaryEffect = tonumber(split[2])
	if (primaryEffect == nil or secondaryEffect == nil) then
		player:sendCancelMessage("Invalid command params.")
		return false
	end

	player:sendCancelMessage("Playing sound number " .. primaryEffect .. " and " .. secondaryEffect .. " on the area.")
	player:getPosition():sendDoubleSoundEffect(primaryEffect, secondaryEffect, player:isInGhostMode() and nil or player)
	return false
end

areasound:separator(" ")
areasound:register()

local internalsound = TalkAction("/internalsound")

function internalsound.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local split = param:split(",")
	if not(split[2]) then
		local primaryEffect = tonumber(param)
		if (primaryEffect == nil or primaryEffect == 0) then
			player:sendCancelMessage("Invalid command param.")
			return false
		end

		player:sendCancelMessage("Playing sound number " .. primaryEffect .. " internally.")
		player:sendSingleSoundEffect(primaryEffect)
		return false
	end

	local primaryEffect = tonumber(split[1])
	local secondaryEffect = tonumber(split[2])
	if (primaryEffect == nil or secondaryEffect == nil) then
		player:sendCancelMessage("Invalid command params.")
		return false
	end

	player:sendCancelMessage("Playing sound number " .. primaryEffect .. " and " .. secondaryEffect .. " internally.")
	player:sendDoubleSoundEffect(primaryEffect, secondaryEffect)
	return false
end

internalsound:separator(" ")
internalsound:register()

local globalsound = TalkAction("/globalsound")

function globalsound.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local split = param:split(",")
	if not(split[2]) then
		local primaryEffect = tonumber(param)
		if (primaryEffect == nil or primaryEffect == 0) then
			player:sendCancelMessage("Invalid command param.")
			return false
		end

		player:sendCancelMessage("Playing sound number " .. primaryEffect .. " globally.")
		for _, pid in ipairs(Game.getPlayers()) do
			pid:sendSingleSoundEffect(primaryEffect, false)
		end
		return false
	end

	local primaryEffect = tonumber(split[1])
	local secondaryEffect = tonumber(split[2])
	if (primaryEffect == nil or secondaryEffect == nil) then
		player:sendCancelMessage("Invalid command params.")
		return false
	end

	player:sendCancelMessage("Playing sound number " .. primaryEffect .. " and " .. secondaryEffect .. " globally.")
	for _, pid in ipairs(Game.getPlayers()) do
		pid:sendDoubleSoundEffect(primaryEffect, secondaryEffect)
	end
	return false
end

globalsound:separator(" ")
globalsound:register()
