local addonBonus = CreatureEvent("AddonBonus")

function addonBonus.onLogin(player)
	-- Define different conditions
	local conditions = {
		mage1 = Condition(CONDITION_ATTRIBUTES), -- Condition for mage addon 1
		mage2 = Condition(CONDITION_ATTRIBUTES), -- Condition for mage addon 2
		mage3 = Condition(CONDITION_ATTRIBUTES), -- Condition for mage addon 3
		noble1 = Condition(CONDITION_ATTRIBUTES), -- Condition for nobleman/noblewoman addon 1
		noble2 = Condition(CONDITION_ATTRIBUTES), -- Condition for nobleman/noblewoman addon 2
		noble3 = Condition(CONDITION_ATTRIBUTES) -- Condition for nobleman/noblewoman addon 3
	}

	-- Set parameters for each condition
	-- CONDITION_PARAM_TICKS -1 for the entier time player is logged in, if you
	-- want player to receive it for a certain amount of time eg. 10s instead
	-- of setting as -1, set it as 10000

	conditions.noble1:setParameter(CONDITION_PARAM_TICKS, -1)
	conditions.noble1:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 5)
	conditions.noble1:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 25)

	conditions.noble2:setParameter(CONDITION_PARAM_TICKS, -1)
	conditions.noble2:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 10)
	conditions.noble2:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 35)

	conditions.noble3:setParameter(CONDITION_PARAM_TICKS, -1)
	conditions.noble3:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_CHANCE, 15)
	conditions.noble3:setParameter(CONDITION_PARAM_SKILL_CRITICAL_HIT_DAMAGE, 50)

	conditions.mage1:setParameter(CONDITION_PARAM_TICKS, -1)
	conditions.mage1:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 1)
	conditions.mage1:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE, 25)
	conditions.mage1:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 25)

	conditions.mage2:setParameter(CONDITION_PARAM_TICKS, -1)
	conditions.mage2:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 2)
	conditions.mage2:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE, 50)
	conditions.mage2:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 35)

	conditions.mage3:setParameter(CONDITION_PARAM_TICKS, -1)
	conditions.mage3:setParameter(CONDITION_PARAM_STAT_MAGICPOINTS, 3)
	conditions.mage3:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_CHANCE, 100)
	conditions.mage3:setParameter(CONDITION_PARAM_SKILL_MANA_LEECH_AMOUNT, 50)

	-- Getting the player id
    local playerId = player:getGuid()

    -- Query for looktype
    local lookTypeQuery = db.storeQuery('SELECT `looktype` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')
    local lookType = Result.getNumber(lookTypeQuery, "looktype")

    -- Query for lookaddons
    local lookAddonsQuery = db.storeQuery('SELECT `lookaddons` FROM `players` WHERE `id` =' .. playerId .. ' LIMIT 1;')
    local lookAddons = Result.getNumber(lookAddonsQuery, "lookaddons")

	-- if the player has the outfit set, male or female, then we'll look if the player has any addon for it
	-- if so, we'll then send a custom message to the player and give the bonus that we previously set
	if lookType == 2501 or lookType == 2502 then -- Noblewoman or Nobleman outfit
		if lookAddons == 1 then -- if player is using the first addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[CRIT CHANCE] 5%\n[CRIT DAMAEG] 25%")
			player:addCondition(conditions.noble1)
		elseif lookAddons == 2 then -- if player is using the second addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[CRIT CHANCE] 10%\n[CRIT DAMAGE] 35%")
			player:addCondition(conditions.noble2)
		elseif lookAddons == 3 then -- if player is using both first and second addons
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[CRIT CHANCE] 15%\n[CRIT DAMAGE] 50%")
			player:addCondition(conditions.noble3)
		else -- player isnt using any addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao possui nenhuma outfit especial para um complemento de bonus")
		end
	elseif lookType == 2505 or lookType == 2506 then -- Noblewoman or Nobleman outfit
		if lookAddons == 1 then -- if player is using the first addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[CRIT CHANCE] 5%\n[CRIT DAMAEG] 25%")
			player:addCondition(conditions.noble1)
		elseif lookAddons == 2 then -- if player is using the second addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[CRIT CHANCE] 10%\n[CRIT DAMAGE] 35%")
			player:addCondition(conditions.noble2)
		elseif lookAddons == 3 then -- if player is using both first and second addons
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[CRIT CHANCE] 15%\n[CRIT DAMAGE] 50%")
			player:addCondition(conditions.noble3)
		else -- player isnt using any addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao possui nenhuma outfit especial para um complemento de bonus")
		end
	elseif lookType == 2504 or lookType == 2503 then -- Especial outfit
		if lookAddons == 1 then -- if player is using the first addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[Magic Level] +1\n[MANA LEECH CHANCE] 25%\n[MANA LEECH] 25%")
			player:addCondition(conditions.mage1)
		elseif lookAddons == 2 then -- if player is using the second addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[Magic Level] +2\n[MANA LEECH CHANCE] 50%\n[MANA LEECH] 35%")
			player:addCondition(conditions.mage2)
		elseif lookAddons == 3 then -- if player is using both first and second addons
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce esta elegivel para um complemento de bonus por addon..\n[Magic Level] +3\n[MANA LEECH CHANCE] 100%\n[MANA LEECH] 50%")
			player:addCondition(conditions.mage3)
		else -- player isnt using any addon
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao possui nenhuma outfit especial para um complemento de bonus")
		end
	else -- if player is using any outfit that isnt set
			player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "Voce nao possui nenhuma outfit especial para um complemento de bonus")
	end
	return true
end

addonBonus:register()