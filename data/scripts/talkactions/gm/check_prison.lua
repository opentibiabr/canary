local config = {
	prisonCheckPos = Position(1606, 1033, 6),
	flamesPositions = {
		Position(1602, 1029, 6),
		Position(1606, 1029, 6),
		Position(1610, 1029, 6),
		Position(1602, 1033, 6),
		Position(1610, 1033, 6),
		Position(1602, 1037, 6),
		Position(1606, 1037, 6),
		Position(1610, 1037, 6),
	},
	wrongFlame = 1959,
	successFlame = 2133,
	minutesToPassTest = 10, -- minutes
	wrongActionId = 14515,
	successActionId = 14514,
	prisonPosition = Position(1562, 1042, 6),
	defaultPrisonHours = 3,
	players = {},
	maxTentatives = 3,
	playerTentatives = {},
}

local function checkTarget(target, remove)
	if not target then
		return { error = true, msg = "A player with that name is not online." }
	end

	if remove == nil and target:inPrison() then
		return { error = true, msg = target:getName() .. " is already on jail!" }
	end

	if remove == true and not target:inPrison() then
		return { error = true, msg = target:getName() .. " is not on jail!" }
	end

	if target:getPosition():isInRange(Position(1015, 1109, 7), Position(1094, 1738, 7)) then
		return { error = true, msg = target:getName() .. " is in training room!" }
	end

	return { error = false }
end

local function movePlayerToPrison(player, prisonHours)
	if not player then
		return true
	end

	local hours = prisonHours or config.defaultPrisonHours

	player:teleportTo(config.prisonPosition)
	local kvScoped = player:kv():scoped("prison")
	local arrestTimes = kvScoped:get("arrests") or 0
	kvScoped:set("arrests", arrestTimes + 1)
	kvScoped:set("free-in", os.time() + hours * 3600)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	player:sendTextMessage(MESSAGE_LOOT, "You didn't pass in our test! You will be {36792|arrest} for " .. hours .. " hours in our maximum security prison! Good luck..")
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have " .. arrestTimes .. " arrests!")

	local msgToAll = "The player  " .. player:getName() .. " didn't pass in our prison system test and has been arrested to be using BOT 100% AFK!"
	Game.broadcastMessage(msgToAll, MESSAGE_GAME_HIGHLIGHT)
	Webhook.sendMessage("Player Arrested", msgToAll, WEBHOOK_COLOR_WARNING)
end

local function removePlayerFromPrison(player)
	if not player then
		return true
	end

	player:kv():scoped("prison"):remove("free-in")
	player:teleportTo(player:getTown():getTemplePosition())
	player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	player:sendTextMessage(MESSAGE_LOOT, "You are {3415|FREE} again!")
end

--------------------- TALKACTIONS ---------------------
-------------------- Check Prison --------------------
local checkPrison = TalkAction("/checkprison")
function checkPrison.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid parameter. Usage: /checkprison <playerName>")
		return true
	end

	local target = Player(param:trim():lower())

	local check = checkTarget(target)
	if check.error then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, check.msg or "Error on use command!")
		return true
	end

	if #config.players > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "There's someone in test!")
		return true
	end

	local checkPositionIndex = math.random(#config.flamesPositions)
	local successFlamePos = config.flamesPositions[checkPositionIndex]

	-- remove todos os portais e cria novamente, setando a wrongActionId
	for i, pos in pairs(config.flamesPositions) do
		local tileItems = Tile(pos):getItems()
		if tileItems then
			for j, item in pairs(tileItems) do
				item:remove()
			end
		end

		if successFlamePos ~= pos then
			local newWrongFlame = Game.createItem(config.wrongFlame, 1, pos)
			newWrongFlame:setActionId(config.wrongActionId)
		end
	end

	-- cria fogo amarelo na posição selecionada
	local successFlame = Game.createItem(config.successFlame, 1, successFlamePos)
	successFlame:setActionId(config.successActionId)

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " has been moved to check prison test!")

	local oldPosition = target:getPosition()
	config.players[target:getGuid()] = oldPosition

	target:teleportTo(config.prisonCheckPos)
	target:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	target:sendTextMessage(
		MESSAGE_LOOT,
		"We have detected unnatural behaviour of your actions that match to an disallowed usage of external program like BOT full afk, If this was a mistake please enter on your {3043|designated} teleport different... \nYou have only "
			.. config.maxTentatives
			.. " chances to step in a correct teleport, if you step wrong "
			.. config.maxTentatives
			.. "x or if "
			.. config.minutesToPassTest
			.. " minute"
			.. (config.minutesToPassTest > 1 and "s" or "")
			.. " pass, you will be arrested!"
	)

	addEvent(function()
		if config.players[target:getGuid()] ~= nil then
			movePlayerToPrison(target, config.defaultPrisonHours)
		end
		return true
	end, config.minutesToPassTest * 60 * 1000)

	return true
