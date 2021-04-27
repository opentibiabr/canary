local weapons = {
	{
		itemId = 40737,
		type = WEAPON_AMMO,
		level = 150,
		unproperly = true,
		action = "removecount"
	}, -- spectral bolt (no decay)
	{
		itemId = 40357,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 150,
		mana = 19,
		damage = {80, 100},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- jungle wand
	{
		itemId = 40356,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 150,
		mana = 19,
		damage = {80, 100},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- jungle rod
	{
		itemId = 40353,
		type = WEAPON_DISTANCE,
		level = 150,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- jungle bow
	{
		itemId = 40350,
		type = WEAPON_AXE,
		level = 150,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- throwing axe
	{
		itemId = 40349,
		type = WEAPON_CLUB,
		level = 150,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- jungle flail
	{
		itemId = 38990,
		type = WEAPON_SWORD,
		level = 270,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- lion longsword
	{
		itemId = 39089,
		type = WEAPON_CLUB,
		level = 270,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- lion hammer
	{
		itemId = 39088,
		type = WEAPON_AXE,
		level = 270,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- lion axe
	{
		itemId = 38987,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 220,
		mana = 21,
		damage = {89, 109},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- lion wand
	{
		itemId = 38986,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 270,
		mana = 20,
		damage = {85, 105},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- lion rod
	{
		itemId = 38985,
		type = WEAPON_DISTANCE,
		level = 270,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- lion longbow
	{
		itemId = 38926,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 400,
		mana = 21,
		damage = {98, 118},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- soulhexer rod
	{
		itemId = 38925,
		type = WEAPON_WAND,
		wandType = "death",
		level = 400,
		mana = 21,
		damage = {100, 120},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- soultainter wand
	{
		itemId = 38924,
		type = WEAPON_DISTANCE,
		level = 400,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- soulpiercer crossbow
	{
		itemId = 38923,
		type = WEAPON_DISTANCE,
		level = 400,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- soulbleeder bow
	{
		itemId = 38922,
		type = WEAPON_CLUB,
		level = 400,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- soulmaimer club
	{
		itemId = 38921,
		type = WEAPON_CLUB,
		level = 400,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- soulcrusher club
	{
		itemId = 38920,
		type = WEAPON_AXE,
		level = 400,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- souleater axe
	{
		itemId = 38919,
		type = WEAPON_AXE,
		level = 400,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- soulbiter axe
	{
		itemId = 38918,
		type = WEAPON_SWORD,
		level = 400,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- soulshredder sword
	{
		itemId = 38917,
		type = WEAPON_SWORD,
		level = 400,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- soulcutter sword
	{
		itemId = 37451,
		type = WEAPON_AXE,
		level = 180,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- phantasmal axe
	{
		itemId = 36928,
		type = WEAPON_CLUB
	}, -- meat hammer
	{
		itemId = 36449,
		type = WEAPON_SWORD,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- tagralt blade
	{
		itemId = 36416,
		type = WEAPON_DISTANCE,
		level = 250,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- bow of cataclysm
	{
		itemId = 36415,
		type = WEAPON_CLUB,
		level = 220,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- mortal mace
	{
		itemId = 35235,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 220,
		mana = 21,
		damage = {70, 110},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- cobra rod
	{
		itemId = 35234,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 270,
		mana = 22,
		damage = {94, 100},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- cobra wand
	{
		itemId = 35233,
		type = WEAPON_SWORD,
		level = 220,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- cobra sword
	{
		itemId = 35231,
		type = WEAPON_AXE,
		level = 220,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- cobra axe
	{
		itemId = 35230,
		type = WEAPON_CLUB,
		level = 220,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- cobra club
	{
		itemId = 35228,
		type = WEAPON_DISTANCE,
		level = 220,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- cobra crossbow
	{
		itemId = 35112,
		type = WEAPON_AXE
	}, -- ice hatchet
	{
		itemId = 34063,
		type = WEAPON_WAND,
		wandType = "fire",
		level = 180,
		mana = 24,
		damage = {88, 108},
		vocation = {
			{"Sorcerer", true},
			{"Druid", true, true},
			{"Master Sorcerer"},
			{"Elder Druid"}
		}
	}, -- energized limb
	{
		itemId = 34060,
		type = WEAPON_SWORD,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- winterblade
	{
		itemId = 34059,
		type = WEAPON_SWORD,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- summerblade
	{
		itemId = 34057,
		type = WEAPON_CLUB,
		level = 230,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- resizer
	{
		itemId = 34055,
		type = WEAPON_DISTANCE,
		level = 220,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- living vine bow
	{
		itemId = 33925,
		type = WEAPON_AXE
	}, -- golden axe
	{
		itemId = 33267,
		type = WEAPON_WAND
	}, -- wand of destruction test
	{
		itemId = 33266,
		type = WEAPON_DISTANCE
	}, -- umbral master bow test
	{
		itemId = 33254,
		type = WEAPON_WAND
	}, -- sorcerer test weapon
	{
		itemId = 33253,
		type = WEAPON_DISTANCE
	}, -- bow of destruction test
	{
		itemId = 33252,
		type = WEAPON_SWORD
	}, -- test weapon for knights
	{
		itemId = 32529,
		type = WEAPON_CLUB,
		level = 80,
		unproperly = true
	}, -- sulphurous demonbone
	{
		itemId = 32528,
		type = WEAPON_CLUB,
		level = 80,
		unproperly = true
	}, -- unliving demonbone
	{
		itemId = 32527,
		type = WEAPON_CLUB,
		level = 80,
		unproperly = true
	}, -- energized demonbone
	{
		itemId = 32526,
		type = WEAPON_CLUB,
		level = 80,
		unproperly = true
	}, -- rotten demonbone
	{
		itemId = 32523,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 230,
		mana = 23,
		damage = {80, 120},
		vocation = {
			{"Sorcerer", true},
			{"Druid", true, true},
			{"Master Sorcerer"},
			{"Elder Druid"}
		}
	}, -- deepling fork
	{
		itemId = 32522,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 180,
		mana = 23,
		damage = {86, 98},
		vocation = {
			{"Sorcerer", true},
			{"Druid", true, true},
			{"Master Sorcerer"},
			{"Elder Druid"}
		}
	}, -- deepling ceremonial dagger
	{
		itemId = 32425,
		type = WEAPON_CLUB,
		level = 300,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- falcon mace
	{
		itemId = 32424,
		type = WEAPON_AXE,
		level = 300,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- falcon battleaxe
	{
		itemId = 32423,
		type = WEAPON_SWORD,
		level = 300,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- falcon longsword
	{
		itemId = 32418,
		type = WEAPON_DISTANCE,
		level = 300,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- falcon bow
	{
		itemId = 32417,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 300,
		mana = 21,
		damage = {86, 102},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- falcon wand
	{
		itemId = 32416,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 300,
		mana = 20,
		damage = {87, 101},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- falcon rod
	{
		itemId = 30886,
		type = WEAPON_SWORD,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- gnome sword
	{
		itemId = 30760,
		type = WEAPON_CLUB
	}, -- mallet handle
	{
		itemId = 30758,
		type = WEAPON_CLUB
	}, -- strange mallet
	{
		itemId = 30693,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 200,
		mana = 20,
		damage = {80, 110},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- rod of destruction
	{
		itemId = 30692,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 200,
		mana = 20,
		damage = {80, 110},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of destruction
	{
		itemId = 30691,
		type = WEAPON_DISTANCE,
		level = 200,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crossbow of destruction
	{
		itemId = 30690,
		type = WEAPON_DISTANCE,
		level = 200,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- bow of destruction
	{
		itemId = 30689,
		type = WEAPON_CLUB,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- hammer of destruction
	{
		itemId = 30688,
		type = WEAPON_CLUB,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- mace of destruction
	{
		itemId = 30687,
		type = WEAPON_AXE,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- chopper of destruction
	{
		itemId = 30686,
		type = WEAPON_AXE,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- axe of destruction
	{
		itemId = 30685,
		type = WEAPON_SWORD,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- slayer of destruction
	{
		itemId = 30684,
		type = WEAPON_SWORD,
		level = 200,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- blade of destruction
	{
		itemId = 29297,
		type = WEAPON_CLUB
	}, -- ornate carving hammer
	{
		itemId = 29296,
		type = WEAPON_CLUB
	}, -- valuable carving hammer
	{
		itemId = 29295,
		type = WEAPON_CLUB
	}, -- plain carving hammer
	{
		itemId = 29294,
		type = WEAPON_CLUB
	}, -- ornate carving mace
	{
		itemId = 29293,
		type = WEAPON_CLUB
	}, -- valuable carving mace
	{
		itemId = 29292,
		type = WEAPON_CLUB
	}, -- plain carving mace
	{
		itemId = 29291,
		type = WEAPON_AXE
	}, -- ornate carving chopper
	{
		itemId = 29290,
		type = WEAPON_AXE
	}, -- valuable carving chopper
	{
		itemId = 29289,
		type = WEAPON_AXE
	}, -- plain carving chopper
	{
		itemId = 29288,
		type = WEAPON_AXE
	}, -- ornate carving axe
	{
		itemId = 29287,
		type = WEAPON_AXE
	}, -- valuable carving axe
	{
		itemId = 29286,
		type = WEAPON_AXE
	}, -- plain carving axe
	{
		itemId = 29285,
		type = WEAPON_SWORD
	}, -- ornate carving slayer
	{
		itemId = 29284,
		type = WEAPON_SWORD
	}, -- valuable carving slayer
	{
		itemId = 29283,
		type = WEAPON_SWORD
	}, -- plain carving slayer
	{
		itemId = 29282,
		type = WEAPON_SWORD
	}, -- ornate carving blade
	{
		itemId = 29281,
		type = WEAPON_SWORD
	}, -- valuable carving blade
	{
		itemId = 29280,
		type = WEAPON_SWORD
	}, -- plain carving blade
	{
		itemId = 29267,
		type = WEAPON_CLUB
	}, -- ornate remedy hammer
	{
		itemId = 29266,
		type = WEAPON_CLUB
	}, -- valuable remedy hammer
	{
		itemId = 29265,
		type = WEAPON_CLUB
	}, -- plain remedy hammer
	{
		itemId = 29264,
		type = WEAPON_CLUB
	}, -- ornate remedy mace
	{
		itemId = 29263,
		type = WEAPON_CLUB
	}, -- valuable remedy mace
	{
		itemId = 29262,
		type = WEAPON_CLUB
	}, -- plain remedy mace
	{
		itemId = 29261,
		type = WEAPON_AXE
	}, -- ornate remedy chopper
	{
		itemId = 29260,
		type = WEAPON_AXE
	}, -- valuable remedy chopper
	{
		itemId = 29259,
		type = WEAPON_AXE
	}, -- plain remedy chopper
	{
		itemId = 29258,
		type = WEAPON_AXE
	}, -- ornate remedy axe
	{
		itemId = 29257,
		type = WEAPON_AXE
	}, -- valuable remedy axe
	{
		itemId = 29256,
		type = WEAPON_AXE
	}, -- plain remedy axe
	{
		itemId = 29255,
		type = WEAPON_SWORD
	}, -- ornate remedy slayer
	{
		itemId = 29254,
		type = WEAPON_SWORD
	}, -- valuable remedy slayer
	{
		itemId = 29253,
		type = WEAPON_SWORD
	}, -- plain remedy slayer
	{
		itemId = 29252,
		type = WEAPON_SWORD
	}, -- ornate remedy blade
	{
		itemId = 29251,
		type = WEAPON_SWORD
	}, -- valuable remedy blade
	{
		itemId = 29250,
		type = WEAPON_SWORD
	}, -- plain remedy blade
	{
		itemId = 29236,
		type = WEAPON_CLUB
	}, -- ornate mayhem hammer
	{
		itemId = 29235,
		type = WEAPON_CLUB
	}, -- valuable mayhem hammer
	{
		itemId = 29234,
		type = WEAPON_CLUB
	}, -- plain mayhem hammer
	{
		itemId = 29233,
		type = WEAPON_CLUB
	}, -- ornate mayhem mace
	{
		itemId = 29232,
		type = WEAPON_CLUB
	}, -- valuable mayhem mace
	{
		itemId = 29231,
		type = WEAPON_CLUB
	}, -- plain mayhem mace
	{
		itemId = 29230,
		type = WEAPON_AXE
	}, -- ornate mayhem chopper
	{
		itemId = 29229,
		type = WEAPON_AXE
	}, -- valuable mayhem chopper
	{
		itemId = 29228,
		type = WEAPON_AXE
	}, -- plain mayhem chopper
	{
		itemId = 29227,
		type = WEAPON_AXE
	}, -- ornate mayhem axe
	{
		itemId = 29226,
		type = WEAPON_AXE
	}, -- valuable mayhem axe
	{
		itemId = 29225,
		type = WEAPON_AXE
	}, -- plain mayhem axe
	{
		itemId = 29224,
		type = WEAPON_SWORD
	}, -- ornate mayhem slayer
	{
		itemId = 29223,
		type = WEAPON_SWORD
	}, -- valuable mayhem slayer
	{
		itemId = 29222,
		type = WEAPON_SWORD
	}, -- plain mayhem slayer
	{
		itemId = 29221,
		type = WEAPON_SWORD
	}, -- ornate mayhem blade
	{
		itemId = 29220,
		type = WEAPON_SWORD
	}, -- valuable mayhem blade
	{
		itemId = 29219,
		type = WEAPON_SWORD
	}, -- plain mayhem blade
	{
		itemId = 29210,
		type = WEAPON_CLUB
	}, -- energy war hammer replica
	{
		itemId = 29209,
		type = WEAPON_CLUB
	}, -- energy orcish maul replica
	{
		itemId = 29208,
		type = WEAPON_CLUB
	}, -- energy basher replica
	{
		itemId = 29207,
		type = WEAPON_CLUB
	}, -- energy crystal mace replica
	{
		itemId = 29206,
		type = WEAPON_CLUB
	}, -- energy clerical mace replica
	{
		itemId = 29205,
		type = WEAPON_AXE
	}, -- energy war axe replica
	{
		itemId = 29204,
		type = WEAPON_AXE
	}, -- energy headchopper replica
	{
		itemId = 29203,
		type = WEAPON_AXE
	}, -- energy heroic axe replica
	{
		itemId = 29202,
		type = WEAPON_AXE
	}, -- energy knight axe replica
	{
		itemId = 29201,
		type = WEAPON_AXE
	}, -- energy barbarian axe replica
	{
		itemId = 29200,
		type = WEAPON_SWORD
	}, -- energy dragon slayer replica
	{
		itemId = 29199,
		type = WEAPON_SWORD
	}, -- energy blacksteel replica
	{
		itemId = 29198,
		type = WEAPON_SWORD
	}, -- energy mystic blade replica
	{
		itemId = 29197,
		type = WEAPON_SWORD
	}, -- energy relic sword replica
	{
		itemId = 29196,
		type = WEAPON_SWORD
	}, -- energy spike sword replica
	{
		itemId = 29195,
		type = WEAPON_CLUB
	}, -- earth war hammer replica
	{
		itemId = 29194,
		type = WEAPON_CLUB
	}, -- earth orcish maul replica
	{
		itemId = 29193,
		type = WEAPON_CLUB
	}, -- earth basher replica
	{
		itemId = 29192,
		type = WEAPON_CLUB
	}, -- earth crystal mace replica
	{
		itemId = 29191,
		type = WEAPON_CLUB
	}, -- earth clerical mace replica
	{
		itemId = 29190,
		type = WEAPON_AXE
	}, -- earth war axe replica
	{
		itemId = 29189,
		type = WEAPON_AXE
	}, -- earth headchopper replica
	{
		itemId = 29188,
		type = WEAPON_AXE
	}, -- earth heroic axe replica
	{
		itemId = 29187,
		type = WEAPON_AXE
	}, -- earth knight axe replica
	{
		itemId = 29186,
		type = WEAPON_AXE
	}, -- earth barbarian axe replica
	{
		itemId = 29185,
		type = WEAPON_SWORD
	}, -- earth dragon slayer replica
	{
		itemId = 29184,
		type = WEAPON_SWORD
	}, -- earth blacksteel replica
	{
		itemId = 29183,
		type = WEAPON_SWORD
	}, -- earth mystic blade replica
	{
		itemId = 29182,
		type = WEAPON_SWORD
	}, -- earth relic sword replica
	{
		itemId = 29181,
		type = WEAPON_SWORD
	}, -- earth spike sword replica
	{
		itemId = 29180,
		type = WEAPON_CLUB
	}, -- icy war hammer replica
	{
		itemId = 29179,
		type = WEAPON_CLUB
	}, -- icy orcish maul replica
	{
		itemId = 29178,
		type = WEAPON_CLUB
	}, -- icy basher replica
	{
		itemId = 29177,
		type = WEAPON_CLUB
	}, -- icy crystal mace replica
	{
		itemId = 29176,
		type = WEAPON_CLUB
	}, -- icy clerical mace replica
	{
		itemId = 29175,
		type = WEAPON_AXE
	}, -- icy war axe replica
	{
		itemId = 29174,
		type = WEAPON_AXE
	}, -- icy headchopper replica
	{
		itemId = 29173,
		type = WEAPON_AXE
	}, -- icy heroic axe replica
	{
		itemId = 29172,
		type = WEAPON_AXE
	}, -- icy knight axe replica
	{
		itemId = 29171,
		type = WEAPON_AXE
	}, -- icy barbarian axe replica
	{
		itemId = 29170,
		type = WEAPON_SWORD
	}, -- icy dragon slayer replica
	{
		itemId = 29169,
		type = WEAPON_SWORD
	}, -- icy blacksteel replica
	{
		itemId = 29168,
		type = WEAPON_SWORD
	}, -- icy mystic blade replica
	{
		itemId = 29167,
		type = WEAPON_SWORD
	}, -- icy relic sword replica
	{
		itemId = 29166,
		type = WEAPON_SWORD
	}, -- icy spike sword replica
	{
		itemId = 29165,
		type = WEAPON_CLUB
	}, -- fiery war hammer replica
	{
		itemId = 29164,
		type = WEAPON_CLUB
	}, -- fiery orcish maul replica
	{
		itemId = 29163,
		type = WEAPON_CLUB
	}, -- fiery basher replica
	{
		itemId = 29162,
		type = WEAPON_CLUB
	}, -- fiery crystal mace replica
	{
		itemId = 29161,
		type = WEAPON_CLUB
	}, -- fiery clerical mace replica
	{
		itemId = 29160,
		type = WEAPON_AXE
	}, -- fiery war axe replica
	{
		itemId = 29159,
		type = WEAPON_AXE
	}, -- fiery headchopper replica
	{
		itemId = 29158,
		type = WEAPON_AXE
	}, -- fiery heroic axe replica
	{
		itemId = 29157,
		type = WEAPON_AXE
	}, -- fiery knight axe replica
	{
		itemId = 29156,
		type = WEAPON_AXE
	}, -- fiery barbarian axe replica
	{
		itemId = 29155,
		type = WEAPON_SWORD
	}, -- fiery dragon slayer replica
	{
		itemId = 29154,
		type = WEAPON_SWORD
	}, -- fiery blacksteel replica
	{
		itemId = 29153,
		type = WEAPON_SWORD
	}, -- fiery mystic blade replica
	{
		itemId = 29152,
		type = WEAPON_SWORD
	}, -- fiery relic sword replica
	{
		itemId = 29151,
		type = WEAPON_SWORD
	}, -- fiery spike sword replica
	{
		itemId = 29060,
		type = WEAPON_WAND,
		wandType = "death",
		level = 41,
		mana = 15,
		damage = {75, 95},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of darkness
	{
		itemId = 29059,
		type = WEAPON_DISTANCE,
		level = 120,
		unproperly = true,
		breakChance = 30
	}, -- royal star
	{
		itemId = 29058,
		type = WEAPON_AMMO,
		level = 150,
		unproperly = true,
		action = "removecount"
	}, -- spectral bolt
	{
		itemId = 29036,
		type = WEAPON_DISTANCE,
		level = 60,
		unproperly = true,
		breakChance = 40
	}, -- leaf star
	{
		itemId = 29005,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 80,
		mana = 18,
		damage = {63, 77},
		vocation = {
			{"Sorcerer", true},
			{"Druid", true, true},
			{"Master Sorcerer"},
			{"Elder Druid"}
		}
	}, -- dream blossom staff
	{
		itemId = 25995,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 100,
		mana = 18,
		damage = {70, 105},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- rod of carving
	{
		itemId = 25991,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 100,
		mana = 18,
		damage = {70, 105},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of carving
	{
		itemId = 25987,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crossbow of carving
	{
		itemId = 25983,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- bow of carving
	{
		itemId = 25979,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- hammer of carving
	{
		itemId = 25975,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- mace of carving
	{
		itemId = 25971,
		type = WEAPON_AXE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- chopper of carving
	{
		itemId = 25967,
		type = WEAPON_AXE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- axe of carving
	{
		itemId = 25963,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- slayer of carving
	{
		itemId = 25959,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- blade of carving
	{
		itemId = 25955,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 100,
		mana = 18,
		damage = {70, 105},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- rod of remedy
	{
		itemId = 25951,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 100,
		mana = 18,
		damage = {70, 105},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of remedy
	{
		itemId = 25947,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crossbow of remedy
	{
		itemId = 25943,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- bow of remedy
	{
		itemId = 25939,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- hammer of remedy
	{
		itemId = 25935,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- mace of remedy
	{
		itemId = 25931,
		type = WEAPON_AXE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- chopper of remedy
	{
		itemId = 25927,
		type = WEAPON_AXE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- axe of remedy
	{
		itemId = 25923,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- slayer of remedy
	{
		itemId = 25919,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- blade of remedy
	{
		itemId = 25888,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 100,
		mana = 18,
		damage = {70, 105},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- rod of mayhem
	{
		itemId = 25887,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 100,
		mana = 18,
		damage = {70, 105},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of mayhem
	{
		itemId = 25886,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crossbow of mayhem
	{
		itemId = 25885,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- bow of mayhem
	{
		itemId = 25884,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- hammer of mayhem
	{
		itemId = 25883,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- mace of mayhem
	{
		itemId = 25882,
		type = WEAPON_AXE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- chopper of mayhem
	{
		itemId = 25881,
		type = WEAPON_AXE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- axe of mayhem
	{
		itemId = 25880,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- slayer of mayhem
	{
		itemId = 25879,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- blade of mayhem
	{
		itemId = 25523,
		type = WEAPON_DISTANCE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- rift crossbow
	{
		itemId = 25522,
		type = WEAPON_DISTANCE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- rift bow
	{
		itemId = 25422,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 100,
		mana = 19,
		damage = {80, 110},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- ferumbras' staff (enchanted)
	{
		itemId = 25421,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 65,
		mana = 17,
		damage = {65, 95},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- ferumbras' staff (failed)
	{
		itemId = 25420,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true
	}, -- Ferumbras' staff
	{
		itemId = 25418,
		type = WEAPON_CLUB,
		level = 150,
		unproperly = true
	}, -- maimer
	{
		itemId = 25416,
		type = WEAPON_SWORD,
		level = 150,
		unproperly = true
	}, -- Impaler of the igniter
	{
		itemId = 25415,
		type = WEAPON_AXE,
		level = 150,
		unproperly = true
	}, -- plague bite
	{
		itemId = 25383,
		type = WEAPON_AXE,
		level = 70,
		unproperly = true
	}, -- rift lance
	{
		itemId = 24839,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 37,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- ogre sceptra
	{
		itemId = 24828,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true
	}, -- ogre choppa
	{
		itemId = 24827,
		type = WEAPON_AXE,
		level = 50,
		unproperly = true
	}, -- ogre klubba
	{
		itemId = 23839,
		type = WEAPON_AMMO,
		action = "removecount"
	}, -- simple arrow
	--[[
		the chiller
		{itemId = 23721}
		scripted weapon
	]]
	--[[
		the scorcher
		{itemId = 23719}
		scripted weapon
	]]
	{
		itemId = 23590,
		type = WEAPON_CLUB,
		level = 70,
		unproperly = true
	}, -- one hit wonder
	{
		itemId = 23551,
		type = WEAPON_AXE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- glooth axe
	{
		itemId = 23550,
		type = WEAPON_SWORD,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- glooth blade
	{
		itemId = 23549,
		type = WEAPON_CLUB,
		level = 75,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- glooth club
	{
		itemId = 23548,
		type = WEAPON_SWORD,
		level = 25,
		unproperly = true
	}, -- cowtana
	{
		itemId = 23547,
		type = WEAPON_AXE,
		level = 55,
		unproperly = true
	}, -- execowtioner axe
	{
		itemId = 23545,
		type = WEAPON_AXE,
		level = 45,
		unproperly = true
	}, -- mino lance
	{
		itemId = 23544,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true
	}, -- moohtant cudgel
	{
		itemId = 23543,
		type = WEAPON_CLUB,
		level = 25,
		unproperly = true
	}, -- glooth whip
	{
		itemId = 23542,
		type = WEAPON_CLUB,
		level = 55,
		unproperly = true
	}, -- metal bat
	{
		itemId = 23529,
		type = WEAPON_DISTANCE,
		level = 60,
		unproperly = true,
		breakChance = 2
	}, -- glooth spear
	{
		itemId = 22421,
		type = WEAPON_DISTANCE,
		level = 250,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- umbral master crossbow
	{
		itemId = 22420,
		type = WEAPON_DISTANCE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- umbral crossbow
	{
		itemId = 22419,
		type = WEAPON_DISTANCE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crude umbral crossbow
	{
		itemId = 22418,
		type = WEAPON_DISTANCE,
		level = 250,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- umbral master bow
	{
		itemId = 22417,
		type = WEAPON_DISTANCE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- umbral bow
	{
		itemId = 22416,
		type = WEAPON_DISTANCE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crude umbral bow
	{
		itemId = 22415,
		type = WEAPON_CLUB,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral master hammer
	{
		itemId = 22414,
		type = WEAPON_CLUB,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral hammer
	{
		itemId = 22413,
		type = WEAPON_CLUB,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- crude umbral hammer
	{
		itemId = 22412,
		type = WEAPON_CLUB,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral master mace
	{
		itemId = 22411,
		type = WEAPON_CLUB,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral mace
	{
		itemId = 22410,
		type = WEAPON_CLUB,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- crude umbral mace
	{
		itemId = 22409,
		type = WEAPON_AXE,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral master chopper
	{
		itemId = 22408,
		type = WEAPON_AXE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral chopper
	{
		itemId = 22407,
		type = WEAPON_AXE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- guardian halberd
	{
		itemId = 22406,
		type = WEAPON_AXE,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral master axe
	{
		itemId = 22405,
		type = WEAPON_AXE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral axe
	{
		itemId = 22404,
		type = WEAPON_AXE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- crude umbral axe
	{
		itemId = 22403,
		type = WEAPON_SWORD,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral master slayer
	{
		itemId = 22402,
		type = WEAPON_SWORD,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral slayer
	{
		itemId = 22401,
		type = WEAPON_SWORD,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- crude umbral slayer
	{
		itemId = 22400,
		type = WEAPON_SWORD,
		level = 250,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral masterblade
	{
		itemId = 22399,
		type = WEAPON_SWORD,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- umbral blade
	{
		itemId = 22398,
		type = WEAPON_SWORD,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- crude umbral blade
	{
		itemId = 21696,
		type = WEAPON_DISTANCE,
		unproperly = true
	}, -- icicle bow
	{
		itemId = 21690,
		type = WEAPON_DISTANCE,
		level = 70,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- triple bolt crossbow
	{
		itemId = 20139,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true
	}, -- spiky club
	{
		itemId = 20108,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- pair of iron fists
	{
		itemId = 20104,
		type = WEAPON_CLUB
	}, -- swampling club
	{
		itemId = 20093,
		type = WEAPON_CLUB,
		level = 15,
		unproperly = true
	}, -- life preserver
	{
		itemId = 20092,
		type = WEAPON_SWORD,
		level = 15,
		unproperly = true
	}, -- ratana
	{
		itemId = 19391,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 1,
		mana = 2,
		damage = {8, 18},
		vocation = {
			{"None", true}
		}
	}, -- sorc and druid staff
	{
		itemId = 19390,
		type = WEAPON_DISTANCE,
		breakChance = 3,
		vocation = {
			{"None", true}
		}
	}, -- mean paladin spear
	{
		itemId = 19389,
		type = WEAPON_SWORD,
		unproperly = true,
		vocation = {
			{"None", true}
		}
	}, -- mean knight sword
	{
		itemId = 18465,
		type = WEAPON_SWORD,
		level = 120,
		unproperly = true
	}, -- shiny blade
	{
		itemId = 18454,
		type = WEAPON_DISTANCE,
		level = 105,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- mycological bow
	{
		itemId = 18453,
		type = WEAPON_DISTANCE,
		level = 90,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- crystal crossbow
	{
		itemId = 18452,
		type = WEAPON_CLUB,
		level = 120,
		unproperly = true
	}, -- mycological mace
	{
		itemId = 18451,
		type = WEAPON_AXE,
		level = 120,
		unproperly = true
	}, -- crystalline axe
	{
		itemId = 18450,
		type = WEAPON_SWORD,
		level = 62,
		unproperly = true
	}, -- crystalline sword
	{
		itemId = 18437,
		type = WEAPON_AMMO,
		level = 70,
		unproperly = true,
		action = "removecount"
	}, -- envenomed arrow
	{
		itemId = 18436,
		type = WEAPON_AMMO,
		level = 70,
		unproperly = true,
		action = "removecount"
	}, -- drill bolt
	{
		itemId = 18435,
		type = WEAPON_AMMO,
		level = 90,
		unproperly = true,
		action = "removecount"
	}, -- prismatic bolt
	{
		itemId = 18412,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 65,
		mana = 17,
		damage = {75, 95},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- glacial rod
	{
		itemId = 18411,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 65,
		mana = 17,
		damage = {75, 95},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- muck rod
	{
		itemId = 18409,
		type = WEAPON_WAND,
		wandType = "fire",
		level = 65,
		mana = 17,
		damage = {75, 95},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of everblazing
	{
		itemId = 18390,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 65,
		mana = 17,
		damage = {75, 95},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of defiance
	{
		itemId = 18304,
		type = WEAPON_AMMO,
		level = 90,
		unproperly = true,
		action = "removecount"
	}, -- crystalline arrow
	{
		itemId = 18303,
		type = WEAPON_AMMO,
		action = "removecount"
	}, -- crystal bolt
	{
		itemId = 16111,
		type = WEAPON_DISTANCE,
		level = 150,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- thorn spitter
	{
		itemId = 15649,
		type = WEAPON_AMMO,
		level = 40,
		unproperly = true,
		action = "removecount"
	}, -- vortex bolt
	{
		itemId = 15648,
		type = WEAPON_AMMO,
		level = 30,
		unproperly = true,
		action = "removecount"
	}, -- tarsal arrow
	{
		itemId = 15647,
		type = WEAPON_CLUB,
		level = 48,
		unproperly = true
	}, -- deepling squelcher
	{
		itemId = 15644,
		type = WEAPON_DISTANCE,
		level = 50,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- ornate crossbow
	{
		itemId = 15643,
		type = WEAPON_DISTANCE,
		level = 85,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- hive bow
	{
		itemId = 15492,
		type = WEAPON_AXE,
		level = 70,
		unproperly = true
	}, -- hive scythe
	{
		itemId = 15454,
		type = WEAPON_AXE,
		level = 50,
		unproperly = true
	}, -- guardian axe
	{
		itemId = 15451,
		type = WEAPON_AXE,
		level = 40,
		unproperly = true
	}, -- warrior's axe
	{
		itemId = 15414,
		type = WEAPON_CLUB,
		level = 90,
		unproperly = true
	}, -- ornate mace
	{
		itemId = 15404,
		type = WEAPON_AXE,
		level = 80,
		unproperly = true
	}, -- deepling axe
	{
		itemId = 15400,
		type = WEAPON_CLUB,
		level = 38,
		unproperly = true
	}, -- deepling staff
	{
		itemId = 13880,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 40,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- shimmer wand
	{
		itemId = 13873,
		type = WEAPON_DISTANCE,
		level = 40,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- shimmer bow
	{
		itemId = 13872,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 40,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- shimmer rod
	{
		itemId = 13871,
		type = WEAPON_SWORD,
		level = 40,
		unproperly = true
	}, -- shimmer sword
	{
		itemId = 13838,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true
	}, -- heavy trident
	{
		itemId = 13829,
		type = WEAPON_SWORD
	}, -- wooden sword
	{
		itemId = 13760,
		type = WEAPON_WAND,
		wandType = "death",
		level = 37,
		mana = 9,
		damage = {44, 62},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of dimensions
	{
		itemId = 12649,
		type = WEAPON_SWORD,
		level = 82,
		unproperly = true
	}, -- blade of corruption
	{
		itemId = 12648,
		type = WEAPON_CLUB,
		level = 82,
		unproperly = true
	}, -- snake god's sceptre
	{
		itemId = 12613,
		type = WEAPON_SWORD,
		level = 58,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- twiceslicer
	{
		itemId = 11323,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true
	}, -- Zaoan halberd
	{
		itemId = 11309,
		type = WEAPON_SWORD,
		level = 20,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- twin hooks
	{
		itemId = 11308,
		type = WEAPON_CLUB,
		level = 55,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- drachaku
	{
		itemId = 11307,
		type = WEAPON_SWORD,
		level = 55,
		unproperly = true
	}, -- Zaoan sword
	{
		itemId = 11306,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- sai
	{
		itemId = 11305,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true
	}, -- drakinata
	{
		itemId = 10313,
		type = WEAPON_SWORD
	}, -- incredible mumpiz slayer
	{
		itemId = 10304,
		type = WEAPON_SWORD
	}, -- poet's fencing quill
	{
		itemId = 10303,
		type = WEAPON_AXE
	}, -- farmer's avenger
	{
		itemId = 10302,
		type = WEAPON_CLUB
	}, -- club of the fury
	{
		itemId = 10301,
		type = WEAPON_AXE
	}, -- scythe of the reaper
	{
		itemId = 10295,
		type = WEAPON_DISTANCE
	}, -- musician's bow
	{
		itemId = 10293,
		type = WEAPON_CLUB
	}, -- stale bread of ancientness
	{
		itemId = 10292,
		type = WEAPON_SWORD
	}, -- pointed rabbitslayer
	{
		itemId = 10290,
		type = WEAPON_CLUB
	}, -- glutton's mace
	{
		itemId = 8932,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- the calamity
	{
		itemId = 8931,
		type = WEAPON_SWORD,
		level = 120,
		unproperly = true
	}, -- the epiphany
	{
		itemId = 8930,
		type = WEAPON_SWORD,
		level = 100,
		unproperly = true
	}, -- emerald sword
	{
		itemId = 8929,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- the stomper
	{
		itemId = 8928,
		type = WEAPON_CLUB,
		level = 100,
		unproperly = true
	}, -- obsidian truncheon
	{
		itemId = 8927,
		type = WEAPON_CLUB,
		level = 120,
		unproperly = true
	}, -- dark trinity mace
	{
		itemId = 8926,
		type = WEAPON_AXE,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- demonwing axe
	{
		itemId = 8925,
		type = WEAPON_AXE,
		level = 130,
		unproperly = true
	}, -- solar axe
	{
		itemId = 8924,
		type = WEAPON_AXE,
		level = 110,
		unproperly = true
	}, -- hellforged axe
	{
		itemId = 8922,
		type = WEAPON_WAND,
		wandType = "death",
		level = 42,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of voodoo
	{
		itemId = 8921,
		type = WEAPON_WAND,
		wandType = "fire",
		level = 22,
		mana = 5,
		damage = {23, 37},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of draconia
	{
		itemId = 8920,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 37,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of starmstorm
	{
		itemId = 8912,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 37,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- springsprout rod
	{
		itemId = 8911,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 22,
		mana = 5,
		damage = {23, 37},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- northwind rod
	{
		itemId = 8910,
		type = WEAPON_WAND,
		wandType = "death",
		level = 42,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- underworld rod
	{
		itemId = 8858,
		type = WEAPON_DISTANCE,
		level = 70,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- elethriel's elemental bow
	{
		itemId = 8857,
		type = WEAPON_DISTANCE,
		level = 40,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- silkweaver bow
	{
		itemId = 8856,
		type = WEAPON_DISTANCE,
		level = 60,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- yol's bow
	{
		itemId = 8855,
		type = WEAPON_DISTANCE,
		level = 50,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- composite hornbow
	{
		itemId = 8854,
		type = WEAPON_DISTANCE,
		level = 80,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- warsinger bow
	{
		itemId = 8853,
		type = WEAPON_DISTANCE,
		level = 80,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- ironworker
	{
		itemId = 8852,
		type = WEAPON_DISTANCE,
		level = 100,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- devileye
	{
		itemId = 8851,
		type = WEAPON_DISTANCE,
		level = 130,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- royal crossbow
	{
		itemId = 8850,
		type = WEAPON_DISTANCE,
		level = 60,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- chain bolter
	{
		itemId = 8849,
		type = WEAPON_DISTANCE,
		level = 45,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- modified crossbow
	{
		itemId = 8602,
		type = WEAPON_SWORD
	}, -- jagged sword
	{
		itemId = 8601,
		type = WEAPON_AXE
	}, -- steel axe
	{
		itemId = 8209,
		type = WEAPON_SWORD
	}, -- crimson sword
	{
		itemId = 7883,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- energy war hammer
	{
		itemId = 7882,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- energy orcish maul
	{
		itemId = 7881,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- energy cranial basher
	{
		itemId = 7880,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- energy crystal mace
	{
		itemId = 7879,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- energy clerical mace
	{
		itemId = 7878,
		type = WEAPON_AXE,
		level = 65,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- energy war axe
	{
		itemId = 7877,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- energy headchopper
	{
		itemId = 7876,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- energy heroic axe
	{
		itemId = 7875,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true,
		action = "removecharge"
	}, -- energy knight axe
	{
		itemId = 7874,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- energy barbarian axe
	{
		itemId = 7873,
		type = WEAPON_SWORD,
		level = 45,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- energy dragon slayer
	{
		itemId = 7872,
		type = WEAPON_SWORD,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- energy blacksteel sword
	{
		itemId = 7871,
		type = WEAPON_SWORD,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- energy mystic blade
	{
		itemId = 7870,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true,
		action = "removecharge"
	}, -- energy relic sword
	{
		itemId = 7869,
		type = WEAPON_SWORD,
		action = "removecharge"
	}, -- energy spike sword
	{
		itemId = 7868,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- earth war hammer
	{
		itemId = 7867,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- earth orcish maul
	{
		itemId = 7866,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- earth cranial basher
	{
		itemId = 7865,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- earth crystal mace
	{
		itemId = 7864,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- earth clerical mace
	{
		itemId = 7863,
		type = WEAPON_AXE,
		level = 65,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- earth war axe
	{
		itemId = 7862,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- earth headchopper
	{
		itemId = 7861,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- earth heroic axe
	{
		itemId = 7860,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true,
		action = "removecharge"
	}, -- earth knight axe
	{
		itemId = 7859,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- earth barbarian axe
	{
		itemId = 7858,
		type = WEAPON_SWORD,
		level = 45,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- earth dragon slayer
	{
		itemId = 7857,
		type = WEAPON_SWORD,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- earth blacksteel sword
	{
		itemId = 7856,
		type = WEAPON_SWORD,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- earth mystic blade
	{
		itemId = 7855,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true,
		action = "removecharge"
	}, -- earth relic sword
	{
		itemId = 7854,
		type = WEAPON_SWORD,
		action = "removecharge"
	}, -- earth spike sword
	{
		itemId = 7850,
		type = WEAPON_AMMO,
		level = 20,
		unproperly = true,
		action = "removecount"
	}, -- earth arrow
	{
		itemId = 7840,
		type = WEAPON_AMMO,
		level = 20,
		unproperly = true,
		action = "removecount"
	}, -- flaming arrow
	{
		itemId = 7839,
		type = WEAPON_AMMO,
		level = 20,
		unproperly = true,
		action = "removecount"
	}, -- shiver arrow
	{
		itemId = 7838,
		type = WEAPON_AMMO,
		level = 20,
		unproperly = true,
		action = "removecount"
	}, -- flash arrow
	{
		itemId = 7777,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- icy war hammer
	{
		itemId = 7776,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- icy orcish maul
	{
		itemId = 7775,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- icy cranial basher
	{
		itemId = 7774,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- icy crystal mace
	{
		itemId = 7773,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- icy clerical mace
	{
		itemId = 7772,
		type = WEAPON_AXE,
		level = 65,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- icy war axe
	{
		itemId = 7771,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- icy headchopper
	{
		itemId = 7770,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- icy heroic axe
	{
		itemId = 7769,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true,
		action = "removecharge"
	}, -- icy knight axe
	{
		itemId = 7768,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- icy barbarian axe
	{
		itemId = 7767,
		type = WEAPON_SWORD,
		level = 45,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- icy dragon slayer
	{
		itemId = 7766,
		type = WEAPON_SWORD,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- icy blacksteel sword
	{
		itemId = 7765,
		type = WEAPON_SWORD,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- icy mystic blade
	{
		itemId = 7764,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true,
		action = "removecharge"
	}, -- icy relic sword
	{
		itemId = 7763,
		type = WEAPON_SWORD,
		action = "removecharge"
	}, -- icy spike sword
	{
		itemId = 7758,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- fiery war hammer
	{
		itemId = 7757,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- fiery orcish maul
	{
		itemId = 7756,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- fiery cranial basher
	{
		itemId = 7755,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true,
		action = "removecharge"
	}, -- fiery crystal mace
	{
		itemId = 7754,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- fiery clerical mace
	{
		itemId = 7753,
		type = WEAPON_AXE,
		level = 65,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- fiery war axe
	{
		itemId = 7752,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- fiery headchopper
	{
		itemId = 7751,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- fiery heroic axe
	{
		itemId = 7750,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true,
		action = "removecharge"
	}, -- fiery knight axe
	{
		itemId = 7749,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true,
		action = "removecharge"
	}, -- fiery barbarian axe
	{
		itemId = 7748,
		type = WEAPON_SWORD,
		level = 45,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- fiery dragon slayer
	{
		itemId = 7747,
		type = WEAPON_SWORD,
		level = 35,
		unproperly = true,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- fiery blacksteel sword
	{
		itemId = 7746,
		type = WEAPON_SWORD,
		level = 60,
		unproperly = true,
		action = "removecharge"
	}, -- fiery mystic blade
	{
		itemId = 7745,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true,
		action = "removecharge"
	}, -- fiery relic sword
	{
		itemId = 7744,
		type = WEAPON_SWORD,
		action = "removecharge"
	}, -- fiery spike sword
	{
		itemId = 7456,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true
	}, -- noble axe
	{
		itemId = 7455,
		type = WEAPON_AXE,
		level = 80,
		unproperly = true
	}, -- mythril axe
	{
		itemId = 7454,
		type = WEAPON_AXE,
		level = 30,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- glorious axe
	{
		itemId = 7453,
		type = WEAPON_AXE,
		level = 85,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- executioner
	{
		itemId = 7452,
		type = WEAPON_CLUB,
		level = 30,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- spiked squelcher
	{
		itemId = 7451,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true
	}, -- shadow sceptre
	{
		itemId = 7450,
		type = WEAPON_CLUB,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- hammer of prophecy
	{
		itemId = 7449,
		type = WEAPON_SWORD,
		level = 25,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- crystal sword
	{
		itemId = 7438,
		type = WEAPON_DISTANCE
	}, -- elvish bow
	{
		itemId = 7437,
		type = WEAPON_CLUB,
		level = 30,
		unproperly = true
	}, -- sapphire hammer
	{
		itemId = 7436,
		type = WEAPON_AXE,
		level = 45,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- angelic axe
	{
		itemId = 7435,
		type = WEAPON_AXE,
		level = 85,
		unproperly = true
	}, -- impaler
	{
		itemId = 7434,
		type = WEAPON_AXE,
		level = 75,
		unproperly = true
	}, -- royal axe
	{
		itemId = 7433,
		type = WEAPON_AXE,
		level = 65,
		unproperly = true
	}, -- ravenwing
	{
		itemId = 7432,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true
	}, -- furry club
	{
		itemId = 7431,
		type = WEAPON_CLUB,
		level = 80,
		unproperly = true
	}, -- demonbone
	{
		itemId = 7430,
		type = WEAPON_CLUB,
		level = 30,
		unproperly = true
	}, -- dragonbone staff
	{
		itemId = 7429,
		type = WEAPON_CLUB,
		level = 75,
		unproperly = true
	}, -- blessed sceptre
	{
		itemId = 7428,
		type = WEAPON_CLUB,
		level = 55,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- bonebreaker
	{
		itemId = 7427,
		type = WEAPON_CLUB,
		level = 45,
		unproperly = true
	}, -- chaos mace
	{
		itemId = 7426,
		type = WEAPON_CLUB,
		level = 40,
		unproperly = true
	}, -- amber staff
	{
		itemId = 7425,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true
	}, -- taurus mace
	{
		itemId = 7424,
		type = WEAPON_CLUB,
		level = 30,
		unproperly = true
	}, -- lunar staff
	{
		itemId = 7423,
		type = WEAPON_CLUB,
		level = 85,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- skullcrusher
	{
		itemId = 7422,
		type = WEAPON_CLUB,
		level = 70,
		unproperly = true
	}, -- jade hammer
	{
		itemId = 7421,
		type = WEAPON_CLUB,
		level = 65,
		unproperly = true
	}, -- onyx flail
	{
		itemId = 7420,
		type = WEAPON_AXE,
		level = 70,
		unproperly = true
	}, -- reaper's axe
	{
		itemId = 7419,
		type = WEAPON_AXE,
		level = 40,
		unproperly = true
	}, -- dreaded cleaver
	{
		itemId = 7418,
		type = WEAPON_SWORD,
		level = 70,
		unproperly = true
	}, -- nightmare blade
	{
		itemId = 7417,
		type = WEAPON_SWORD,
		level = 65,
		unproperly = true
	}, -- runed sword
	{
		itemId = 7416,
		type = WEAPON_SWORD,
		level = 55,
		unproperly = true
	}, -- bloody edge
	{
		itemId = 7415,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true
	}, -- cranial basher
	{
		itemId = 7414,
		type = WEAPON_CLUB,
		level = 60,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- abyss hammer
	{
		itemId = 7413,
		type = WEAPON_AXE,
		level = 40,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- titan axe
	{
		itemId = 7412,
		type = WEAPON_AXE,
		level = 45,
		unproperly = true
	}, -- butcher's axe
	{
		itemId = 7411,
		type = WEAPON_AXE,
		level = 50,
		unproperly = true
	}, -- ornamented axe
	{
		itemId = 7410,
		type = WEAPON_CLUB,
		level = 55,
		unproperly = true
	}, -- queen's sceptre
	{
		itemId = 7409,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true
	}, -- northern star
	{
		itemId = 7408,
		type = WEAPON_SWORD,
		level = 25,
		unproperly = true
	}, -- wyvern fang
	{
		itemId = 7407,
		type = WEAPON_SWORD,
		level = 30,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- haunted blade
	{
		itemId = 7406,
		type = WEAPON_SWORD,
		level = 35,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- blacksteel sword
	{
		itemId = 7405,
		type = WEAPON_SWORD,
		level = 70,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- havoc blade
	{
		itemId = 7404,
		type = WEAPON_SWORD,
		level = 40,
		unproperly = true
	}, -- assassin dagger
	{
		itemId = 7403,
		type = WEAPON_SWORD,
		level = 65,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- berserker
	{
		itemId = 7402,
		type = WEAPON_SWORD,
		level = 45,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- dragon slayer
	{
		itemId = 7392,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true
	}, -- orcish maul
	{
		itemId = 7391,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- thaian sword
	{
		itemId = 7390,
		type = WEAPON_SWORD,
		level = 75,
		unproperly = true
	}, -- the justice seeker
	{
		itemId = 7389,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true
	}, -- heroic axe
	{
		itemId = 7388,
		type = WEAPON_AXE,
		level = 55,
		unproperly = true
	}, -- vile axe
	{
		itemId = 7387,
		type = WEAPON_CLUB,
		level = 25,
		unproperly = true
	}, -- diamond sceptre
	{
		itemId = 7386,
		type = WEAPON_SWORD,
		level = 40,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- mercenary sword
	{
		itemId = 7385,
		type = WEAPON_SWORD,
		level = 20,
		unproperly = true
	}, -- crimson sword
	{
		itemId = 7384,
		type = WEAPON_SWORD,
		level = 60,
		unproperly = true
	}, -- mystic blade
	{
		itemId = 7383,
		type = WEAPON_SWORD,
		level = 50,
		unproperly = true
	}, -- relic sword
	{
		itemId = 7382,
		type = WEAPON_SWORD,
		level = 60,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- demonrage sword
	{
		itemId = 7381,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true
	}, -- mammoth whopper
	{
		itemId = 7380,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- headchopper
	{
		itemId = 7379,
		type = WEAPON_CLUB,
		level = 25,
		unproperly = true
	}, -- brutetamer's staff
	{
		itemId = 7378,
		type = WEAPON_DISTANCE,
		level = 25,
		unproperly = true,
		breakChance = 3
	}, -- royal spear
	{
		itemId = 7368,
		type = WEAPON_DISTANCE,
		level = 80,
		unproperly = true,
		breakChance = 33
	}, -- assassin star
	{
		itemId = 7367,
		type = WEAPON_DISTANCE,
		level = 42,
		unproperly = true,
		breakChance = 1
	}, -- enchanted spear
	{
		itemId = 7365,
		type = WEAPON_AMMO,
		level = 40,
		unproperly = true,
		action = "removecount"
	}, -- onyx arrow
	{
		itemId = 7364,
		type = WEAPON_AMMO,
		level = 20,
		unproperly = true,
		action = "removecount"
	}, -- sniper arrow
	{
		itemId = 7363,
		type = WEAPON_AMMO,
		level = 30,
		unproperly = true,
		action = "removecount"
	}, -- piercing bolt
	{
		itemId = 6553,
		type = WEAPON_AXE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- ruthless axe
	{
		itemId = 6529,
		type = WEAPON_AMMO,
		level = 110,
		unproperly = true,
		action = "removecount"
	}, -- infernal bolt
	{
		itemId = 6528,
		type = WEAPON_SWORD,
		level = 75,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- the avenger
	{
		itemId = 6101,
		type = WEAPON_SWORD
	}, -- Ron the Ripper's sabre
	{
		itemId = 5803,
		type = WEAPON_DISTANCE,
		level = 75,
		unproperly = true,
		vocation = {
			{"Paladin", true},
			{"Royal Paladin"}
		}
	}, -- arbalest
	{
		itemId = 3966,
		type = WEAPON_CLUB
	}, -- banana staff
	{
		itemId = 3965,
		type = WEAPON_DISTANCE,
		level = 20,
		unproperly = true,
		breakChance = 6
	}, -- hunting spear
	{
		itemId = 3964,
		type = WEAPON_AXE
	}, -- ripper lance
	{
		itemId = 3963,
		type = WEAPON_SWORD
	}, -- templar scytheblade
	{
		itemId = 3962,
		type = WEAPON_AXE,
		level = 30,
		unproperly = true
	}, -- beastslayer axe
	{
		itemId = 3961,
		type = WEAPON_CLUB,
		level = 40,
		unproperly = true
	}, -- lich staff
	{
		itemId = 2550,
		type = WEAPON_CLUB
	}, -- scythe
	{
		itemId = 2547,
		type = WEAPON_AMMO,
		level = 55,
		unproperly = true,
		action = "removecount"
	}, -- power bolt
	{
		itemId = 2544,
		type = WEAPON_AMMO,
		action = "removecount"
	}, -- arrow
	{
		itemId = 2543,
		type = WEAPON_AMMO,
		action = "removecount"
	}, -- bolt
	{
		itemId = 2456,
		type = WEAPON_DISTANCE
	}, -- bow
	{
		itemId = 2455,
		type = WEAPON_DISTANCE
	}, -- crossbow
	{
		itemId = 2454,
		type = WEAPON_AXE,
		level = 65,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- war axe
	{
		itemId = 2453,
		type = WEAPON_CLUB,
		level = 75,
		unproperly = true
	}, -- arcane staff
	{
		itemId = 2452,
		type = WEAPON_CLUB,
		level = 70,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- heavy mace
	{
		itemId = 2451,
		type = WEAPON_SWORD,
		level = 35,
		unproperly = true
	}, -- djinn blade
	{
		itemId = 2450,
		type = WEAPON_SWORD
	}, -- bone sword
	{
		itemId = 2449,
		type = WEAPON_CLUB
	}, -- bone club
	{
		itemId = 2448,
		type = WEAPON_CLUB
	}, -- studded club
	{
		itemId = 2447,
		type = WEAPON_AXE,
		level = 50,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- twin axe
	{
		itemId = 2446,
		type = WEAPON_SWORD,
		level = 45,
		unproperly = true
	}, -- pharaoh sword
	{
		itemId = 2445,
		type = WEAPON_CLUB,
		level = 35,
		unproperly = true
	}, -- crystal mace
	{
		itemId = 2444,
		type = WEAPON_CLUB,
		level = 65,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- hammer of wrath
	{
		itemId = 2443,
		type = WEAPON_AXE,
		level = 70,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- ravager's axe
	{
		itemId = 2442,
		type = WEAPON_SWORD
	}, -- heavy machete
	{
		itemId = 2441,
		type = WEAPON_AXE
	}, -- daramian axe
	{
		itemId = 2440,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- daramian waraxe
	{
		itemId = 2439,
		type = WEAPON_CLUB
	}, -- daramian mace
	{
		itemId = 2438,
		type = WEAPON_SWORD,
		level = 30,
		unproperly = true
	}, -- epee
	{
		itemId = 2437,
		type = WEAPON_CLUB
	}, -- light mace
	{
		itemId = 2436,
		type = WEAPON_CLUB,
		level = 30,
		unproperly = true
	}, -- skull staff
	{
		itemId = 2435,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true
	}, -- dwarven axe
	{
		itemId = 2434,
		type = WEAPON_CLUB,
		level = 25,
		unproperly = true
	}, -- dragon hammer
	{
		itemId = 2433,
		type = WEAPON_CLUB
	}, -- enchanted staff
	{
		itemId = 2432,
		type = WEAPON_AXE,
		level = 35,
		unproperly = true
	}, -- fire axe
	{
		itemId = 2431,
		type = WEAPON_AXE,
		level = 90,
		unproperly = true
	}, -- stonecutter axe
	{
		itemId = 2430,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true
	}, -- knight axe
	{
		itemId = 2429,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true
	}, -- barbarian axe
	{
		itemId = 2428,
		type = WEAPON_AXE
	}, -- orcish axe
	{
		itemId = 2427,
		type = WEAPON_AXE,
		level = 55,
		unproperly = true
	}, -- guardian halberd
	{
		itemId = 2426,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true
	}, -- naginata
	{
		itemId = 2425,
		type = WEAPON_AXE,
		level = 20,
		unproperly = true
	}, -- obsidian lance
	{
		itemId = 2424,
		type = WEAPON_CLUB,
		level = 45,
		unproperly = true
	}, -- silver mace
	{
		itemId = 2423,
		type = WEAPON_CLUB,
		level = 20,
		unproperly = true
	}, -- clerical mace
	{
		itemId = 2422,
		type = WEAPON_CLUB
	}, -- iron hammer
	{
		itemId = 2421,
		type = WEAPON_CLUB,
		level = 85,
		unproperly = true
	}, -- thunder hammer
	{
		itemId = 2420,
		type = WEAPON_SWORD
	}, -- machete
	{
		itemId = 2419,
		type = WEAPON_SWORD
	}, -- scimitar
	{
		itemId = 2418,
		type = WEAPON_AXE
	}, -- golden sickle
	{
		itemId = 2417,
		type = WEAPON_CLUB
	}, -- battle hammer
	{
		itemId = 2416,
		type = WEAPON_CLUB
	}, -- crowbar
	{
		itemId = 2415,
		type = WEAPON_AXE,
		level = 95,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- great axe
	{
		itemId = 2414,
		type = WEAPON_AXE,
		level = 60,
		unproperly = true
	}, -- dragon lance
	{
		itemId = 2413,
		type = WEAPON_SWORD,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- broadsword
	{
		itemId = 2412,
		type = WEAPON_SWORD
	}, -- katana
	{
		itemId = 2411,
		type = WEAPON_SWORD
	}, -- poison dagger
	{
		itemId = 2410,
		type = WEAPON_DISTANCE,
		breakChance = 7
	}, -- throwing knife
	{
		itemId = 2409,
		type = WEAPON_SWORD
	}, -- serpent sword
	{
		itemId = 2408,
		type = WEAPON_SWORD,
		level = 120,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- warlord sword
	{
		itemId = 2407,
		type = WEAPON_SWORD,
		level = 30,
		unproperly = true
	}, -- bright sword
	{
		itemId = 2406,
		type = WEAPON_SWORD
	}, -- short sword
	{
		itemId = 2405,
		type = WEAPON_AXE
	}, -- sickle
	{
		itemId = 2404,
		type = WEAPON_SWORD
	}, -- combat knife
	{
		itemId = 2403,
		type = WEAPON_SWORD
	}, -- knife
	{
		itemId = 2402,
		type = WEAPON_SWORD
	}, -- silver dagger
	{
		itemId = 2401,
		type = WEAPON_CLUB
	}, -- staff
	{
		itemId = 2400,
		type = WEAPON_SWORD,
		level = 80,
		unproperly = true
	}, -- magic sword
	{
		itemId = 2399,
		type = WEAPON_DISTANCE,
		breakChance = 10
	}, -- throwing star
	{
		itemId = 2398,
		type = WEAPON_CLUB
	}, -- mace
	{
		itemId = 2397,
		type = WEAPON_SWORD
	}, -- longsword
	{
		itemId = 2396,
		type = WEAPON_SWORD,
		action = "removecharge",
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- ice rapier
	{
		itemId = 2395,
		type = WEAPON_SWORD
	}, -- carlin sword
	{
		itemId = 2394,
		type = WEAPON_CLUB
	}, -- morning star
	{
		itemId = 2393,
		type = WEAPON_SWORD,
		level = 55,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- giant sword
	{
		itemId = 2392,
		type = WEAPON_SWORD,
		level = 30,
		unproperly = true
	}, -- fire sword
	{
		itemId = 2391,
		type = WEAPON_CLUB,
		level = 50,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- war hammer
	{
		itemId = 2390,
		type = WEAPON_SWORD,
		level = 140,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- magic longsword
	{
		itemId = 2389,
		type = WEAPON_DISTANCE,
		breakChance = 3
	}, -- spear
	{
		itemId = 2388,
		type = WEAPON_AXE
	}, -- hatchet
	{
		itemId = 2387,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- double axe
	{
		itemId = 2386,
		type = WEAPON_AXE
	}, -- axe
	{
		itemId = 2385,
		type = WEAPON_SWORD
	}, -- sabre
	{
		itemId = 2384,
		type = WEAPON_SWORD
	}, -- rapier
	{
		itemId = 2383,
		type = WEAPON_SWORD
	}, -- spike sword
	{
		itemId = 2382,
		type = WEAPON_CLUB
	}, -- club
	{
		itemId = 2381,
		type = WEAPON_AXE,
		level = 25,
		unproperly = true
	}, -- halberd
	{
		itemId = 2380,
		type = WEAPON_AXE
	}, -- hand axe
	{
		itemId = 2379,
		type = WEAPON_SWORD
	}, -- dagger
	{
		itemId = 2378,
		type = WEAPON_AXE,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- battle axe
	{
		itemId = 2377,
		type = WEAPON_SWORD,
		level = 20,
		unproperly = true,
		vocation = {
			{"Knight", true},
			{"Elite Knight"}
		}
	}, -- two handed sword
	{
		itemId = 2376,
		type = WEAPON_SWORD
	}, -- sword
	{
		itemId = 2321,
		type = WEAPON_CLUB
	}, -- giant smithhammer
	{
		itemId = 2191,
		type = WEAPON_WAND,
		wandType = "fire",
		level = 13,
		mana = 3,
		damage = {13, 25},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of dragonbreath
	{
		itemId = 2190,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 6,
		mana = 1,
		damage = {8, 18},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of vortex
	{
		itemId = 2189,
		type = WEAPON_WAND,
		wandType = "energy",
		level = 26,
		mana = 8,
		damage = {37, 53},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of cosmic energy
	{
		itemId = 2188,
		type = WEAPON_WAND,
		wandType = "death",
		level = 19,
		mana = 5,
		damage = {23, 37},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of decay
	{
		itemId = 2187,
		type = WEAPON_WAND,
		wandType = "fire",
		level = 33,
		mana = 8,
		damage = {56, 74},
		vocation = {
			{"Sorcerer", true},
			{"Master Sorcerer"}
		}
	}, -- wand of inferno
	{
		itemId = 2186,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 13,
		mana = 3,
		damage = {13, 25},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- moonlight rod
	{
		itemId = 2185,
		type = WEAPON_WAND,
		wandType = "death",
		level = 19,
		mana = 5,
		damage = {23, 37},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- necrotic rod
	{
		itemId = 2183,
		type = WEAPON_WAND,
		wandType = "ice",
		level = 33,
		mana = 13,
		damage = {56, 74},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- hailstorm rod
	{
		itemId = 2182,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 6,
		mana = 2,
		damage = {8, 18},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- snakebit rod
	{
		itemId = 2181,
		type = WEAPON_WAND,
		wandType = "earth",
		level = 26,
		mana = 8,
		damage = {37, 53},
		vocation = {
			{"Druid", true},
			{"Elder Druid"}
		}
	}, -- terra rod
	{
		itemId = 2111,
		type = WEAPON_DISTANCE,
		action = "removecount"
	}, -- snowball
	{
		itemId = 1294,
		type = WEAPON_DISTANCE,
		breakChance = 3
	} -- small stone
}

for index, weaponTable in ipairs(weapons) do
	local weapon = Weapon(weaponTable.type)
	weapon:id(weaponTable.itemId)

	if(weaponTable.action) then
		weapon:action(weaponTable.action)
	end
	if(weaponTable.breakChance) then
		weapon:breakChance(weaponTable.breakChance)
	end
	if(weaponTable.level) then
		weapon:level(weaponTable.level)
	end
	if(weaponTable.mana) then
		weapon:mana(weaponTable.mana)
	end
	if(weaponTable.unproperly) then
		weapon:wieldUnproperly(weaponTable.unproperly)
	end
	if(weaponTable.damage) then
		weapon:damage(weaponTable.damage[1], weaponTable.damage[2])
	end
	if(weaponTable.wandType) then
		weapon:element(weaponTable.wandType)
	end
	if(weaponTable.vocation) then
		for index, vocation in ipairs(weaponTable.vocation) do
			weapon:vocation(vocation[1], vocation[2] or false, vocation[3] or false)
		end
	end

	weapon:register()
end
