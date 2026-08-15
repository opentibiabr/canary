return function(api)
	local rules = {}
	api.rules = rules

	local function randomBetween(minimum, maximum)
		minimum = math.floor(api.toFiniteNumber(minimum, 0))
		maximum = math.max(minimum, math.floor(api.toFiniteNumber(maximum, minimum)))
		return math.random(minimum, maximum)
	end

	local function percentage(value, maximum)
		return math.min(maximum or 100, api.clampByte(api.toFiniteNumber(value, 0)))
	end

	local function difficultySettings(difficulty)
		return api.config.bounty.difficulties[api.normalizeDifficulty(difficulty, api.difficulty.beginner)]
	end

	local function playerLevel(player)
		if player and type(player.getLevel) == "function" then
			return math.max(1, math.floor(api.toFiniteNumber(player:getLevel(), 1)))
		end
		return 1
	end

	local function taskMultiplier(kind)
		if kind == api.taskKind.gold then
			return 4
		end
		if kind == api.taskKind.silver then
			return 2
		end
		return 1
	end

	local function talismanPercent(level)
		level = math.max(0, api.toFiniteNumber(level, 0))
		if level <= 15 then
			return 2.5 + (level * 0.5)
		end
		local secondStage = level - 15
		if secondStage <= 40 then
			return 10 + (secondStage * 0.25)
		end
		return 20 + ((secondStage - 40) * 0.1)
	end

	local function talismanDoubleBestiaryChance(level)
		level = math.max(0, api.toFiniteNumber(level, 0))
		if level <= 15 then
			return 5 + level
		end
		local secondStage = level - 15
		if secondStage <= 40 then
			return 20 + (secondStage * 0.5)
		end
		return 40 + ((secondStage - 40) * 0.2)
	end

	local function bestiaryKillAmount(player)
		local amount = 1
		local runtimeConfig = rawget(_G, "configManager")
		local runtimeKeys = rawget(_G, "configKeys")
		if type(runtimeConfig) == "table" and type(runtimeConfig.getNumber) == "function" and type(runtimeKeys) == "table" and runtimeKeys.BESTIARY_KILL_MULTIPLIER ~= nil then
			local ok, configuredAmount = pcall(runtimeConfig.getNumber, runtimeKeys.BESTIARY_KILL_MULTIPLIER)
			if ok then
				amount = math.max(1, math.floor(api.toFiniteNumber(configuredAmount, 1)))
			end
		end

		local runtimeKv = rawget(_G, "KV")
		if type(runtimeKv) == "table" and type(runtimeKv.scoped) == "function" then
			local ok, enabled = pcall(function()
				return runtimeKv.scoped("eventscheduler"):get("double-bestiary")
			end)
			if ok and enabled == true then
				amount = amount * 2
			end
		end

		local runtimeConcoction = rawget(_G, "Concoction")
		if type(runtimeConcoction) == "table" and type(runtimeConcoction.find) == "function" and type(runtimeConcoction.Ids) == "table" then
			local found, concoction = pcall(runtimeConcoction.find, runtimeConcoction.Ids.BestiaryBetterment)
			if found and concoction and type(concoction.active) == "function" then
				local ok, active = pcall(concoction.active, concoction, player)
				if ok and active == true then
					amount = amount * 2
				end
			end
		end
		return math.min(0xFFFFFFFF, amount)
	end

	local function hasEquippedTalisman(player)
		if not player or type(player.getSlotItem) ~= "function" then
			return false
		end
		local ammoSlot = rawget(_G, "CONST_SLOT_AMMO")
		if ammoSlot == nil then
			return false
		end
		local item = player:getSlotItem(ammoSlot)
		return item ~= nil and type(item.getId) == "function" and tonumber(item:getId()) == tonumber(api.config.talisman.itemId)
	end

	local function activeBountyTask(player, raceId)
		if not api.isEnabled() or not api.isTaskboardEligible(player) then
			return nil, nil
		end
		local state = api.state.load(player)
		local task = state.bounty.tasks[1]
		if not task or task.state ~= api.taskState.selected or task.raceId ~= raceId or task.current >= task.required then
			return nil, state
		end
		return task, state
	end

	local function randomTaskKind()
		local goldChance = percentage(api.config.bounty.goldTaskChance)
		local silverChance = percentage(api.config.bounty.silverTaskChance, 100 - goldChance)
		local roll = math.random(1, 100)
		if roll <= goldChance then
			return api.taskKind.gold
		end
		if roll <= goldChance + silverChance then
			return api.taskKind.silver
		end
		return api.taskKind.normal
	end

	local function bountyPreferences(state)
		local preferred = {}
		local unwanted = {}
		for _, preference in ipairs(state.bounty.preferences or {}) do
			if preference.unlocked then
				local preferredRace = tonumber(preference.preferredRace) or 0
				local unwantedRace = tonumber(preference.unwantedRace) or 0
				if preferredRace > 0 then
					table.insert(preferred, preferredRace)
				end
				if unwantedRace > 0 then
					unwanted[unwantedRace] = true
				end
			end
		end
		return preferred, unwanted
	end

	local function selectBountyEntries(state, difficulty, amount)
		local preferred, unwanted = bountyPreferences(state)
		local unwantedChance = percentage(api.config.bounty.unwantedRaceSkipChance)
		local pool = api.catalog.getPool(difficulty)
		local candidates = {}
		for _, entry in ipairs(pool) do
			if not unwanted[entry.raceId] or math.random(1, 100) > unwantedChance then
				table.insert(candidates, entry)
			end
		end
		if #candidates == 0 then
			for _, entry in ipairs(pool) do
				table.insert(candidates, entry)
			end
		end

		local availableByRaceId = {}
		for _, entry in ipairs(candidates) do
			availableByRaceId[entry.raceId] = true
		end
		local preferredChance = percentage(api.config.bounty.preferredRaceChance)
		local selected = {}
		amount = math.max(0, math.floor(api.toFiniteNumber(amount, 0)))
		while #selected < amount and #candidates > 0 do
			local selectedIndex
			for _, raceId in ipairs(preferred) do
				if availableByRaceId[raceId] and math.random(1, 100) <= preferredChance then
					for index, entry in ipairs(candidates) do
						if entry.raceId == raceId then
							selectedIndex = index
							break
						end
					end
				end
				if selectedIndex then
					break
				end
			end

			selectedIndex = selectedIndex or math.random(1, #candidates)
			local entry = table.remove(candidates, selectedIndex)
			availableByRaceId[entry.raceId] = nil
			table.insert(selected, entry)
		end
		return selected
	end

	local function experienceToNextLevel(level)
		return (50 * level * level) - (150 * level) + 200
	end

	function rules.calculateWeeklyExperience(level, difficulty, itemTask)
		level = math.max(1, math.floor(api.toFiniteNumber(level, 1)))
		local experience
		if level < 84 then
			experience = math.floor(experienceToNextLevel(level) / 2)
		elseif level <= 100 then
			experience = math.min(math.floor((1994.008 * level) + 0.5), math.floor(experienceToNextLevel(level) / 2))
		elseif level < 1000 then
			experience = math.floor((1994.008 * level) + 0.5)
		else
			experience = math.floor(experienceToNextLevel(level) / 25)
		end

		local settings = difficultySettings(difficulty)
		if not itemTask and settings.weeklyKillCap > 0 then
			experience = math.min(experience, settings.weeklyKillCap)
		end
		return api.clampU32(experience)
	end

	function rules.generateBounty(player, state)
		local difficulty = api.normalizeDifficulty(state.bounty.difficulty, api.getDifficultyForLevel(playerLevel(player)))
		state.bounty.difficulty = difficulty
		local settings = difficultySettings(difficulty)
		local selected = selectBountyEntries(state, difficulty, api.config.bounty.slotCount)
		state.bounty.tasks = {}
		for _, entry in ipairs(selected) do
			local kind = randomTaskKind()
			local multiplier = taskMultiplier(kind)
			local required = randomBetween(settings.minimumKills, settings.maximumKills)
			table.insert(state.bounty.tasks, {
				raceId = entry.raceId,
				required = required,
				experience = api.clampU32(math.floor(settings.experienceFactor * required) * multiplier),
				bountyPoints = api.clampByte(settings.points * multiplier),
				current = 0,
				state = api.taskState.notSelected,
				marker = kind,
			})
		end
		return true
	end

	function rules.ensureBounty(player, state)
		if #state.bounty.tasks > 0 then
			return false
		end
		return rules.generateBounty(player, state)
	end

	local function weeklySlotCounts(state)
		if state.general.thirdSlotUnlocked then
			return api.config.weekly.thirdSlotKillSlots, api.config.weekly.thirdSlotItemSlots
		end
		return api.config.weekly.killSlots, api.config.weekly.itemSlots
	end

	function rules.generateWeekly(player, state, selectionPending)
		local difficulty = api.normalizeDifficulty(state.weekly.difficulty, api.getDifficultyForLevel(playerLevel(player)))
		local settings = difficultySettings(difficulty)
		local killSlots, itemSlots = weeklySlotCounts(state)
		state.weekly.difficulty = difficulty
		state.weekly.selectionPending = selectionPending == true
		state.weekly.killsCompleted = 0
		state.weekly.itemsCompleted = 0
		state.weekly.points = 0
		state.weekly.soulseals = 0
		state.weekly.killExperience = rules.calculateWeeklyExperience(playerLevel(player), difficulty, false)
		state.weekly.itemExperience = rules.calculateWeeklyExperience(playerLevel(player), difficulty, true)
		state.weekly.anyCreature = {
			required = api.clampU16((difficulty + 1) * api.config.weekly.baseAnyCreatureKills),
			current = 0,
			completed = false,
		}
		state.weekly.kills = {}
		state.weekly.items = {}

		if selectionPending then
			return true
		end

		local killSettings = {
			minimum = settings.weeklyKillMinimum,
			maximum = settings.weeklyKillMaximum,
		}
		for _, entry in ipairs(api.catalog.randomUnique(killSlots, nil, difficulty)) do
			table.insert(state.weekly.kills, {
				raceId = entry.raceId,
				required = randomBetween(killSettings.minimum, killSettings.maximum),
				current = 0,
				completed = false,
			})
		end
		table.sort(state.weekly.kills, function(left, right)
			if left.required == right.required then
				return left.raceId < right.raceId
			end
			return left.required < right.required
		end)

		local itemPool = {}
		for _, item in ipairs(api.catalog.getWeeklyItems()) do
			if tonumber(item.id) and tonumber(item.id) > 0 then
				table.insert(itemPool, item)
			end
		end
		local usedItems = {}
		for index = 1, itemSlots do
			if #itemPool == 0 then
				break
			end
			local available = {}
			for _, item in ipairs(itemPool) do
				if not usedItems[item.id] then
					table.insert(available, item)
				end
			end
			if #available == 0 then
				usedItems = {}
				available = itemPool
			end
			local item = available[math.random(1, #available)]
			usedItems[item.id] = true
			table.insert(state.weekly.items, {
				index = index - 1,
				itemId = api.clampU32(item.id),
				required = api.clampU32(randomBetween(settings.weeklyItemMinimum, settings.weeklyItemMaximum)),
				current = 0,
				completed = false,
			})
		end
		return true
	end

	function rules.ensureWeekly(player, state)
		if state.weekly.selectionPending or #state.weekly.kills > 0 or #state.weekly.items > 0 then
			return false
		end
		return rules.generateWeekly(player, state, true)
	end

	function rules.getWeeklyRewardMultiplier(state)
		local completed = math.max(0, (tonumber(state.weekly.killsCompleted) or 0) + (tonumber(state.weekly.itemsCompleted) or 0))
		if completed >= 16 then
			return 8
		end
		if completed >= 12 then
			return 5
		end
		if completed >= 8 then
			return 3
		end
		if completed >= 4 then
			return 2
		end
		return 1
	end

	function rules.getWeeklyRewardPoints(state)
		local basePoints = math.max(0, tonumber(state.weekly.points) or 0)
		return api.clampU32(basePoints * rules.getWeeklyRewardMultiplier(state))
	end

	function rules.finalizeWeekly(player, state)
		local points = rules.getWeeklyRewardPoints(state)
		if points > 0 and player and type(player.addTaskHuntingPoints) == "function" then
			player:addTaskHuntingPoints(points)
		end
		state.general.soulseals = math.max(0, (tonumber(state.general.soulseals) or 0) + (tonumber(state.weekly.soulseals) or 0))
	end

	local function addExperience(player, amount)
		if amount > 0 and player and type(player.addExperience) == "function" then
			player:addExperience(amount, true)
		end
	end

	local function completeWeeklyTask(player, state, task, experience)
		if task.completed then
			return false
		end
		task.current = task.required
		task.completed = true
		state.weekly.points = (state.weekly.points or 0) + api.config.weekly.killCompletionPoints
		state.weekly.soulseals = (state.weekly.soulseals or 0) + api.config.weekly.completionSeals
		addExperience(player, experience)
		return true
	end

	function rules.updateWeeklyOnKill(player, state, raceId)
		if state.weekly.selectionPending then
			return false
		end

		local changed = false
		local any = state.weekly.anyCreature
		if not any.completed then
			any.current = math.min(any.required, (any.current or 0) + 1)
			changed = true
			if any.current >= any.required and any.required > 0 then
				any.completed = true
				state.weekly.killsCompleted = (state.weekly.killsCompleted or 0) + 1
				state.weekly.points = (state.weekly.points or 0) + api.config.weekly.killCompletionPoints
				state.weekly.soulseals = (state.weekly.soulseals or 0) + api.config.weekly.completionSeals
				addExperience(player, state.weekly.killExperience)
			end
		end

		for _, task in ipairs(state.weekly.kills) do
			if not task.completed and task.raceId == raceId then
				task.current = math.min(task.required, (task.current or 0) + 1)
				changed = true
				if task.current >= task.required and task.required > 0 then
					if completeWeeklyTask(player, state, task, state.weekly.killExperience) then
						state.weekly.killsCompleted = (state.weekly.killsCompleted or 0) + 1
						api.wire.sendWeeklyTaskSpecificCreatureFinished(player, task.raceId)
					end
				end
			end
		end
		return changed
	end

	function rules.updateBountyOnKill(player, state, raceId)
		local task = state.bounty.tasks[1]
		if not task or task.state ~= api.taskState.selected or task.raceId ~= raceId or task.current >= task.required then
			return false
		end
		task.current = math.min(task.required, task.current + 1)
		if task.current >= task.required then
			task.state = api.taskState.completed
			api.wire.sendBountyTaskFinished(player, task.raceId)
		end
		return true
	end

	function rules.syncCreatureIcons(player, state)
		if not player or type(player.setRaceIconOverlay) ~= "function" or type(player.clearRaceIconOverlays) ~= "function" then
			return false
		end

		local changed = false
		if player:clearRaceIconOverlays(api.creatureIcon.bountyTaskMonster) then
			changed = true
		end
		if player:clearRaceIconOverlays(api.creatureIcon.weeklyTaskMonster) then
			changed = true
		end
		if not api.isTaskboardEligible(player) or not state then
			return changed
		end

		local bounty = state.bounty.tasks[1]
		if bounty and bounty.state == api.taskState.selected and bounty.current < bounty.required and player:setRaceIconOverlay(bounty.raceId, api.creatureIcon.bountyTaskMonster) then
			changed = true
		end

		if not state.weekly.selectionPending then
			for _, task in ipairs(state.weekly.kills) do
				if not task.completed and task.current < task.required and player:setRaceIconOverlay(task.raceId, api.creatureIcon.weeklyTaskMonster) then
					changed = true
				end
			end
		end
		return changed
	end

	function rules.onMonsterKilled(player, raceId)
		if not api.isEnabled() or not player or tonumber(raceId) == nil or not api.isTaskboardEligible(player) then
			return
		end
		local state = api.state.ensure(player)
		local activeTask = state.bounty.tasks[1]
		local bestiaryUnlocked = false
		if type(player.isMonsterBestiaryUnlocked) == "function" then
			local checked, unlocked = pcall(player.isMonsterBestiaryUnlocked, player, tonumber(raceId))
			bestiaryUnlocked = checked and unlocked == true
		end
		if not bestiaryUnlocked and activeTask and activeTask.state == api.taskState.selected and activeTask.raceId == tonumber(raceId) and hasEquippedTalisman(player) and type(player.addBestiaryKill) == "function" then
			local chance = talismanDoubleBestiaryChance(state.upgrades.doubleBestiary)
			if chance > 0 and math.random(1, 100) <= chance then
				local entry = api.catalog.get(raceId)
				if entry then
					player:addBestiaryKill(entry.name, bestiaryKillAmount(player))
					if type(player.sendTextMessage) == "function" then
						player:sendTextMessage(MESSAGE_LOOT, "Your Bounty Talisman's bestiary bonus activated! This kill counted twice.")
					end
				end
			end
		end
		local bountyChanged = rules.updateBountyOnKill(player, state, tonumber(raceId))
		local weeklyChanged = rules.updateWeeklyOnKill(player, state, tonumber(raceId))
		local iconsChanged = rules.syncCreatureIcons(player, state)
		api.state.save(player, state)
		if iconsChanged and type(player.refreshVisibleCreatureIcons) == "function" then
			player:refreshVisibleCreatureIcons()
		end
		if bountyChanged and api.wire and api.supportsOfficialTaskboard(player) then
			api.wire.sendBounty(player, state)
		end
		if weeklyChanged and api.wire and api.supportsOfficialTaskboard(player) then
			api.wire.sendWeekly(player, state)
		end
	end

	function rules.selectBounty(state, clientIndex)
		local index = (tonumber(clientIndex) or -1) + 1
		local task = state.bounty.tasks[index]
		if not task or task.state ~= api.taskState.notSelected then
			return false
		end
		task.state = api.taskState.selected
		state.bounty.tasks = { task }
		return true
	end

	function rules.claimBounty(player, state)
		local task = state.bounty.tasks[1]
		if not task or task.state ~= api.taskState.completed then
			return false
		end
		addExperience(player, task.experience)
		state.general.bountyPoints = math.max(0, (state.general.bountyPoints or 0) + task.bountyPoints)
		state.bounty.dailyRerolls = math.min(api.config.bounty.maxDailyRerolls, (state.bounty.dailyRerolls or 0) + 1)
		rules.generateBounty(player, state)
		return true
	end

	function rules.rerollBounty(player, state)
		if (state.bounty.dailyRerolls or 0) <= 0 then
			return false
		end
		state.bounty.dailyRerolls = state.bounty.dailyRerolls - 1
		rules.generateBounty(player, state)
		return true
	end

	function rules.getRerollState(state)
		if state.bounty.dailyRerolls >= api.config.bounty.maxDailyRerolls then
			return api.rerollState.limitReached
		end
		if os.time() - (state.bounty.lastRerollClaim or 0) < api.config.bounty.rerollCooldownSeconds then
			return api.rerollState.claimed
		end
		return api.rerollState.available
	end

	function rules.claimDailyReroll(state)
		if rules.getRerollState(state) ~= api.rerollState.available then
			return false
		end
		state.bounty.dailyRerolls = math.min(api.config.bounty.maxDailyRerolls, (state.bounty.dailyRerolls or 0) + 1)
		state.bounty.lastRerollClaim = os.time()
		return true
	end

	function rules.chooseBountyDifficulty(player, state, difficulty)
		difficulty = api.normalizeDifficulty(difficulty, -1)
		if difficulty < api.difficulty.beginner or difficulty > api.getDifficultyForLevel(playerLevel(player)) then
			return false
		end
		state.bounty.difficulty = difficulty
		local currentTask = state.bounty.tasks[1]
		if currentTask and currentTask.state ~= api.taskState.notSelected then
			return true
		end
		return rules.generateBounty(player, state)
	end

	function rules.chooseWeeklyDifficulty(player, state, difficulty)
		if not state.weekly.selectionPending then
			return false
		end
		difficulty = api.normalizeDifficulty(difficulty, -1)
		if difficulty < api.difficulty.beginner or difficulty > api.getDifficultyForLevel(playerLevel(player)) then
			return false
		end
		state.weekly.difficulty = difficulty
		return rules.generateWeekly(player, state, false)
	end

	local upgradeKeys = { "damage", "lifeLeech", "moreLoot", "doubleBestiary" }
	function rules.upgradeTalisman(state, upgradeType)
		local key = upgradeKeys[(tonumber(upgradeType) or -1) + 1]
		if not key then
			return false
		end
		local level = state.upgrades[key] or 0
		if level >= api.config.upgrades.maxLevel then
			return false
		end
		local cost = api.getUpgradeCost(level)
		if (state.general.bountyPoints or 0) < cost then
			return false
		end
		state.general.bountyPoints = state.general.bountyPoints - cost
		state.upgrades[key] = level + 1
		return true
	end

	local function preferenceAt(state, clientIndex)
		local index = (tonumber(clientIndex) or -1) + 1
		return state.bounty.preferences[index], index
	end

	function rules.unlockPreference(state)
		for index, preference in ipairs(state.bounty.preferences) do
			if not preference.unlocked then
				local cost = math.max(0, index - 1) * api.config.bounty.preferenceUnlockBaseCost
				if (state.general.bountyPoints or 0) < cost then
					return false
				end
				state.general.bountyPoints = state.general.bountyPoints - cost
				preference.unlocked = true
				return true
			end
		end
		return false
	end

	function rules.clearPreference(state, clientIndex, preferred)
		local preference = preferenceAt(state, clientIndex)
		if not preference or not preference.unlocked then
			return false
		end
		local key = preferred and "preferredRace" or "unwantedRace"
		if (preference[key] or 0) == 0 or (state.general.bountyPoints or 0) < api.config.bounty.preferenceClearCost then
			return false
		end
		state.general.bountyPoints = state.general.bountyPoints - api.config.bounty.preferenceClearCost
		preference[key] = 0
		return true
	end

	function rules.assignPreference(state, clientIndex, raceId, preferred)
		local preference = preferenceAt(state, clientIndex)
		if not preference or not preference.unlocked or not api.catalog.isValidRace(raceId) then
			return false
		end
		local key = preferred and "preferredRace" or "unwantedRace"
		preference[key] = api.clampU16(raceId)
		return true
	end

	function rules.getWeeklyItemAvailability(player, item)
		local itemId = tonumber(item and item.itemId) or 0
		if itemId <= 0 then
			return 0, 0, 0
		end
		local inventory = type(player.getItemCount) == "function" and (player:getItemCount(itemId, -1, true, true) or 0) or 0
		local stash = type(player.getStashItemCount) == "function" and (player:getStashItemCount(itemId) or 0) or 0
		return math.max(0, inventory), math.max(0, stash), math.max(0, inventory + stash)
	end

	function rules.deliverWeeklyItem(player, state, clientIndex)
		if state.weekly.selectionPending then
			return false
		end
		local item = state.weekly.items[(tonumber(clientIndex) or -1) + 1]
		if not item or item.completed then
			return false
		end
		local inventory, stash, total = rules.getWeeklyItemAvailability(player, item)
		if total < item.required then
			return false
		end

		local fromInventory = math.min(inventory, item.required)
		local fromStash = item.required - fromInventory
		if fromInventory > 0 and type(player.removeItem) ~= "function" then
			return false
		end
		if fromStash > 0 and (type(player.removeStashItem) ~= "function" or (fromInventory > 0 and type(player.addItemStash) ~= "function")) then
			return false
		end
		if fromStash > 0 and not player:removeStashItem(item.itemId, fromStash) then
			return false
		end
		if fromInventory > 0 and not player:removeItem(item.itemId, fromInventory, -1, true, true) then
			if fromStash > 0 then
				player:addItemStash(item.itemId, fromStash)
			end
			return false
		end

		item.current = item.required
		item.completed = true
		state.weekly.itemsCompleted = (state.weekly.itemsCompleted or 0) + 1
		state.weekly.points = (state.weekly.points or 0) + api.config.weekly.itemCompletionPoints
		state.weekly.soulseals = (state.weekly.soulseals or 0) + api.config.weekly.completionSeals
		addExperience(player, state.weekly.itemExperience)
		return true
	end

	local function getTaskPoints(player)
		if player and type(player.getTaskHuntingPoints) == "function" then
			return math.max(0, tonumber(player:getTaskHuntingPoints()) or 0)
		end
		return 0
	end

	local function changeTaskPoints(player, amount)
		if amount > 0 and type(player.addTaskHuntingPoints) == "function" then
			local result = player:addTaskHuntingPoints(amount)
			return result ~= nil and result ~= false
		end
		if amount < 0 and type(player.removeTaskHuntingPoints) == "function" then
			return player:removeTaskHuntingPoints(-amount) == true
		end
		return amount == 0
	end

	local function storeInboxWithSlots(player, slotsNeeded)
		if not player or type(player.getStoreInbox) ~= "function" then
			return nil
		end
		local inbox = player:getStoreInbox()
		if not inbox or type(inbox.getItems) ~= "function" or type(inbox.getMaxCapacity) ~= "function" or type(inbox.addItemEx) ~= "function" then
			return nil
		end

		local items = inbox:getItems()
		local capacity = tonumber(inbox:getMaxCapacity()) or 0
		if type(items) ~= "table" or capacity < (#items + slotsNeeded) then
			return nil
		end
		return inbox
	end

	local function storeTimestamp()
		local clock = rawget(_G, "systemTime")
		return type(clock) == "function" and clock() or os.time()
	end

	local function markStoreItem(item, player)
		if type(item.setOwner) == "function" then
			item:setOwner(player)
		end
		local storeAttribute = rawget(_G, "ITEM_ATTRIBUTE_STORE")
		if storeAttribute ~= nil and type(item.setAttribute) == "function" then
			item:setAttribute(storeAttribute, storeTimestamp())
		end
	end

	local function decorationName(offer, itemId)
		local itemTypeFactory = rawget(_G, "ItemType")
		if type(itemTypeFactory) == "function" then
			local ok, itemType = pcall(itemTypeFactory, itemId)
			if ok and itemType and type(itemType.getName) == "function" then
				local nameOk, name = pcall(itemType.getName, itemType)
				if nameOk and type(name) == "string" and name ~= "" then
					return name
				end
			end
		end
		return tostring(offer.name or itemId)
	end

	local function removeStoreReward(item)
		if type(item.remove) == "function" then
			item:remove()
		end
	end

	local function createStoreReward(player, offer, wrappedItemId)
		local game = rawget(_G, "Game")
		if type(game) ~= "table" or type(game.createItem) ~= "function" then
			return nil
		end

		local itemId = wrappedItemId and rawget(_G, "ITEM_DECORATION_KIT") or tonumber(offer.id)
		if not itemId or itemId <= 0 then
			return nil
		end
		local item = game.createItem(itemId, 1)
		if not item then
			return nil
		end
		markStoreItem(item, player)

		if wrappedItemId then
			if type(item.setCustomAttribute) ~= "function" then
				removeStoreReward(item)
				return nil
			end
			item:setCustomAttribute("unWrapId", wrappedItemId)
			local descriptionAttribute = rawget(_G, "ITEM_ATTRIBUTE_DESCRIPTION")
			if descriptionAttribute ~= nil and type(item.setAttribute) == "function" then
				item:setAttribute(descriptionAttribute, "Unwrap this kit in your own house to create a <" .. decorationName(offer, wrappedItemId) .. ">.")
			end
		end
		return item
	end

	local function rollbackStoreRewards(items)
		for index = #items, 1, -1 do
			removeStoreReward(items[index])
		end
	end

	local function deliverStoreRewards(player, offer)
		local wrappedItemIds
		if offer.kind == api.offerKind.decoration then
			local primaryId = tonumber(offer.id)
			if not primaryId or primaryId <= 0 then
				return false
			end
			wrappedItemIds = { primaryId }
			local secondaryId = tonumber(offer.secondId)
			if secondaryId and secondaryId > 0 then
				table.insert(wrappedItemIds, secondaryId)
			end
		else
			wrappedItemIds = { false }
		end

		local inbox = storeInboxWithSlots(player, #wrappedItemIds)
		if not inbox then
			return false
		end
		local rewards = {}
		for _, wrappedItemId in ipairs(wrappedItemIds) do
			local item = createStoreReward(player, offer, wrappedItemId or nil)
			if not item then
				rollbackStoreRewards(rewards)
				return false
			end
			table.insert(rewards, item)
		end

		local wherever = rawget(_G, "INDEX_WHEREEVER") or -1
		local noLimit = rawget(_G, "FLAG_NOLIMIT") or 0
		local noError = rawget(_G, "RETURNVALUE_NOERROR") or 0
		for _, item in ipairs(rewards) do
			if inbox:addItemEx(item, wherever, noLimit) ~= noError then
				rollbackStoreRewards(rewards)
				return false
			end
		end
		if type(player.sendUpdateContainer) == "function" then
			player:sendUpdateContainer(inbox)
		end
		return true
	end

	local function outfitOwnership(state, offer)
		local outfit = api.getOutfitOfferData(offer)
		if not outfit then
			return nil, nil
		end
		state.general.shopOutfits = state.general.shopOutfits or {}
		local ownership = state.general.shopOutfits[outfit.key]
		if not ownership then
			ownership = { base = false, addon1 = false, addon2 = false }
			state.general.shopOutfits[outfit.key] = ownership
		end
		return ownership, outfit
	end

	local function syncOutfitOwnership(player, state, offer)
		local ownership, outfit = outfitOwnership(state, offer)
		if not ownership or type(player.hasOutfit) ~= "function" then
			return false
		end
		local lookType = api.getOutfitLookType(player, offer)
		if not lookType then
			return false
		end

		local changed = false
		for addon, key in pairs({ [0] = "base", [1] = "addon1", [2] = "addon2" }) do
			if not ownership[key] and player:hasOutfit(lookType, addon) then
				ownership[key] = true
				changed = true
			end
		end
		return changed
	end

	function rules.syncShopOutfitOwnership(player, state)
		local changed = false
		for index = 1, api.getShopOfferCount() do
			local offer = api.config.shopOffers[index]
			if offer.kind == api.offerKind.outfit and syncOutfitOwnership(player, state, offer) then
				changed = true
			end
		end
		return changed
	end

	function rules.getShopOfferState(player, state, offer)
		local price = api.getShopOfferPrice(offer)
		if price == nil then
			return api.offerState.notAvailable
		end
		if offer.kind == api.offerKind.mount then
			local mountId = offer.mountId or offer.id
			if type(player.hasMount) ~= "function" or not player:hasMount(mountId) then
				return getTaskPoints(player) >= price and api.offerState.available or api.offerState.notEnoughPoints
			end
			return api.offerState.bought
		end
		if offer.kind == api.offerKind.outfit then
			local ownership, outfit = outfitOwnership(state, offer)
			if not ownership or not outfit then
				return api.offerState.notAvailable
			end
			syncOutfitOwnership(player, state, offer)
			if outfit.addon > 0 and not ownership.base then
				return api.offerState.requiresBaseOutfit
			end
			local ownershipKey = outfit.addon == 0 and "base" or "addon" .. outfit.addon
			if ownership[ownershipKey] then
				return api.offerState.bought
			end
			return getTaskPoints(player) >= price and api.offerState.available or api.offerState.notEnoughPoints
		end
		if getTaskPoints(player) < price then
			return api.offerState.notEnoughPoints
		end
		return api.offerState.available
	end

	local function grantOffer(player, state, offer)
		if offer.kind == api.offerKind.item or offer.kind == api.offerKind.decoration then
			return deliverStoreRewards(player, offer)
		end
		if offer.kind == api.offerKind.mount then
			return type(player.addMount) == "function" and player:addMount(offer.mountId or offer.id) == true
		end
		if offer.kind == api.offerKind.outfit then
			local ownership, outfit = outfitOwnership(state, offer)
			if not ownership or not outfit then
				return false
			end
			local method = outfit.addon == 0 and player.addOutfit or player.addOutfitAddon
			if type(method) ~= "function" then
				return false
			end

			local delivered = {}
			for _, lookType in ipairs({ outfit.male, outfit.female }) do
				if not delivered[lookType] then
					if method(player, lookType, outfit.addon) ~= true then
						return false
					end
					delivered[lookType] = true
				end
			end
			ownership.base = true
			if outfit.addon > 0 then
				ownership["addon" .. outfit.addon] = true
			end
			return true
		end
		return false
	end

	function rules.purchaseShopOffer(player, state, clientIndex)
		local index = tonumber(clientIndex) or -1
		local offers = api.config.shopOffers or {}
		local offerCount = api.getShopOfferCount()
		if index == offerCount then
			state.wheel.multiplier = math.max(1, math.min(api.config.wheel.maximumMultiplier, math.floor(tonumber(state.wheel.multiplier) or 1)))
			state.wheel.price = api.getWheelPrice(state.wheel.multiplier)
			if state.wheel.multiplier >= api.config.wheel.maximumMultiplier or getTaskPoints(player) < state.wheel.price then
				return false
			end
			if not changeTaskPoints(player, -state.wheel.price) then
				return false
			end
			state.wheel.multiplier = state.wheel.multiplier + 1
			state.wheel.price = api.getWheelPrice(state.wheel.multiplier)
			return true
		end

		if index < 0 or index >= offerCount then
			return false
		end
		local offer = offers[index + 1]
		if not offer or rules.getShopOfferState(player, state, offer) ~= api.offerState.available then
			return false
		end
		local price = api.getShopOfferPrice(offer)
		if price == nil or not changeTaskPoints(player, -price) then
			return false
		end
		if grantOffer(player, state, offer) then
			return true
		end
		if not changeTaskPoints(player, price) then
			local runtimeLogger = rawget(_G, "logger")
			if type(runtimeLogger) == "table" and type(runtimeLogger.error) == "function" then
				runtimeLogger.error("[Taskboard] failed to refund {} task hunting points to {}", price, player:getName())
			end
		end
		return false
	end

	function rules.getLootBonus(player, monster)
		if not player or not monster or not hasEquippedTalisman(player) then
			return 0
		end
		local monsterType = type(monster.getType) == "function" and monster:getType() or monster
		local raceId = monsterType and type(monsterType.raceId) == "function" and monsterType:raceId() or monster.raceId
		local task, state = activeBountyTask(player, raceId)
		if not task then
			return 0
		end
		local level = state.upgrades.moreLoot or 0
		return talismanPercent(level) / 100
	end

	local function activeTalismanUpgrades(player, target)
		if not player or not target or not hasEquippedTalisman(player) or type(target.getType) ~= "function" then
			return nil
		end
		local monsterType = target:getType()
		local raceId = monsterType and type(monsterType.raceId) == "function" and monsterType:raceId() or 0
		local task, state = activeBountyTask(player, raceId)
		if not task then
			return nil
		end
		return state.upgrades
	end

	function rules.getDamageBonus(player, target)
		local upgrades = activeTalismanUpgrades(player, target)
		if not upgrades then
			return 0
		end
		if math.random(1, 100) <= percentage(api.config.talisman.damageActivationChance) then
			return talismanPercent(upgrades.damage)
		end
		return 0
	end

	function rules.getLifeLeechBonus(player, target)
		local upgrades = activeTalismanUpgrades(player, target)
		if not upgrades then
			return 0
		end
		if math.random(1, 100) <= percentage(api.config.talisman.lifeLeechActivationChance) then
			return talismanPercent(upgrades.lifeLeech)
		end
		return 0
	end

	function rules.getCombatBonuses(player, target)
		return rules.getDamageBonus(player, target), rules.getLifeLeechBonus(player, target)
	end
end
