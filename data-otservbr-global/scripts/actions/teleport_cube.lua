local config = {
    { name = "Cities"},
    { name = "Bosses" },
    { name = "Trainer", position = Position(1116, 1094, 7) },
    { name = "House", action = "teleportHouse" },
}

function teleportHouse(player)
    local house = player:getHouse()
    if not house then
        player:sendCancelMessage("You don't have a house.")
        return false
    else
        player:teleportTo(house:getExitPosition())
        return true
    end
end

local Bosses = {
    { name = "Scarlett Etzel", position = Position(33395, 32671, 6) },
    { name = "Oberon", position = Position(33363, 31342, 9) },
	{ name = "Drume", position = Position(33183, 31756, 7) },
	{ name = "Timira", position = Position(33808, 32699, 8) },
	{ name = "Urmahlulu", position = Position(33920, 31607, 8) },
	{ name = "Werelion Minibosses", position = Position(33123, 32234, 12) },
	{ name = "Leiden", position = Position(33121, 31951, 15) },
	{ name = "Lady Tenebris", position = Position(32900, 31630, 14) },
	{ name = "Thorn Knight", position = Position(32658, 32885, 14) },
	{ name = "The Time Guardian", position = Position(33009, 31667, 14) },
	{ name = "Lloyd", position = Position(32758, 32875, 14) },
	{ name = "Brain Head", position = Position(31974, 32326, 10) },
	{ name = "The Brainstealer", position = Position(32537, 31120, 15) },
	{ name = "Dream Courts", position = Position(32208, 32060, 13) },
	{ name = "Faceless Bane", position = Position(33642, 32560, 13) },
    { name = "The Dread Maiden", position = Position(33746, 31506, 14) },
    { name = "The Unwelcome", position = Position(33745, 31537, 14) },
	{ name = "The Fearfeaster", position = Position(33742, 31471, 14) },
	{ name = "The Pale Worm", position = Position(33781, 31504 , 14 ) },
	{ name = "Ghulosh", position = Position(32749, 32769, 10) },
	{ name = "Lokathmor", position = Position(32722, 32746, 10) },
	{ name = "Gorzindel", position = Position(32748, 32746, 10) },
	{ name = "Mazzinor", position = Position(32722, 32770, 10) },
	{ name = "The Scourge of Oblivion", position = Position(32480, 32598, 15) },
	{ name = "Eradicator", position = Position (32338, 31288, 14) },
	{ name = "Foreshock", position = Position (32180, 31246, 14) },
	{ name = "Anomaly", position = Position (32243, 31245, 14) },
	{ name = "Rupture", position = Position (32305, 31249, 14) },
	{ name = "World Devourer", position = Position(32213, 31381, 14) },
	
	
	
	
	{ name = "Black Vixen", position = Position(33443, 32052, 9) },
	{ name = "Shadowpelt", position = Position(33405, 32096, 9) },
	{ name = "Darkfang", position = Position(33059, 31912, 9) },
	{ name = "Bloodback", position = Position(33168, 31980, 8) },
	{ name = "Sharpclaw", position = Position(33131, 31971, 9) },

	
	
	
	
	
	
	
	
	
	{ name = "Druke Krule", position = Position(33457, 31498, 13 ) },
	{ name = "Lord Azaram", position = Position(33425, 31499 , 13) },
	{ name = "Count Vlarkorth", position = Position(33458, 31406, 13) },
	{ name = "Earl Osam", position = Position(33519, 31439, 13) },
	{ name = "Sir Baeloc & Sir Nictros", position = Position(33428, 31406, 13) },
	{ name = "King Zelos", position = Position(33492, 31546, 13) },
	{ name = "The Percht Queen", position = Position(33787, 31101, 9) },
	{ name = "Ahau", position = Position(34032, 31726, 10) },
	{ name = "Tentugly", position = Position(33797, 31389, 6) },	
	{ name = "Ratmiral Blackwhiskers", position = Position(33895, 31391, 15) },	
	{ name = "Brokul", position = Position(33522, 31468, 15) },	
	{ name = "Dragonking Zyrtarch", position = Position(33392, 31185, 10) },	
	{ name = "The Monster", position = Position(33807, 32587, 12) },	
	{ name = "Irgix The Flimsy", position = Position(33493, 31400, 8) },
	{ name = "Unaz The Mean", position = Position(33564, 31477, 8) },
	{ name = "Vok The Freakish", position = Position(33509, 31451, 9) },
	{ name = "Warzone 1,2,3", position = Position(33001, 31900, 9) },
	{ name = "Warzone 4,5,6", position = Position(33745, 32191, 14) },
	{ name = "Warzone 7,8,9", position = Position(32601, 31864, 9) },
	{ name = "Ferumbras Ascendant", position = Position(33266, 31474, 14) },
	{ name = "Soulwar Hub", position = Position(33621, 31427, 10) },
	{ name = "Rotten Blood Hub", position = Position(34105, 31995, 13) },
	{ name = "Gnomprona", position = Position(33517, 32856, 14) },

}

