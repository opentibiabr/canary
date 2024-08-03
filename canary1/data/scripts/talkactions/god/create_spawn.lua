local createMonster = TalkAction("/spawn")

function createMonster.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	local spawn = Spawn()
	local parameter = param:split(",")
	local config = {
		{
			spawntime = tonumber(parameter[2]) or 60,
			monster = parameter[1],
			pos = player:getPosition(),
			status = true,
		},
	}
	spawn:setPositions(config)
	spawn:executeSpawn()
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_GREEN)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have spawned " .. parameter[1] .. ".")
	return true
end

createMonster:separator(" ")
createMonster:groupType("god")
createMonster:register()
