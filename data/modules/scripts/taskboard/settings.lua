return function(api)
	api.packet = {
		clientTaskboard = 0x5F,
		serverTaskboard = 0x5B,
		clientSoulpit = 0xBA,
		serverSoulpit = 0xBA,
		resourceBalance = 0xEE,
		serverClientEvent = 0x75,
	}

	api.clientEvent = {
		bountyTaskFinished = 11,
		weeklyTaskSpecificCreatureFinished = 12,
	}

	api.window = {
		bounty = 0x00,
		weekly = 0x01,
		shop = 0x02,
	}

	api.action = {
		openBounty = 0x00,
		openWeekly = 0x01,
		chooseBountyDifficulty = 0x02,
		rerollBounty = 0x03,
		claimDailyReroll = 0x04,
		selectBounty = 0x05,
		claimBounty = 0x06,
		upgradeTalisman = 0x07,
		deliverWeeklyItem = 0x08,
		chooseWeeklyDifficulty = 0x09,
		openShop = 0x0A,
		buyShopOffer = 0x0B,
		unlockPreference = 0x0C,
		clearPreferred = 0x0D,
		clearUnwanted = 0x0E,
		assignPreferred = 0x0F,
		assignUnwanted = 0x10,
	}

	api.difficulty = {
		beginner = 0,
		adept = 1,
		expert = 2,
		master = 3,
	}

	api.taskState = {
		notSelected = 0,
		selected = 1,
		completed = 2,
	}

	api.taskKind = {
		normal = 0,
		silver = 1,
		gold = 2,
	}

	api.offerKind = {
		item = 0,
		mount = 1,
		outfit = 2,
		decoration = 3,
		wheelBonus = 4,
	}

	api.offerState = {
		available = 0,
		notAvailable = 1,
		notEnoughPoints = 2,
		requiresBaseOutfit = 3,
		bought = 4,
	}

	api.rerollState = {
		available = 0,
		claimed = 1,
		limitReached = 2,
	}

	api.resource = {
		bountyPoints = 0x56,
		taskHuntingPoints = 0x32,
		soulseals = 0x57,
	}

	api.creatureIcon = {
		weeklyTaskMonster = 8,
		bountyTaskMonster = 9,
	}

	function api.toFiniteNumber(value, fallback)
		value = tonumber(value)
		if value == nil or value ~= value or value == math.huge or value == -math.huge then
			return fallback
		end
		return value
	end

	local function clamp(value, minimum, maximum)
		value = tonumber(value)
		if value == nil or value ~= value then
			return minimum
		end
		if value < minimum then
			return minimum
		end
		if value > maximum then
			return maximum
		end
		return math.floor(value)
	end

	api.clampByte = function(value)
		return clamp(value, 0, 0xFF)
	end

	api.clampU16 = function(value)
		return clamp(value, 0, 0xFFFF)
	end

	api.clampU32 = function(value)
		return clamp(value, 0, 0xFFFFFFFF)
	end

	api.config = {
		enabled = true,
		stateScope = "task-board",
		stateVersion = 1,
		preferenceSlots = 5,
		weeklyThirdSlotUnlocked = false,
		bounty = {
			slotCount = 3,
			maxDailyRerolls = 10,
			rerollCooldownSeconds = 24 * 60 * 60,
			goldTaskChance = 5,
			silverTaskChance = 10,
			preferredRaceChance = 15,
			unwantedRaceSkipChance = 15,
			preferenceClearCost = 10,
			preferenceUnlockBaseCost = 300,
		},
		upgrades = {
			maxLevel = 355,
			baseCost = 5,
			costPerLevel = 12,
		},
		wheel = {
			maximumMultiplier = 50,
		},
		talisman = {
			itemId = 51978,
			damageActivationChance = 15,
			lifeLeechActivationChance = 10,
		},
		weekly = {
			baseAnyCreatureKills = 1000,
			killSlots = 5,
			thirdSlotKillSlots = 8,
			itemSlots = 6,
			thirdSlotItemSlots = 9,
			killCompletionPoints = 25,
			itemCompletionPoints = 75,
			completionSeals = 1,
		},
		-- This is deliberately a small, local default catalog. Servers can extend
		-- it without changing packet writers or purchase logic.
		weeklyItems = {
			{ id = 2148, min = 50, max = 250 },
			{ id = 2671, min = 10, max = 40 },
			{ id = 2666, min = 10, max = 40 },
			{ id = 2681, min = 10, max = 40 },
			{ id = 2690, min = 10, max = 40 },
			{ id = 2667, min = 10, max = 40 },
			{ id = 2689, min = 10, max = 40 },
			{ id = 2675, min = 10, max = 40 },
			{ id = 2672, min = 10, max = 40 },
		},
		-- Only item and wheel offers are enabled by default so a fresh server does
		-- not promise mount/outfit ids that its own data pack may not contain.
		shopOffers = {
			{
				kind = 0,
				id = 2160,
				name = "crystal coin",
				description = "A compact reward for a successful hunt.",
				price = 100,
			},
		},
		soulpit = {
			authorizationSeconds = 10,
			-- Configure race ids when the server exposes a SoulPit engine adapter.
			raceIds = {},
		},
	}

	api.config.bounty.difficulties = {
		[api.difficulty.beginner] = {
			minimumLevel = 1,
			minimumStars = 2,
			maximumStars = 2,
			minimumKills = 50,
			maximumKills = 100,
			points = 3,
			experienceFactor = 15,
			weeklyKillMinimum = 10,
			weeklyKillMaximum = 30,
			weeklyItemMinimum = 5,
			weeklyItemMaximum = 15,
			weeklyKillCap = 200000,
		},
		[api.difficulty.adept] = {
			minimumLevel = 30,
			minimumStars = 2,
			maximumStars = 3,
			minimumKills = 100,
			maximumKills = 200,
			points = 7,
			experienceFactor = 97.5,
			weeklyKillMinimum = 30,
			weeklyKillMaximum = 60,
			weeklyItemMinimum = 15,
			weeklyItemMaximum = 30,
			weeklyKillCap = 800000,
		},
		[api.difficulty.expert] = {
			minimumLevel = 150,
			minimumStars = 3,
			maximumStars = 4,
			minimumKills = 200,
			maximumKills = 400,
			points = 16,
			experienceFactor = 510,
			weeklyKillMinimum = 50,
			weeklyKillMaximum = 80,
			weeklyItemMinimum = 30,
			weeklyItemMaximum = 50,
			weeklyKillCap = 3000000,
		},
		[api.difficulty.master] = {
			minimumLevel = 400,
			minimumStars = 4,
			maximumStars = 5,
			minimumKills = 300,
			maximumKills = 600,
			points = 27,
			experienceFactor = 1875,
			weeklyKillMinimum = 80,
			weeklyKillMaximum = 200,
			weeklyItemMinimum = 50,
			weeklyItemMaximum = 100,
			weeklyKillCap = 0,
		},
	}

	function api.isEnabled()
		return api.config.enabled == true
	end

	function api.isTaskboardEligible(player)
		if not player then
			return false
		end
		if type(player.getVocation) ~= "function" then
			return true
		end

		local vocationRead, vocation = pcall(player.getVocation, player)
		if not vocationRead or not vocation or type(vocation.getId) ~= "function" then
			return true
		end

		local idRead, vocationId = pcall(vocation.getId, vocation)
		if not idRead then
			return true
		end
		return tonumber(vocationId) ~= tonumber(rawget(_G, "VOCATION_NONE") or 0)
	end

	function api.getDifficultyForLevel(level)
		level = api.toFiniteNumber(level, 1)
		local selected = api.difficulty.beginner
		for difficulty, settings in pairs(api.config.bounty.difficulties) do
			if level >= settings.minimumLevel and difficulty > selected then
				selected = difficulty
			end
		end
		return selected
	end

	function api.normalizeDifficulty(value, fallback)
		value = api.toFiniteNumber(value)
		if value == nil or api.config.bounty.difficulties[value] == nil then
			return fallback or api.difficulty.beginner
		end
		return clamp(value, api.difficulty.beginner, api.difficulty.master)
	end

	function api.getUpgradeCost(level)
		level = clamp(level, 0, api.config.upgrades.maxLevel)
		return api.clampU16(api.config.upgrades.baseCost + (level * api.config.upgrades.costPerLevel))
	end

	function api.getWheelPrice(multiplier)
		multiplier = clamp(multiplier, 1, api.config.wheel.maximumMultiplier)
		return api.clampU32((50 * multiplier * multiplier) - (50 * multiplier) + 100)
	end

	function api.getShopOfferCount()
		local offers = api.config.shopOffers
		if type(offers) ~= "table" then
			return 0
		end
		-- One byte carries the total count and the Wheel offer is always last.
		return math.min(#offers, 0xFE)
	end

	function api.getShopOfferPrice(offer)
		if type(offer) ~= "table" then
			return nil
		end
		local price = tonumber(offer.price)
		if not price or price ~= price or price % 1 ~= 0 or price < 0 or price > 0xFFFFFFFF then
			return nil
		end
		return price
	end

	local function outfitLookType(value)
		value = tonumber(value)
		if not value or value % 1 ~= 0 or value <= 0 or value > 0xFFFF then
			return nil
		end
		return value
	end

	function api.getOutfitOfferData(offer)
		if type(offer) ~= "table" then
			return nil
		end
		local addon = tonumber(offer.addon) or 0
		if addon ~= addon or addon % 1 ~= 0 or addon < 0 or addon > 2 then
			return nil
		end

		local value = offer.lookType or offer.outfitId
		local male
		local female
		if type(value) == "table" then
			male = outfitLookType(value.male)
			female = outfitLookType(value.female)
		else
			male = outfitLookType(value)
			female = male
		end
		if not male or not female then
			return nil
		end

		return {
			male = male,
			female = female,
			addon = addon,
			key = tostring(male) .. "-" .. tostring(female),
		}
	end

	function api.getOutfitLookType(player, offer)
		local outfit = api.getOutfitOfferData(offer)
		if not outfit then
			return nil
		end
		local femaleSex = rawget(_G, "PLAYERSEX_FEMALE")
		if femaleSex ~= nil and player and type(player.getSex) == "function" and player:getSex() == femaleSex then
			return outfit.female
		end
		return outfit.male
	end

	function api.getWeeklyResetTimestamp(now)
		now = math.floor(api.toFiniteNumber(now, os.time()))
		local date = os.date("*t", now)
		local daysUntilMonday = (2 - date.wday) % 7

		local hour, minute = 0, 0
		local runtimeConfig = rawget(_G, "configManager")
		local runtimeKeys = rawget(_G, "configKeys")
		if type(runtimeConfig) == "table" and type(runtimeConfig.getString) == "function" and type(runtimeKeys) == "table" and runtimeKeys.GLOBAL_SERVER_SAVE_TIME ~= nil then
			local ok, configuredTime = pcall(runtimeConfig.getString, runtimeKeys.GLOBAL_SERVER_SAVE_TIME)
			local configuredHour, configuredMinute
			if ok then
				configuredHour, configuredMinute = tostring(configuredTime):match("^(%d%d?):(%d%d?):%d%d$")
			end
			if configuredHour then
				configuredHour = tonumber(configuredHour)
				configuredMinute = tonumber(configuredMinute)
				if configuredHour and configuredHour >= 0 and configuredHour <= 23 and configuredMinute and configuredMinute >= 0 and configuredMinute <= 59 then
					hour, minute = configuredHour, configuredMinute
				end
			end
		end
		local reset = os.time({
			year = date.year,
			month = date.month,
			day = date.day + daysUntilMonday,
			hour = hour,
			min = minute,
			sec = 0,
		})
		if reset <= now then
			reset = os.time({
				year = date.year,
				month = date.month,
				day = date.day + daysUntilMonday + 7,
				hour = hour,
				min = minute,
				sec = 0,
			})
		end
		return math.max(now + 1, reset)
	end

	function api.usesWeeklySoulsealsTail(player)
		local client = player and player:getClient()
		local versionString = client and client.versionString
		local known1520Build = "15.20.f23bc3"
		if type(versionString) == "string" then
			local normalizedVersion = versionString:lower()
			if normalizedVersion:sub(1, #known1520Build) == known1520Build then
				return true
			end

			local major, minor = normalizedVersion:match("^(%d+)%.(%d+)")
			major = tonumber(major)
			minor = tonumber(minor)
			if major and minor then
				return major > 15 or (major == 15 and minor >= 21)
			end
		end

		local numericVersion = math.floor(api.toFiniteNumber(client and client.version, 0))
		return numericVersion >= 1521
	end

	function api.supportsOfficialTaskboard(player)
		local client = player and player:getClient()
		local numericVersion = tonumber(client and client.version) or 0
		if numericVersion >= 1520 then
			return true
		end
		local versionString = client and client.versionString
		return type(versionString) == "string" and versionString:match("^15%.20%.") ~= nil
	end
end
