local offlineTraining = CreatureEvent("OfflineTraining")

function offlineTraining.onLogin(player)
	local lastLogout = player:getLastLogout()
	local offlineTime = lastLogout ~= 0 and math.min(os.time() - lastLogout, 86400 * 21) or 0
	local offlineTrainingSkill = player:getOfflineTrainingSkill()
	if offlineTrainingSkill == SKILL_NONE then
		player:addOfflineTrainingTime(offlineTime * 250)
		return true
	end

	player:setOfflineTrainingSkill(SKILL_NONE)

	if offlineTime < 600 then
		player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, "You must be logged out for more than 10 minutes to start offline training.")
		return true
	end

	local trainingTime = math.max(0, math.min(offlineTime, math.min(43200, player:getOfflineTrainingTime() / 1000)))
	player:removeOfflineTrainingTime(trainingTime * 1000)

	local remainder = offlineTime - trainingTime
	if remainder > 0 then
		player:addOfflineTrainingTime(remainder * 1000)
	end

	if trainingTime < 60 then
		return true
	end

	local text = "During your absence you trained for"
	local hours = math.floor(trainingTime / 3600)
	if hours > 1 then
		text = string.format("%s %d hours", text, hours)
	elseif hours == 1 then
		text = string.format("%s 1 hour", text)
	end

	local minutes = math.floor((trainingTime % 3600) / 60)
	if minutes ~= 0 then
		if hours ~= 0 then
			text = string.format("%s and", text)
		end

		if minutes > 1 then
			text = string.format("%s %d minutes", text, minutes)
		else
			text = string.format("%s 1 minute", text)
		end
	end

	text = string.format("%s.", text)
	player:sendTextMessage(MESSAGE_OFFLINE_TRAINING, text)

	local vocation = player:getVocation()
	local promotion = vocation:getPromotion()
	local topVocation = not promotion and vocation or promotion

	--Check Stamina
	local isStaminaEnabled = configManager.getBoolean(configKeys.STAMINA_SYSTEM)
	local isStaminaActive = false
	if isStaminaEnabled then
		local staminaMinutes = player:getStamina()
		if staminaMinutes > 2340 and player:isPremium() then
			isStaminaActive = true
		end
	end
	
	local updateSkills = false
	if table.contains({ SKILL_CLUB, SKILL_SWORD, SKILL_AXE, SKILL_DISTANCE }, offlineTrainingSkill) then
		updateSkills = player:addOfflineTrainingTries(offlineTrainingSkill, (trainingTime / 12) / (isStaminaActive and 1.5 or 1))
	elseif offlineTrainingSkill == SKILL_MAGLEVEL then
		local gainTicks = (topVocation:getManaGainTicks() / 1000) * 2
		if gainTicks < 1 then
			gainTicks = 1
		end

		updateSkills = player:addOfflineTrainingTries(SKILL_MAGLEVEL, (trainingTime * ((vocation:getManaGainAmount()/2) / gainTicks)) / (isStaminaActive and 1.25 or 1))
	end

	if updateSkills then
		local shield_tries = (trainingTime / 12) / (isStaminaActive and 1.5 or 1)
		player:addOfflineTrainingTries(SKILL_SHIELD, shield_tries)
	end
	return true
end

offlineTraining:register()
