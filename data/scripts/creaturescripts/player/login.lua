local function sendBoostMessage(player, category, isIncreased)
	return player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, string.format("Event! %s is %screased. Happy Hunting!", category, isIncreased and "in" or "de"))
end

local playerLoginGlobal = CreatureEvent("PlayerLoginGlobal")

function playerLoginGlobal.onLogin(player)
	-- Welcome
	local loginStr
	if player:getLastLoginSaved() == 0 then
		loginStr = "Please choose your outfit."
		player:sendOutfitWindow()
		local startStreakLevel = configManager.getNumber(configKeys.START_STREAK_LEVEL)
		if startStreakLevel > 0 then
			player:setStreakLevel(startStreakLevel)
		end

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
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, string.format("Today's boosted creature: %s.\nBoosted creatures yield more experience points, carry more loot than usual, and respawn at a faster rate.", Game.getBoostedCreature()))
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, string.format("Today's boosted boss: %s.\nBoosted bosses contain more loot and count more kills for your Bosstiary.", Game.getBoostedBoss()))

	-- Rewards
	local rewards = #player:getRewardList()
	if rewards > 0 then
		player:sendTextMessage(MESSAGE_LOGIN, string.format("You have %d reward%s in your reward chest.", rewards, rewards > 1 and "s" or ""))
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

	if SCHEDULE_BOSS_LOOT_RATE ~= 100 then
		sendBoostMessage(player, "Boss Loot Rate", SCHEDULE_BOSS_LOOT_RATE > 100)
	end

	if SCHEDULE_SKILL_RATE ~= 100 then
		sendBoostMessage(player, "Skill Rate", SCHEDULE_SKILL_RATE > 100)
	end

	-- Send Recruiter Outfit
	local resultId = db.storeQuery("SELECT `recruiter` FROM `accounts` WHERE `id`= " .. Game.getPlayerAccountId(getPlayerName(player)))
	if resultId then
		local recruiterStatus = Result.getNumber(resultId, "recruiter")
		local sex = player:getSex()
		local outfitId = (sex == 1) and 746 or 745
		for outfitAddOn = 0, 2 do
			if recruiterStatus >= outfitAddOn * 3 + 1 then
				if not player:hasOutfit(outfitId, outfitAddOn) then
					if outfitAddOn == 0 then
						player:addOutfit(outfitId)
					else
						player:addOutfitAddon(outfitId, outfitAddOn)
					end
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

	-- Updates the player's VIP status and executes corresponding actions if applicable.
	if configManager.getBoolean(configKeys.VIP_SYSTEM_ENABLED) then
		local isCurrentlyVip = player:isVip()
		local hadVipStatus = player:kv():scoped("account"):get("vip-system") or false

		if hadVipStatus ~= isCurrentlyVip then
			if hadVipStatus then
				player:onRemoveVip()
			else
				player:onAddVip(player:getVipDays())
			end
		end

		if isCurrentlyVip then
			player:sendVipStatus()
		end
	end

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

	-- Change support outfit to a normal outfit to open customize character without crashes
	local playerOutfit = player:getOutfit()
	if table.contains({ 75, 266, 302 }, playerOutfit.lookType) then
		playerOutfit.lookType = 136
		playerOutfit.lookAddons = 0
		player:setOutfit(playerOutfit)
	end

	player:initializeLoyaltySystem()
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	player:registerEvent("BossParticipation")
	player:registerEvent("UpdatePlayerOnAdvancedLevel")
	return true
end

playerLoginGlobal:register()
