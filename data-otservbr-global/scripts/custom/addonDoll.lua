
local outfits = {
    {name = "Citizen", looktype = {136, 128}},
    {name = "Hunter", looktype = {137, 129}},
    {name = "Knight", looktype = {139, 131}},
    {name = "Noblewoman", looktype = {140, 132}},
    {name = "Warrior", looktype = {142, 134}},
    {name = "Barbarian", looktype = {147, 143}},
    {name = "Druid", looktype = {148, 144}},
    {name = "Wizard", looktype = {149, 145}},
    {name = "Oriental", looktype = {150, 146}},
    {name = "Pirate", looktype = {147, 143}},
    {name = "Assassin", looktype = {156, 152}},
    {name = "Beggar", looktype = {157, 153}},
    {name = "Shaman", looktype = {158, 154}},
    {name = "Norsewoman", looktype = {252, 251}},
    {name = "Nightmare", looktype = {269, 268}},
    {name = "Jester", looktype = {270, 273}},
    {name = "Brotherhood", looktype = {279, 278}},
    {name = "Newly Wed", looktype = {329, 328}},
    {name = "Warmaster", looktype = {335, 336}},
    {name = "Wayfarer", looktype = {366, 367}},
    {name = "Afflicted", looktype = {431, 430}},
    {name = "Elementalist", looktype = {433, 432}},
    {name = "Deepling", looktype = {464, 463}},
    {name = "Insectoid", looktype = {466, 465}},
    {name = "Entrepreneur", looktype = {471, 472}},
    {name = "Crystal Warlord", looktype = {513, 512}},
    {name = "Soil Guardian", looktype = {516, 514}},
    {name = "Demon", looktype = {542, 541}},
    {name = "Cave Explorer", looktype = {574, 575}},
    {name = "Dream Warden", looktype = {577, 578}},
    {name = "Glooth Engineer", looktype = {610, 618}},
    {name = "Jersey", looktype = {620, 619}},
    {name = "Champion", looktype = {633, 632}},
    {name = "Conjurer", looktype = {635, 634}},
    {name = "Beastmaster", looktype = {637, 636}},
    {name = "Chaos Acolyte", looktype = {664, 665}},
    {name = "Death Herald", looktype = {667, 666}},
    {name = "Ranger", looktype = {683, 684}},
    {name = "Ceremonial Garb", looktype = {695, 694}},
    {name = "Puppeteer", looktype = {696, 697}},
    {name = "Spirit Caller", looktype = {698, 699}},
    {name = "Evoker", looktype = {724, 725}},
    {name = "Seaweaver", looktype = {732, 733}},
    {name = "Recruiter", looktype = {746, 745}},
    {name = "Sea Dog", looktype = {749, 750}},
    {name = "Royal Pumpkin", looktype = {760, 759}},
    {name = "Rift Warrior", looktype = {846, 845}},
    {name = "Winter Warden", looktype = {852, 853}},
    {name = "Philosopher", looktype = {873, 874}},
    {name = "Arena Champion", looktype = {885, 884}},
    {name = "Lupine Warden", looktype = {899, 900}},
    {name = "Grove Keeper", looktype = {909, 908}},
    {name = "Festive", looktype = {931, 929}},
    {name = "Pharaoh", looktype = {956, 955}},
    {name = "Trophy Hunter", looktype = {957, 958}},
    {name = "Retro Warrior", looktype = {963, 962}},
    {name = "Retro Summoner", looktype = {964, 965}},
    {name = "Retro Noblewoman", looktype = {967, 966}},
    {name = "Retro Mage", looktype = {968, 969}},
    {name = "Retro Knight", looktype = {971, 970}},
    {name = "Retro Hunter", looktype = {972, 973}},
    {name = "Retro Citizen", looktype = {975, 974}},
    {name = "Herbalist", looktype = {1021, 1020}},
    {name = "Sun Priest", looktype = {1024, 1023}},
    {name = "Makeshift Warrior", looktype = {1043, 1042}},
    {name = "Siege Master", looktype = {1050, 1051}},
    {name = "Mercenary", looktype = {1056, 1057}},
    {name = "Battle Mage", looktype = {1070, 1069}},
    {name = "Discoverer", looktype = {1095, 1094}},
    {name = "Sinister Archer", looktype = {1102, 1103}},
    {name = "Pumpkin Mummy", looktype = {1128, 1127}},
    {name = "Dream Warrior", looktype = {1146, 1147}},
    {name = "Percht Raider", looktype = {1162, 1161}},
    {name = "Owl Keeper", looktype = {1173, 1174}},
    {name = "Guidon Bearer", looktype = {1187, 1186}},
    {name = "Void Master", looktype = {1203, 1202}},
    {name = "Veteran Paladin", looktype = {1205, 1204}},
    {name = "Lion of War", looktype = {1207, 1206}},
    {name = "Hand of the Inquisition", looktype = {1244, 1243}},
    {name = "Breezy Garb", looktype = {1245, 1246}},
    {name = "Orcsoberfest Garb", looktype = {1252, 1251}},
    {name = "Herder", looktype = {1280, 1279}},
    {name = "Falconer", looktype = {1283, 1282}},
    {name = "Dragon Slayer", looktype = {1289, 1288}},
    {name = "Trailblazer", looktype = {1293, 1292}},
    {name = "Revenant", looktype = {1323, 1322}},
    {name = "Jouster", looktype = {1331, 1332}},
    {name = "Moth Cape", looktype = {1339, 1338}},
    {name = "Rascoohan", looktype = {1372, 1371}},
    {name = "Merry Garb", looktype = {1383, 1382}},
    {name = "Rune Master", looktype = {1385, 1384}},
    {name = "Citizen of Issavi", looktype = {1387, 1386}},
    {name = "Forest Warden", looktype = {1416, 1415}},
    {name = "Royal Bounacean Advisor", looktype = {1437, 1436}},
    {name = "Dragon Knight", looktype = {1445, 1444}},
    {name = "Arbalester", looktype = {1449, 1450}},
    {name = "Formal Dress", looktype = {1460, 1461}}
}

local addonItem = Action()
local itemDoll

function purchaseaddon(player, choice)
    local selectedOutfit = outfits[choice]
    if selectedOutfit then
        itemDoll:remove(1)
        player:addOutfitAddon(selectedOutfit.looktype[1], 3)
        player:addOutfitAddon(selectedOutfit.looktype[2], 3)
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Addon added for outfit: " .. selectedOutfit.name)
        local effect = tonumber(6)
if(effect ~= nil and effect > 0) then
    player:getPosition():sendMagicEffect(effect)
end
    else
        player:sendCancelMessage("Invalid choice!")
    end
end

function addonItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    player:registerEvent("modal5")
    itemDoll = item
    if item:getId() == 24394 then
        local title = "Addon Full Shop!"
        local message = "Select your addon:"
        local window = ModalWindow(0, title, message)
        
        for i, outfit in ipairs(outfits) do
            window:addChoice(i, outfit.name)
        end
        
        window:addButton(0, "Buy")
        window:addButton(1, "Cancel")
        window:setDefaultEnterButton(100)
        window:setDefaultEscapeButton(101)
        window:sendToPlayer(player)
        
        return true
    end
    
    return false
end

addonItem:id(24394)
addonItem:register()

local modaltp = CreatureEvent("modal5")

function modaltp.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("modal5")
    if modalWindowId == 0 and buttonId == 0 then
        purchaseaddon(player, choiceId)
    end
    return true
end

modaltp:type("modalwindow")
modaltp:register()