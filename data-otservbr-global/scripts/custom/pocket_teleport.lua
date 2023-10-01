local teleportItem = Action()

local cidades = {
   
    {name = "Thais", townId = 8},
    {name = "Venore", townId = 9},
    {name = "Carlin", townId = 6},
    {name = "Edron", townId = 11},
    {name = "Yalahar", townId = 17},
    {name = "Ab'Dendriel", townId = 5},
    {name = "Farmine", townId = 12},
    {name = "Ankrahmun", townId = 10},
    {name = "Bounac", townId = 25},
    {name = "Cobra Bastion", townId = 24},
    {name = "Krailos", townId = 19},
    {name = "Darashia", townId = 13},
    {name = "Issavi", townId = 22},
    {name = "Farmine", townId = 9},
    {name = "Gray Beach", townId = 18},
    {name = "Kazordoon", townId = 7},
    {name = "Liberty Bay", townId = 14},
    {name = "Port Hope", townId = 15},
    {name = "Neptune", townId = 30},
    {name = "Rathleton", townId = 20},
    {name = "Roshamuul", townId = 21},
    {name = "Svargrond", townId = 16},
    {name = "Feyrist", townId = 26},
    {name = "Gnomprona", townId = 27},
    {name = "Marapur", townId = 28}
}

function teleportToCity(player, choice)

    if not player:isPzLocked() and not player:getCondition(CONDITION_INFIGHT, CONDITIONID_DEFAULT) then
        local city = cidades[choice]
        local townId = city.townId
        local cityPos = getTownTemplePosition(townId)
        player:teleportTo(cityPos) 
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
	else
		player:sendCancelMessage("You can't use this when you're in a fight.")
		Position(fromPosition):sendMagicEffect(CONST_ME_POFF)
	end
end

function teleportItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    player:registerEvent("modal2")
	if item:getId() == 19369 then
        local title = "Select a city"
        local message = "Choose a city to teleport to:"
        local window = ModalWindow(0, title, message)
        

        for i = 1, #cidades do
            window:addChoice(i, cidades[i].name)
        end
        
        window:addButton(0, "OK")
        window:addButton(1, "Cancel")
        window:setDefaultEnterButton(100)
        window:setDefaultEscapeButton(101)
        window:sendToPlayer(player)
        return true
    end
    
    return false
end

teleportItem:id(19369)
teleportItem:register()

local modaltp = CreatureEvent("modal2")

function modaltp.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("modal2")
    if modalWindowId == 0 then
        teleportToCity(player,choiceId)
    end
    return true
end


modaltp:type("modalwindow")
modaltp:register()