local config = {
    { name="Thais", position = Position(32369, 32241, 7) },
	{ name="Edron", position = Position(33217, 31814, 8) },
	{ name="Carlin", position = Position(32360, 31782, 7) },
	{ name="Venore", position = Position(32957, 32076, 7) },
	{ name="Ab'Dendriel", position = Position(32732, 31634, 7) },
	{ name="Port Hope", position = Position(32594, 32745, 7) },
	{ name="Yalahar", position = Position(32787, 31276, 7) },
	{ name="Kazordoon", position = Position(32649, 31925, 11) },
	{ name="Darashia", position = Position(33213, 32454, 1) },
	{ name="Rathleton", position = Position(33594, 31899, 6) },
	{ name="Svargrond", position = Position(32212, 31132, 7) },
	{ name="Farmine", position = Position(33023, 31521, 11) },
	{ name="Ankrahmun", position = Position(33194, 32853, 8) },
	{ name="Liberty Bay", position = Position(32317, 32826, 7) },
	{ name="Roshamuul", position = Position(33513, 32363, 6) },
	{ name="Gray beach", position = Position(33447, 31323, 9) },
	{ name="Issavi", position = Position(33921, 31477, 5) },
	{ name="Krailos", position = Position(33655, 31666, 8) },
	{ name="Hunts Teleports", position = Position(31891, 32024, 8) },
	{ name="Forge", position = Position(32376, 32239, 7) },
}



local teleportSupreme = Action()

function teleportSupreme.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    player:registerEvent("modal")

    local supremeCubeModal = ModalWindow(1, "Select a Location")
    for i, location in ipairs(config) do
        supremeCubeModal:addChoice(i, location.name)
    end
    supremeCubeModal:addButton(0, "Select")
    supremeCubeModal:addButton(1, "Cancel")
    supremeCubeModal:setDefaultEnterButton(0)
    supremeCubeModal:setDefaultEscapeButton(1)
    supremeCubeModal:sendToPlayer(player)
    return true
end

teleportSupreme:id(31633)
teleportSupreme:register()

local modal = CreatureEvent("modal")

function modal.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("modal")
    if buttonId == 0 then
        local selectedLocation = config[choiceId]
        if selectedLocation then
            player:teleportTo(selectedLocation.position)
        end
    end
    return true
end

modal:type("modalwindow")
modal:register()





