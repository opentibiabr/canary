local mounts = {

    -- Config
        dollID = 27845, -- Change this to your dolls or items, item ID
     
        -- Main Window Messages (The first window the player sees)
        mainTitle = "Choose a Mount!",
        mainMsg = "Choose a mount to unlock.",
     
        -- Already Owned Window (The window that appears when the player already owns the addon)
        ownedTitle = "Whoops!",
        ownedMsg = "You already have this mount. Please choose another.",
     
        -- No Doll in Backpack (The window that appears when the player doesnt have the doll in their backpack)
        dollTitle = "Whoops!",
        dollMsg = "The mount doll must be in your backpack.",
    -- End Config

    -- Mounts Table
        [1] = {name = "Widow Queen", ID = 1},
        [2] = {name = "Racing Bird", ID = 2},
        [3] = {name = "War Bear", ID = 3},
        [4] = {name = "Batcat", ID = 77},
        [5] = {name = "Magic Carpet", ID = 70},
        [6] = {name = "Blazebringer", ID = 9},
        [7] = {name = "Rapid Boar", ID = 10},
        [8] = {name = "Donkey", ID = 13},
        [9] = {name = "War horse", ID = 17},
        [10] = {name = "Kingly Deer", ID = 18},
        [11] = {name = "Rented Horse", ID = 22},
        [12] = {name = "Armoured War Horse", ID = 23},
        [13] = {name = "Rented Horse", ID = 25},
        [14] = {name = "Rented Horse", ID = 26},
        [15] = {name = "Gnarlhound", ID = 32},
        [16] = {name = "Crimson Ray", ID = 33},
        [17] = {name = "Steelbeak", ID = 34},
        [18] = {name = "Tombstinger", ID = 36},
        [19] = {name = "Platesaurian", ID = 37},
        [20] = {name = "Ursagrodon", ID = 38},
        [21] = {name = "Noble Lion", ID = 40},
        [22] = {name = "Desert King", ID = 41},
        [23] = {name = "Azudocus", ID = 44},
        [24] = {name = "Carpacosaurus", ID = 45},
        [25] = {name = "Death Crawler", ID = 46},
        [26] = {name = "Flamesteed", ID = 47},
        [27] = {name = "Jade Lion", ID = 48},
        [28] = {name = "Jade Pincer", ID = 49},
        [29] = {name = "Nethersteed", ID = 50},
        [30] = {name = "Tempest", ID = 51},
        [31] = {name = "Winter King", ID = 52},
        [32] = {name = "Doombringer", ID = 53},
        [33] = {name = "Woodland Prince", ID = 54},
        [34] = {name = "Hailtorm Fury", ID = 55},
        [35] = {name = "Siegebreaker", ID = 56},
        [36] = {name = "Poisonbane", ID = 57},
        [37] = {name = "Blackpelt", ID = 58},
        [38] = {name = "Golden Dragonfly", ID = 59},
        [39] = {name = "Steel Bee", ID = 60},
        [40] = {name = "Copper Fly", ID = 61},
        [41] = {name = "Tundra Rambler", ID = 62},
        [42] = {name = "Highland Yak", ID = 63},
        [43] = {name = "Glacier Vagabond", ID = 64},
        [44] = {name = "Glooth Glider", ID = 65},
        [45] = {name = "Shadow Hart", ID = 66},
        [46] = {name = "Black Stag", ID = 67},
        [47] = {name = "Emperor Deer", ID = 68},
        [48] = {name = "Flying Divan", ID = 69},
        [49] = {name = "Magic Carpet", ID = 70},
        [50] = {name = "Floating Kashmir", ID = 71},
        [51] = {name = "Ringtail Wazzoon", ID = 72},
        [52] = {name = "Night Wazzoon", ID = 73},
        [53] = {name = "Emerald Waccoon", ID = 74},
        [54] = {name = "Flitterkatzen", ID = 75},
        [55] = {name = "Venompaw", ID = 76},
        [56] = {name = "Batcat", ID = 77},
        [57] = {name = "Sea Devil", ID = 78},
        [58] = {name = "Coralripper", ID = 79},
        [59] = {name = "Plumfish", ID = 80},
        [60] = {name = "Gorongra", ID = 81},
        [61] = {name = "Noctungra", ID = 82},
        [62] = {name = "Silverneck", ID = 83},
        [63] = {name = "Kimera", ID = 84},
        [64] = {name = "Kimera Devil", ID = 85},
        [65] = {name = "Shadow Beast", ID = 86},		
    }
     
local mountsDollModal = TalkAction("!mountsdoll")

function mountsDollModal.onSay(player, words, param)
        player:sendMountWindow(mounts)
    end

mountsDollModal:separator(" ")
mountsDollModal:groupType("normal")
mountsDollModal:register()
    