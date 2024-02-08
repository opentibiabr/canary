local worldBoard = Action()

local communicates = {
	[1] = {
		storageValue = GlobalStorage.FuryGate,
		communicate = "A fiery fury gate has opened near one of the major cities somewhere in Tibia.",
	},

	[2] = {
		storageValue = GlobalStorage.Yasir,
		communicate = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay.",
	},

	[3] = {
		storageValue = GlobalStorage.WorldBoard.NightmareIsle.ankrahmunNorth,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the Ankhramun tar pits!.",
	},

	[4] = {
		storageValue = GlobalStorage.WorldBoard.NightmareIsle.darashiaNorth,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the northernmost coast!",
	},

	[5] = {
		storageValue = GlobalStorage.WorldBoard.NightmareIsle.darashiaWest,
		communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the river near Drefia!",
	},
}

function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	for index, value in pairs(communicates) do
		if Game.getStorageValue(value.storageValue) > 0 then
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.communicate)
		end
	end
	return true
end

worldBoard:id(19236)
worldBoard:register()
