function createHirelingType(HirelingName)
	local npcType = Game.createNpcType(HirelingName)
	local npcConfig = {}

	npcConfig.name = HirelingName
	npcConfig.description = HirelingName

	npcConfig.health = 100
	npcConfig.maxHealth = npcConfig.health
	npcConfig.walkInterval = 0
	npcConfig.walkRadius = 2

	npcConfig.outfit = {
		lookType = 136,
		lookHead = 97,
		lookBody = 34,
		lookLegs = 3,
		lookFeet = 116,
		lookAddons = 0
	}

	npcConfig.flags = {
		floorchange = false
	}

	npcConfig.shop = {
		{itemName = "amphora", clientId = 2893, buy = 4},
		{itemName = "animate dead rune", clientId = 3203, buy = 377},
		{itemName = "armor rack kit", clientId = 6114, buy = 90},
		{itemName = "arrow", clientId = 3447, buy = 2},
		{itemName = "avalanche rune", clientId = 3161, buy = 57},
		{itemName = "axe", clientId = 3274, sell = 7},
		{itemName = "bamboo drawer kit", clientId = 2795, buy = 20},
		{itemName = "bamboo table kit", clientId = 2788, buy = 25},
		{itemName = "barrel kit", clientId = 2793, buy = 12},
		{itemName = "basket", clientId = 2855, buy = 6},
		{itemName = "battle axe", clientId = 3266, sell = 80},
		{itemName = "battle hammer", clientId = 3305, sell = 120},
		{itemName = "big table kit", clientId = 2785, buy = 30},
		{itemName = "birdcage kit", clientId = 2796, buy = 50},
		{itemName = "blank rune", clientId = 3147, buy = 10},
		{itemName = "blue bed kit", clientId = 834, buy = 80},
		{itemName = "blue pillow", clientId = 2394, buy = 25},
		{itemName = "blue quiver", clientId = 35848, buy = 400},
		{itemName = "blue tapestry", clientId = 2659, buy = 25},
		{itemName = "bolt", clientId = 3446, buy = 4},
		{itemName = "bone sword", clientId = 3338, sell = 20},
		{itemName = "bookcase kit", clientId = 6372, buy = 70},
		{itemName = "bottle", clientId = 2875, buy = 3},
		{itemName = "bow", clientId = 3350, sell = 100},
		{itemName = "box", clientId = 2469, buy = 10},
		{itemName = "brass armor", clientId = 3359, sell = 150},
		{itemName = "brass helmet", clientId = 3354, sell = 30},
		{itemName = "brass legs", clientId = 3372, sell = 49},
		{itemName = "brass shield", clientId = 3411, sell = 25},
		{itemName = "brown mushroom", clientId = 3725, buy = 10},
		{itemName = "bucket", clientId = 2873, buy = 4},
		{itemName = "candelabrum", clientId = 2911, buy = 8},
		{itemName = "candlestick", clientId = 2917, buy = 2},
		{itemName = "canopy bed kit", clientId = 17972, buy = 200},
		{itemName = "carlin sword", clientId = 3283, sell = 118},
		{itemName = "chain armor", clientId = 3358, sell = 70},
		{itemName = "chain helmet", clientId = 3352, sell = 17},
		{itemName = "chain legs", clientId = 3558, sell = 25},
		{itemName = "chameleon rune", clientId = 3178, buy = 210},
		{itemName = "chest", clientId = 2472, buy = 10},
		{itemName = "chest of drawers", clientId = 2789, buy = 18},
		{itemName = "chimney kit", clientId = 7864, buy = 200},
		{itemName = "closed trap", clientId = 3481, sell = 75},
		{itemName = "club", clientId = 3270, sell = 1},
		{itemName = "coal basin kit", clientId = 2806, buy = 25},
		{itemName = "coat", clientId = 3562, sell = 1},
		{itemName = "convince creature rune", clientId = 3177, buy = 80},
		{itemName = "cookie", clientId = 3598, buy = 2},
		{itemName = "crate", clientId = 2471, buy = 10},
		{itemName = "crossbow", clientId = 3349, sell = 120},
		{itemName = "crowbar", clientId = 3304, sell = 50},
		{itemName = "crystalline arrow", clientId = 15793, buy = 20},
		{itemName = "cuckoo clock", clientId = 2664, buy = 40},
		{itemName = "cure poison rune", clientId = 3153, buy = 65},
		{itemName = "dagger", clientId = 3267, sell = 2},
		{itemName = "destroy field rune", clientId = 3148, buy = 15},
		{itemName = "diamond arrow", clientId = 35901, buy = 100},
		{itemName = "disintegrate rune", clientId = 3197, buy = 26},
		{itemName = "doublet", clientId = 3379, sell = 3},
		{itemName = "dresser kit", clientId = 2790, buy = 25},
		{itemName = "drill bolt", clientId = 16142, buy = 12},
		{itemName = "dwarven shield", clientId = 3425, sell = 100},
		{itemName = "earth arrow", clientId = 774, buy = 5},
		{itemName = "empty potion flask", clientId = 283, sell = 5},
		{itemName = "empty potion flask", clientId = 284, sell = 5},
		{itemName = "empty potion flask", clientId = 285, sell = 5},
		{itemName = "energy bomb rune", clientId = 3149, buy = 203},
		{itemName = "energy field rune", clientId = 3164, buy = 38},
		{itemName = "energy wall rune", clientId = 3166, buy = 85},
		{itemName = "envenomed arrow", clientId = 16143, buy = 12},
		{itemName = "exercise axe", clientId = 28553},
		{itemName = "exercise bow", clientId = 28555},
		{itemName = "exercise club", clientId = 28554},
		{itemName = "exercise rod", clientId = 28556, buy = 262500},
		{itemName = "exercise rod", clientId = 28556, buy = 262500},
		{itemName = "exercise sword", clientId = 28552},
		{itemName = "exercise wand", clientId = 28557, buy = 262500},
		{itemName = "exercise wand", clientId = 28557, buy = 262500},
		{itemName = "explosion rune", clientId = 3200, buy = 31},
		{itemName = "fire bomb rune", clientId = 3192, buy = 147},
		{itemName = "fire field rune", clientId = 3188, buy = 28},
		{itemName = "fire wall rune", clientId = 3190, buy = 61},
		{itemName = "fireball rune", clientId = 3189, buy = 30},
		{itemName = "fireworks rocket", clientId = 6576, buy = 100},
		{itemName = "fishing rod", clientId = 3483, sell = 40},
		{itemName = "flaming arrow", clientId = 763, buy = 5},
		{itemName = "flash arrow", clientId = 761, buy = 5},
		{itemName = "flower bowl", clientId = 2983, buy = 6},
		{itemName = "globe", clientId = 2797, buy = 50},
		{itemName = "goblin statue kit", clientId = 2804, buy = 50},
		{itemName = "god flowers", clientId = 2981, buy = 5},
		{itemName = "goldfish bowl", clientId = 5928, buy = 50},
		{itemName = "great fireball rune", clientId = 3191, buy = 57},
		{itemName = "great health potion", clientId = 239, buy = 225},
		{itemName = "great mana potion", clientId = 238, buy = 144},
		{itemName = "great spirit potion", clientId = 7642, buy = 228},
		{itemName = "green balloons", clientId = 6577, buy = 500},
		{itemName = "green bed kit", clientId = 831, buy = 80},
		{itemName = "green cushioned chair kit", clientId = 2776, buy = 40},
		{itemName = "green pillow", clientId = 2396, buy = 25},
		{itemName = "green tapestry", clientId = 2647, buy = 25},
		{itemName = "hailstorm rod", clientId = 3067, buy = 13526},
		{itemName = "ham", clientId = 3582, buy = 10},
		{itemName = "hand axe", clientId = 3268, sell = 4},
		{itemName = "harp kit", clientId = 2808, buy = 50},
		{itemName = "health potion", clientId = 266, buy = 50},
		{itemName = "heart pillow", clientId = 2393, buy = 30},
		{itemName = "heavy magic missile rune", clientId = 3198, buy = 12},
		{itemName = "holy missile rune", clientId = 3182, buy = 16},
		{itemName = "honey flower", clientId = 2984, buy = 5},
		{itemName = "icicle rune", clientId = 3158, buy = 30},
		{itemName = "indoor plant kit", clientId = 2811, buy = 8},
		{itemName = "intense healing rune", clientId = 3152, buy = 95},
		{itemName = "iron helmet", clientId = 3353, sell = 150},
		{itemName = "ivory chair kit", clientId = 2781, buy = 25},
		{itemName = "jacket", clientId = 3561, sell = 1},
		{itemName = "knight statue kit", clientId = 2802, buy = 50},
		{itemName = "label", clientId = 3507, buy = 1},
		{itemName = "large amphora kit", clientId = 2805, buy = 50},
		{itemName = "large trunk", clientId = 2794, buy = 10},
		{itemName = "leather armor", clientId = 3361, sell = 12},
		{itemName = "leather boots", clientId = 3552, sell = 2},
		{itemName = "leather helmet", clientId = 3355, sell = 4},
		{itemName = "leather legs", clientId = 3559, sell = 9},
		{itemName = "letter", clientId = 3505, buy = 8},
		{itemName = "light magic missile rune", clientId = 3174, buy = 4},
		{itemName = "locker kit", clientId = 2791, buy = 30},
		{itemName = "longsword", clientId = 3285, sell = 51},
		{itemName = "mace", clientId = 3286, sell = 30},
		{itemName = "machete", clientId = 3308, sell = 6},
		{itemName = "magic wall rune", clientId = 3180, buy = 116},
		{itemName = "mana potion", clientId = 268, buy = 56},
		{itemName = "meat", clientId = 3577, buy = 5},
		{itemName = "minotaur statue kit", clientId = 2803, buy = 50},
		{itemName = "moonlight rod", clientId = 3070, buy = 1245},
		{itemName = "morning star", clientId = 3282, sell = 100},
		{itemName = "necrotic rod", clientId = 3069, buy = 4999},
		{itemName = "northwind rod", clientId = 8083, buy = 142},
		{itemName = "onyx arrow", clientId = 7365, buy = 7},
		{itemName = "orange tapestry", clientId = 2653, buy = 25},
		{itemName = "oven kit", clientId = 6371, buy = 80},
		{itemName = "paralyse rune", clientId = 3165, buy = 700},
		{itemName = "parcel", clientId = 3503, buy = 15},
		{itemName = "party hat", clientId = 6578, buy = 800},
		{itemName = "party trumpet", clientId = 6572, buy = 500},
		{itemName = "pendulum clock kit", clientId = 2801, buy = 75},
		{itemName = "piano kit", clientId = 2807, buy = 200},
		{itemName = "pick", clientId = 3456, sell = 15},
		{itemName = "piercing bolt", clientId = 7363, buy = 5},
		{itemName = "plate armor", clientId = 3357, sell = 400},
		{itemName = "plate shield", clientId = 3410, sell = 45},
		{itemName = "poison bomb rune", clientId = 3173, buy = 85},
		{itemName = "poison field rune", clientId = 3172, buy = 21},
		{itemName = "poison wall rune", clientId = 3176, buy = 52},
		{itemName = "potted flower", clientId = 2985, buy = 5},
		{itemName = "power bolt", clientId = 3450, buy = 7},
		{itemName = "present", clientId = 2856, buy = 10},
		{itemName = "prismatic bolt", clientId = 16141, buy = 20},
		{itemName = "purple tapestry", clientId = 2644, buy = 25},
		{itemName = "quiver", clientId = 35562, buy = 400},
		{itemName = "rapier", clientId = 3272, sell = 5},
		{itemName = "red balloons", clientId = 6575, buy = 500},
		{itemName = "red bed kit", clientId = 833, buy = 80},
		{itemName = "red cushioned chair kit", clientId = 2775, buy = 40},
		{itemName = "red pillow", clientId = 2395, buy = 25},
		{itemName = "red quiver", clientId = 35849, buy = 400},
		{itemName = "red tapestry", clientId = 2656, buy = 25},
		{itemName = "rocking horse", clientId = 2800, buy = 30},
		{itemName = "rope", clientId = 3003, sell = 15},
		{itemName = "round blue pillow", clientId = 2398, buy = 25},
		{itemName = "round purple pillow", clientId = 2400, buy = 25},
		{itemName = "round red pillow", clientId = 2399, buy = 25},
		{itemName = "round turquoise pillow", clientId = 2401, buy = 25},
		{itemName = "royal spear", clientId = 7378, buy = 15},
		{itemName = "sabre", clientId = 3273, sell = 12},
		{itemName = "scale armor", clientId = 3377, sell = 75},
		{itemName = "scythe", clientId = 3453, sell = 10},
		{itemName = "shiver arrow", clientId = 762, buy = 5},
		{itemName = "short sword", clientId = 3294, sell = 10},
		{itemName = "shovel", clientId = 3457, sell = 8},
		{itemName = "sickle", clientId = 3293, sell = 3},
		{itemName = "small blue pillow", clientId = 2389, buy = 20},
		{itemName = "small green pillow", clientId = 2387, buy = 20},
		{itemName = "small ice statue", clientId = 7448, buy = 50},
		{itemName = "small orange pillow", clientId = 2390, buy = 20},
		{itemName = "small purple pillow", clientId = 2386, buy = 20},
		{itemName = "small red pillow", clientId = 2388, buy = 20},
		{itemName = "small round table", clientId = 2783, buy = 25},
		{itemName = "small table kit", clientId = 2782, buy = 20},
		{itemName = "small trunk", clientId = 2426, buy = 20},
		{itemName = "small turquoise pillow", clientId = 2391, buy = 20},
		{itemName = "small white pillow", clientId = 2392, buy = 20},
		{itemName = "snakebite rod", clientId = 3066, buy = 500},
		{itemName = "sniper arrow", clientId = 7364, buy = 5},
		{itemName = "sofa chair kit", clientId = 2779, buy = 55},
		{itemName = "soldier helmet", clientId = 3375, sell = 16},
		{itemName = "soulfire rune", clientId = 3195, buy = 46},
		{itemName = "spear", clientId = 3277, sell = 3},
		{itemName = "spectral bolt", clientId = 35902, buy = 70},
		{itemName = "spellwand", clientId = 651, sell = 299},
		{itemName = "spike sword", clientId = 3271, sell = 240},
		{itemName = "springsprout rod", clientId = 8084, buy = 15468},
		{itemName = "square table kit", clientId = 2784, buy = 25},
		{itemName = "stalagmite rune", clientId = 3179, buy = 12},
		{itemName = "steel helmet", clientId = 3351, sell = 293},
		{itemName = "steel shield", clientId = 3409, sell = 80},
		{itemName = "stone shower rune", clientId = 3175, buy = 37},
		{itemName = "stone table kit", clientId = 2786, buy = 30},
		{itemName = "strong health potion", clientId = 236, buy = 115},
		{itemName = "strong mana potion", clientId = 237, buy = 93},
		{itemName = "studded armor", clientId = 3378, sell = 25},
		{itemName = "studded helmet", clientId = 3376, sell = 20},
		{itemName = "studded legs", clientId = 3362, sell = 15},
		{itemName = "studded shield", clientId = 3426, sell = 16},
		{itemName = "sudden death rune", clientId = 3155, buy = 135},
		{itemName = "supreme health potion", clientId = 23375, buy = 625},
		{itemName = "sword", clientId = 3264, sell = 25},
		{itemName = "table lamp kit", clientId = 2798, buy = 35},
		{itemName = "tarsal arrow", clientId = 14251, buy = 6},
		{itemName = "telescope kit", clientId = 2799, buy = 70},
		{itemName = "terra rod", clientId = 3065, buy = 9087},
		{itemName = "thick trunk", clientId = 2352, buy = 20},
		{itemName = "throwing knife", clientId = 3298, sell = 2},
		{itemName = "throwing star", clientId = 3287, buy = 42},
		{itemName = "thunderstorm rune", clientId = 3202, buy = 47},
		{itemName = "torch", clientId = 2920, buy = 2},
		{itemName = "treasure chest", clientId = 2478, buy = 1245},
		{itemName = "trophy stand", clientId = 872, buy = 50},
		{itemName = "trough kit", clientId = 2792, buy = 7},
		{itemName = "tusk chair kit", clientId = 2780, buy = 25},
		{itemName = "tusk table kit", clientId = 2787, buy = 25},
		{itemName = "two handed sword", clientId = 3265, sell = 456},
		{itemName = "ultimate healing rune", clientId = 3160, buy = 175},
		{itemName = "ultimate health potion", clientId = 7643, buy = 381},
		{itemName = "ultimate mana potion", clientId = 23373, buy = 443},
		{itemName = "ultimate spirit potion", clientId = 23374, buy = 443},
		{itemName = "underworld rod", clientId = 8082, buy = 19666},
		{itemName = "vase", clientId = 2876, buy = 3},
		{itemName = "venorean cabinet", clientId = 17974, buy = 90},
		{itemName = "venorean drawer", clientId = 17977, buy = 40},
		{itemName = "venorean wardrobe", clientId = 17975, buy = 50},
		{itemName = "vial", clientId = 377, sell = 5},
		{itemName = "viking helmet", clientId = 3367, sell = 66},
		{itemName = "viking shield", clientId = 3431, sell = 85},
		{itemName = "vortex bolt", clientId = 14252, buy = 6},
		{itemName = "wall mirror", clientId = 2632, buy = 40},
		{itemName = "wand of cosmic energy", clientId = 3073, buy = 9087},
		{itemName = "wand of decay", clientId = 3072, buy = 4999},
		{itemName = "wand of draconia", clientId = 8093, buy = 142},
		{itemName = "wand of dragonbreath", clientId = 3075, buy = 1245},
		{itemName = "wand of inferno", clientId = 3071, buy = 13526},
		{itemName = "wand of starstorm", clientId = 8092, buy = 15468},
		{itemName = "wand of voodoo", clientId = 8094, buy = 19666},
		{itemName = "wand of vortex", clientId = 3074, buy = 500},
		{itemName = "war hammer", clientId = 3279, sell = 595},
		{itemName = "watch", clientId = 2906, sell = 6},
		{itemName = "water pipe", clientId = 2980, buy = 40},
		{itemName = "weapon rack kit", clientId = 6115, buy = 90},
		{itemName = "white tapestry", clientId = 2667, buy = 25},
		{itemName = "wild growth rune", clientId = 3156, buy = 160},
		{itemName = "wooden chair kit", clientId = 2777, buy = 15},
		{itemName = "wooden shield", clientId = 3412, sell = 5},
		{itemName = "worm", clientId = 3492, buy = 1},
		{itemName = "yellow bed kit", clientId = 832, buy = 80},
		{itemName = "yellow pillow", clientId = 900, buy = 25},
		{itemName = "yellow tapestry", clientId = 2650, buy = 25}
	}
	-- On buy npc shop message
	npcType.onBuyItem = function(npc, player, itemId, subType, amount, ignore, inBackpacks, totalCost)
		npc:sellItem(player, itemId, amount, subType, 0, ignore, inBackpacks)
	end
	-- On sell npc shop message
	npcType.onSellItem = function(npc, player, itemId, subtype, amount, ignore, name, totalCost)
		player:sendTextMessage(MESSAGE_INFO_DESCR, string.format("Sold %ix %s for %i gold.", amount, name, totalCost))
	end
	-- On check npc shop message (look item)
	npcType.onCheckItem = function(npc, player, clientId, subType)
	end

	local keywordHandler = KeywordHandler:new()
	local npcHandler = NpcHandler:new(keywordHandler)
	local hireling = nil
	local count = {} -- for banking
	local transfer = {} -- for banking

	npcType.onAppear = function(npc, creature)
		npcHandler:onAppear(npc, creature)

		if not hireling then
			local position = creature:getPosition()

			hireling = getHirelingByPosition(position)
			hireling:setCreature(creature)
		end
	end

	npcType.onDisappear = function(npc, creature)
		npcHandler:onDisappear(npc, creature)
	end

	npcType.onSay = function(npc, creature, type, message)
		npcHandler:onSay(npc, creature, type, message)
	end

	npcType.onCloseChannel = function(npc, creature)
		npcHandler:onCloseChannel(npc, creature)
	end

	npcType.onThink = function(npc, interval)
		npcHandler:onThink(npc, interval)
	end

	local TOPIC = {
		NONE = 1000,
		LAMP = 1001,
		SERVICES = 1100,
		BANK = 1200,
		FOOD = 1300,
		GOODS = 1400
	}

	local TOPIC_FOOD = {
		SKILL_CHOOSE = 1301
	}

	local GREETINGS = {
		BANK = "Alright! What can I do for you and your bank business, |PLAYERNAME|?",
		FOOD = "Hmm, yes! A variety of fine food awaits! However, a small expense of 15000 gold is expected to make these delicious masterpieces happen. Shall I?",
		STASH = "Of course, here is your stash! Well-maintained and neatly sorted for your convenience!"
	}

	local function getHirelingSkills()
		local skills = {}
		if hireling:hasSkill(HIRELING_SKILLS.BANKER) then
			table.insert(skills, HIRELING_SKILLS.BANKER)
		end
		if hireling:hasSkill(HIRELING_SKILLS.COOKING) then
			table.insert(skills, HIRELING_SKILLS.COOKING)
		end
		if hireling:hasSkill(HIRELING_SKILLS.STEWARD) then
			table.insert(skills, HIRELING_SKILLS.STEWARD)
		end
		-- ignoring trader skills as it shows the same message about {goods}
		return skills
	end

	local function getHirelingServiceString(creature)
		local skills = getHirelingSkills()
		local str = "Do you want to see my {goods}"

		for i = 1, #skills do
			if i == #skills then
				str = str .. " or "
			else
				str = str .. ", "
			end

			if skills[i] == HIRELING_SKILLS.BANKER then
				str = str .. "to access your {bank} account" -- TODO: this setence is not official
			elseif skills[i] == HIRELING_SKILLS.COOKING then
				str = str .. "to order {food}"
			elseif skills[i] == HIRELING_SKILLS.STEWARD then
				str = str .. "to open your {stash}"
			end
		end
		str = str .. "?"

		local player = Player(creature)

		if player:getGuid() == hireling:getOwnerId() then
			str = str .. " If you want, I can go back to my {lamp} or maybe change my {outfit}."
		end
		return str
	end

	local function sendSkillNotLearned(npc, creature, SKILL)
		local message = "Sorry, but I do not have mastery in this skill yet."
		local profession
		if SKILL == HIRELING_SKILLS.BANKER then
			profession = "banker"
		elseif SKILL == HIRELING_SKILLS.COOKING then
			profession = "cooker"
		elseif SKILL == HIRELING_SKILLS.STEWARD then
			profession = "steward"
		elseif SKILL == HIRELING_SKILLS.TRADER then
			profession = "trader"
		end

		if profession then
			message =
				string.format(
				"I'm not a %s and would not know how to help you with that, sorry. I can start a %s apprenticeship if you buy it for me in the store!",
				profession,
				profession
			)
		end

		npcHandler:say(message, npc, creature)
	end
	-- ----------------------[[ END STEWARD FUNCTIONS ]] ------------------------------
	--[[
	############################################################################
	############################################################################
	############################################################################
	]]
	-- ----------------------[[ BANKING FUNCTIONS ]] ------------------------------
	-------------------------------- guild bank -----------------------------------------------
	local receiptFormat = "Date: %s\nType: %s\nGold Amount: %d\nReceipt Owner: %s\nRecipient: %s\n\n%s"
	local function GetReceipt(info)
		local receipt = Game.createItem(info.success and 21932 or 21933)
		receipt:setAttribute(
			ITEM_ATTRIBUTE_TEXT,
			receiptFormat:format(
				os.date("%d. %b %Y - %H:%M:%S"),
				info.type,
				info.amount,
				info.owner,
				info.recipient,
				info.message
			)
		)

		return receipt
	end

	local function GetGuildIdByName(name, func)
		db.asyncStoreQuery(
			"SELECT `id` FROM `guilds` WHERE `name` = " .. db.escapeString(name),
			function(resultId)
				if resultId then
					func(result.getNumber(resultId, "id"))
					result.free(resultId)
				else
					func(nil)
				end
			end
		)
	end

	local function GetGuildBalance(id)
		local guild = Guild(id)
		if guild then
			return guild:getBankBalance()
		else
			local balance
			local resultId = db.storeQuery("SELECT `balance` FROM `guilds` WHERE `id` = " .. id)
			if resultId then
				balance = result.getU64(resultId, "balance")
				result.free(resultId)
			end

			return balance
		end
	end

	local function SetGuildBalance(id, balance)
		local guild = Guild(id)
		if guild then
			guild:setBankBalance(balance)
		else
			db.query("UPDATE `guilds` SET `balance` = " .. balance .. " WHERE `id` = " .. id)
		end
	end

	local function TransferFactory(playerName, amount, fromGuildId, info)
		return function(toGuildId)
			if not toGuildId then
				local player = Player(playerName)
				if player then
					info.success = false
					info.message =
						"We are sorry to inform you that we could not fulfil your request, because we could not find the recipient guild."
					local inbox = player:getInbox()
					local receipt = GetReceipt(info)
					inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
				end
			else
				local fromBalance = GetGuildBalance(fromGuildId)
				if fromBalance < amount then
					info.success = false
					info.message =
						"We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your guild account."
				else
					info.success = true
					info.message = "We are happy to inform you that your transfer request was successfully carried out."
					SetGuildBalance(fromGuildId, fromBalance - amount)
					SetGuildBalance(toGuildId, GetGuildBalance(toGuildId) + amount)
				end

				local player = Player(playerName)
				if player then
					local inbox = player:getInbox()
					local receipt = GetReceipt(info)
					inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
				end
			end
		end
	end
	--------------------------------end guild bank-----------------------------------------------
	local function handleBankActions(npc, creature, message)
		local player = Player(creature)
		local playerId = player:getId()
		---------------------------- help ------------------------
		if MsgContains(message, "bank account") then
			---------------------------- balance ---------------------
			--------------------------------guild bank-----------------------------------------------
			npcHandler:say(
				{
					"Every citizen has one. The big advantage is that you can access your money in every branch of the Global Bank! ...",
					"Would you like to know more about the {basic} functions of your bank account, the {advanced} functions, or are you already bored, perhaps?"
				},
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 1445)
			return true
		elseif MsgContains(message, "guild balance") then
			--------------------------------guild bank-----------------------------------------------
			npcHandler:setTopic(playerId, 1445)
			if not player:getGuild() then
				npcHandler:say("You are not a member of a guild.", npc, creature)
				return false
			end
			npcHandler:say(
				"Your guild account balance is " .. player:getGuild():getBankBalance() .. " gold.",
				npc,
				creature
			)
			return true
		elseif MsgContains(message, "balance") then
			---------------------------- deposit ---------------------
			--------------------------------guild bank-----------------------------------------------
			npcHandler:setTopic(playerId, 1445)
			if player:getBankBalance() >= 100000000 then
				npcHandler:say(
					"I think you must be one of the richest inhabitants in the world! Your account balance is " ..
						player:getBankBalance() .. " gold.",
					npc,
					creature
				)
				return true
			elseif player:getBankBalance() >= 10000000 then
				npcHandler:say(
					"You have made ten millions and it still grows! Your account balance is " ..
						player:getBankBalance() .. " gold.",
					npc,
					creature
				)
				return true
			elseif player:getBankBalance() >= 1000000 then
				npcHandler:say(
					"Wow, you have reached the magic number of a million gp!!! Your account balance is " ..
						player:getBankBalance() .. " gold!",
					npc,
					creature
				)
				return true
			elseif player:getBankBalance() >= 100000 then
				npcHandler:say(
					"You certainly have made a pretty penny. Your account balance is " ..
						player:getBankBalance() .. " gold.",
					npc,
					creature
				)
				return true
			else
				npcHandler:say("Your account balance is " .. player:getBankBalance() .. " gold.", npc, creature)
				return true
			end
		elseif MsgContains(message, "guild deposit") then
			if not player:getGuild() then
				npcHandler:say("You are not a member of a guild.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return false
			end
			-- count[playerId] = player:getMoney()
			-- if count[playerId] < 1 then
			-- npcHandler:say('You do not have enough gold.', npc, creature)
			-- npcHandler:setTopic(playerId, 1445)
			-- return false
			--end
			if string.match(message, "%d+") then
				count[playerId] = getMoneyCount(message)
				if count[playerId] < 1 then
					npcHandler:say("You do not have enough gold.", npc, creature)
					npcHandler:setTopic(playerId, 1445)
					return false
				end
				npcHandler:say(
					"Would you really like to deposit " .. count[playerId] .. " gold to your {guild account}?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1642)
				return true
			else
				npcHandler:say("Please tell me how much gold it is you would like to deposit.", npc, creature)
				npcHandler:setTopic(playerId, 1641)
				return true
			end
		elseif npcHandler:getTopic(playerId) == 1641 then
			count[playerId] = getMoneyCount(message)
			if isValidMoney(count[playerId]) then
				npcHandler:say(
					"Would you really like to deposit " .. count[playerId] .. " gold to your {guild account}?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1642)
				return true
			else
				npcHandler:say("You do not have enough gold.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return true
			end
		elseif npcHandler:getTopic(playerId) == 1642 then
			--------------------------------guild bank-----------------------------------------------
			if MsgContains(message, "yes") then
				npcHandler:say(
					"Alright, we have placed an order to deposit the amount of " ..
						count[playerId] .. " gold to your guild account. Please check your inbox for confirmation.",
					npc,
					creature
				)
				local guild = player:getGuild()
				local info = {
					type = "Guild Deposit",
					amount = count[playerId],
					owner = player:getName() .. " of " .. guild:getName(),
					recipient = guild:getName()
				}
				local playerBalance = player:getBankBalance()
				if playerBalance < tonumber(count[playerId]) then
					info.message =
						"We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your bank account."
					info.success = false
				else
					info.message = "We are happy to inform you that your transfer request was successfully carried out."
					info.success = true
					guild:setBankBalance(guild:getBankBalance() + tonumber(count[playerId]))
					player:setBankBalance(playerBalance - tonumber(count[playerId]))
				end

				local inbox = player:getInbox()
				local receipt = GetReceipt(info)
				inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
			elseif MsgContains(message, "no") then
				npcHandler:say("As you wish. Is there something else I can do for you?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
			return true
		elseif MsgContains(message, "deposit") then
			if not isValidMoney(count[playerId]) then
				npcHandler:say("Sorry, but you can't deposit that much.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return false
			end
			count[playerId] = player:getMoney()
			if count[playerId] < 1 then
				npcHandler:say("You do not have enough gold.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return false
			end
			if MsgContains(message, "all") then
				count[playerId] = player:getMoney()
				npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
				npcHandler:setTopic(playerId, 1447)
				return true
			else
				if string.match(message, "%d+") then
					count[playerId] = getMoneyCount(message)
					if count[playerId] < 1 then
						npcHandler:say("You do not have enough gold.", npc, creature)
						npcHandler:setTopic(playerId, 1445)
						return false
					end
					npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
					npcHandler:setTopic(playerId, 1447)
					return true
				else
					npcHandler:say("Please tell me how much gold it is you would like to deposit.", npc, creature)
					npcHandler:setTopic(playerId, 1446)
					return true
				end
			end
		elseif npcHandler:getTopic(playerId) == 1446 then
			count[playerId] = getMoneyCount(message)
			if isValidMoney(count[playerId]) then
				npcHandler:say("Would you really like to deposit " .. count[playerId] .. " gold?", npc, creature)
				npcHandler:setTopic(playerId, 1447)
				return true
			else
				npcHandler:say("You do not have enough gold.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return true
			end
		elseif npcHandler:getTopic(playerId) == 1447 then
			---------------------------- withdraw --------------------
			--------------------------------guild bank-----------------------------------------------
			if MsgContains(message, "yes") then
				if player:depositMoney(count[playerId]) then
					npcHandler:say(
						"Alright, we have added the amount of " ..
							count[playerId] ..
								" gold to your {balance}. You can {withdraw} your money anytime you want to.",
						npc,
						creature
					)
				else
					npcHandler:say("You do not have enough gold.", npc, creature)
				end
			elseif MsgContains(message, "no") then
				npcHandler:say("As you wish. Is there something else I can do for you?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
			return true
		elseif MsgContains(message, "guild withdraw") then
			if not player:getGuild() then
				npcHandler:say("I am sorry but it seems you are currently not in any guild.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return false
			elseif player:getGuildLevel() < 2 then
				npcHandler:say(
					"Only guild leaders or vice leaders can withdraw money from the guild account.",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1445)
				return false
			end

			if string.match(message, "%d+") then
				count[playerId] = getMoneyCount(message)
				if isValidMoney(count[playerId]) then
					npcHandler:say(
						"Are you sure you wish to withdraw " .. count[playerId] .. " gold from your guild account?",
						npc,
						creature
					)
					npcHandler:setTopic(playerId, 1644)
				else
					npcHandler:say("There is not enough gold on your guild account.", npc, creature)
					npcHandler:setTopic(playerId, 1445)
				end
				return true
			else
				npcHandler:say(
					"Please tell me how much gold you would like to withdraw from your guild account.",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1643)
				return true
			end
		elseif npcHandler:getTopic(playerId) == 1643 then
			count[playerId] = getMoneyCount(message)
			if isValidMoney(count[playerId]) then
				npcHandler:say(
					"Are you sure you wish to withdraw " .. count[playerId] .. " gold from your guild account?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1644)
			else
				npcHandler:say("There is not enough gold on your guild account.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
			return true
		elseif npcHandler:getTopic(playerId) == 1644 then
			--------------------------------guild bank-----------------------------------------------
			if MsgContains(message, "yes") then
				local guild = player:getGuild()
				local balance = guild:getBankBalance()
				npcHandler:say(
					"We placed an order to withdraw " ..
						count[playerId] .. " gold from your guild account. Please check your inbox for confirmation.",
					npc,
					creature
				)
				local info = {
					type = "Guild Withdraw",
					amount = count[playerId],
					owner = player:getName() .. " of " .. guild:getName(),
					recipient = player:getName()
				}
				if balance < tonumber(count[playerId]) then
					info.message =
						"We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your guild account."
					info.success = false
				else
					info.message = "We are happy to inform you that your transfer request was successfully carried out."
					info.success = true
					guild:setBankBalance(balance - tonumber(count[playerId]))
					local playerBalance = player:getBankBalance()
					player:setBankBalance(playerBalance + tonumber(count[playerId]))
				end

				local inbox = player:getInbox()
				local receipt = GetReceipt(info)
				inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
				npcHandler:setTopic(playerId, 1445)
			elseif MsgContains(message, "no") then
				npcHandler:say("As you wish. Is there something else I can do for you?", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
			return true
		elseif MsgContains(message, "withdraw") then
			if string.match(message, "%d+") then
				count[playerId] = getMoneyCount(message)
				if isValidMoney(count[playerId]) then
					npcHandler:say(
						"Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?",
						npc,
						creature
					)
					npcHandler:setTopic(playerId, 1626)
				else
					npcHandler:say("There is not enough gold on your account.", npc, creature)
					npcHandler:setTopic(playerId, 1445)
				end
				return true
			else
				npcHandler:say("Please tell me how much gold you would like to withdraw.", npc, creature)
				npcHandler:setTopic(playerId, 1625)
				return true
			end
		elseif npcHandler:getTopic(playerId) == 1625 then
			count[playerId] = getMoneyCount(message)
			if isValidMoney(count[playerId]) then
				npcHandler:say(
					"Are you sure you wish to withdraw " .. count[playerId] .. " gold from your bank account?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1626)
			else
				npcHandler:say("There is not enough gold on your account.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
			return true
		elseif npcHandler:getTopic(playerId) == 1626 then
			---------------------------- transfer --------------------
			--------------------------------guild bank-----------------------------------------------
			if MsgContains(message, "yes") then
				if player:getFreeCapacity() >= getMoneyWeight(count[playerId]) then
					if not player:withdrawMoney(count[playerId]) then
						npcHandler:say("There is not enough gold on your account.", npc, creature)
					else
						npcHandler:say(
							"Here you are, " ..
								count[playerId] ..
									" gold. Please let me know if there is something else I can do for you.",
							npc,
							creature
						)
					end
				else
					npcHandler:say(
						"Whoah, hold on, you have no room in your inventory to carry all those coins. I don't want you to drop it on the floor, maybe come back with a cart!",
						npc,
						creature
					)
				end
				npcHandler:setTopic(playerId, 1445)
			elseif MsgContains(message, "no") then
				npcHandler:say(
					"The customer is king! Come back anytime you want to if you wish to {withdraw} your money.",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1445)
			end
			return true
		elseif MsgContains(message, "guild transfer") then
			if not player:getGuild() then
				npcHandler:say("I am sorry but it seems you are currently not in any guild.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return false
			elseif player:getGuildLevel() < 2 then
				npcHandler:say(
					"Only guild leaders or vice leaders can transfer money from the guild account.",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1445)
				return false
			end

			if string.match(message, "%d+") then
				count[playerId] = getMoneyCount(message)
				if isValidMoney(count[playerId]) then
					transfer[playerId] = string.match(message, "to%s*(.+)$")
					if transfer[playerId] then
						npcHandler:say(
							"So you would like to transfer " ..
								count[playerId] ..
									" gold from your guild account to guild " .. transfer[playerId] .. "?",
							npc,
							creature
						)
						npcHandler:setTopic(playerId, 1647)
					else
						npcHandler:say(
							"Which guild would you like to transfer " .. count[playerId] .. " gold to?",
							npc,
							creature
						)
						npcHandler:setTopic(playerId, 1646)
					end
				else
					npcHandler:say("There is not enough gold on your guild account.", npc, creature)
					npcHandler:setTopic(playerId, 1445)
				end
			else
				npcHandler:say("Please tell me the amount of gold you would like to transfer.", npc, creature)
				npcHandler:setTopic(playerId, 1645)
			end
			return true
		elseif npcHandler:getTopic(playerId) == 1645 then
			count[playerId] = getMoneyCount(message)
			if player:getGuild():getBankBalance() < count[playerId] then
				npcHandler:say("There is not enough gold on your guild account.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return true
			end
			if isValidMoney(count[playerId]) then
				npcHandler:say(
					"Which guild would you like to transfer " .. count[playerId] .. " gold to?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1646)
			else
				npcHandler:say("There is not enough gold on your account.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
			return true
		elseif npcHandler:getTopic(playerId) == 1646 then
			transfer[playerId] = message
			if player:getGuild():getName() == transfer[playerId] then
				npcHandler:say("Fill in this field with person who receives your gold!", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return true
			end
			npcHandler:say(
				"So you would like to transfer " ..
					count[playerId] .. " gold from your guild account to guild " .. transfer[playerId] .. "?",
				npc,
				creature
			)
			npcHandler:setTopic(playerId, 1647)
			return true
		elseif npcHandler:getTopic(playerId) == 1647 then
			--------------------------------guild bank-----------------------------------------------
			if MsgContains(message, "yes") then
				npcHandler:say(
					"We have placed an order to transfer " ..
						count[playerId] ..
							" gold from your guild account to guild " ..
								transfer[playerId] .. ". Please check your inbox for confirmation.",
					npc,
					creature
				)
				local guild = player:getGuild()
				local balance = guild:getBankBalance()
				local info = {
					type = "Guild to Guild Transfer",
					amount = count[playerId],
					owner = player:getName() .. " of " .. guild:getName(),
					recipient = transfer[playerId]
				}
				if balance < tonumber(count[playerId]) then
					info.message =
						"We are sorry to inform you that we could not fulfill your request, due to a lack of the required sum on your guild account."
					info.success = false
					local inbox = player:getInbox()
					local receipt = GetReceipt(info)
					inbox:addItemEx(receipt, INDEX_WHEREEVER, FLAG_NOLIMIT)
				else
					GetGuildIdByName(
						transfer[playerId],
						TransferFactory(player:getName(), tonumber(count[playerId]), guild:getId(), info)
					)
				end
				npcHandler:setTopic(playerId, 1445)
			elseif MsgContains(message, "no") then
				npcHandler:say("Alright, is there something else I can do for you?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
		elseif MsgContains(message, "transfer") then
			npcHandler:say("Please tell me the amount of gold you would like to transfer.", npc, creature)
			npcHandler:setTopic(playerId, 1630)
		elseif npcHandler:getTopic(playerId) == 1630 then
			count[playerId] = getMoneyCount(message)
			if player:getBankBalance() < count[playerId] then
				npcHandler:say("There is not enough gold on your account.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return true
			end
			if isValidMoney(count[playerId]) then
				npcHandler:say("Who would you like transfer " .. count[playerId] .. " gold to?", npc, creature)
				npcHandler:setTopic(playerId, 1631)
			else
				npcHandler:say("There is not enough gold on your account.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
		elseif npcHandler:getTopic(playerId) == 1631 then
			transfer[playerId] = message
			if player:getName() == transfer[playerId] then
				npcHandler:say("Fill in this field with person who receives your gold!", npc, creature)
				npcHandler:setTopic(playerId, 1445)
				return true
			end
			if playerExists(transfer[playerId]) then
				local arrayDenied = {
					"accountmanager",
					"rooksample",
					"druidsample",
					"sorcerersample",
					"knightsample",
					"paladinsample"
				}
				if isInArray(arrayDenied, string.gsub(transfer[playerId]:lower(), " ", "")) then
					npcHandler:say("This player does not exist.", npc, creature)
					npcHandler:setTopic(playerId, 1445)
					return true
				end
				npcHandler:say(
					"So you would like to transfer " .. count[playerId] .. " gold to " .. transfer[playerId] .. "?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1632)
			else
				npcHandler:say("This player does not exist.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
		elseif npcHandler:getTopic(playerId) == 1632 then
			---------------------------- money exchange --------------
			if MsgContains(message, "yes") then
				if not player:transferMoneyTo(transfer[playerId], count[playerId]) then
					npcHandler:say("You cannot transfer money to this account.", npc, creature)
				else
					npcHandler:say(
						"Very well. You have transferred " ..
							count[playerId] .. " gold to " .. transfer[playerId] .. ".",
						npc,
						creature
					)
					transfer[playerId] = nil
				end
			elseif MsgContains(message, "no") then
				npcHandler:say("Alright, is there something else I can do for you?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
		elseif MsgContains(message, "change gold") then
			npcHandler:say("How many platinum coins would you like to get?", npc, creature)
			npcHandler:setTopic(playerId, 1633)
		elseif npcHandler:getTopic(playerId) == 1633 then
			if getMoneyCount(message) < 1 then
				npcHandler:say("Sorry, you do not have enough gold coins.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			else
				count[playerId] = getMoneyCount(message)
				npcHandler:say(
					"So you would like me to change " ..
						count[playerId] * 100 .. " of your gold coins into " .. count[playerId] .. " platinum coins?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1634)
			end
		elseif npcHandler:getTopic(playerId) == 1634 then
			if MsgContains(message, "yes") then
				if player:removeItem(3031, count[playerId] * 100) then
					player:addItem(3035, count[playerId])
					npcHandler:say("Here you are.", npc, creature)
				else
					npcHandler:say("Sorry, you do not have enough gold coins.", npc, creature)
				end
			else
				npcHandler:say("Well, can I help you with something else?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
		elseif MsgContains(message, "change platinum") then
			npcHandler:say("Would you like to change your platinum coins into gold or crystal?", npc, creature)
			npcHandler:setTopic(playerId, 1635)
		elseif npcHandler:getTopic(playerId) == 1635 then
			if MsgContains(message, "gold") then
				npcHandler:say("How many platinum coins would you like to change into gold?", npc, creature)
				npcHandler:setTopic(playerId, 1636)
			elseif MsgContains(message, "crystal") then
				npcHandler:say("How many crystal coins would you like to get?", npc, creature)
				npcHandler:setTopic(playerId, 1638)
			else
				npcHandler:say("Well, can I help you with something else?", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			end
		elseif npcHandler:getTopic(playerId) == 1636 then
			if getMoneyCount(message) < 1 then
				npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			else
				count[playerId] = getMoneyCount(message)
				npcHandler:say(
					"So you would like me to change " ..
						count[playerId] ..
							" of your platinum coins into " .. count[playerId] * 100 .. " gold coins for you?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1637)
			end
		elseif npcHandler:getTopic(playerId) == 1637 then
			if MsgContains(message, "yes") then
				if player:removeItem(3035, count[playerId]) then
					player:addItem(3031, count[playerId] * 100)
					npcHandler:say("Here you are.", npc, creature)
				else
					npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
				end
			else
				npcHandler:say("Well, can I help you with something else?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
		elseif npcHandler:getTopic(playerId) == 1638 then
			if getMoneyCount(message) < 1 then
				npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			else
				count[playerId] = getMoneyCount(message)
				npcHandler:say(
					"So you would like me to change " ..
						count[playerId] * 100 ..
							" of your platinum coins into " .. count[playerId] .. " crystal coins for you?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1641)
			end
		elseif npcHandler:getTopic(playerId) == 1639 then
			if MsgContains(message, "yes") then
				if player:removeItem(3035, count[playerId] * 100) then
					player:addItem(3043, count[playerId])
					npcHandler:say("Here you are.", npc, creature)
				else
					npcHandler:say("Sorry, you do not have enough platinum coins.", npc, creature)
				end
			else
				npcHandler:say("Well, can I help you with something else?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
		elseif MsgContains(message, "change crystal") then
			npcHandler:say("How many crystal coins would you like to change into platinum?", npc, creature)
			npcHandler:setTopic(playerId, 1640)
		elseif npcHandler:getTopic(playerId) == 1640 then
			if getMoneyCount(message) < 1 then
				npcHandler:say("Sorry, you do not have enough crystal coins.", npc, creature)
				npcHandler:setTopic(playerId, 1445)
			else
				count[playerId] = getMoneyCount(message)
				npcHandler:say(
					"So you would like me to change " ..
						count[playerId] ..
							" of your crystal coins into " .. count[playerId] * 100 .. " platinum coins for you?",
					npc,
					creature
				)
				npcHandler:setTopic(playerId, 1641)
			end
		elseif npcHandler:getTopic(playerId) == 1641 then
			if MsgContains(message, "yes") then
				if player:removeItem(3043, count[playerId]) then
					player:addItem(3035, count[playerId] * 100)
					npcHandler:say("Here you are.", npc, creature)
				else
					npcHandler:say("Sorry, you do not have enough crystal coins.", npc, creature)
				end
			else
				npcHandler:say("Well, can I help you with something else?", npc, creature)
			end
			npcHandler:setTopic(playerId, 1445)
		elseif MsgContains(message, "money") then
			npcHandler:say("We can {change} money for you. You can also access your {bank account}.", npc, creature)
		elseif MsgContains(message, "change") then
			npcHandler:say(
				"There are three different coin types in Global Bank: 100 gold coins equal 1 platinum coin, 100 platinum coins equal 1 crystal coin. So if you'd like to change 100 gold into 1 platinum, simply say '{change gold}' and then '1 platinum'.",
				npc,
				creature
			)
		elseif MsgContains(message, "bank") then
			npcHandler:say("We can {change} money for you. You can also access your {bank account}.", npc, creature)
		elseif MsgContains(message, "advanced") then
			npcHandler:say(
				"Your bank account will be used automatically when you want to {rent} a house or place an offer on an item on the {market}. Let me know if you want to know about how either one works.",
				npc,
				creature
			)
		elseif MsgContains(message, "help") then
			npcHandler:say(
				"You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can also {transfer} money to other characters, provided that they have a vocation.",
				npc,
				creature
			)
		elseif MsgContains(message, "functions") then
			npcHandler:say(
				"You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can also {transfer} money to other characters, provided that they have a vocation.",
				npc,
				creature
			)
		elseif MsgContains(message, "basic") then
			npcHandler:say(
				"You can check the {balance} of your bank account, {deposit} money or {withdraw} it. You can also {transfer} money to other characters, provided that they have a vocation.",
				npc,
				creature
			)
		elseif MsgContains(message, "job") then
			npcHandler:say(
				"I work in this house. I can change money for you and help you with your bank account.",
				npc,
				creature
			)
		end
		return true
	end
	-- ======================[[ END BANKING FUNCTIONS ]] ======================== --
	--[[
	############################################################################
	############################################################################
	############################################################################
	]]
	-- ========================[[ COOKER FUNCTIONS ]] ========================== --

	local function getDeliveredMessageByFoodId(food_id) -- remove the hardcoded food ids
		local message = ""
		if food_id == 29408 then
			message = "Oh yes, a tasty roasted wings to make you even tougher and skilled with the defensive arts."
		elseif food_id == 29409 then
			message = "Divine! Carrot is a well known nourishment that makes the eyes see even more sharply."
		elseif food_id == 29410 then
			message = "Magnifique! A tiger meat that has been marinated for several hours in magic spices."
		elseif food_id == 29411 then
			message =
				"Aaah, the beauty of the simple dishes! A delicate salad made of selected ingredients, capable of bring joy to the hearts of bravest warriors and their weapons."
		elseif food_id == 29412 then
			message =
				"Oh yes, very spicy chilly combined with delicious minced carniphila meat and a side dish of fine salad!"
		elseif food_id == 29413 then
			message =
				"Aaah, the northern cuisine! A catch of fresh salmon right from the coast Svargrond is the base of this extraordinary fish dish."
		elseif food_id == 29414 then
			message = "A traditional and classy meal. A beefy casserole which smells far better than it sounds!"
		elseif food_id == 29415 then
			message = "A tasty chunk of juicy beef with an aromatic sauce and parsley potatoes, mmh!"
		elseif food_id == 29416 then
			message = "Oooh, well... that one didn't quite turn out as it was supposed to be, I'm sorry."
		end

		return message
	end

	local function deliverFood(npc, creature, food_id)
		local playerId = creature:getId()
		local player = Player(creature)
		local itType = ItemType(food_id)
		local inbox = player:getSlotItem(CONST_SLOT_STORE_INBOX)

		if player:getFreeCapacity() < itType:getWeight(1) then
			npcHandler:say("Sorry, but you don't have enough capacity.", npc, creature)
		elseif not inbox or inbox:getEmptySlots() == 0 then
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			npcHandler:say("Sorry, you don't have enough room on your inbox", npc, creature)
		elseif not player:removeMoneyBank(15000) then
			npcHandler:say("Sorry, you don't have enough money.", npc, creature)
		else
			local message = getDeliveredMessageByFoodId(food_id)
			npcHandler:say(message, npc, creature)
			inbox:addItem(food_id, 1, INDEX_WHEREEVER, FLAG_NOLIMIT)
		end
		npcHandler:setTopic(playerId, TOPIC.SERVICES)
	end

	local function cookFood(npc, creature)
		local playerId = creature:getId()
		local random = math.random(6)
		if random == 6 then
			-- ask for preferred skill
			npcHandler:setTopic(playerId, TOPIC_FOOD.SKILL_CHOOSE)
			npcHandler:say(
				"Yay! I have the ingredients to make a skill boost dish. Would you rather like to boost your {magic}, {melee}, {shielding} or {distance} skill?",
				npc,
				creature
			)
		else -- deliver the random generated index
			deliverFood(npc, creature, HIRELING_FOODS[random])
		end
	end

	local function handleFoodActions(npc, creature, message)
		local playerId = creature:getId()
		if npcHandler:getTopic(playerId) == TOPIC.FOOD then
			if MsgContains(message, "yes") then
				cookFood(npc, creature)
			elseif MsgContains(message, "no") then
				npcHandler:setTopic(playerId, TOPIC.SERVICES)
				npcHandler:say("Alright then, ask me for other {services}, if you want.", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) == TOPIC_FOOD.SKILL_CHOOSE then
			if MsgContains(message, "magic") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.MAGIC)
			elseif MsgContains(message, "melee") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.MELEE)
			elseif MsgContains(message, "shielding") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.SHIELDING)
			elseif MsgContains(message, "distance") then
				deliverFood(npc, creature, HIRELING_FOODS_BOOST.DISTANCE)
			else
				npcHandler:say(
					"Sorry, but you must choose a valid skill class. Would you like to boost your {magic}, {melee}, {shielding} or {distance} skill?",
					npc,
					creature
				)
			end
		end
	end

	-- ======================[[ END COOKER FUNCTIONS ]] ======================== --
	local function creatureSayCallback(npc, creature, type, message)
		local player = Player(creature)
		local playerId = player:getId()

		if not npcHandler:checkInteraction(npc, creature) then
			return false
		end

		if not hireling:canTalkTo(player) then
			return false
		end

		-- roleplay
		if MsgContains(message, "sword of fury") then
			npcHandler:say(
				"In my youth I dreamt to wield it! Now I wield the broom of... brooming. I guess that's the next best thing!",
				npc,
				creature
			)
		elseif MsgContains(message, "rookgaard") then
			npcHandler:say("What an uncivilised place without any culture.", npc, creature)
		elseif MsgContains(message, "excalibug") then
			-- end roleplay
			npcHandler:say("I'll keep an eye open for it when cleaning up the things you brought home!", npc, creature)
		elseif (MsgContains(message, "service")) then
			npcHandler:setTopic(playerId, TOPIC.SERVICES)
			local servicesMsg = getHirelingServiceString(creature)
			npcHandler:say(servicesMsg, npc, creature)
		elseif npcHandler:getTopic(playerId) == TOPIC.SERVICES then
			if MsgContains(message, "bank") then
				if hireling:hasSkill(HIRELING_SKILLS.BANKER) then
					npcHandler:setTopic(playerId, TOPIC.BANK)
					count[playerId], transfer[playerId] = nil, nil
					npcHandler:say(GREETINGS.BANK, npc, creature)
				else
					sendSkillNotLearned(npc, creature, HIRELING_SKILLS.BANKER)
				end
			elseif MsgContains(message, "food") then
				if hireling:hasSkill(HIRELING_SKILLS.COOKING) then
					npcHandler:setTopic(playerId, TOPIC.FOOD)
					npcHandler:say(GREETINGS.FOOD, npc, creature)
				else
					sendSkillNotLearned(npc, creature, HIRELING_SKILLS.COOKING)
				end
			elseif MsgContains(message, "stash") then
				if hireling:hasSkill(HIRELING_SKILLS.STEWARD) then
					npcHandler:say(GREETINGS.STASH, npc, creature)
					player:openStash(true)
				else
					sendSkillNotLearned(npc, creature, HIRELING_SKILLS.STEWARD)
				end
			elseif MsgContains(message, "goods") then
				npcHandler:say("I sell a selection of various items. Just ask {trade}!", npc, creature)
			elseif MsgContains(message, "lamp") then
				npcHandler:setTopic(playerId, TOPIC.LAMP)
				if player:getGuid() == hireling:getOwnerId() then
					npcHandler:say("Are you sure you want me to go back to my lamp?", npc, creature)
				else
					return false
				end
			elseif MsgContains(message, "outfit") then
				if player:getGuid() == hireling:getOwnerId() then
					hireling:requestOutfitChange()
					npcHandler:say("As you wish!", npc, creature)
				else
					return false
				end
			end
		elseif npcHandler:getTopic(playerId) == TOPIC.LAMP then
			if MsgContains(message, "yes") then
				hireling:returnToLamp(player:getGuid())
			else
				npcHandler:setTopic(playerId, TOPIC.SERVICES)
				npcHandler:say("Alright then, I will be here.", npc, creature)
			end
		elseif npcHandler:getTopic(playerId) >= TOPIC.BANK and npcHandler:getTopic(playerId) < TOPIC.FOOD then
			handleBankActions(npc, creature, message)
		elseif npcHandler:getTopic(playerId) >= TOPIC.FOOD and npcHandler:getTopic(playerId) < TOPIC.GOODS then
			handleFoodActions(npc, creature, message)
		end
		return true
	end

	npcHandler:setMessage(MESSAGE_GREET, "It is good to see you. I'm always at your {service}")
	npcHandler:setMessage(MESSAGE_FAREWELL, "Farewell, |PLAYERNAME|, I'll be here if you need me again.")
	npcHandler:setMessage(MESSAGE_WALKAWAY, "Come back soon!")

	npcHandler:setCallback(CALLBACK_MESSAGE_DEFAULT, creatureSayCallback)
	npcHandler:addModule(FocusModule:new(), npcConfig.name, true, true, true)

	-- npcType registering the npcConfig table
	npcType:register(npcConfig)
end

createHirelingType("Hireling")
