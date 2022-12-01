local arenaTrophy = MoveEvent()

function arenaTrophy.onStepIn(creature, item, position, fromPosition)
	local player = creature:getPlayer()
	if not player then
		return true
	end

	local arenaId = ARENA_TROPHY[item.uid]
	if not arenaId then
		return true
	end

	local storage = arenaId.trophyStorage
	if player:getStorageValue(storage) == 1 then
		return true
	end

	local rewardPosition = player:getPosition()
	rewardPosition.y = rewardPosition.y - 1

	local rewardItem = Game.createItem(arenaId.trophy, 1, rewardPosition)
	if rewardItem then
		rewardItem:setDescription(string.format(arenaId.desc, player:getName()))
	end

	player:setStorageValue(storage, 1)
	player:getPosition():sendMagicEffect(CONST_ME_MAGIC_RED)
	return true
end

arenaTrophy:type("stepin")
arenaTrophy:uid(3264, 3265, 3266)
arenaTrophy:register()
