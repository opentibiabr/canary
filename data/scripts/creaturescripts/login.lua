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

		player:sendTextMessage(MESSAGE_LOGIN, string.format("Your last visit in ".. SERVER_NAME ..": %s.", os.date("%d. %b %Y %X", player:getLastLoginSaved())))
	end

	-- Stamina
	nextUseStaminaTime[player.uid] = 0

	-- Promotion
	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	if player:isPremium() then
		local value = player:getStorageValue(Storage.Promotion)
		if not promotion and value ~= 1 then
			player:setStorageValue(STORAGEVALUE_PROMOTION, 1)
		elseif value == 1 then
			player:setVocation(promotion)
		end
	elseif not promotion then
		player:setVocation(vocation:getDemotion())
	end

	-- Events
	player:registerEvent("PlayerDeath")
	player:registerEvent("DropLoot")


	if onExerciseTraining[player:getId()] then -- onLogin & onLogout
		stopEvent(onExerciseTraining[player:getId()].event)
		onExerciseTraining[player:getId()] = nil
		player:setTraining(false)
	end
	return true
end
	
	if SCHEDULE_SPAWN_RATE ~= 100 then
		if SCHEDULE_SPAWN_RATE > 100 then
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Spawn Rate Event! Monsters respawn at a faster rate \
			Happy Hunting!")
		else
			player:sendTextMessage(MESSAGE_BOOSTED_CREATURE, "Spawn Rate Decreased! Monsters respawn at a slower rate.")
		end
	end

	-- Set Client XP Gain Rate --
	local rateExp = 1
	if Game.getStorageValue(GlobalStorage.XpDisplayMode) > 0 then
		rateExp = getRateFromTable(experienceStages, player:getLevel(), configManager.getNumber(configKeys.RATE_EXP))

		if SCHEDULE_EXP_RATE ~= 100 then
			rateExp = math.max(0, (rateExp * SCHEDULE_EXP_RATE)/100)
		end
	end

	local staminaMinutes = player:getStamina()
	player:setBaseXpGain(rateExp * 100)

login:register()
