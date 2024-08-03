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

	local usage = "/setbestiary PLAYER NAME,MONSTER NAME,AMOUNT"
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

	local monsterName = split[2]
	local mType = MonsterType(monsterName)
	if not mType or (mType and mType:raceId() == 0) then
		player:sendCancelMessage("This monster has no bestiary. Type the name exactly as in game.")
		return true
	end
	local amount = tonumber(split[3])
	if not amount then
		player:sendCancelMessage("Wrong kill amount")
		return true
	end

	player:sendCancelMessage("Set bestiary kill of monster '" .. monsterName .. "' from player '" .. target:getName() .. "' to '" .. amount .. "'.")
	target:sendCancelMessage("Updated kills of monster '" .. monsterName .. "'!")
	target:addBestiaryKill(monsterName, amount)
	target:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
end

setBestiary:separator(" ")
setBestiary:groupType("god")
setBestiary:register()
