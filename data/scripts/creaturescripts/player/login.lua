local function sendBoostMessage(player, category, isIncreased)
	local boostMessage = ""
	if isIncreased then
		boostMessage = "Event! {category} is increased. Happy Hunting!"
	else
		boostMessage = "Event! {category} is decreased. Happy Hunting!"
	end

	boostMessage = boostMessage:gsub("{category}", category)
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, boostMessage)
end

local playerLogin = CreatureEvent("PlayerLogin")

function playerLogin.onLogin(player)
	-- Welcome
	local loginStr
	if player:getLastLoginSaved() == 0 then
		loginStr = "Please choose your outfit."
		player:sendOutfitWindow()

		db.query("UPDATE `players` SET `istutorial` = 0 WHERE `id` = " .. player:getGuid())
	else
		loginStr = string.format("Your last visit in %s: %s.", SERVER_NAME, os.date("%d %b %Y %X", player:getLastLoginSaved()))
	end
	player:sendTextMessage(MESSAGE_LOGIN, loginStr)

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local hasPromotion = player:kv():get("promoted")

		if not player:isPromoted() and hasPromotion then
			player:setVocation(promotion)
		end
	elseif player:isPromoted() then
		player:setVocation(vocation:getDemotion())
	end

	-- Boosted
	local boostedCreatureMsg = string.format("Today's boosted creature: %s. Boosted creatures yield more experience points, carry more loot than usual, and respawn at a faster rate.", Game.getBoostedCreature())
	local boostedBossMsg = string.format("Today's boosted boss: %s. Boosted bosses contain more loot and count more kills for your Bosstiary.", Game.getBoostedBoss())
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, boostedCreatureMsg)
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, boostedBossMsg)

	-- Rewards
	local rewards = #player:getRewardList()
	if rewards > 0 then
		player:sendTextMessage(MESSAGE_LOGIN, string.format("You have %d %s in your reward chest.", rewards, rewards > 1 and "rewards" or "reward"))
	end

	-- Rate events:
	if SCHEDULE_EXP_RATE ~= 100 then
		sendBoostMessage(player, "Exp Rate", SCHEDULE_EXP_RATE > 100)
	end

	if SCHEDULE_SPAWN_RATE ~= 100 then
		sendBoostMessage(player, "Spawn Rate", SCHEDULE_SPAWN_RATE > 100)
	end

	if SCHEDULE_LOOT_RATE ~= 100 then
		sendBoostMessage(player, "Loot Rate", SCHEDULE_LOOT_RATE > 100)
	end

	if SCHEDULE_SKILL_RATE ~= 100 then
		sendBoostMessage(player, "Skill Rate", SCHEDULE_SKILL_RATE > 100)
	end

	-- Send Recruiter Outfit
	local playerName = getPlayerName(player)
	local accountId = getAccountNumberByPlayerName(playerName)
	local resultId = db.storeQuery("SELECT `recruiter` FROM `accounts` WHERE `id`=" .. accountId)
	if not resultId then
		return true
	end

	local recruiterStatus = Result.getNumber(resultId, "recruiter")
	local sex = player:getSex()
	local outfitId = (sex == 1) and 746 or 745
	for outfitAddOn = 0, 2 do
		if recruiterStatus >= outfitAddOn * 3 + 1 then
			local hasOutfit = player:hasOutfit(outfitId, outfitAddOn)
			if not hasOutfit then
				if outfitAddOn == 0 then
					player:addOutfit(outfitId)
				else
					player:addOutfitAddon(outfitId, outfitAddOn)
				end
			end
		end
	end

	-- Send Client Exp Display
	if configManager.getBoolean(configKeys.XP_DISPLAY_MODE) then
		local baseRate = player:getFinalBaseRateExperience() * 100
		if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
			local vipBonusExp = configManager.getNumber(configKeys.VIP_BONUS_EXP)
			if vipBonusExp > 0 and player:isVip() then
				vipBonusExp = (vipBonusExp > 100 and 100) or vipBonusExp
				baseRate = baseRate * (1 + (vipBonusExp / 100))
				player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Normal base xp is: " .. baseRate .. "%, because you are VIP, bonus of " .. vipBonusExp .. "%")
			end
		end

		player:setBaseXpGain(baseRate)
	end

	player:setStaminaXpBoost(player:getFinalBonusStamina() * 100)
	player:getFinalLowLevelBonus()

	-- Set Ghost Mode
	if player:getGroup():getId() >= GROUP_TYPE_GAMEMASTER then
		player:setGhostMode(true)
	end

	-- Resets
	if _G.OnExerciseTraining[player:getId()] then
		stopEvent(_G.OnExerciseTraining[player:getId()].event)
		_G.OnExerciseTraining[player:getId()] = nil
		player:setTraining(false)
	end

	local playerId = player:getId()
	_G.NextUseStaminaTime[playerId] = 1
	_G.NextUseXpStamina[playerId] = 1
	_G.NextUseConcoctionTime[playerId] = 1
	DailyReward.init(playerId)

	local stats = player:inBossFight()
	if stats then
		stats.playerId = player:getId()
	end

	-- Remove Boss Time
	if GetDailyRewardLastServerSave() >= player:getLastLoginSaved() then
		player:setRemoveBossTime(1)
	end

	player:loadSpecialStorage()
	player:initializeLoyaltySystem()
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	player:registerEvent("BossParticipation")
	return true
end

playerLogin:register()
