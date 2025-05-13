local addCharm = TalkAction("/addcharms")

function addCharm.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local usage = "/addcharms PLAYER NAME,AMOUNT"
	if param == "" then
		player:sendCancelMessage("Command param required. Usage: " .. usage)
		return true
	end
	local split = param:split(",")
	if not split[2] then
		player:sendCancelMessage("Insufficient parameters. Usage: " .. usage)
		return true
	end
	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	split[2] = split[2]:trimSpace()

	player:sendCancelMessage("Added " .. split[2] .. " charm points to character '" .. target:getName() .. "'.")
	target:sendCancelMessage("Received " .. split[2] .. " charm points!")
	target:addCharmPoints(tonumber(split[2]))
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
end

addCharm:separator(" ")
addCharm:groupType("god")
addCharm:register()

---------------- // ----------------
local resetCharm = TalkAction("/resetcharms")

function resetCharm.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		param = player:getName()
	end
	local target = Player(param)
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	player:sendCancelMessage("Reseted charm points from character '" .. target:getName() .. "'.")
	target:sendCancelMessage("Reseted your charm points!")
	target:resetCharmsBestiary()
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
end

resetCharm:separator(" ")
resetCharm:groupType("god")
resetCharm:register()

---------------- // ----------------
local charmExpansion = TalkAction("/charmexpansion")

function charmExpansion.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		param = player:getName()
	end
	local target = Player(param)
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	player:sendCancelMessage("Added charm expansion for player '" .. target:getName() .. "'.")
	target:sendCancelMessage("Received charm expansion!")
	target:charmExpansion(true)
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
end

charmExpansion:separator(" ")
charmExpansion:groupType("god")
charmExpansion:register()

---------------- // ----------------
local charmRune = TalkAction("/charmrunes")

function charmRune.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		param = player:getName()
	end
	local target = Player(param)
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	player:sendCancelMessage("Added all charm runes to '" .. target:getName() .. "'.")
	target:sendCancelMessage("Received all charm runes!")
	target:unlockAllCharmRunes()
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
end

charmRune:separator(" ")
charmRune:groupType("god")
charmRune:register()

---------------- // ----------------
local setBestiary = TalkAction("/setbestiary")

function setBestiary.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local usage = "/setbestiary PLAYER NAME,MONSTER NAME/ALL,AMOUNT"
	if param == "" then
		player:sendCancelMessage("Command param required. Usage: " .. usage)
		return true
	end
	local split = param:split(",")
	if not split[3] then
		player:sendCancelMessage("Insufficient parameters. Usage: " .. usage)
		return true
	end
	local target = Player(split[1])
	if not target then
		player:sendCancelMessage("A player with that name is not online.")
		return true
	end

	split[2] = split[2]:trimSpace()
	split[3] = split[3]:trimSpace()

	local amount = tonumber(split[3])
	if not amount then
		player:sendCancelMessage("Wrong kill amount.")
		return true
	end

	local monsterName = split[2]
	-- If "all" is specified, iterate through all monsters
	if monsterName:lower() == "all" then
		local monsterList = Game.getMonsterTypes() -- Retrieves all available monsters
		for _, mType in pairs(monsterList) do
			if mType:raceId() > 0 then -- Ensure the monster has a bestiary entry
				target:addBestiaryKill(mType:name(), amount)
			end
		end
		player:sendCancelMessage("Set bestiary kill count to '" .. amount .. "' for all monsters for player '" .. target:getName() .. "'.")
		target:sendCancelMessage("Updated kills for all monsters in the bestiary!")
	else
		local mType = MonsterType(monsterName)
		if not mType or (mType and mType:raceId() == 0) then
			player:sendCancelMessage("This monster has no bestiary. Type the name exactly as in the game.")
			return true
		end

		target:addBestiaryKill(monsterName, amount)
		player:sendCancelMessage("Set bestiary kill of monster '" .. monsterName .. "' for player '" .. target:getName() .. "' to '" .. amount .. "'.")
		target:sendCancelMessage("Updated kills of monster '" .. monsterName .. "'!")
	end

	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
end

setBestiary:separator(" ")
setBestiary:groupType("god")
setBestiary:register()
