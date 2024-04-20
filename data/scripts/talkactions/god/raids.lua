local startRaid = TalkAction("/raid")

function startRaid.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	if param == "" then
		player:sendCancelMessage("Command param required.")
		return true
	end

	if Raid.registry[param] then
		local raid = Raid.registry[param]
		if raid:tryStart(true) then
			player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Raid " .. param .. " started.")
		else
			player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Raid " .. param .. " could not be started.")
		end
		return true
	end

	local returnValue = Game.startRaid(param)
	if returnValue ~= RETURNVALUE_NOERROR then
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, Game.getReturnMessage(returnValue))
	else
		player:sendTextMessage(MESSAGE_ADMINISTRATOR, "Raid started.")
	end
	return true
end

startRaid:separator(" ")
startRaid:groupType("god")
startRaid:register()

local simulator = TalkAction("/simraid")

function simulator.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)
	-- initialChance,targetChancePerDay,maxChancePerCheck
	local zone = Zone("raid.simzone")
	local params = param:split(",")
	local initialChance = tonumber(params[1])
	local targetChancePerDay = tonumber(params[2])
	local maxChancePerCheck = tonumber(params[3])
	local raid = Raid("simraid", {
		zone = zone,
		allowedDays = { "Monday", "Tuesday", "Wednesday", "Thursday", "Friday", "Saturday", "Sunday" },
		minActivePlayers = 0,
		initialChance = initialChance == 0 and nil or initialChance,
		targetChancePerDay = targetChancePerDay,
		maxChancePerCheck = maxChancePerCheck,
	})
	raid.kv:set("failed-attempts", 0)
	raid.kv:set("trigger-when-possible", false)
	raid.kv:set("last-occurrence", 0)
	raid.kv:set("checks-today", 0)

	local triggerCount = 0
	local rolls = 0

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Simulating raid with initialChance=" .. initialChance .. ", targetChancePerDay=" .. targetChancePerDay .. ", maxChancePerCheck=" .. maxChancePerCheck .. "...")

	local checksPerDay = ParseDuration("23h") / ParseDuration(Raid.checkInterval)
	while triggerCount < 10 do
		rolls = rolls + 1
		if raid:tryStart() then
			triggerCount = triggerCount + 1
			raid:reset()
		end
	end

	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Raid triggered " .. triggerCount .. " times in " .. rolls .. " rolls (" .. rolls / checksPerDay .. " days or once every " .. (rolls / checksPerDay) / triggerCount .. " days)")
	return true
end

simulator:separator(" ")
simulator:groupType("god")
simulator:register()

local listRaid = TalkAction("/listraid")

function listRaid.onSay(player, words, param)
	-- create log
	logCommand(player, words, param)

	local raids = {}
	for name, raid in pairs(Raid.registry) do
		table.insert(raids, name)
	end
	table.sort(raids)

	local message = "Registered raids: "
	for _, name in ipairs(raids) do
		message = message .. name .. ", "
	end
	message = message:sub(1, -3)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, message)
	return true
end

listRaid:separator(" ")
listRaid:groupType("god")
listRaid:register()
