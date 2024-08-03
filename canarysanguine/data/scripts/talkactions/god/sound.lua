local areasound = TalkAction("/areasound")

function areasound.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		local primaryEffect = tonumber(param)
		if primaryEffect == nil or primaryEffect == 0 then
			player:sendCancelMessage("Invalid command param.")
			return true
		end

		player:sendCancelMessage("Playing sound number " .. primaryEffect .. " on the area.")
		player:getPosition():sendSingleSoundEffect(primaryEffect, player:isInGhostMode() and nil or player)
		return true
	end

	local primaryEffect = tonumber(split[1])
	local secondaryEffect = tonumber(split[2])
	if primaryEffect == nil or secondaryEffect == nil then
		player:sendCancelMessage("Invalid command params.")
		return true
	end

	player:sendCancelMessage("Playing sound number " .. primaryEffect .. " and " .. secondaryEffect .. " on the area.")
	player:getPosition():sendDoubleSoundEffect(primaryEffect, secondaryEffect, player:isInGhostMode() and nil or player)
	return true
end

areasound:separator(" ")
areasound:groupType("god")
areasound:register()

---------------- // ----------------
local internalsound = TalkAction("/internalsound")

function internalsound.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		local primaryEffect = tonumber(param)
		if primaryEffect == nil or primaryEffect == 0 then
			player:sendCancelMessage("Invalid command param.")
			return true
		end

		player:sendCancelMessage("Playing sound number " .. primaryEffect .. " internally.")
		player:sendSingleSoundEffect(primaryEffect)
		return true
	end

	local primaryEffect = tonumber(split[1])
	local secondaryEffect = tonumber(split[2])
	if primaryEffect == nil or secondaryEffect == nil then
		player:sendCancelMessage("Invalid command params.")
		return true
	end

	player:sendCancelMessage("Playing sound number " .. primaryEffect .. " and " .. secondaryEffect .. " internally.")
	player:sendDoubleSoundEffect(primaryEffect, secondaryEffect)
	return true
end

internalsound:separator(" ")
internalsound:groupType("god")
internalsound:register()

---------------- // ----------------
local globalsound = TalkAction("/globalsound")

function globalsound.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local split = param:split(",")
	if not split[2] then
		local primaryEffect = tonumber(param)
		if primaryEffect == nil or primaryEffect == 0 then
			player:sendCancelMessage("Invalid command param.")
			return true
		end

		player:sendCancelMessage("Playing sound number " .. primaryEffect .. " globally.")
		for _, pid in ipairs(Game.getPlayers()) do
			pid:sendSingleSoundEffect(primaryEffect, false)
		end
		return true
	end

	local primaryEffect = tonumber(split[1])
	local secondaryEffect = tonumber(split[2])
	if primaryEffect == nil or secondaryEffect == nil then
		player:sendCancelMessage("Invalid command params.")
		return true
	end

	player:sendCancelMessage("Playing sound number " .. primaryEffect .. " and " .. secondaryEffect .. " globally.")
	for _, pid in ipairs(Game.getPlayers()) do
		pid:sendDoubleSoundEffect(primaryEffect, secondaryEffect)
	end
	return true
end

globalsound:separator(" ")
globalsound:groupType("god")
globalsound:register()