end

checkPrison:separator(" ")
checkPrison:groupType("tutor")
checkPrison:register()

-------------------- Send to Prison --------------------
local sendPrison = TalkAction("/sendprison")
function sendPrison.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid parameters. Usage: /sendprison <playerName>, hours")
		return true
	end

	local prisonHours, target = config.defaultPrisonHours

	local split = param:split(",")
	if #split > 0 and not split[2] then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid parameters. Usage: /sendprison <playerName>, hours")
		return true
	elseif #split > 0 and split[2] then
		prisonHours = tonumber(split[2])
		target = Player(split[1])
	else
		target = Player(param:trim():lower())
	end

	local check = checkTarget(target)
	if check.error then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, check.msg or "Error on use command!")
		return true
	end

	movePlayerToPrison(target, prisonHours)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " has been moved to jail!")

	return true
end

sendPrison:separator(" ")
sendPrison:groupType("gamemaster")
sendPrison:register()

-------------------- Remove from Prison --------------------
local removePrison = TalkAction("/removeprison")
function removePrison.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid parameters. Usage: /removeprison <playerName>")
		return true
	end

	local target = Player(param:trim():lower())

	local check = checkTarget(target, true)
	if check.error then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, check.msg or "Error on use command!")
		return true
	end

	removePlayerFromPrison(target)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " has been removed from jail!")

	return true
end

removePrison:separator(" ")
removePrison:groupType("gamemaster")
removePrison:register()

-------------------- Remove Arrests --------------------
local removeArrests = TalkAction("/removearrests")
function removeArrests.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Invalid parameters. Usage: /removearrests <playerName>")
		return true
	end

	local target = Player(param:trim():lower())

	if not target then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "A player with that name is not online.")
		return true
	end

	target:kv():scoped("prison"):set("arrests", 0)
	target:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You had your arrests reset!")

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, target:getName() .. " had his arrests reset!")

	return true
end

removeArrests:separator(" ")
removeArrests:groupType("god")
removeArrests:register()

-------------------- Go to Prison --------------------
local goToPrison = TalkAction("/gotoprison")
function goToPrison.onSay(player, words, param)
	player:teleportTo(config.prisonPosition)
	player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	return true
end

goToPrison:groupType("god")
goToPrison:register()

--------------------- MOVE EVENT ---------------------
---------------- Player Stepin Check ------------------
local passInTp = MoveEvent()
function passInTp.onStepIn(creature, item, position, fromPosition)
	if not creature:isPlayer() or not creature:getPlayer() then
		return true
	end

	local player = creature:getPlayer()
	if not config.players[player:getGuid()] then
		return true
	end

	if item.actionid == config.successActionId then
		local oldPosition = config.players[player:getGuid()]
		player:teleportTo(oldPosition)
		player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
		player:sendTextMessage(MESSAGE_LOOT, "You are proved your value. You are {3415|FREE}!")
		config.players[player:getGuid()] = nil
		config.playerTentatives[player:getGuid()] = nil
	end

	if item.actionid == config.wrongActionId then
		local tentatives = config.playerTentatives[player:getGuid()]
		tentatives = tentatives == nil and 1 or (tentatives + 1)
		if tentatives == config.maxTentatives then
			movePlayerToPrison(player, config.defaultPrisonHours)
			return true
		end
		config.playerTentatives[player:getGuid()] = tentatives
		player:teleportTo(config.prisonCheckPos)
		player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You got the correct portal wrong! Try again..")
	end
	return true
end

passInTp:aid(config.successActionId, config.wrongActionId)
passInTp:type("stepin")
passInTp:register()

------------------ CREATURE EVENT ------------------
------------------- Player Login -------------------
local checkPlayerOnPrison = CreatureEvent("CheckPlayerOnPrison")
function checkPlayerOnPrison.onLogin(player)
	local timeToBeFree = player:kv():scoped("prison"):get("free-in") or -1
	if timeToBeFree < 0 then
		-- player not in prison, do nothing
		return true
	end

	if timeToBeFree <= os.time() then
		removePlayerFromPrison(player)
	else
		if not player:inPrison() then
			-- em caso do player ter sido removido, sem ser liberado, ganha mais 1 dia de detenção
			timeToBeFree = timeToBeFree + 1 * 24 * 3600
			player:teleportTo(config.prisonPosition)
			player:kv():scoped("prison"):set("free-in", timeToBeFree)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
		end
		player:sendTextMessage(MESSAGE_LOOT, string.format("You still {36792|arrested} in our maximum security prison! Good luck.. \n%s", string.format("You have %s of jail time left.", getTimeInWords(timeToBeFree - os.time()))))
	end

	return true
end

checkPlayerOnPrison:register()
