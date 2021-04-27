local worldBoard = Action()

local communicates = {
-- Fury Gates
[1] = {
	globalStorage=65000,
	communicate = "A fiery fury gate has opened near one of the major cities somewhere in Tibia."
},
-- Yasir
[2] = {
	globalStorage = 65014,
	communicate = "Oriental ships sighted! A trader for exotic creature products may currently be visiting Carlin, Ankrahmun or Liberty Bay."
},
-- Nightmare Isle
[3] = {
	globalStorage = 65015,
	communicate = "A sandstorm travels through Darama, leading to isles full of deadly creatures inside a nightmare. Avoid the river near Drefia/northernmost coast/Ankhramun tar pits!"
}
}

function worldBoard.onUse(player, item, fromPosition, target, toPosition, isHotkey)

for index, value in pairs(communicates) do
	if getGlobalStorageValue(value.globalStorage) > 0 then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, value.communicate)
	end
end
	return true
end


worldBoard:id(21570)
worldBoard:register()
