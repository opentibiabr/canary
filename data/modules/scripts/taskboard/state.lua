return function(api)
	local stateApi = {}
	api.state = stateApi

	local function integer(value, fallback, maximum)
		value = api.toFiniteNumber(value)
		if value == nil then
			return fallback or 0
		end
		value = math.max(0, math.floor(value))
		if maximum then
			value = math.min(value, maximum)
		end
		return value
	end

	local function boolean(value)
		return value == true or value == 1
	end

	local function read(scope, key, fallback)
		local value = scope:get(key)
		if value == nil then
			return fallback
		end
		return value
	end

	local function newPreferences()
		local preferences = {}
		for index = 1, api.config.preferenceSlots do
			preferences[index] = {
				unlocked = index == 1,
				preferredRace = 0,
				unwantedRace = 0,
			}
		end
		return preferences
	end

	local function newWeekly(difficulty)
		return {
			difficulty = difficulty,
			selectionPending = true,
			anyCreature = {
				required = 0,
				current = 0,
				completed = false,
			},
			kills = {},
			items = {},
			killsCompleted = 0,
			itemsCompleted = 0,
			points = 0,
			soulseals = 0,
			killExperience = 0,
			itemExperience = 0,
		}
	end

	local function eachOutfitOffer(callback)
		local seen = {}
		for index = 1, api.getShopOfferCount() do
			local offer = api.config.shopOffers[index]
			if offer.kind == api.offerKind.outfit then
				local outfit = api.getOutfitOfferData(offer)
				if outfit and not seen[outfit.key] then
					seen[outfit.key] = true
					callback(outfit)
				end
			end
		end
	end

	local function freshState(player)
		local level = player and type(player.getLevel) == "function" and player:getLevel() or 1
		local difficulty = api.getDifficultyForLevel(level)
		return {
			meta = {
				version = api.config.stateVersion,
				nextWeeklyReset = 0,
			},
			general = {
				bountyPoints = 0,
				soulseals = 0,
				thirdSlotUnlocked = api.config.weeklyThirdSlotUnlocked == true,
				shopOutfits = {},
			},
			bounty = {
				difficulty = difficulty,
				dailyRerolls = 0,
				lastRerollClaim = 0,
				tasks = {},
				preferences = newPreferences(),
			},
			weekly = newWeekly(difficulty),
			upgrades = {
				damage = 0,
				lifeLeech = 0,
				moreLoot = 0,
				doubleBestiary = 0,
			},
			wheel = {
				multiplier = 1,
				price = 100,
			},
		}
	end

	local function loadTask(taskScope)
		local raceId = integer(read(taskScope, "race-id", 0), 0, 0xFFFF)
		if raceId <= 0 then
			return nil
		end
		return {
			raceId = raceId,
			required = integer(read(taskScope, "required", 0), 0, 0xFFFF),
			experience = integer(read(taskScope, "experience", 0), 0, 0xFFFFFFFF),
			bountyPoints = integer(read(taskScope, "bounty-points", 0), 0, 0xFF),
			current = integer(read(taskScope, "current", 0), 0, 0xFFFF),
			state = integer(read(taskScope, "state", api.taskState.notSelected), api.taskState.notSelected, api.taskState.completed),
			marker = integer(read(taskScope, "marker", api.taskKind.normal), api.taskKind.normal, api.taskKind.gold),
		}
	end

	local function normalizeBounty(state, malformedTask)
		local options = {}
		local activeTask
		local rejectedTask = malformedTask == true
		local usedRaceIds = {}
		for _, task in ipairs(state.bounty.tasks) do
			local raceId = integer(task.raceId, 0, 0xFFFF)
			local required = integer(task.required, 0, 0xFFFF)
			if raceId == 0 or required == 0 or usedRaceIds[raceId] or not api.catalog.isValidRace(raceId) then
				rejectedTask = true
			else
				usedRaceIds[raceId] = true
				local taskState = integer(task.state, api.taskState.notSelected, api.taskState.completed)
				local current = integer(task.current, 0, required)
				if taskState == api.taskState.notSelected then
					current = 0
				elseif taskState == api.taskState.completed or current >= required then
					taskState = api.taskState.completed
					current = required
				end

				local normalized = {
					raceId = raceId,
					required = required,
					experience = integer(task.experience, 0, 0xFFFFFFFF),
					bountyPoints = integer(task.bountyPoints, 0, 0xFF),
					current = current,
					state = taskState,
					marker = integer(task.marker, api.taskKind.normal, api.taskKind.gold),
				}
				if taskState == api.taskState.notSelected then
					table.insert(options, normalized)
				elseif not activeTask then
					activeTask = normalized
				else
					rejectedTask = true
				end
			end
		end

		if activeTask then
			state.bounty.tasks = { activeTask }
		elseif rejectedTask then
			state.bounty.tasks = {}
		else
			state.bounty.tasks = options
		end

		for index, preference in ipairs(state.bounty.preferences) do
			preference.unlocked = index == 1 or preference.unlocked == true
			if not preference.unlocked then
				preference.preferredRace = 0
				preference.unwantedRace = 0
			else
				if not api.catalog.isValidRace(preference.preferredRace) then
					preference.preferredRace = 0
				end
				if not api.catalog.isValidRace(preference.unwantedRace) then
					preference.unwantedRace = 0
				end
			end
		end
	end

	local function normalizeWeeklyProgress(required, current, completed)
		required = integer(required, 0, 0xFFFFFFFF)
		if required == 0 then
			return nil
		end

		current = integer(current, 0, required)
		completed = boolean(completed) or current >= required
		return required, completed and required or current, completed
	end

	local function normalizeWeekly(state)
		local weekly = state.weekly
		if weekly.selectionPending then
			weekly.anyCreature = { required = 0, current = 0, completed = false }
			weekly.kills = {}
			weekly.items = {}
			weekly.killsCompleted = 0
			weekly.itemsCompleted = 0
			weekly.points = 0
			weekly.soulseals = 0
			return
		end

		local anyRequired = integer(weekly.anyCreature.required, 0, 0xFFFF)
		if anyRequired == 0 then
			anyRequired = api.clampU16((weekly.difficulty + 1) * api.config.weekly.baseAnyCreatureKills)
		end
		local anyCurrent = integer(weekly.anyCreature.current, 0, anyRequired)
		local anyCompleted = boolean(weekly.anyCreature.completed) or anyCurrent >= anyRequired
		weekly.anyCreature = {
			required = anyRequired,
			current = anyCompleted and anyRequired or anyCurrent,
			completed = anyCompleted,
		}

		local killLimit = state.general.thirdSlotUnlocked and api.config.weekly.thirdSlotKillSlots or api.config.weekly.killSlots
		local normalizedKills = {}
		local usedRaceIds = {}
		for _, task in ipairs(weekly.kills) do
			local raceId = integer(task.raceId, 0, 0xFFFF)
			local required, current, completed = normalizeWeeklyProgress(task.required, task.current, task.completed)
			if #normalizedKills < killLimit and raceId > 0 and required and not usedRaceIds[raceId] and api.catalog.isValidRace(raceId) then
				usedRaceIds[raceId] = true
				table.insert(normalizedKills, {
					raceId = raceId,
					required = api.clampU16(required),
					current = api.clampU16(current),
					completed = completed,
				})
			end
		end
		weekly.kills = normalizedKills

		local validItemIds = {}
		for _, item in ipairs(api.catalog.getWeeklyItems()) do
			local itemId = integer(item.id, 0, 0xFFFFFFFF)
			if itemId > 0 then
				validItemIds[itemId] = true
			end
		end

		local itemLimit = state.general.thirdSlotUnlocked and api.config.weekly.thirdSlotItemSlots or api.config.weekly.itemSlots
		local normalizedItems = {}
		for _, item in ipairs(weekly.items) do
			local itemId = integer(item.itemId, 0, 0xFFFFFFFF)
			local required, current, completed = normalizeWeeklyProgress(item.required, item.current, item.completed)
			if #normalizedItems < itemLimit and validItemIds[itemId] and required then
				table.insert(normalizedItems, {
					index = #normalizedItems,
					itemId = itemId,
					required = required,
					current = current,
					completed = completed,
				})
			end
		end
		weekly.items = normalizedItems

		local killsCompleted = weekly.anyCreature.completed and 1 or 0
		for _, task in ipairs(weekly.kills) do
			if task.completed then
				killsCompleted = killsCompleted + 1
			end
		end
		local itemsCompleted = 0
		for _, item in ipairs(weekly.items) do
			if item.completed then
				itemsCompleted = itemsCompleted + 1
			end
		end

		weekly.killsCompleted = killsCompleted
		weekly.itemsCompleted = itemsCompleted
		weekly.points = api.clampU32((killsCompleted * api.config.weekly.killCompletionPoints) + (itemsCompleted * api.config.weekly.itemCompletionPoints))
		weekly.soulseals = api.clampU32((killsCompleted + itemsCompleted) * api.config.weekly.completionSeals)
	end

	local function loadState(player)
		local state = freshState(player)
		if not player or type(player.kv) ~= "function" then
			return state
		end

		local root = player:kv():scoped(api.config.stateScope)
		local meta = root:scoped("meta")
		state.meta.version = integer(read(meta, "version", state.meta.version), state.meta.version)
		state.meta.nextWeeklyReset = integer(read(meta, "next-weekly-reset", 0), 0)

		local general = root:scoped("general")
		state.general.bountyPoints = integer(read(general, "bounty-points", 0), 0, 0xFFFFFFFF)
		state.general.soulseals = integer(read(general, "soulseals", 0), 0, 0xFFFFFFFF)
		state.general.thirdSlotUnlocked = boolean(read(general, "third-slot-unlocked", state.general.thirdSlotUnlocked))
		if type(player.taskHuntingThirdSlot) == "function" then
			local ok, unlocked = pcall(player.taskHuntingThirdSlot, player)
			if ok and unlocked then
				state.general.thirdSlotUnlocked = true
			end
		end
		local shopOutfits = root:scoped("shop-outfits")
		eachOutfitOffer(function(outfit)
			local ownership = shopOutfits:scoped(outfit.key)
			state.general.shopOutfits[outfit.key] = {
				base = boolean(read(ownership, "base", false)),
				addon1 = boolean(read(ownership, "addon-1", false)),
				addon2 = boolean(read(ownership, "addon-2", false)),
			}
		end)

		local bounty = root:scoped("bounty")
		state.bounty.difficulty = api.normalizeDifficulty(read(bounty, "difficulty", state.bounty.difficulty), state.bounty.difficulty)
		state.bounty.dailyRerolls = integer(read(bounty, "daily-rerolls", 0), 0, api.config.bounty.maxDailyRerolls)
		state.bounty.lastRerollClaim = integer(read(bounty, "last-reroll-claim", 0), 0)
		local taskCount = integer(read(bounty, "task-count", 0), 0, api.config.bounty.slotCount)
		state.bounty.tasks = {}
		local malformedBountyTask = false
		for index = 0, taskCount - 1 do
			local task = loadTask(bounty:scoped("task-" .. index))
			if task then
				table.insert(state.bounty.tasks, task)
			else
				malformedBountyTask = true
			end
		end
		state.bounty.preferences = {}
		for index = 1, api.config.preferenceSlots do
			local preference = bounty:scoped("preference-" .. index)
			state.bounty.preferences[index] = {
				unlocked = boolean(read(preference, "unlocked", index == 1)),
				preferredRace = integer(read(preference, "preferred-race", 0), 0, 0xFFFF),
				unwantedRace = integer(read(preference, "unwanted-race", 0), 0, 0xFFFF),
			}
		end

		local weekly = root:scoped("weekly")
		state.weekly.difficulty = api.normalizeDifficulty(read(weekly, "difficulty", state.weekly.difficulty), state.weekly.difficulty)
		state.weekly.selectionPending = boolean(read(weekly, "selection-pending", true))
		state.weekly.killsCompleted = integer(read(weekly, "kills-completed", 0), 0, 0xFF)
		state.weekly.itemsCompleted = integer(read(weekly, "items-completed", 0), 0, 0xFF)
		state.weekly.points = integer(read(weekly, "points", 0), 0, 0xFFFFFFFF)
		state.weekly.soulseals = integer(read(weekly, "soulseals", 0), 0, 0xFFFFFFFF)
		state.weekly.killExperience = integer(read(weekly, "kill-experience", 0), 0, 0xFFFFFFFF)
		state.weekly.itemExperience = integer(read(weekly, "item-experience", 0), 0, 0xFFFFFFFF)

		local anyCreature = weekly:scoped("any-creature")
		state.weekly.anyCreature = {
			required = integer(read(anyCreature, "required", 0), 0, 0xFFFF),
			current = integer(read(anyCreature, "current", 0), 0, 0xFFFF),
			completed = boolean(read(anyCreature, "completed", false)),
		}

		state.weekly.kills = {}
		local killCount = integer(read(weekly, "kill-count", 0), 0, api.config.weekly.thirdSlotKillSlots)
		for index = 0, killCount - 1 do
			local task = loadTask(weekly:scoped("kill-" .. index))
			if task then
				table.insert(state.weekly.kills, {
					raceId = task.raceId,
					required = task.required,
					current = task.current,
					completed = task.state == api.taskState.completed,
				})
			end
		end

		state.weekly.items = {}
		local itemCount = integer(read(weekly, "item-count", 0), 0, api.config.weekly.thirdSlotItemSlots)
		for index = 0, itemCount - 1 do
			local item = weekly:scoped("item-" .. index)
			table.insert(state.weekly.items, {
				index = index,
				itemId = integer(read(item, "item-id", 0), 0, 0xFFFFFFFF),
				required = integer(read(item, "required", 0), 0, 0xFFFFFFFF),
				current = integer(read(item, "current", 0), 0, 0xFFFFFFFF),
				completed = boolean(read(item, "completed", false)),
			})
		end

		local upgrades = root:scoped("upgrades")
		state.upgrades.damage = integer(read(upgrades, "damage", 0), 0, api.config.upgrades.maxLevel)
		state.upgrades.lifeLeech = integer(read(upgrades, "life-leech", 0), 0, api.config.upgrades.maxLevel)
		state.upgrades.moreLoot = integer(read(upgrades, "more-loot", 0), 0, api.config.upgrades.maxLevel)
		state.upgrades.doubleBestiary = integer(read(upgrades, "double-bestiary", 0), 0, api.config.upgrades.maxLevel)

		local wheel = root:scoped("wheel")
		state.wheel.multiplier = math.max(1, integer(read(wheel, "multiplier", 1), 1, api.config.wheel.maximumMultiplier))
		state.wheel.price = api.getWheelPrice(state.wheel.multiplier)
		normalizeBounty(state, malformedBountyTask)
		normalizeWeekly(state)
		return state
	end

	local function saveTask(taskScope, task)
		taskScope:set("race-id", api.clampU16(task.raceId))
		taskScope:set("required", api.clampU16(task.required))
		taskScope:set("experience", api.clampU32(task.experience))
		taskScope:set("bounty-points", api.clampByte(task.bountyPoints))
		taskScope:set("current", api.clampU16(task.current))
		taskScope:set("state", api.clampByte(task.state))
		taskScope:set("marker", api.clampByte(task.marker))
	end

	function stateApi.save(player, state)
		if not player or type(player.kv) ~= "function" then
			return false
		end

		local root = player:kv():scoped(api.config.stateScope)
		local meta = root:scoped("meta")
		meta:set("version", api.config.stateVersion)
		meta:set("next-weekly-reset", integer(state.meta.nextWeeklyReset, 0))

		local general = root:scoped("general")
		general:set("bounty-points", api.clampU32(state.general.bountyPoints))
		general:set("soulseals", api.clampU32(state.general.soulseals))
		general:set("third-slot-unlocked", state.general.thirdSlotUnlocked == true)
		local shopOutfits = root:scoped("shop-outfits")
		eachOutfitOffer(function(outfit)
			local ownership = (state.general.shopOutfits or {})[outfit.key] or {}
			local ownershipScope = shopOutfits:scoped(outfit.key)
			ownershipScope:set("base", ownership.base == true)
			ownershipScope:set("addon-1", ownership.addon1 == true)
			ownershipScope:set("addon-2", ownership.addon2 == true)
		end)

		local bounty = root:scoped("bounty")
		bounty:set("difficulty", api.clampByte(state.bounty.difficulty))
		bounty:set("daily-rerolls", api.clampByte(state.bounty.dailyRerolls))
		bounty:set("last-reroll-claim", integer(state.bounty.lastRerollClaim, 0))
		bounty:set("task-count", math.min(#state.bounty.tasks, api.config.bounty.slotCount))
		for index, task in ipairs(state.bounty.tasks) do
			saveTask(bounty:scoped("task-" .. (index - 1)), task)
		end
		for index = 1, api.config.preferenceSlots do
			local preference = state.bounty.preferences[index] or {}
			local preferenceScope = bounty:scoped("preference-" .. index)
			preferenceScope:set("unlocked", preference.unlocked == true)
			preferenceScope:set("preferred-race", api.clampU16(preference.preferredRace))
			preferenceScope:set("unwanted-race", api.clampU16(preference.unwantedRace))
		end

		local weekly = root:scoped("weekly")
		weekly:set("difficulty", api.clampByte(state.weekly.difficulty))
		weekly:set("selection-pending", state.weekly.selectionPending == true)
		weekly:set("kills-completed", api.clampByte(state.weekly.killsCompleted))
		weekly:set("items-completed", api.clampByte(state.weekly.itemsCompleted))
		weekly:set("points", api.clampU32(state.weekly.points))
		weekly:set("soulseals", api.clampU32(state.weekly.soulseals))
		weekly:set("kill-experience", api.clampU32(state.weekly.killExperience))
		weekly:set("item-experience", api.clampU32(state.weekly.itemExperience))
		local anyCreature = weekly:scoped("any-creature")
		anyCreature:set("required", api.clampU16(state.weekly.anyCreature.required))
		anyCreature:set("current", api.clampU16(state.weekly.anyCreature.current))
		anyCreature:set("completed", state.weekly.anyCreature.completed == true)
		weekly:set("kill-count", #state.weekly.kills)
		for index, task in ipairs(state.weekly.kills) do
			saveTask(weekly:scoped("kill-" .. (index - 1)), {
				raceId = task.raceId,
				required = task.required,
				experience = 0,
				bountyPoints = 0,
				current = task.current,
				state = task.completed and api.taskState.completed or api.taskState.selected,
				marker = api.taskKind.normal,
			})
		end
		weekly:set("item-count", #state.weekly.items)
		for index, item in ipairs(state.weekly.items) do
			local itemScope = weekly:scoped("item-" .. (index - 1))
			itemScope:set("item-id", api.clampU32(item.itemId))
			itemScope:set("required", api.clampU32(item.required))
			itemScope:set("current", api.clampU32(item.current))
			itemScope:set("completed", item.completed == true)
		end

		local upgrades = root:scoped("upgrades")
		upgrades:set("damage", api.clampU16(state.upgrades.damage))
		upgrades:set("life-leech", api.clampU16(state.upgrades.lifeLeech))
		upgrades:set("more-loot", api.clampU16(state.upgrades.moreLoot))
		upgrades:set("double-bestiary", api.clampU16(state.upgrades.doubleBestiary))

		local wheel = root:scoped("wheel")
		state.wheel.multiplier = math.max(1, integer(state.wheel.multiplier, 1, api.config.wheel.maximumMultiplier))
		state.wheel.price = api.getWheelPrice(state.wheel.multiplier)
		wheel:set("multiplier", state.wheel.multiplier)
		wheel:set("price", state.wheel.price)
		return true
	end

	function stateApi.load(player)
		return loadState(player)
	end

	function stateApi.ensure(player)
		local state = loadState(player)
		local now = os.time()
		if state.meta.nextWeeklyReset <= 0 then
			state.meta.nextWeeklyReset = api.getWeeklyResetTimestamp(now)
		elseif now >= state.meta.nextWeeklyReset then
			if not state.weekly.selectionPending and api.rules and api.rules.finalizeWeekly then
				api.rules.finalizeWeekly(player, state)
			end
			state.weekly = newWeekly(state.weekly.difficulty)
			state.meta.nextWeeklyReset = api.getWeeklyResetTimestamp(now)
		end

		if api.rules then
			api.rules.ensureBounty(player, state)
			api.rules.ensureWeekly(player, state)
		end
		stateApi.save(player, state)
		return state
	end
end
