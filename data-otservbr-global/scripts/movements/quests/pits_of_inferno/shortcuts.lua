local setting = {
	[8816] = Storage.PitsOfInferno.ShortcutHubDoor,
	[8817] = Storage.PitsOfInferno.ShortcutLeverDoor
}

local shortcuts = MoveEvent()

function shortcuts.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local storage = setting[item.actionid]
	if player:getStorageValue(storage) ~= 1 then
		player:setStorageValue(storage, 1)
	end
	return true
end

shortcuts:type("stepin")

for index, value in pairs(setting) do
	shortcuts:aid(index)
end

shortcuts:register()
