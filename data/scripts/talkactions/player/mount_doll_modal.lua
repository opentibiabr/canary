local mounts = {

    -- Config
        dollID = 49754, -- Change this to your dolls or items, item ID
     
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
        [4] = {name = "Black Sheep", ID = 4},
        [5] = {name = "Midnight Panther", ID = 5},
        [6] = {name = "Draptor", ID = 6},
        [7] = {name = "Titanica", ID = 7},
        [8] = {name = "Tin Lizard", ID = 8},
        [9] = {name = "Blazebringer", ID = 9},
        [10] = {name = "Rapid Boar", ID = 10},
        [11] = {name = "Stampor", ID = 11},
        [12] = {name = "Undead Cavebear", ID = 12},
        [13] = {name = "Donkey", ID = 13},
        [14] = {name = "Tiger Slug", ID = 14},
        [15] = {name = "Uniwheel", ID = 15},
        [16] = {name = "Crystal Wolf", ID = 16},
        [17] = {name = "War horse", ID = 17},
        [18] = {name = "Kingly Deer", ID = 18},
        [19] = {name = "Tamed Panda", ID = 19},
        [20] = {name = "Dromedary", ID = 20},
        [21] = {name = "King Scorpion", ID =21},
        [22] = {name = "Rented Horse", ID = 22},
        [23] = {name = "Armoured War Horse", ID = 23},
        [24] = {name = "Shadow Draptor", ID =24},
        [25] = {name = "Rented Horse", ID = 25},
        [26] = {name = "Rented Horse", ID = 26},
        [27] = {name = "Ladybug", ID = 27},
        [28] = {name = "Manta Ray", ID = 28},
        [29] = {name = "Ironblight", ID =29},
        [30] = {name = "Magma Crawler", ID = 30},
        [31] = {name = "Dragonling", ID = 31},
        [32] = {name = "Gnarlhound", ID = 32},
        [33] = {name = "Crimson Ray", ID = 33},
        [34] = {name = "Steelbeak", ID = 34},
        [35] = {name = "Water Buffalo", ID = 35},
        [36] = {name = "Tombstinger", ID = 36},
        [37] = {name = "Platesaurian", ID = 37},
        [38] = {name = "Ursagrodon", ID = 38},
        [39] = {name = "The Hellgrip", ID = 39},
        [40] = {name = "Noble Lion", ID = 40},
        [41] = {name = "Desert King", ID = 41},
        [42] = {name = "Shock Head", ID = 42},
        [43] = {name = "Walker", ID = 43},
        [44] = {name = "Azudocus", ID = 44},
        [45] = {name = "Carpacosaurus", ID = 45},
        [46] = {name = "Death Crawler", ID = 46},
        [47] = {name = "Flamesteed", ID = 47},
        [48] = {name = "Jade Lion", ID = 48},
        [49] = {name = "Jade Pincer", ID = 49},
        [50] = {name = "Nethersteed", ID = 50},
        [51] = {name = "Tempest", ID = 51},
        [52] = {name = "Winter King", ID = 52},
        [53] = {name = "Doombringer", ID = 53},
        [54] = {name = "Woodland Prince", ID = 54},
        [55] = {name = "Hailtorm Fury", ID = 55},
        [56] = {name = "Siegebreaker", ID = 56},
        [57] = {name = "Poisonbane", ID = 57},
        [58] = {name = "Blackpelt", ID = 58},
        [59] = {name = "Golden Dragonfly", ID = 59},
        [60] = {name = "Steel Bee", ID = 60},
        [61] = {name = "Copper Fly", ID = 61},
        [62] = {name = "Tundra Rambler", ID = 62},
        [63] = {name = "Highland Yak", ID = 63},
        [64] = {name = "Glacier Vagabond", ID = 64},
        [65] = {name = "Glooth Glider", ID = 65},
        [66] = {name = "Shadow Hart", ID = 66},
        [67] = {name = "Black Stag", ID = 67},
        [68] = {name = "Emperor Deer", ID = 68},
        [69] = {name = "Flying Divan", ID = 69},
        [70] = {name = "Magic Carpet", ID = 70},
        [71] = {name = "Floating Kashmir", ID = 71},
        [72] = {name = "Ringtail Wazzoon", ID = 72},
        [73] = {name = "Night Wazzoon", ID = 73},
        [74] = {name = "Emerald Waccoon", ID = 74},
        [75] = {name = "Flitterkatzen", ID = 75},
        [76] = {name = "Venompaw", ID = 76},
        [77] = {name = "Batcat", ID = 77},
        [78] = {name = "Sea Devil", ID = 78},
        [79] = {name = "Coralripper", ID = 79},
        [80] = {name = "Plumfish", ID = 80},
        [81] = {name = "Gorongra", ID = 81},
        [82] = {name = "Noctungra", ID = 82},
        [83] = {name = "Silverneck", ID = 83},
        [84] = {name = "Kimera", ID = 84},
        [85] = {name = "Kimera Devil", ID = 85},
        [86] = {name = "Shadow Beast", ID = 86},		
    }
     
local mountsDollModal = TalkAction("!mountsdoll")

function mountsDollModal.onSay(player, words, param)
        player:sendMountWindow(mounts)
    end

mountsDollModal:separator(" ")
mountsDollModal:groupType("normal")
mountsDollModal:register()
    