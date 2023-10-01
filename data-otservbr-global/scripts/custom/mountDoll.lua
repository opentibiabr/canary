local mounts = {
    {name = "Widow Queen", clientid = {368}},
    {name = "Racing Bird", clientid = {369}},
    {name = "Black Sheep", clientid = {371}},
    {name = "Midnight Panther", clientid = {372}},
    {name = "Draptor", clientid = {373}},
    {name = "Titanica", clientid = {374}},
    {name = "Tin Lizzard", clientid = {375}},
    {name = "Blazebringer", clientid = {376}},
    {name = "Rapid Boar", clientid = {377}},
    {name = "Stampor", clientid = {378}},
    {name = "Undead Cavebear", clientid = {379}},
    {name = "Donkey", clientid = {387}},
    {name = "Tiger Slug", clientid = {388}},
    {name = "Uniwheel", clientid = {389}},
    {name = "Crystal Wolf", clientid = {390}},
    {name = "War Horse", clientid = {392}},
    {name = "Kingly Deer", clientid = {401}},
    {name = "Tamed Panda", clientid = {402}},
    {name = "Dromedary", clientid = {405}},
    {name = "Scorpion King", clientid = {406}},
    {name = "Rented Horse", clientid = {421}},
    {name = "Armoured War Horse", clientid = {426}},
    {name = "Shadow Draptor", clientid = {427}},
    {name = "Rented Horse (Gray)", clientid = {437}},
    {name = "Rented Horse (Brown)", clientid = {438}},
    {name = "Lady Bug", clientid = {447}},
    {name = "Manta Ray", clientid = {450}},
    {name = "Ironblight", clientid = {502}},
    {name = "Magma Crawler", clientid = {503}},
    {name = "Dragonling", clientid = {506}},
    {name = "Gnarlhound", clientid = {515}},
    {name = "Crimson Ray", clientid = {521}},
    {name = "Steelbeak", clientid = {522}},
    {name = "Water Buffalo", clientid = {526}},
    {name = "Tombstinger", clientid = {546}},
    {name = "Platesaurian", clientid = {547}},
    {name = "Ursagrodon", clientid = {548}},
    {name = "The Hellgrip", clientid = {559}},
    {name = "Noble Lion", clientid = {571}},
    {name = "Desert King", clientid = {572}},
    {name = "Shock Head", clientid = {580}},
    {name = "Walker", clientid = {606}},
    {name = "Azudocus", clientid = {621}},
    {name = "Carpacosaurus", clientid = {622}},
    {name = "Death Crawler", clientid = {624}},
    {name = "Flamesteed", clientid = {626}},
    {name = "Jade Lion", clientid = {627}},
    {name = "Jade Pincer", clientid = {628}},
    {name = "Nethersteed", clientid = {629}},
    {name = "Tempest", clientid = {630}},
    {name = "Winter King", clientid = {631}},
    {name = "Doombringer", clientid = {644}},
    {name = "Woodland Prince", clientid = {647}},
    {name = "Hailstorm Fury", clientid = {648}},
    {name = "Siegebreaker", clientid = {649}},
    {name = "Poisonbane", clientid = {650}},
    {name = "Blackpelt", clientid = {651}},
    {name = "Golden Dragonfly", clientid = {669}},
    {name = "Steel Bee", clientid = {670}},
    {name = "Copper Fly", clientid = {671}},
    {name = "Tundra Rambler", clientid = {672}},
    {name = "Highland Yak", clientid = {673}},
    {name = "Glacier Vagabond", clientid = {674}},
    {name = "Flying Divan", clientid = {688}},
    {name = "Magic Carpet", clientid = {689}},
    {name = "Floating Kashmir", clientid = {690}},
    {name = "Ringtail Waccoon", clientid = {691}},
    {name = "Night Waccoon", clientid = {692}},
    {name = "Emerald Waccoon", clientid = {693}},
    {name = "Glooth Glider", clientid = {682}},
    {name = "Shadow Hart", clientid = {685}},
    {name = "Black Stag", clientid = {686}},
    {name = "Emperor Deer", clientid = {687}},
    {name = "Flitterkatzen", clientid = {726}},
    {name = "Venompaw", clientid = {727}},
    {name = "Batcat", clientid = {728}},
    {name = "Sea Devil", clientid = {734}},
    {name = "Coralripper", clientid = {735}},
    {name = "Plumfish", clientid = {736}},
    {name = "Gorongra", clientid = {738}},
    {name = "Noctungra", clientid = {739}},
    {name = "Silverneck", clientid = {740}},
    {name = "Slagsnare", clientid = {761}},
    {name = "Nightstinger", clientid = {762}},
    {name = "Razorcreep", clientid = {763}},
    {name = "Rift Runner", clientid = {848}},
    {name = "Nightdweller", clientid = {849}},
    {name = "Frostflare", clientid = {850}},
    {name = "Cinderhoof", clientid = {851}},
    {name = "Mouldpincer", clientid = {868}},
    {name = "Bloodcurl", clientid = {869}},
    {name = "Leafscuttler", clientid = {870}},
    {name = "Sparkion", clientid = {883}},
    {name = "Swamp Snapper", clientid = {886}},
    {name = "Mould Shell", clientid = {887}},
    {name = "Reed Lurker", clientid = {888}},
    {name = "Neon Sparkid", clientid = {889}},
    {name = "Vortexion", clientid = {890}},
    {name = "Ivory Fang", clientid = {901}},
    {name = "Shadow Claw", clientid = {902}},
    {name = "Snow Pelt", clientid = {903}},
    {name = "Jackalope", clientid = {905}},
    {name = "Dreadhare", clientid = {906}},
    {name = "Wolpertinger", clientid = {907}},
    {name = "Stone Rhino", clientid = {937}},
    {name = "Gold Sphinx", clientid = {950}},
    {name = "Emerald Sphinx", clientid = {951}},
    {name = "Shadow Sphinx", clientid = {952}},
    {name = "Jungle Saurian", clientid = {959}},
    {name = "Ember Saurian", clientid = {960}},
    {name = "Lagoon Saurian", clientid = {961}},
    {name = "Blazing Unicorn", clientid = {1017}},
    {name = "Arctic Unicorn", clientid = {1018}},
    {name = "Prismatic unicorn", clientid = {1019}},
    {name = "Cranium Spider", clientid = {1025}},
    {name = "Cave Tarantula", clientid = {1026}},
    {name = "Gloom Widow", clientid = {1027}},
    {name = "Mole", clientid = {1049}},
    {name = "Marsh Toad", clientid = {1052}},
    {name = "Sanguine Frog", clientid = {1053}},
    {name = "Toxic Toad", clientid = {1054}},
    {name = "Ebony Tiger", clientid = {1091}},
    {name = "Feral Tiger", clientid = {1092}},
    {name = "Jungle Tiger", clientid = {1093}},
    {name = "Fleeting Knowledge", clientid = {1101}},
    {name = "Tawny Owl", clientid = {1104}},
    {name = "Snowy Owl", clientid = {1105}},
    {name = "Boreal Owl", clientid = {1106}},
    {name = "Lacewing Moth", clientid = {1150}},
    {name = "Hibernal Moth", clientid = {1151}},
    {name = "Cold Percht Sleigh", clientid = {1163}},
    {name = "Bright Percht Sleigh", clientid = {1164}},
    {name = "Festive Snowman", clientid = {1167}},
    {name = "Muffled Snowman", clientid = {1168}},
    {name = "Caped Snowman", clientid = {1169}},
    {name = "Dark Percht Sleigh", clientid = {1165}},
    {name = "Rabbit Rickshaw", clientid = {1179}},
    {name = "Bunny Dray", clientid = {1180}},
    {name = "Cony Cart", clientid = {1181}},
    {name = "River Crocovile", clientid = {1183}},
    {name = "Swamp Crocovile", clientid = {1184}},
    {name = "Nightmarish Crocovile", clientid = {1185}},
    {name = "Gryphon", clientid = {1191}},
    {name = "Jousting Eagle", clientid = {1208}},
    {name = "Cerberus Champion", clientid = {1209}},
    {name = "Cold Percht Sleigh Variant", clientid = {1229}},
    {name = "Bright Percht Sleigh Variant", clientid = {1230}},
    {name = "Dark Percht Sleigh Variant", clientid = {1231}},
    {name = "Cold Percht Sleigh Final", clientid = {1232}},
    {name = "Bright Percht Sleigh Final", clientid = {1233}},
    {name = "Dark Percht Sleigh Final", clientid = {1234}},
    {name = "Battle Badger", clientid = {1247}},
    {name = "Ether Badger", clientid = {1248}},
    {name = "Zaoan Badger", clientid = {1249}},
    {name = "Blue Rolling Barrel", clientid = {1257}},
    {name = "Red Rolling Barrel", clientid = {1258}},
    {name = "Green Rolling Barrel", clientid = {1259}},
    {name = "Floating Sage", clientid = {1264}},
    {name = "Floating Scholar", clientid = {1265}},
    {name = "Floating Augur", clientid = {1266}},
    {name = "Haze", clientid = {1269}},
    {name = "Antelope", clientid = {1281}},
    {name = "Snow Strider", clientid = {1284}},
    {name = "Dusk Pryer", clientid = {1285}},
    {name = "Dawn Strayer", clientid = {1286}},
    {name = "Phantasmal Jade", clientid = {1321}},
    {name = "Savanna Ostrich", clientid = {1324}},
    {name = "Coral Rhea", clientid = {1325}},
    {name = "Eventide Nandu", clientid = {1326}},
    {name = "Voracious Hyaena", clientid = {1333}},
    {name = "Cunning Hyaena", clientid = {1334}},
    {name = "Scruffy Hyaena", clientid = {1335}},
    {name = "White Lion", clientid = {1336}},
    {name = "Krakoloss", clientid = {1363}},
    {name = "Merry Mammoth", clientid = {1379}},
    {name = "Holiday Mammoth", clientid = {1380}},
    {name = "Festive Mammoth", clientid = {1381}},
    {name = "Void Watcher", clientid = {1389}},
    {name = "Rune Watcher", clientid = {1390}},
    {name = "Rift Watcher", clientid = {1391}},
    {name = "Phant", clientid = {1417}},
    {name = "Shellodon", clientid = {1430}},
    {name = "Singeing Steed", clientid = {1431}},
    {name = "Hyacinth", clientid = {1439}},
    {name = "Peony", clientid = {1440}},
    {name = "Dandelion", clientid = {1441}},
    {name = "Rustwurm", clientid = {1446}},
    {name = "Bogwurm", clientid = {1447}},
    {name = "Gloomwurm", clientid = {1448}},
    {name = "Emerald Raven", clientid = {1453}},
    {name = "Mystic Raven", clientid = {1454}},
    {name = "Radiant Raven", clientid = {1455}},
    {name = "Gloothomotive", clientid = {1459}}

}



local mountsItem = Action()
local itemMountDoll

function purchasemount(player, choice)
    local selectedOutfit = mounts[choice]
    if selectedOutfit then
        print(selectedOutfit.name)
        itemMountDoll:remove(1)
        player:addMount(selectedOutfit.name) -- Remove [1] index
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Mount added: " .. selectedOutfit.name)
        local effect = tonumber(6)
        if(effect ~= nil and effect > 0) then
            player:getPosition():sendMagicEffect(effect)
        end
    else
        player:sendCancelMessage("Invalid choice!")
    end
end


function mountsItem.onUse(player, item, fromPosition, target, toPosition, isHotkey)
    print("clicou no addon doll")
    player:registerEvent("modalou")
    itemMountDoll = item
    
    if item:getId() == 20308 then
        local title = "Mounts Shop!"
        local message = "Select your mount:"
        local window = ModalWindow(0, title, message)
        
        for i, outfit in ipairs(mounts) do
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

mountsItem:id(20308)
mountsItem:register()

local modalmount = CreatureEvent("modalou")

function modalmount.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("modalou")
    if modalWindowId == 0 and buttonId == 0 then
        purchasemount(player, choiceId)
    end
    return true
end

modalmount:type("modalwindow")
modalmount:register()