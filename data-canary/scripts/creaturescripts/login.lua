local login = CreatureEvent("PlayerLogin")

function login.onLogin(player)
	local loginStr = "Welcome to " .. configManager.getString(configKeys.SERVER_NAME) .. "!"
	if player:getLastLoginSaved() <= 0 then
		loginStr = loginStr .. " Please choose your outfit."
		player:sendOutfitWindow()
	else
		if loginStr ~= "" then
			player:sendTextMessage(MESSAGE_LOGIN, loginStr)
		end

		player:sendTextMessage(MESSAGE_LOGIN, string.format("Your last visit in " .. SERVER_NAME .. ": %s.", os.date("%d. %b %Y %X", player:getLastLoginSaved())))
	end

	-- Stamina
	nextUseStaminaTime[player.uid] = 0

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

	-- Events
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")
	player:registerEvent("BossParticipation")

	if onExerciseTraining[player:getId()] then -- onLogin & onLogout
		stopEvent(onExerciseTraining[player:getId()].event)
		onExerciseTraining[player:getId()] = nil
		player:setTraining(false)
	end

	-- Boosted creature
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Today's boosted creature: " .. Game.getBoostedCreature() .. " \
	Boosted creatures yield more experience points, carry more loot than usual and respawn at a faster rate.")

	-- Boosted boss
	player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Today's boosted boss: " .. Game.getBoostedBoss() .. " \
	Boosted bosses contain more loot and count more kills for your Bosstiary.")

	if SCHEDULE_EXP_RATE ~= 100 then
		if SCHEDULE_EXP_RATE > 100 then
			player:sendTextMessage(
				MESSAGE_BOOSTED_CREATURE,
				"Exp Rate Event! Monsters yield more experience points than usual \
			Happy Hunting!"
			)
		else
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Exp Rate Decreased! Monsters yield less experience points than usual.")
		end
	end

	if SCHEDULE_SPAWN_RATE ~= 100 then
		if SCHEDULE_SPAWN_RATE > 100 then
			player:sendTextMessage(
				MESSAGE_BOOSTED_CREATURE,
				"Spawn Rate Event! Monsters respawn at a faster rate \
			Happy Hunting!"
			)
		else
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Spawn Rate Decreased! Monsters respawn at a slower rate.")
		end
	end

	if SCHEDULE_LOOT_RATE ~= 100 then
		if SCHEDULE_LOOT_RATE > 100 then
			player:sendTextMessage(
				MESSAGE_BOOSTED_CREATURE,
				"Loot Rate Event! Monsters carry more loot than usual \
			Happy Hunting!"
			)
		else
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Loot Rate Decreased! Monsters carry less loot than usual.")
		end
	end

	if SCHEDULE_SKILL_RATE ~= 100 then
		if SCHEDULE_SKILL_RATE > 100 then
			player:sendTextMessage(
				MESSAGE_BOOSTED_CREATURE,
				"Skill Rate Event! Your skills progresses at a higher rate \
			Happy Hunting!"
			)
		else
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Skill Rate Decreased! Your skills progresses at a lower rate.")
		end
	end

	local playerId = player:getId()

	-- Stamina
	nextUseStaminaTime[playerId] = 1

	-- EXP Stamina
	nextUseXpStamina[playerId] = 1

	-- Set Client XP Gain Rate --
	if configManager.getBoolean(configKeys.XP_DISPLAY_MODE) then
		local baseRate = player:getFinalBaseRateExperience()
		baseRate = baseRate * 100
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

	local staminaBonus = player:getFinalBonusStamina()
	player:setStaminaXpBoost(staminaBonus * 100)

	player:getFinalLowLevelBonus()

	return true
end

login:register()
