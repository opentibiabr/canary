local createMonster = TalkAction("/spawn")

function createMonster.onSay(player, words, param)
	if not player:getGroup():getAccess() or player:getAccountType() < ACCOUNT_TYPE_GOD then
		return true
	end

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return false
	end

	local spawn = Spawn()
	local parameter = param:split(",")
	local config = {
		{
			spawntime = tonumber(parameter[2]) or 60,
			monster = parameter[1],
			pos = player:getPosition(),
			status = true
		}
	}
	spawn:setPositions(config)
	spawn:executeSpawn()
	return false
end

createMonster:separator(" ")
createMonster:register()