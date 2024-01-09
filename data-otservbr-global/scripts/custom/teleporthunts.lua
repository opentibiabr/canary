-- Config
local tplist = {







    [40031] = {name = "Dragons", level = {35, 35, 40, 40}, positions = {{x = 32820, y = 32140, z = 7}, {x = 32750 , y = 31295, z = 9}, {x = 33265 , y = 32266, z = 10}, {x = 33118 , y = 32601, z = 6}}, subareas = {'Dlair Venore', 'Dlair Yalahar', 'Dlair Darashia', 'Dlair Ankrahmun'}},
    [40032] = {name = "Dragon Lords", level = {50, 50, 50}, positions = {{x = 33237, y = 32267, z = 11}, {x = 32829 , y = 32335, z = 11}, {x = 32593 , y = 31408, z = 15}}, subareas = {'DL Darashia', 'DL POI', 'DL Fenrock'}},
    [40033] = {name = "Wyrm", level = {40, 40, 40}, positions = {{x = 3285, y = 322770, z = 3}, {x = 32403 , y = 32747, z = 1}, {x = 32388 , y = 32838, z = 7}}, subareas = {'Wyrm Mountain1', 'Wyrm Mountain2', 'Wyrm Sul LB'}},
    [40034] = {name = "Hydra", level = {40, 40, 40}, positions = {{x = 32996, y = 32677, z = 6}, {x = 32978 , y = 32628, z = 5}, {x = 33526 , y = 31880, z = 8}}, subareas = {'Hydra PH1', 'Hydra PH2', 'Hydra Oramond'}},
    [40035] = {name = "Spiders", level = {8, 20, 20}, positions = {{x = 32848, y = 32868, z = 7}, {x = 32736 , y = 32265, z = 7}, {x = 32894 , y = 32896, z = 10}}, subareas = {'Tarantulas', 'GS Venore', 'GS Port Hope'}},
    [40036] = {name = "Frosts", level = {50, 50}, positions = {{x = 31927, y = 31374, z = 8}, {x = 32225 , y = 31382, z = 7}}, subareas = {'Crystal Spiders', 'Frost Dragons Okolnir'}},
    [40037] = {name = "Behemoth", level = {50, 50, 50}, positions = {{x = 32402, y = 32769, z = 1}, {x = 33295 , y = 31686, z = 14}, {x = 33024 , y = 32581, z = 6}}, subareas = {'Behe LB Mountain', 'Behe Edron Cave', 'Behe ForbidenLands'}},
    [40038] = {name = "Lizards", level = {40, 40}, positions = {{x = 33304, y = 31537, z = 7}, {x = 33079 , y = 31218, z = 8}}, subareas = {'Lizard Farmine', 'Lizard Zao'}},
    [40039] = {name = "Lamassu", level = 45, positions = {{x = 33851, y = 31455, z = 6}}, subareas = {}},
    [40041] = {name = "Demons", level = {80, 80, 80}, positions = {{x = 33284, y = 31594, z = 12}, {x = 32895 , y = 31048, z = 9}, {x = 33496 , y = 32026, z = 10}}, subareas = {'Demon Helmet', 'Demon Yalahar', 'Demon Oramond'}},
    [40042] = {name = "Deeplings", level = 50, positions = {{x = 33461, y = 31279, z = 14}}, subareas = {}},
    [40043] = {name = "Exotic Cave", level = 50, positions = {{x = 33913, y = 31457, z = 8}}, subareas = {}},
    [40044] = {name = "Necromancer/Hellspawn", level = {12, 30}, positions = {{x = 0, y = 0, z = 0}, {x = 0 , y = 0, z = 0}}, subareas = {'Necro/Hells Yalahar', 'Necro Drefia'}},

    [40045] = {name = "Glooth Bandit", level = {60, 60, 80}, positions = {{x = 33482, y = 31963, z = 12}, {x = 33528 , y = 32040, z = 11}, {x = 33650 , y = 32017, z = 13}}, subareas = {'Glooth West', 'Glooth South', 'Glooth East'}},
    [40046] = {name = "Lizard Chozen", level = {60, 60}, positions = {{x = 33292, y = 31210, z = 8}, {x = 33180 , y = 31205, z = 8}}, subareas = {'Lizard Chozen1', 'Lizard Chozen2'}},
    [40047] = {name = "WereBixos+", level = {80, 80}, positions = {{x = 33366, y = 32006, z = 8}, {x = 33416 , y = 31570, z = 10}}, subareas = {'WereBear Cormaya', 'Grimvale -4'}},
    [40048] = {name = "Boquinha Feyrist", level = {100, 100}, positions = {{x = 33585, y = 32262, z = 7}, {x = 33544 , y = 32270, z = 8}}, subareas = {'Surface Boquinha Feyrist', '-1 Boquinha Feyrist'}},
    [40049] = {name = "Ghastly Dragon", level = {100, 100}, positions = {{x = 33174, y = 31015, z = 7}, {x = 33156 , y = 31161, z = 12}}, subareas = {'Ghastly Dragon Farmine', 'Ghastly Dragon Zao Palace'}},
    [40051] = {name = "Yielothax", level = 100, positions = {{x = 32942, y = 31596, z = 8}}, subareas = {}},
    [40052] = {name = "Asura", level = 100, positions =  {{x = 32812, y = 32762, z = 9}}, subareas = {}},
    [40053] = {name = "Faun", level = {60, 80}, positions = {{x = 33416, y = 32249, z = 7}, {x = 33550 , y = 32204, z = 8}}, subareas = {'Feiryst Suface', 'Dark Faun Cave'}},
    [40054] = {name = "Quaras", level = {80, 80, 80}, positions = {{x = 32203, y = 32881, z = 7}, {x = 31913 , y = 32715, z = 12}, {x = 33553 , y = 31626, z = 15}}, subareas = {'Quara LB', 'Quara Mermaid', 'Quara Captain'}},
    [40055] = {name = "Sea", level = {70, 70}, positions = {{x = 31911, y = 31187, z = 9}, {x = 33397 , y = 31808, z = 13}}, subareas = {'Sea1', 'Sea2'}},
    [40056] = {name = "Shaburaks", level = 100, positions = {{x = 33259, y = 31940, z = 15}}, subareas = {}},
    [40057] = {name = "Insectoids Hardcore", level = 100, positions = {{x = 33516, y = 31223, z = 7}}, subareas = {}},
    [40058] = {name = "Oramond West", level = 140, positions = {{x = 33576, y = 31910, z = 7}}, subareas = {}},
    [40059] = {name = "Grim Reaper", level = {120, 120}, positions = {{x = 0, y = 0, z = 0}, {x = 0 , y = 0, z = 0}}, subareas = {'Grim Reaper Drefia', 'Yalahar'}},
    [40061] = {name = "Orclops", level = 80, positions = {{x = 32720, y = 32241, z = 8}}, subareas = {}},
    [40062] = {name = "Plaguesmith", level = 100, positions = {{x = 32153, y = 31144, z = 12}}, subareas = {}},
    [40063] = {name = "Fury MOTA", level = 130, positions = {{x = 33246, y = 32113, z = 8}}, subareas = {}},
    [40064] = {name = "Hellfire Hell", level = 150, positions = {{x = 33289, y = 31788, z = 13}}, subareas = {}},
    [40065] = {name = "Roshamuul", level = {1, 100, 150}, positions = {{x = 33495, y = 32566, z = 7}, {x = 33542 , y = 3270, z = 7}, {x = 33593 , y = 32433, z = 8}}, subareas = {'Roshamuul Entrada', 'Roshamuul DP', 'Prison -1'}},
    [40066] = {name = "Wherewhyena", level = 120, positions = {{x = 33221, y = 32358, z = 9}}, subareas = {}},
    [40067] = {name = "Barkless", level = 100, positions = {{x = 32725, y = 31532, z = 9}}, subareas = {}},
    [40068] = {name = "Medusa", level = {80, 120, 150}, positions = {{x = 32866, y = 32851, z = 8}, {x = 32808 , y = 32638, z = 11}, {x = 32731 , y = 32647, z = 15}}, subareas = {'Medusa Tower', 'Banuta Entrada', 'Banuta -4'}},
    [40069] = {name = "Vulcongra", level = 100, positions = {{x = 32253, y = 32616, z = 13}}, subareas = {}},
    [40071] = {name = "Elder Wyrm", level = 80, positions = {{x = 33087, y = 32378, z = 13}}, subareas = {}},
    [40072] = {name = "War Golem", level = {80, 80}, positions = {{x = 32881, y = 31312, z = 11}, {x = 32901 , y = 31299, z = 10}}, subareas = {'War Golem1', 'War Golem2'}},
    [40073] = {name = "Vampires", level = 60, positions = {{x = 33068, y = 31599, z = 10}}, subareas = {}},
    [40074] = {name = "Spectres", level = {20, 100, 150}, positions = {{x = 32673, y = 32647, z = 7}, {x = 33092 , y = 32392, z = 8}, {x = 32688 , y = 32246, z = 8}}, subareas = {'Gazer PH', 'Burster Darashia', 'Ripper Venore'}},
    [40075] = {name = "Drakens", level = {100, 130}, positions = {{x = 33042, y = 31171, z = 2}, {x = 33032 , y = 31230, z = 2}}, subareas = {'Draken Tower West', 'Draken Tower South'}},
    [40076] = {name = "Draken Elite", level = 150, positions = {{x = 33051, y = 31076, z = 8}}, subareas = {}},
    [40077] = {name = "Gloth Golem", level = {100, 150}, positions = {{x = 33562, y = 31922, z = 7}, {x = 33558 , y = 31964, z = 13}}, subareas = {'Gloth Tower', 'Gloth Factory'}},


    [40078] = {name = "Asura Mirror", level = 250, positions = {{x = 32986, y = 32730, z = 7}}, subareas = {}},
    [40079] = {name = "Carnivor", level = 250, positions = {{x = 32759, y = 32625, z = 0}}, subareas = {}},
    [40081] = {name = "Cobra", level = 250, positions = {{x = 33305, y = 32653, z = 7}}, subareas = {}},
    [40082] = {name = "Diremaw Wz6", level = 250, positions = {{x = 33831, y = 32126, z = 14}}, subareas = {}},
    [40083] = {name = "Warzone 5", level = 250, positions = {{x = 33771, y = 32199, z = 14}}, subareas = {}},
    [40084] = {name = "Warzone 4", level = 250, positions = {{x = 33824, y = 32181, z = 14}}, subareas = {}},
    [40085] = {name = "Lost Exile", level = 250, positions = {{x = 33773, y = 32246, z = 14}}, subareas = {}},
    [40086] = {name = "Lost Souls", level = {250, 300}, positions = {{x = 33583, y = 31414, z = 8}, {x = 32625 , y = 32072, z = 7}}, subareas = {'Alminha PH', 'Alminha Venore'}},
    [40087] = {name = "Falcon", level = 250, positions = {{x = 33345, y = 31348, z = 7}}, subareas = {}},
    [40088] = {name = "Elf Fogo", level = 200, positions = {{x = 33681, y = 32153, z = 7}}, subareas = {}},
    [40089] = {name = "Elf Gelo", level = 200, positions = {{x = 33669, y = 32219, z = 7}}, subareas = {}},
    [40091] = {name = "Deathling", level = 250, positions = {{x = 33574, y = 31402, z = 13}}, subareas = {}},
    [40092] = {name = "Dark Carnisylvan", level = 250, positions = {{x = 32396, y = 32495, z = 10}}, subareas = {}},
    [40093] = {name = "Skeletin", level = 250, positions = {{x = 33114, y = 32382, z = 7}}, subareas = {}},
    [40094] = {name = "Werelion", level = {300, 300}, positions = {{x = 33126, y = 32319, z = 12}, {x = 33123 , y = 32248, z = 10}}, subareas = {'Werelion -2', 'Werelion -1'}},

    [40095] = {name = "Girtabilu", level = 400, positions = {{x = 33814, y = 31692, z = 8}}, subareas = {}},
    [40096] = {name = "GT", level = {400, 450, 500}, positions = {{x = GT33174, y = 32634, z = 7}, {x = 33041 , y = 31367, z = 7}, {x = 32159 , y = 31298, z = 6}}, subareas = {'GT Ank', 'GT Zao', 'GT Svar'}},
    [40097] = {name = "Ferumbras Seal", level = {500, 500, 500, 500, 500, 500, 500, 500}, positions = {{x = 33221, y = 32318, z = 12}, {x = 33420, y = 32680, z = 13}, {x = 33466 , y = 32796, z = 8}, {x = 33380 , y = 32342, z = 10}, {x = 33433 , y = 32443, z = 13}, {x = 33618 , y = 32627, z = 13}, {x = 33641 , y = 32690, z = 11}, {x = 33229 , y = 31442, z = 11}}, subareas = {'Entrance', 'DT Seal', 'Spectre Seal', 'Undead Seal', 'Juger Seal', 'Fire Seal', 'Phantasm Seal', 'Plague Seal'}},
    [40098] = {name = "Ingol", level = {450, 600}, positions = {{x = 33711, y = 32602, z = 6}, {x = 33784 , y = 32570, z = 10}}, subareas = {'Ingol Surface', 'Ingol -3'}},
    [40099] = {name = "Livraria", level = {350, 500, 500}, positions = {{x = 32458, y = 32606, z = 12}, {x = 32478 , y = 32777, z = 11}, {x = 32551 , y = 32703, z = 12}}, subareas = {'Ice Library', 'Energy  Library', 'Fire  Library'}},
    [40101] = {name = "True Asura", level = 500, positions = {{x = 32878, y = 32808, z = 9}}, subareas = {}},
    [40102] = {name = "Bashmu", level = 500, positions = {{x = 33972, y = 31653, z = 7}}, subareas = {}},
    [40103] = {name = "WereTiger", level = 600, positions = {{x = 32997, y = 32935, z = 7}}, subareas = {}},


    [40104] = {name = "Cloak", level = 650, positions = {{x = 33859, y = 31831, z = 3}}, subareas = {}},
    [40105] = {name = "Brachio", level = 650, positions = {{x = 34011, y = 31013, z = 9}}, subareas = {}},
    [40106] = {name = "Peixe", level = 650, positions = {{x = 33894, y = 31020, z = 8}}, subareas = {}},
    [40107] = {name = "Rotten", level = 650, positions = {{x = 33971, y = 31041, z = 11}}, subareas = {}},
    [40108] = {name = "Dark Thais", level = 650, positions = {{x = 33888, y = 31185, z = 10}}, subareas = {}},


    [40109] = {name = "Gnomprona  1-Carrinho", level = 750, positions = {{x = 33592, y = 32911, z = 15}}, subareas = {}},
    [40110] = {name = "Gnomprona  2-Carrinho", level = 750, positions = {{x = 33634, y = 32841, z = 15}}, subareas = {}},
    [40111] = {name = "Gnomprona  3-Carrinho", level = 750, positions = {{x = 33766, y = 32911, z = 15}}, subareas = {}},


    [40112] = {name = "Warzone 9", level = 700, positions = {{x = 32145, y = 31447, z = 14}}, subareas = {}},
    [40113] = {name = "Warzone 8", level = 700, positions = {{x = 32067, y = 31462, z = 12}}, subareas = {}},
    [40114] = {name = "Warzone 7", level = 700, positions = {{x = 32677, y = 31789, z = 10}}, subareas = {}},


    [40115] = {name = "Putrefactory", level = 850, positions = {{x = 34101, y = 31679, z = 13}}, subareas = {}},
    [40116] = {name = "Jaded Roots", level = 850, positions = {{x = 33842, y = 31652, z = 13}}, subareas = {}},
    [40117] = {name = "Darklight Core", level = 850, positions = {{x = 33809, y = 31816, z = 13}}, subareas = {}},
    [40118] = {name = "Gloom Pillars", level = 850, positions = {{x = 34119, y = 31877, z = 13}}, subareas = {}},
    [40119] = {name = "Ingol", level = {1050, 0}, positions = {{x = 33711, y = 32602, z = 6}, {x = 33784 , y = 32570, z = 10}}, subareas = {'Ingol Surface', 'Ingol -3'}},

    [40030] = {name = "Teleports 3", level = 350, positions = {{x = 31704, y = 32273, z = 11}}, subareas = {}},
    [40040] = {name = "Teleports 4", level = 500, positions = {{x = 31704, y = 32315, z = 11}}, subareas = {}},
    [40050] = {name = "Teleports 5", level = 650, positions = {{x = 31802, y = 32171, z = 8}}, subareas = {}},
    [40060] = {name = "Adventurer Stone", level = 0, positions = {{x = 32210, y = 32300, z = 6}}, subareas = {}},


    [40901] = {name = "Amazon", level = 1, positions = {{x = 32825, y = 31912, z = 7}}, subareas = {}},
    [40902] = {name = "Cyclops", level = {1, 1}, positions = {{x = 33256, y = 31706, z = 7}, {x = 32639, y = 31439, z = 7}}, subareas = {'Cyc Edron', 'Cyc Mistrock'}},
    [40903] = {name = "Minotaur", level = {1, 1}, positions = {{x = 33298, y = 32297, z = 7}, {x = 32376, y = 32120, z = 15}}, subareas = {'Minotaur Darashia', 'Minotaur Mintwalin'}},
    [40904] = {name = "Orcs", level = {1, 20}, positions = {{x = 32578, y = 31674, z = 7}, {x = 32821 , y = 31767, z = 7}}, subareas = {'Orcs Ab Elvenbane', 'Orc Fortless'}},
    [40905] = {name = "Sibang", level = 40, positions = {{x = 32779, y = 32521, z = 5}}, subareas = {}},
    [40906] = {name = "Mutated Human", level = 40, positions = {{x = 32749, y = 31163, z = 5}}, subareas = {}},
    [40907] = {name = "Putered Mummy", level = 40, positions = {{x = 33290, y = 32276, z = 12}}, subareas = {}},
    [40908] = {name = "Dark Catedral", level = 20, positions = {{x = 32657, y = 32340, z = 7}}, subareas = {}},
    [40909] = {name = "Corym", level = {20, 20}, positions = {{x = 33091, y = 32074, z = 11}, {x = 32604 , y = 32801, z = 7}}, subareas = {'Corym Venore', 'Corym PH'}},
    [40010] = {name = "Stonerefiner", level = 13, positions = {{x = 33029, y = 32009, z = 12}}, subareas = {}},
    [40911] = {name = "Thornback Tortoise", level = 29, positions = {{x = 32391, y = 32603, z = 8}}, subareas = {}},
    [40912] = {name = "Dwarf", level = 1, positions = {{x = 32527, y = 31948, z = 11}}, subareas = {}},
    [40913] = {name = "Bonebeast", level = 14, positions = {{x = 33227, y = 31651, z = 7}}, subareas = {}},
    [40914] = {name = "Wyrvern", level = {15, 15}, positions = {{x = 32780, y = 31833, z = 7}, {x = 32776 , y = 31935, z = 10}}, subareas = {'Wyrvern Cave', 'Wyrvern Montain'}},
    [40915] = {name = "Nobre Lion", level = 20, positions = {{x = 33122, y = 32302, z = 8}}, subareas = {}},
    [40916] = {name = "Nightmare Scion", level = 55, positions = {{x = 33576, y = 31591, z = 7}}, subareas = {}},
    [40917] = {name = "Waspoid", level = 20, positions = {{x = 33443, y = 31297, z = 7}}, subareas = {}},
    [40918] = {name = "Water Elemental", level = 25, positions = {{x = 32802, y = 31070, z =7}}, subareas = {}},
    [40919] = {name = "Mino Oramond", level = {40, 60}, positions = {{x = 33540, y = 32014, z = 6}, {x = 3681 , y = 31940, z = 6}}, subareas = {'Entrada Mino Oramond ', 'Hardcore Mino Oramond'}},
    [40921] = {name = "Iks Aucar", level = 40, positions = {{x = 34015, y = 31885, z = 8}}, subareas = {}},
    [40922] = {name = "Humans", level = {30, 30}, positions = {{x = 32404, y = 31813, z = 8}, {x = 33260 , y = 31597, z = 8}}, subareas = {'Cult Carlin', 'Hero Cave Entrada'}},
    [40923] = {name = "Water Elemental", level = 25, positions = {{x = 32558, y = 32859, z = 7}}, subareas = {}},
    [20024] = {name = "Insectoids", level = 25, positions = {{x = 33443, y = 31297, z = 7}}, subareas = {}},
    [40925] = {name = "Nightmare", level = 50, positions = {{x = 32802, y = 31070, z = 7}}, subareas = {}},
    [40926] = {name = "WereBixos", level = {50, 50}, positions = {{x = 33189, y = 31914, z = 7}, {x = 33342 , y = 31693, z = 7}}, subareas = {'Grimvale Sul', 'Grimvale Norte'}},
    [40927] = {name = "Lava Lurker", level = 90, positions = {{x = 33854, y = 32177, z = 14}}, subareas = {}},
    [40928] = {name = "NightmareScion Krailos", level = 60, positions = {{x = 33576, y = 31591, z = 7}}, subareas = {}},
    [40929] = {name = "Minos Oramond", level = {40, 60}, positions = {{x = 33540, y = 32014, z = 6}, {x = 33681 , y = 31940, z = 6}}, subareas = {'MinoOramond Entrada', 'MinoOramond Hardcore'}}


}
local firstid = 40031 -- Put your first action id used here
local lastid = 40929 -- Put your last action id used here

