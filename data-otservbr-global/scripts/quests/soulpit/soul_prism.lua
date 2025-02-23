local soulPrism = Action()

local function getNextDifficultyLevel(currentLevel)
	for level, value in pairs(SoulPit.SoulCoresConfiguration.monstersDifficulties) do
		if value == currentLevel + 1 then
			return level
		end
	end
	return nil
end

local function getPreviousDifficultyLevel(currentLevel)
	for level, value in pairs(SoulPit.SoulCoresConfiguration.monstersDifficulties) do
		if value == currentLevel - 1 then
			return level
		end
	end
	return nil
end

local function getSoulCoreItemForMonster(monsterName)
	local lowerMonsterName = monsterName:lower()
	local soulCoreName = SoulPit.SoulCoresConfiguration.monsterVariationsSoulCore[monsterName]

	if soulCoreName then
		local newSoulCoreId = getItemIdByName(soulCoreName)
		if newSoulCoreId then
			return newSoulCoreId
		end
	else
		local newMonsterSoulCore = string.format("%s soul core", monsterName)
		local newSoulCoreId = getItemIdByName(newMonsterSoulCore)
		if newSoulCoreId then
			return newSoulCoreId
		end
	end

	return false
end

function soulPrism.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local itemName = target:getName()
	local monsterName = SoulPit.getSoulCoreMonster(itemName)

	if not monsterName then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You can only use Soul Prism with a Soul Core.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local monsterType = MonsterType(monsterName)
	if not monsterType then
		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Invalid monster type. Please contact an administrator.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local currentDifficulty = monsterType:BestiaryStars()
	local nextDifficultyLevel = getNextDifficultyLevel(currentDifficulty)
	local nextDifficultyMonsters = nil

	if nextDifficultyLevel then
		nextDifficultyMonsters = Game.getMonstersByBestiaryStars(SoulPit.SoulCoresConfiguration.monstersDifficulties[nextDifficultyLevel])
	else
		nextDifficultyLevel = currentDifficulty
		nextDifficultyMonsters = Game.getMonstersByBestiaryStars(SoulPit.SoulCoresConfiguration.monstersDifficulties[currentDifficulty])
	end

	if #nextDifficultyMonsters == 0 then
		player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "No monsters available for the next difficulty level.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	local newMonsterType = nextDifficultyMonsters[math.random(#nextDifficultyMonsters)]
	local newSoulCoreItem = getSoulCoreItemForMonster(newMonsterType:getName())
	if not newSoulCoreItem then -- Retry a second time.
		newSoulCoreItem = getSoulCoreItemForMonster(newMonsterType:getName())
		if not newSoulCoreItem then
			player:sendTextMessage(MESSAGE_GAME_HIGHLIGHT, "Failed to generate a Soul Core.")
			player:getPosition():sendMagicEffect(CONST_ME_POFF)
			return false
		end
	end

	if player:getFreeCapacity() < ItemType(newSoulCoreItem):getWeight() then
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You do not have enough capacity.")
		player:getPosition():sendMagicEffect(CONST_ME_POFF)
		return false
	end

	if math.random(100) <= SoulPit.SoulCoresConfiguration.chanceToGetOminousSoulCore then
		player:addItem(49163, 1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, "You have received an Ominous Soul Core.")
	else
		player:addItem(newSoulCoreItem, 1)
		target:remove(1)
		player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have received a %s soul core.", newMonsterType:getName()))
	end
	item:remove(1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	return true
end

soulPrism:id(49164)
soulPrism:register()