local Cities = {
    { name = "Thais", position = Position(32369, 32241, 7) },
    { name = "Edron", position = Position(33217, 31814, 8) },
    { name = "Carlin", position = Position(32360, 31782, 7) },
    { name = "Venore", position = Position(32957, 32076, 7) },
    { name = "Ab'Dendriel", position = Position(32732, 31634, 7) },
    { name = "Port Hope", position = Position(32594, 32745, 7) },
    { name = "Yalahar", position = Position(32787, 31276, 7) },
    { name = "Kazordoon", position = Position(32649, 31925, 11) },
    { name = "Darashia", position = Position(33213, 32454, 1) },
    { name = "Rathleton", position = Position(33594, 31899, 6) },
    { name = "Svargrond", position = Position(32212, 31132, 7) },
    { name = "Farmine", position = Position(33023, 31521, 11) },
    { name = "Ankrahmun", position = Position(33194, 32853, 8) },
    { name = "Liberty Bay", position = Position(32317, 32826, 7) },
    { name = "Roshamuul", position = Position(33513, 32363, 6) },
    { name = "Gray beach", position = Position(33447, 31323, 9) },
    { name = "Issavi", position = Position(33921, 31477, 5) },
    { name = "Marapur", position = Position(33777, 32841, 7) },
}

local teleportCube = Action()
function teleportCube.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    if (player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) or player:isPzLocked()) 
        and not (Tile(player:getPosition()):hasFlag(TILESTATE_PROTECTIONZONE)) then
        player:sendCancelMessage("You can't use this when you're in a fight.")
	player:getPosition():sendMagicEffect(CONST_ME_POFF)
        return true
    end    local window = ModalWindow {
        title = "Teleport Modal",
        message = "Locations"
    }

    for _, info in pairs(config) do
        window:addChoice(info.name, function(player, button, choice)
            if button.name ~= "Select" then
                return true
            end

            if info.name == "Bosses" then
                openLocationsModal(player, Bosses)
            elseif info.name == "Cities" then
                openLocationsModal(player, Cities)
            elseif info.name == "House" then
                teleportHouse(player)
            else
                teleportPlayer(player, info.position, info.name)
            end

            return true
        end)
    end

    window:addButton("Select")
    window:addButton("Close")
    window:setDefaultEnterButton(0)
    window:setDefaultEscapeButton(1)
    window:sendToPlayer(player)
    return true
end
teleportCube:id(31633) -- Reemplaza el ID del item con el que desees
teleportCube:register()

function openLocationsModal(player, locations)
    local locationsWindow = ModalWindow {
        title = "Locations",
        message = "Select a Location"
    }

    for _, location in ipairs(locations) do
        locationsWindow:addChoice(location.name, function(player, button, choice)
            if button.name ~= "Select" then
                return true
            end
            teleportPlayer(player, location.position, location.name)
            return true
        end)
    end

    locationsWindow:addButton("Select")
    locationsWindow:addButton("Close")
    locationsWindow:setDefaultEnterButton(0)
    locationsWindow:setDefaultEscapeButton(1)
    locationsWindow:sendToPlayer(player)
end

function teleportPlayer(player, position, locationName)

        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You were teleported to " .. locationName)
        player:teleportTo(position)
        player:getPosition():sendMagicEffect(CONST_ME_SUPREME_CUBE)

      
    end


--   -- Establece el nuevo valor del temporizador con el tiempo actual más el tiempo de enfriamiento
    --    player:setStorageValue(cubeTimerStorage, os.time() + cubeCooldown)
  --  else
      --  local remainingCooldown = playerTimerValue - os.time()
       -- player:sendCancelMessage("You cannot use this item yet. It is still on cooldown. Please wait " .. math.ceil(remainingCooldown / 60) .. " minutes.")