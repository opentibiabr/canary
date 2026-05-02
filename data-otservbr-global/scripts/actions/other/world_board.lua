local worldBoard = Action()

local communicates = {
	[1] = {
		storageValue = GlobalStorage.FuryGates,
		communicate = "A fiery fury gate has opened near one of the major cities somewhere in Tibia.",
	},

	[2] = {
		storageValue = GlobalStorage.Yasir,
		communicate = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay.",
	},

	[3] = {
		storageValue = GlobalStorage.WorldBoard.NightmareIsle.AnkrahmunNorth,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the Ankhramun tar pits!.",
	},

	[4] = {
		storageValue = GlobalStorage.WorldBoard.NightmareIsle.DarashiaNorth,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the northernmost coast!",
	},

	[5] = {
		storageValue = GlobalStorage.WorldBoard.NightmareIsle.DarashiaWest,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the river near Drefia!",
	},

	[6] = {
		kv = KV.scoped("worldchanges"):scoped("bored"),
		kvKey = "active",
		communicate = "Sharpen your sword! The witch Wyda seems to be bored so pay her a visit!",
	},
}

local function isCommunicateActive(value)
	if value.storageValue ~= nil then
		return Game.getStorageValue(value.storageValue) > 0
	end

	if value.kv ~= nil then
		local kvKey = value.kvKey or "active"
		local kvValue = value.kv:get(kvKey)
		return kvValue == true or kvValue == 1
	end

	return false
end

function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for _, value in pairs(communicates) do
		if isCommunicateActive(value) then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.communicate)
		end
	end
	return true
end

worldBoard:id(19236)
worldBoard:register()
