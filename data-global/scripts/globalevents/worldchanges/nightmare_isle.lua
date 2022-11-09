local config = {
	-- ankrahmun - north
	[1] = {
		mapName = "ankrahmun-north",
		displayName = "north of Ankrahmun"
	},
	-- darashia - west
	[2] = {
		mapName = "darashia-west",
		displayName = "west of Darashia"
	},
	-- darashia - north
	[3] = {
		mapName = "darashia-north",
		displayName = "north of Darashia"
	}
}

local function Nightmarewebhook(message)	-- New local function that runs on delay to send webhook message.
	Webhook.send("[Nightmare Isle] ", message, WEBHOOK_COLOR_ONLINE)	--Sends webhook message
end

local NightmareIsle = GlobalEvent("NightmareIsle")
function NightmareIsle.onStartup(interval)
	local select = config[math.random(#config)]
	Game.loadMap(DATA_DIRECTORY.. '/world/world_changes/nightmare_isle/' .. select.mapName .. '.otbm')
	Spdlog.info(string.format("[WorldChanges] Nightmare Isle will be active %s today",
	select.displayName))
	local message = string.format("Nightmare Isle will be active %s today",
	select.displayName)	-- Declaring the message to send to webhook.
	addEvent(Nightmarewebhook, 60000, message) -- Event with 1 minute delay to send webhook message after server starts.

	setGlobalStorageValue(GlobalStorage.NightmareIsle, 1)

	return true
end
NightmareIsle:register()
