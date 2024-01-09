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
local teleportCooldown = 300 -- 5 minutes cooldown in seconds
local lastTeleportTime = {}

local teleportSupreme = Action()
function teleportSupreme.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    local itemId = item:getId()

    -- Check if the item has a cooldown
    if lastTeleportTime[player:getId()] and os.time() - lastTeleportTime[player:getId()] < teleportCooldown then
        local remainingCooldown = teleportCooldown - (os.time() - lastTeleportTime[player:getId()])
        player:sendCancelMessage("You must wait " .. remainingCooldown .. " seconds before using this item again.")
        return true
    end

    player:registerEvent("modal")

    local supremeCubeModal = ModalWindow(1, "Select a Location")
    if not player:isPzLocked() and not player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) then
        for i, location in ipairs(config) do
            supremeCubeModal:addChoice(i, location.name)
        end
    else
        player:sendCancelMessage("You can't use this when you're in a fight.")
        Position(fromPosition):sendMagicEffect(CONST_ME_POFF)
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
			player:say("~*Supreme Cube*~", TALKTYPE_MONSTER_SAY)
			player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            player:teleportTo(selectedLocation.position)

            -- Update the last teleport time for cooldown
            lastTeleportTime[player:getId()] = os.time()
        end
    end

    return true
end

modal:type("modalwindow")
modal:register()