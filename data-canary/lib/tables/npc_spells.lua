local spells = {
    -- Instant spell
    {
        name = "find person",
        group = "support spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "duria", "gregor", "ormuhn", "puffels", "thorwulf", "trisha", "tristan", "uso", "shalmar", "gundralph", "faluae", "asrak", "razan"}, 
        price = 80,
        vocation = {1, 2, 3, 4, 5, 6, 7, 8}, 
        premium = false, 
        level = 8
    },
    {
        name = "light",
        group ="support spells",
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "duria", "gregor", "ormuhn", "puffels", "thorwulf", "trisha", "tristan", "uso", "shalmar", "maealil", "gundralph", "faluae", "asrak", "razan"},
        price = 0,
        vocation = {1, 2, 4, 5, 6, 8},
        premium = false,
        level = 8
    },
    {
        name = "light healing",
        group ="healing spells",
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "shalmar", "gundralph", "asrak", "razan"}, 
        price = 0,
        vocation = {1, 2, 3, 5, 6, 7}, 
        premium = false, 
        level = 8
    },
    {
        name = "magic rope",
        group ="support spells", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "tothdral", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "ormuhn", "puffels", "thorwulf", "tristan", "uso", "shalmar", "gundralph", "razan"}, 
        price = 200,
        vocation = {1, 2, 3, 4, 5, 6, 7, 8}, 
        premium = false, 
        level = 9
    },
    {
        name = "cure poison",
        group ="healing spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "duria", "gregor", "ormuhn", "puffels", "thorwulf", "trisha", "tristan", "uso", "shalmar", "maealil", "gundralph", "asrak", "razan"}, 
        price = 150,
        vocation = {1, 2, 3, 4, 5, 6, 7, 8}, 
        premium = false, 
        level = 8
    },
    {
        name = "wound cleansing",
        group ="healing spells", 
        npc = {"duria", "gregor", "ormuhn", "puffels", "thorwulf", "trisha", "tristan", "uso", "asrak", "razan"}, 
        price = 0,
        vocation = {4, 8}, 
        premium = false, 
        level = 8
    },
    {
        name = "levitate",
        group ="support spells", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "tothdral", "rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "ormuhn", "puffels", "thorwulf", "tristan", "uso", "shalmar", "gundralph", "razan"}, 
        price = 500,
        vocation = {1, 2, 3, 4, 5, 6, 7, 8}, 
        premium = true,
        level = 12
    },
    {
        name = "energy strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "gundralph"}, 
        price = 800,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 12
    },
    {
        name = "great light",
        group ="support spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "duria", "gregor", "ormuhn", "puffels", "thorwulf", "trisha", "tristan", "uso", "shalmar", "gundralph", "faluae", "asrak", "razan"}, 
        price = 500,
        vocation = {1, 2, 4, 5, 6, 8}, 
        premium = false, 
        level = 13
    },
    {
        name = "terra strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tothdral", "rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 800,
        vocation = {1, 2, 3, 5, 6, 7}, 
        premium = true,
        level = 13
    },
    {
        name = "conjure arrow",
        group ="support spells", 
        npc = {"dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "asrak", "razan"}, 
        price = 450,
        vocation = {3, 7}, 
        premium = false, 
        level = 13
    },
    {
        name = "cancel magic shield",
        group ="support spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 450,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 14
    },
    {
        name = "flame strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "rahkem", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 800,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 14
    },
    {
        name = "haste",
        group ="support spells", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "tothdral", "marvik", "rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "ormuhn", "puffels", "thorwulf", "tristan", "uso", "shalmar", "gundralph", "razan"}, 
        price = 600,
        vocation = {1, 2, 3, 4, 5, 6, 7, 8}, 
        premium = true,
        level = 14
    },
    {
        name = "food",
        group ="conjuring spells", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph", "faluae"}, 
        price = 300,
        vocation = {2, 6}, 
        premium = false, 
        level = 14
    },
    {
        name = "magic shield",
        group ="support spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph", "eroth"}, 
        price = 450,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 14
    },
    {
        name = "ice strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "tothdral", "rahkem", "ustan", "hjaern", "charlotta", "shalmar", "gundralph"}, 
        price = 800,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 15
    },
    {
        name = "death strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 800,
        vocation = {1, 5}, 
        premium = true,
        level = 16
    },
    {
        name = "brutal strike",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 1000,
        vocation = {4, 8}, 
        premium = true,
        level = 16
    },
    {
        name = "physical strike",
        group ="attack spells", 
        npc = {"rahkem", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 800,
        vocation = {2, 6}, 
        premium = true,
        level = 16
    },
    {
        name = "ice wave",
        group ="attack spells", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "elathriel", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 850,
        vocation = {2, 6}, 
        premium = false, 
        level = 18
    },
    {
        name = "heal friend",
        group ="healing spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 800,
        vocation = {2, 6}, 
        premium = true,
        level = 18
    },
    {
        name = "fire wave",
        group ="attack spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 850,
        vocation = {1, 5}, 
        premium = false, 
        level = 18
    },
    {
        name = "challenge",
        group ="support spells", 
        npc = {"eremo"}, 
        price = 2000,
        vocation = {4, 8}, 
        premium = true,
        level = 20
    },
    {
        name = "intense healing",
        group ="healing spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "hjaern", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "shalmar", "maealil", "gundralph", "asrak", "razan"}, 
        price = 350,
        vocation = {1, 2, 3, 5, 6, 7}, 
        premium = false, 
        level = 20
    },
    {
        name = "strong haste",
        group ="support spells", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "tothdral", "rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 1300,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 20
    },
    {
        name = "cure electrification",
        group ="healing spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 1000,
        vocation = {2, 6}, 
        premium = true,
        level = 22
    },
    {
        name = "creature illusion",
        group ="support spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 1000,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 23
    },
    {
        name = "energy beam",
        group ="attack spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 1000,
        vocation = {1, 5}, 
        premium = false, 
        level = 23
    },
    {
        name = "ethereal spear",
        group ="attack spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "razan"}, 
        price = 1100,
        vocation = {3, 7}, 
        premium = true,
        level = 23
    },
    {
        name = "summon creature",
        group ="conjuring spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph", "eroth"}, 
        price = 2000,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 25
    },
    {
        name = "charge",
        group ="support spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 1300,
        vocation = {4, 8}, 
        premium = true,
        level = 25
    },
    {
        name = "conjure explosive arrow",
        group ="support spells", 
        npc = {"dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "asrak", "razan"}, 
        price = 1000,
        vocation = {3, 7}, 
        premium = false, 
        level = 25
    },
    {
        name = "cancel invisibility",
        group ="support spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "razan"}, 
        price = 1600,
        vocation = {3, 7}, 
        premium = true,
        level = 26
    },
    {
        name = "ignite",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 1500,
        vocation = {1, 5}, 
        premium = true,
        level = 26
    },
    {
        name = "ultimate light",
        group ="support spells", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 1600,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 26
    },
    {
        name = "whirlwind throw",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 1500,
        vocation = {4, 8}, 
        premium = true,
        level = 28
    },
    {
        name = "great energy beam",
        group ="attack spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 1800,
        vocation = {1, 5}, 
        premium = false, 
        level = 29
    },
    {
        name = "ultimate healing",
        group ="healing spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "maealil", "gundralph"}, 
        price = 1000,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 30
    },
    {
        name = "cure burning",
        group ="healing spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar"}, 
        price = 2000,
        vocation = {2, 6}, 
        premium = true,
        level = 30
    },
    {
        name = "enchant party",
        group ="support spells", 
        npc = {"eliza"}, 
        price = 4000,
        vocation = {1, 5}, 
        premium = true,
        level = 32
    },
    {
        name = "heal party",
        group ="support spells", 
        npc = {"eliza"}, 
        price = 4000,
        vocation = {2, 6}, 
        premium = true,
        level = 32
    },
    {
        name = "protect party",
        group ="support spells", 
        npc = {"eliza"}, 
        price = 4000,
        vocation = {3, 7}, 
        premium = true,
        level = 32
    },
    {
        name = "train party",
        group ="support spells", 
        npc = {"eliza"}, 
        price = 4000,
        vocation = {4, 8}, 
        premium = true,
        level = 32
    },
    {
        name = "groundshaker",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 1500,
        vocation = {4, 8}, 
        premium = true,
        level = 33
    },
    {
        name = "electrify",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 2500,
        vocation = {1, 5}, 
        premium = true,
        level = 34
    },
    {
        name = "berserk",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 2500,
        vocation = {4, 8}, 
        premium = true,
        level = 35
    },
    {
        name = "divine healing",
        group ="healing spells", 
        npc = {"dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "asrak", "razan"}, 
        price = 3000,
        vocation = {3, 7}, 
        premium = false, 
        level = 35
    },
    {
        name = "invisible",
        group ="support spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 2000,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 35
    },
    {
        name = "mass healing",
        group ="healing spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "zoltan", "gundralph"}, 
        price = 2200,
        vocation = {2, 6}, 
        premium = true,
        level = 36
    },
    {
        name = "energy wave",
        group ="attack spells", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 2500,
        vocation = {1, 5}, 
        premium = false, 
        level = 38
    },
    {
        name = "great fire wave",
        group ="attack spells", 
        npc = {0}, 
        price = 25000,
        vocation = {1, 5}, 
        premium = true,
        level = 38
    },
    {
        name = "terra wave",
        group ="attack spells", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "hjaern", "elathriel", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 2500,
        vocation = {2, 6}, 
        premium = false, 
        level = 38
    },
    {
        name = "inflict wound",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 2500,
        vocation = {4, 8}, 
        premium = true,
        level = 40
    },
    {
        name = "divine missile",
        group ="attack spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "razan"}, 
        price = 1800,
        vocation = {3, 7}, 
        premium = true,
        level = 40
    },
    {
        name = "strong ice wave",
        group ="attack spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 7500,
        vocation = {2, 6}, 
        premium = true,
        level = 40
    },
    {
        name = "conjure wand of darkness",
        group ="conjuring spells", 
        npc = {"eremo"}, 
        price = 5000,
        vocation = {1, 5}, 
        premium = true,
        level = 41
    },
    {
        name = "cure bleeding",
        group ="healing spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "ormuhn", "puffels", "thorwulf", "tristan", "uso", "shalmar", "gundralph", "razan"}, 
        price = 2500,
        vocation = {2, 4, 6, 8}, 
        premium = true,
        level = 45
    },
    {
        name = "enchant spear",
        group ="support spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "razan"}, 
        price = 2000,
        vocation = {3, 7}, 
        premium = true,
        level = 45
    },
    {
        name = "envenom",
        group ="attack spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 6000,
        vocation = {2, 6}, 
        premium = true,
        level = 50
    },
    {
        name = "divine caldera",
        group ="attack spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "zoltan", "razan"}, 
        price = 3000,
        vocation = {3, 7}, 
        premium = true,
        level = 50
    },
    {
        name = "recovery",
        group ="healing spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 4000,
        vocation = {3, 4, 7, 8}, 
        premium = true,
        level = 50
    },
    {
        name = "lightning",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 5000,
        vocation = {1, 5}, 
        premium = true,
        level = 55
    },
    {
        name = "wrath of nature",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 6000,
        vocation = {2, 6}, 
        premium = true,
        level = 55
    },
    {
        name = "rage of the skies",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 6000,
        vocation = {1, 5}, 
        premium = true,
        level = 55
    },
    {
        name = "protector",
        group ="support spells", 
        npc = {"zoltan"}, 
        price = 6000,
        vocation = {4, 8}, 
        premium = true,
        level = 55
    },
    {
        name = "swift foot",
        group ="support spells", 
        npc = {"zoltan"}, 
        price = 6000,
        vocation = {3, 7}, 
        premium = true,
        level = 55
    },
    {
        name = "salvation",
        group ="support spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "silas", "ursula", "razan"}, 
        price = 8000,
        vocation = {3, 7}, 
        premium = true,
        level = 60
    },
    {
        name = "eternal winter",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 8000,
        vocation = {2, 6}, 
        premium = true,
        level = 60
    },
    {
        name = "hells core",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 8000,
        vocation = {1, 5}, 
        premium = true,
        level = 60
    },
    {
        name = "blood rage",
        group ="support spells", 
        npc = {"zoltan"}, 
        price = 8000,
        vocation = {4, 8}, 
        premium = true,
        level = 60
    },
    {
        name = "sharpshooter",
        group ="support spells", 
        npc = {"zoltan"}, 
        price = 8000,
        vocation = {3, 7}, 
        premium = true,
        level = 60
    },
    {
        name = "front sweep",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 4000,
        vocation = {4, 8}, 
        premium = true,
        level = 70
    },
    {
        name = "holy flash",
        group ="attack spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "silas", "ursula", "razan"}, 
        price = 7500,
        vocation = {3, 7}, 
        premium = true,
        level = 70
    },
    {
        name = "strong flame strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 6000,
        vocation = {1, 5}, 
        premium = true,
        level = 70
    },
    {
        name = "strong terra strike",
        group ="attack spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 6000,
        vocation = {2, 6}, 
        premium = true,
        level = 70
    },
    {
        name = "curse",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tothdral", "shalmar", "gundralph"}, 
        price = 6000,
        vocation = {1, 5}, 
        premium = true,
        level = 75
    },
    {
        name = "cure curse",
        group ="healing spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "silas", "ursula", "razan"}, 
        price = 6000,
        vocation = {3, 7}, 
        premium = true,
        level = 80
    },
    {
        name = "intense wound cleansing",
        group ="healing spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 6000,
        vocation = {4, 8}, 
        premium = true,
        level = 80
    },
    {
        name = "strong energy strike",
        group ="attack spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tothdral", "shalmar", "gundralph"}, 
        price = 6000,
        vocation = {1, 5}, 
        premium = true,
        level = 80
    },
    {
        name = "strong ice strike",
        group ="attack spells", 
        npc = {"tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 6000,
        vocation = {2, 6}, 
        premium = true,
        level = 80
    },
    {
        name = "fierce berserk",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "uso", "zoltan", "razan"}, 
        price = 7500,
        vocation = {4, 8}, 
        premium = true,
        level = 90
    },
    {
        name = "strong ethereal spear",
        group ="attack spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "razan"}, 
        price = 10000,
        vocation = {3, 7}, 
        premium = true,
        level = 90
    },
    {
        name = "ultimate terra strike",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 15000,
        vocation = {2, 6}, 
        premium = true,
        level = 90
    },
    {
        name = "ultimate flame strike",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 15000,
        vocation = {1, 5}, 
        premium = true,
        level = 90
    },
    {
        name = "intense recovery",
        group ="healing spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "ormuhn", "puffels", "thorwulf", "uso", "razan"}, 
        price = 10000,
        vocation = {3, 4, 7, 8}, 
        premium = true,
        level = 100
    },
    {
        name = "ultimate ice strike",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 15000,
        vocation = {2, 6}, 
        premium = true,
        level = 100
    },
    {
        name = "ultimate energy strike",
        group ="attack spells", 
        npc = {"zoltan"}, 
        price = 15000,
        vocation = {1, 5}, 
        premium = true,
        level = 100
    },
    {
        name = "annihilation",
        group ="attack spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 20000,
        vocation = {4, 8}, 
        premium = true,
        level = 110
    },
    {
        name = "conjure diamond arrow",
        group ="conjuring spells", 
        npc = {"eremo"}, 
        price = 15000,
        vocation = {3, 7}, 
        premium = true,
        level = 150
    },
    {
        name = "conjure spectral bolt",
        group ="conjuring spells", 
        npc = {"eremo"}, 
        price = 15000,
        vocation = {3, 7}, 
        premium = true,
        level = 150
    },
    {
        name = "summon grovebeast",
        group ="conjuring spells", 
        npc = {"rahkem", "tamara", "ustan", "hjaern", "charlotta", "azalea", "shalmar", "gundralph"}, 
        price = 50000,
        vocation = {2, 6}, 
        premium = true,
        level = 200
    },
    {
        name = "summon thundergiant",
        group ="conjuring spells", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "shalmar", "gundralph"}, 
        price = 50000,
        vocation = {1, 5}, 
        premium = true,
        level = 200
    },
    {
        name = "summon skullfrost",
        group ="support spells", 
        npc = {"ormuhn", "puffels", "thorwulf", "tristan", "uso", "razan"}, 
        price = 50000,
        vocation = {4, 8}, 
        premium = true,
        level = 200
    },
    {
        name = "summon emberwing",
        group ="support spells", 
        npc = {"dario", "ethan", "hawkyr", "helor", "isolde", "silas", "ursula", "razan"}, 
        price = 50000,
        vocation = {3, 7}, 
        premium = true,
        level = 200
    },
    {
        name = "chivalrous challenge",
        group ="support spells", 
        npc = {0}, 
        price = 250000,
        vocation = {4, 8}, 
        premium = true,
        level = 250
    },
    {
        name = "divine dazzle",
        group ="support spells", 
        npc = {0}, 
        price = 250000,
        vocation = {3, 7}, 
        premium = true,
        level = 250
    },
    {
        name = "fair wound cleansing",
        group ="healing spells", 
        npc = {0}, 
        price = 500000,
        vocation = {4, 8}, 
        premium = true,
        level = 300
    },
    {
        name = "restoration",
        group ="healing spells", 
        npc = {"shalmar", "gundralph"}, 
        price = 500000,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 300
    },
    {
        name = "nature embrace",
        group ="healing spells", 
        npc = {"shalmar", "gundralph"}, 
        price = 500000,
        vocation = {2, 6}, 
        premium = true,
        level = 300
    },
    -- rune spells
    {
        name = "poison field rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 300,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 14
    },
    {
        name = "fire field rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 500,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 15
    },
    {
        name = "cure poison rune",
        group ="support rune", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "maealil"}, 
        price = 600,
        vocation = {2, 6}, 
        premium = false, 
        level = 15
    },
    {
        name = "intense healing rune",
        group ="support rune", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "maealil"}, 
        price = 600,
        vocation = {2, 6}, 
        premium = false, 
        level = 15
    },
    {
        name = "light magic missile rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "elathriel", "charlotta", "shalmar", "gundralph"}, 
        price = 500,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 15
    },
    {
        name = "convince creature rune",
        group ="support rune", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "azalea", "shalmar"}, 
        price = 800,
        vocation = {2, 6}, 
        premium = false, 
        level = 16
    },
    {
        name = "destroy field rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "azalea", "dario", "elane", "ethan", "hawkyr", "helor", "isolde", "legola", "silas", "ursula", "shalmar", "gundralph", "eroth", "asrak", "razan"}, 
        price = 700,
        vocation = {1, 2, 3, 5, 6, 7}, 
        premium = false, 
        level = 17
    },
    {
        name = "energy field rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 700,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 18
    },
    {
        name = "disintegrate rune",
        group ="support rune", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "ustan", "charlotta", "azalea", "shalmar", "gundralph", "razan"}, 
        price = 900,
        vocation = {1, 2, 3, 5, 6, 7}, 
        premium = true,
        level = 21
    },
    {
        name = "ultimate healing rune",
        group ="support rune", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "maealil"}, 
        price = 1500,
        vocation = {2, 6}, 
        premium = false, 
        level = 24
    },
    {
        name = "stalagmite rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "elathriel", "charlotta", "shalmar", "gundralph"}, 
        price = 1400,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 24
    },
    {
        name = "heavy magic missile rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "elathriel", "charlotta", "shalmar", "gundralph"}, 
        price = 1500,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 25
    },
    {
        name = "poison bomb rune",
        group ="support rune", 
        npc = {"ustan", "charlotta", "shalmar", "gundralph"}, 
        price = 1000,
        vocation = {2, 6}, 
        premium = true,
        level = 25
    },
    {
        name = "wild growth rune",
        group ="support rune", 
        npc = {"eremo"}, 
        price = 2000,
        vocation = {2, 6}, 
        premium = true,
        level = 27
    },
    {
        name = "chameleon rune",
        group ="support rune", 
        npc = {"marvik", "padreia", "smiley", "tamara", "ustan", "charlotta", "azalea", "shalmar", "eroth"}, 
        price = 1300,
        vocation = {2, 6}, 
        premium = false, 
        level = 27
    },
    {
        name = "soulfire rune",
        group ="support rune", 
        npc = {"barnabas dee", "malunga", "romir", "tamoril", "tothdral", "rahkem", "ustan", "gundralph"}, 
        price = 1800,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 27
    },
    {
        name = "holy missile rune",
        group ="support rune", 
        npc = {"razan"}, 
        price = 1600,
        vocation = {3, 7}, 
        premium = true,
        level = 27
    },
    {
        name = "fire bomb rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 1500,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 27
    },
    {
        name = "animate dead rune",
        group ="support rune", 
        npc = {"barnabas dee", "romir", "tamoril", "rahkem", "ustan", "charlotta", "azalea", "shalmar"}, 
        price = 1200,
        vocation = {1, 2, 5, 6}, 
        premium = true,
        level = 27
    },
    {
        name = "fireball rune",
        group ="support rune", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "gundralph"}, 
        price = 1600,
        vocation = {1, 5}, 
        premium = true,
        level = 27
    },
    {
        name = "thunderstorm rune",
        group ="support rune", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril" ,"tothdral"}, 
        price = 1100,
        vocation = {1, 5}, 
        premium = true,
        level = 28
    },
    {
        name = "icicle rune",
        group ="support rune", 
        npc = {"rahkem", "ustan", "charlotta", "shalmar", "gundralph"}, 
        price = 1700,
        vocation = {2, 6}, 
        premium = true,
        level = 28
    },
    {
        name = "stone shower rune",
        group ="support rune", 
        npc = {"rahkem", "ustan", "charlotta", "shalmar", "gundralph"}, 
        price = 1100,
        vocation = {2, 6}, 
        premium = false, 
        level = 28
    },
    {
        name = "poison wall rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 1600,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 29
    },
    {
        name = "great fireball rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "gundralph"}, 
        price = 1200,
        vocation = {1, 5}, 
        premium = true,
        level = 30
    },
    {
        name = "avalanche rune",
        group ="support rune", 
        npc = {"marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "elathriel", "charlotta", "shalmar", "gundralph"}, 
        price = 1200,
        vocation = {2, 6}, 
        premium = false, 
        level = 30
    },
    {
        name = "explosion rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "elathriel", "charlotta", "shalmar", "gundralph"}, 
        price = 1800,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 31
    },
    {
        name = "magic wall rune",
        group ="support rune", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "gundralph"}, 
        price = 2000,
        vocation = {1, 5}, 
        premium = true,
        level = 32
    },
    {
        name = "fire wall rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "shalmar", "gundralph", "eroth"}, 
        price = 2000,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 33
    },
    {
        name = "energy bomb rune",
        group ="support rune", 
        npc = {"barnabas dee", "malunga", "myra", "romir", "tamoril", "tothdral", "zoltan", "gundralph"}, 
        price = 2300,
        vocation = {1, 5}, 
        premium = true,
        level = 37
    },
    {
        name = "energy wall rune",
        group ="support rune", 
        npc = {"barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "marvik", "padreia", "rahkem", "smiley", "tamara", "ustan", "charlotta", "gundralph", "eroth"}, 
        price = 2500,
        vocation = {1, 2, 5, 6}, 
        premium = false, 
        level = 41
    },
    {
        name = "sudden death rune",
        group ="support rune", 
        npc = {"Garamond", "barnabas dee", "chatterbone", "etzel", "lea", "malunga", "muriel", "myra", "romir", "tamoril", "tothdral", "gundralph"}, 
        price = 3000,
        vocation = {1, 5}, 
        premium = false, 
        level = 35
    },
    {
        name = "paralyze rune",
        group ="support rune", 
        npc = {"Garamond", "marvik", "rahkem", "tamara", "ustan", "charlotta", "azalea", "shalmar", "zoltan"}, 
        price = 1900,
        vocation = {2, 6}, 
        premium = true,
        level = 54
    }
}
