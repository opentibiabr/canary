local expScroll = Action()

function expScroll.onUse(cid, item, fromPosition, target, toPosition, isHotkey)
	local player = Player(cid)
	if not player then
		return
	end

	local xpPercent = 60
	local remainingBoost = player:getXpBoostTime()

	-- unlimited
	--local expBoostCount = player:getStorageValue(GameStore.Storages.expBoostCount)
	--if expBoostCount >= 5 then -- Xp boost can only be used 5 times a day
	--	player:say("You have reached the limit for today, try again after Server Save.", TALKTYPE_MONSTER_SAY)
	--	return true
	--end

	-- If player still has an active xp boost, don't let him use another one
	if remainingBoost > 0 then
		player:say("You already have an active XP boost.", TALKTYPE_MONSTER_SAY)
		return true
	end

	player:setXpBoostPercent(xpPercent)
	player:setXpBoostTime(remainingBoost + 3600)
	Item(item.uid):remove(1)
	player:say("Your hour of " .. xpPercent .. "% bonus XP has started!", TALKTYPE_MONSTER_SAY)
	return true
end

expScroll:id(64023)
--expScroll:register()

-----------------------
local expDungeonScroll = Action()

function expDungeonScroll.onUse(player, item, fromPosition, target, toPosition, isHotkey)
	local level = player:getLevel()
	local min, max = 1
	if level < 100 then
		min, max = 7, 15
	elseif level < 200 then
		min, max = 5, 8
	elseif level < 300 then
		min, max = 2, 6
	elseif level < 400 then
		min, max = 2, 5
	elseif level < 600 then
		min, max = 1, 4
	elseif level < 800 then
		min, max = 1, 3
	elseif level < 1000 then
		max = 2
	elseif level < 2000 then
		max = 1
	end

	local gainLevel = math.random(min, max)
	local nextLevel = level + gainLevel
	logger.info("Player {} used a taberna dungeon exp, and won: {} levels [from: {}, to {}]", player:getName(), gainLevel, level, nextLevel)

	level = nextLevel - 1
	local expToWin = ((((50 * level * level * level) - (150 * level * level) + (400 * level)) / 3) - player:getExperience())
	player:addExperience(expToWin, true)

	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_BLUE)
	player:getPosition():sendMagicEffect(CONST_ME_HOLYAREA)
	player:sendTextMessage(MESSAGE_EVENT_ADVANCE, string.format("You have used a taberna dungeon exp and won %d of experience points (%i level%s).", expToWin, gainLevel, gainLevel > 1 and "s" or ""))
	item:remove(1)

	return true
end

expDungeonScroll:id(64023)
expDungeonScroll:register()