-- Config End
local teleports = MoveEvent()
function teleports.onStepIn(player, item, position, fromPosition)
    if not player:isPlayer() then
        return false
    end
  
    local tp = tplist[item.actionid]
    local quantity = table.getn(tp.positions)
  
    player:registerEvent("Teleport_Modal_Window")
  
    local title = "Teleport"
    local message = "List of ".. tp.name .." Spawns"
      
    local window = ModalWindow(item.actionid, title, message)
    doTeleportThing(player, fromPosition, false) 
    window:addButton(100, "Go")
    window:addButton(101, "Cancel")
      
    for i = 1, quantity do
        if tp.subareas[i] == nil then
            window:addChoice(i,"".. tp.name .." ".. i .."")
        else
            window:addChoice(i,"".. tp.subareas[i] .."")
        end
    end
  
    window:setDefaultEnterButton(100)
    window:setDefaultEscapeButton(101)
  
    if tp and quantity < 2 then
        player:unregisterEvent("Teleport_Modal_Window")
        player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teleported to '.. tp.name ..'.')
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
        player:teleportTo(tp.positions[1])
        player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
    else
        window:sendToPlayer(player)
    end
    return true
end

for j = firstid, lastid do
    teleports:aid(j)
end

teleports:type("stepin")
teleports:register()

local modalTp = CreatureEvent("Teleport_Modal_Window")
modalTp:type("modalwindow")

function modalTp.onModalWindow(player, modalWindowId, buttonId, choiceId)
    player:unregisterEvent("Teleport_Modal_Window")
    if modalWindowId >= firstid and modalWindowId <= lastid then
        if buttonId == 100 then
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            player:teleportTo(tplist[modalWindowId].positions[choiceId])
            player:getPosition():sendMagicEffect(CONST_ME_TELEPORT)
            if tplist[modalWindowId].subareas[choiceId] == nil then
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teleported to '.. tplist[modalWindowId].name ..' '.. choiceId ..'.')
            else
                player:sendTextMessage(MESSAGE_EVENT_ADVANCE, 'Teleported to '.. tplist[modalWindowId].subareas[choiceId] ..'.')
            end
        end
    end
    return true
end

modalTp:register()